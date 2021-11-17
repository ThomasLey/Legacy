unit uniMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ScktComp, Buttons, ComCtrls, Tabnotbk, Menus,
  uniVerbinden, Registry, ShellApi, ExtCtrls, uniOptions, uniBenutzer;



const WM_TaskBarEvent = WM_User + 1;

type
  TSendEreignis = class(TObject)
    Text: ShortString;
  end;

type
  TfrmMain = class(TForm)
    csoClient: TClientSocket;
    MainMenu1: TMainMenu;
    Programm1: TMenuItem;
    Beenden1: TMenuItem;
    Verbindung1: TMenuItem;
    Erstellen1: TMenuItem;
    Trennen1: TMenuItem;
    N1: TMenuItem;
    Bearbeiten1: TMenuItem;
    ChatLschen1: TMenuItem;
    N2: TMenuItem;
    Optionen1: TMenuItem;
    ppmTNA: TPopupMenu;
    Anzeigen1: TMenuItem;
    Info2: TMenuItem;
    N3: TMenuItem;
    Beenden2: TMenuItem;
    Schliessen1: TMenuItem;
    Zettelschreiben1: TMenuItem;
    Ansicht1: TMenuItem;
    Benutzer1: TMenuItem;
    Malfenster1: TMenuItem;
    edtChat: TMemo;
    mmoChat: TMemo;
    stbMain: TStatusBar;
    imgIcon: TImage;
    tmrPuffer: TTimer;
    procedure csoClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure Erstellen1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Info1Click(Sender: TObject);
    procedure Beenden1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Trennen1Click(Sender: TObject);
    procedure csoClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure edtChatKeyPress(Sender: TObject; var Key: Char);
    procedure Optionen1Click(Sender: TObject);
    procedure MyUpdate;
    procedure ChatLschen1Click(Sender: TObject);
    procedure Anzeigen1Click(Sender: TObject);
    procedure Schliessen1Click(Sender: TObject);
    procedure Zettelschreiben1Click(Sender: TObject);
    procedure Benutzer1Click(Sender: TObject);
    procedure CheckMemo;
    procedure Malfenster1Click(Sender: TObject);
    procedure RealEnd;
    procedure tmrPufferTimer(Sender: TObject);
  protected
           procedure WMTaskBarEvent(var message: TMessage); message WM_TaskBarEvent;
  end;

// Proceduren und Functionen aus DLL'S
procedure ShowSplashFrm(ID: Char; Timer: Boolean); stdcall; external 'csutil21.dll';
function GetString(Zeichen: Char; Text: ShortString; Zahler: Integer): ShortString; stdcall; external 'csutil21.dll';
function GetInteger(Zeichen: Char; Text: ShortString; Zahler: Integer): Integer; stdcall; external 'csutil21.dll';
function GetVersion: ShortString; stdcall; external 'csutil21.dll';
// Meine Proceduren
procedure TaskBarAddIcon;
procedure TaskBarRemoveIcon;
function Eintrag(Text: String): Boolean;

var
  SendEreignis: TSendEreignis;
  SPuffer: TList;
  frmMain: TfrmMain;
  UserName, IPAddress, Host: String;
  ChatScrollen: Boolean;
  ChatZeilen: Integer;
  Regist: TRegistry;

implementation

uses uniZettel, uniMalen;

{$R *.DFM}
procedure TaskBarAddIcon;
var mytna: TNOTIFYICONDATA;
begin
     mytna.cbSize := sizeof(Tnotifyicondata);
     mytna.Wnd := frmMain.handle;
     mytna.uid := 1;
     mytna.hIcon := frmMain.imgIcon.Picture.Icon.Handle;
     mytna.uFlags := nif_message or nif_Icon or nif_tip;
     mytna.ucallbackmessage := wm_Taskbarevent;
     strcopy(mytna.sztip, 'Intra Chat - Client');
     Shell_NotifyIcon(NIM_ADD, @mytna)
end;

procedure TaskBarRemoveIcon;
var mytna: TNOTIFYICONDATA;
begin
     mytna.cbSize := sizeof(Tnotifyicondata);
     mytna.Wnd := frmMain.handle;
     mytna.uid := 1;
     Shell_NotifyIcon(NIM_DELETE, @mytna)
end;

procedure TfrmMain.WMTaskBarEvent(var message: TMessage);
var Point: TPoint;
begin
     case message.LParamLo of
          wm_LButtonDblClk: begin
                            frmMain.show;
                            end;
          wm_RButtonDown  : begin
                            GetCursorPos(Point);
                            ppmTNA.popup(point.x, point.y);
                            end;
     end;
end;

procedure TfrmMain.MyUpdate;
begin
     If Regist.GetDataSize('cScrollen') = -1 then
        Regist.WriteBool('cScrollen', true);
     ChatScrollen := Regist.ReadBool('cScrollen');
     If Regist.GetDataSize('cZeilen') = -1 then
        Regist.WriteInteger('cZeilen', 25);
     ChatZeilen := Regist.ReadInteger('cZeilen');
end;

procedure TfrmMain.CheckMemo;
var
   i: Integer;
begin
     If (mmoChat.Lines.Count >= ChatZeilen) and ChatScrollen then begin
         For i := 1 to (mmoChat.Lines.Count - Round(ChatZeilen / 4)) do
             mmoChat.Lines.Delete(0);
     end;
end;

function Eintrag(Text: String): Boolean;
var i: Integer;
    Gefunden: Boolean;
begin
  Gefunden := False;
  If  frmBenutzer.SrcList.Items.Count > 0 then
     For i := 0 to (frmBenutzer.SrcList.Items.Count-1) do
         If frmBenutzer.SrcList.Items[i] = Text then Gefunden := true;
  If frmBenutzer.DstList.Items.Count > 0 then
     If not Gefunden then
         For i := 0 to (frmBenutzer.DstList.Items.Count-1) do
             If frmBenutzer.DstList.Items[i] = Text then Gefunden := true;
  Result := Gefunden;
end;

procedure TfrmMain.RealEnd;
begin
    If MessageBox(0, 'Beim Beenden werden alle Verbindungen mit dem Server getrennt. ' + #10 + #13 + #10 + #13 + 'Wirklich Beenden?', 'Beenden?', MB_YESNO + MB_IconQuestion + MB_ApplModal + MB_DefButton2) = IDNO then abort;
    TaskBarRemoveIcon;
    Regist.WriteString('csoAdresse', csoClient.Address);
    Regist.WriteString('csoPort', IntToStr(csoClient.Port));
// loging out
   If csoClient.Active then begin
     csoclient.Socket.SendText('%o%' + Host + '%');
     csoClient.Active := false;
   end;
   SendEreignis.Free;
   SPuffer.Free;
   close;
end;

procedure TfrmMain.csoClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
     Host := csoClient.Socket.LocalHost;
     csoClient.Socket.SendText('%e%' + Host + '%' + UserName + '%');
end;

procedure TfrmMain.Erstellen1Click(Sender: TObject);
begin
     frmConnection.showmodal;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     frmMain.csoClient.Active := false;
//     frmMain.Hide;
//     abort;
end;

procedure TfrmMain.Info1Click(Sender: TObject);
begin
     ShowSplashFrm('c', false);
end;

procedure TfrmMain.Beenden1Click(Sender: TObject);
begin
     frmMain.realEnd;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var dw: dWord;
    kack: PChar;
begin
     TaskBarAddIcon;
     mmoChat.Text := '';
     Trennen1.Enabled := false;
     Regist := TRegistry.Create;
//     IPAddress := csoClient.Socket.LocalAddress;
     dw := 255;
     Kack := StrAlloc(255);
     GetUserName(Kack, dw);
     UserName := Kack;
     StrDispose(Kack);
     edtChat.Text := '';
//Restart Connection
     Regist.RootKey := HKey_Current_User;
     Regist.OpenKey('Software\Tommiware\Chat10', true);
     IF Regist.ReadString('csoPort') = '' then begin
        Regist.WriteString('csoPort', '7350');
        csoClient.Port := StrToInt(Regist.ReadString('csoPort'));
     End;
     csoClient.Port := StrToInt(Regist.ReadString('csoPort'));
     csoClient.Address  := Regist.ReadString('csoAdresse');
     IF csoClient.Address = '' Then Begin
        Regist.WriteString('csoAdresse', '127.0.0.1');
        csoClient.Address := Regist.ReadString('csoAdresse');
     End;
     If Regist.GetDataSize('cScrollen') = -1 then
        Regist.WriteBool('cScrollen', true);
     ChatScrollen := Regist.ReadBool('cScrollen');
     If Regist.GetDataSize('cZeilen') = -1 then
        Regist.WriteInteger('cZeilen', 25);
     ChatZeilen := Regist.ReadInteger('cZeilen');

     If Regist.GetDataSize('cRestart') = -1 then
        Regist.WriteBool('cRestart', false);
     If Regist.ReadBool('cRestart') then begin
        frmMain.csoClient.Active := true;
        frmMain.Erstellen1.Enabled := false;
        frmMain.Trennen1.Enabled := true;
        stbMain.Panels.Items[0].Text := 'Verbunden mit ' + csoClient.Address + ' auf Port ' + IntToStr(csoClient.Port);
     end;
end;

procedure TfrmMain.Trennen1Click(Sender: TObject);
begin
// loging out
   If MessageBox(0, 'Sind sie sicher, dass sie die Verbindung mit dem Server trennen wollen?', 'Trennen?', MB_YESNO + MB_IconQuestion + MB_ApplModal + MB_DefButton2) = IDYES then begin
     csoclient.Socket.SendText('%o%' + Host + '%');
     csoClient.Active := false;
     Trennen1.Enabled := false;
     Erstellen1.Enabled := true;
     stbMain.Panels.Items[0].Text := 'nicht Verbunden';
   end;
end;

procedure TfrmMain.csoClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
   text: String;
begin
     text := csoClient.Socket.ReceiveText;
     SendEreignis.Text := Text;
     SPuffer.Add(SendEreignis);
     tmrPuffer.Enabled := true;
end;

procedure TfrmMain.edtChatKeyPress(Sender: TObject; var Key: Char);
var Code: Char;
    i: Integer;
begin
   If (key = #13) and not(edtChat.Text = '') then begin
// Sonderoption
     If Copy(edtChat.Text, 1, 1) = '%' then begin
       Code := lowercase(Copy(edtChat.Text, 2, 1))[1];
       Case Code of
{Whisper}     'w': begin
                   csoClient.Socket.Sendtext(edtChat.Text);
                   end;
{Message}     'm': begin
                   csoClient.Socket.Sendtext(edtChat.Text);
                   end;
        end
     end else begin
         If frmBenutzer.rbnSelected.Checked then begin
            If frmBenutzer.DstList.Items.Count > 0 then
               For i := 0 to (frmBenutzer.DstList.Items.Count - 1) do
                  csoClient.Socket.SendText('%w%' + frmBenutzer.DstList.Items[i] + '%' + UserName + '@' + Host + '...' + edtChat.Text + '%')
         end;
         If frmBenutzer.rbnAll.Checked then begin
{Loud}      csoClient.Socket.Sendtext('%c%' + Host + '%' + edtChat.text + '%');
         end;
     end;
         edtChat.text := '';
   end;
end;

procedure TfrmMain.Optionen1Click(Sender: TObject);
begin
     frmOptions.Show;
end;

procedure TfrmMain.ChatLschen1Click(Sender: TObject);
begin
     mmoChat.Text := '';
end;

procedure TfrmMain.Anzeigen1Click(Sender: TObject);
begin
     frmMain.show;
end;

procedure TfrmMain.Schliessen1Click(Sender: TObject);
begin
     frmMain.Hide;
end;

procedure TfrmMain.Zettelschreiben1Click(Sender: TObject);
begin
     frmZettel.show;
end;

procedure TfrmMain.Benutzer1Click(Sender: TObject);
begin
     frmBenutzer.show;
end;

procedure TfrmMain.Malfenster1Click(Sender: TObject);
begin
     frmMalen.show;
end;


procedure TfrmMain.tmrPufferTimer(Sender: TObject);
var
   text, cUser, MyText: String;
   i, found: Integer;
   f: File;
   Gefunden: Boolean;
begin
  If SPuffer.Count > 0 then begin
     SendEreignis := SPuffer.Items[0];
     Text := SendEreignis.Text;
// Chat
     If text[2] = 'c' then begin
        mmoChat.Text := mmoChat.Text + copy(text, 4, length(text)-4) + #13 + #10;
        CheckMemo
     end;
// Message
     If text[2] = 'm' then begin
        MyText := GetString('%', text, 2);
        If MyText = (UserName + '@' + Host) then begin
           If FileExists('message.txt') then DeleteFile('message.txt');
           AssignFile(f, 'message.txt');
           {$i-} Rewrite(f, 1); {$i+}
           MyText := GetString('%', Text, 3);
           BlockWrite(f, MyText[1], length(MyText));
           CloseFile(f);
           i := ShellExecute(handle, 'open', 'zettel.exe', 'message.txt', '', sw_show);
           If i <= 32 then
              showmessage('Unerwarteter Fehler aufgetreten');
        end
     end;
// Benutzer hinzufügen
     If text[2] = 'u' then begin
        cUser := GetString('%', Text, 2);
        If not Eintrag(cUser) then begin
           frmBenutzer.SrcList.Items.Add(cUser);
           frmZettel.cmbUser.Items.Add(cUser);
           mmoChat.Text := mmoChat.Text + '**** Sarah: ' + cUser + ' ist in den Chat gekommen' + #13 + #10;
           frmMain.CheckMemo;
        end;
     end;
// Benutzer löschen
     If text[2] = 'v' then begin
        cUser := GetString('%', text, 2);
// Entfernen aus frmBenutzer
        Gefunden := false;
        For i := 0 to (frmBenutzer.SrcList.Items.Count - 1) do begin
          If not frmBenutzer.SRCList.Items.Count = 0 then
            If frmBenutzer.SrcList.Items[i] = cUser then begin
               Gefunden := True;
               Found := i;
               frmBenutzer.SrcList.Items.Delete(Found);
            end;
        end;
        If not Gefunden then
          If not frmBenutzer.DSTList.Items.Count = 0 then
            For i := 0 to (frmBenutzer.SrcList.Items.Count- 1) do begin
                If frmBenutzer.DstList.Items[i] = cUser then begin
                   Found := i;
                   frmBenutzer.DstList.Items.Delete(Found);
                end;
            end;
// austragen aus frmZettel.cmbUser
        For i := 0 to (frmZettel.cmbUser.Items.Count - 1) do begin
            If frmZettel.cmbUser.Items[i] = cUser then begin
               frmZettel.cmbUser.Items.Delete(i);
            end;
        end;
        mmoChat.Text := mmoChat.Text + '**** Sarah: ' + cUser + ' hat den Chat verlassen' + #13 + #10;
        frmMain.CheckMemo;
     end;
// Whisper
     If text[2] = 'w' then begin
        If UserName + '@' + Host = GetString('%', text, 2) then begin
           mmoChat.Text := mmoChat.Text + GetString('%', text, 3) + #13 + #10;
           CheckMemo;
        end;
     end;
// Rausgeworfen werden
     If text[2] = 'o' then
        If Host = GetString('%', Text, 2) then begin
          csoClient.Socket.SendText('%o%' + Host + '%');
          csoClient.Active := false;
          MessageBox(handle, 'Sie sind von Sarah rausgeworfen worden', 'und tschüss...', mb_ok + mb_applmodal);
          SPuffer.Clear;
        end;
// Malen -> Weitersenden an frmMalen.GetPaint
     If text[2] = 'p' then
        frmMalen.GetPaint(Copy(text, 3, length(text) - 2));
// Neues Datum und Uhrzeit
     If Text[2] = 't' then begin
//        Date := StrToDate(GetString('%', text, 2));
//        Time := StrToDate(GetString('%', text, 3));
     end;
// Erstes Item des Puffers lösche
   If SPuffer.Count > 0 then SPuffer.Delete(0) else SPuffer.Clear;
   end else tmrPuffer.Enabled := false; {Wenn count > 0}
end;

begin
// Puffer:
     SendEreignis := TSendEreignis.Create;
     SPuffer := TList.Create;
end.
