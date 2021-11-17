unit uniMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ScktComp, ComCtrls, Tabnotbk, Buttons, Registry, Grids, Menus, ShellApi,
  ExtCtrls;

const wm_taskbarevent = wm_user + 1;

type MyEreignis = class(TObject)
       Text: String;
end;

type
  TfrmMain = class(TForm)
    tbnMain: TTabbedNotebook;
    ssoServer: TServerSocket;
    stgBenutzer: TStringGrid;
    mmoChat: TMemo;
    mmoProtokoll: TMemo;
    gpbThisInfo: TGroupBox;
    lblUser: TLabel;
    lblPC: TLabel;
    lblIP: TLabel;
    edtUser: TEdit;
    edtPC: TEdit;
    edtIP: TEdit;
    mmuMain: TMainMenu;
    Datei1: TMenuItem;
    Starten1: TMenuItem;
    Unterbrechen1: TMenuItem;
    N1: TMenuItem;
    Beenden1: TMenuItem;
    lblCopyright: TLabel;
    gpbVerbindung: TGroupBox;
    Label1: TLabel;
    edtPort: TEdit;
    Bearbeiten1: TMenuItem;
    Protokoll1: TMenuItem;
    Lschen1: TMenuItem;
    N2: TMenuItem;
    Optionen1: TMenuItem;
    lblActive: TLabel;
    imgIcon: TImage;
    ppmTNA: TPopupMenu;
    Beenden2: TMenuItem;
    Anzeigen1: TMenuItem;
    Info2: TMenuItem;
    Schliessen1: TMenuItem;
    Client1: TMenuItem;
    Rauswerfen1: TMenuItem;
    Label2: TLabel;
    edtConnections: TEdit;
    N3: TMenuItem;
    tmrAktualisieren: TTimer;
    tmrPuffer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure ssoServerClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure Starten1Click(Sender: TObject);
    procedure Unterbrechen1Click(Sender: TObject);
    procedure Beenden1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Lschen1Click(Sender: TObject);
    procedure Optionen1Click(Sender: TObject);
    procedure Info1Click(Sender: TObject);
    procedure MyUpdate;
    procedure Anzeigen1Click(Sender: TObject);
    procedure Schliessen1Click(Sender: TObject);
    procedure SendAllUser;
    procedure rLogoutUser(Computer: String);
    procedure Rauswerfen1Click(Sender: TObject);
    procedure tmrAktualisierenTimer(Sender: TObject);
    procedure tmrPufferTimer(Sender: TObject);
  protected
    procedure WMTaskBarEvent(var message: TMessage); message WM_TaskBarEvent;
  end;

// Sonstige Funktionen oder Proceduren aus DLL's
function GetString(Zeichen: Char; Text: ShortString; Zahler: Integer): ShortString; stdcall; external 'csUtil21.dll';
function GetProgrammer: ShortString; stdcall; external 'csUtil21.dll';
procedure LogoutUser(Table: TStringGrid; Computer: ShortString); stdCall; external 'csUtil21.dll';
function GetNameByPc(Table: TStringGrid; Computer: ShortString): ShortString; stdcall; external 'csUtil21.dll';
procedure ShowSplashFrm(ID: Char; Time: Integer); stdcall; external 'csUtil21.dll';
function GetVersion: ShortString; stdcall; external 'csutil21.dll';

// Meine Proceduren und Funktionen
procedure TaskBarAddIcon;
procedure TaskBarRemoveIcon;
procedure SendToAll(Text: String);

var
  Ereignis: MyEreignis;
  Puffer: TList;
  frmMain: TfrmMain;
  Regist: TRegistry;
  ChatZeilen: Integer;
  ChatScrollen: Boolean;

implementation

uses uniOptions;

{$R *.DFM}

procedure SendToAll(Text: String);
var i: Integer;
begin
   If frmMain.ssoServer.Socket.ActiveConnections > 0 then begin
     i := 0;
     Repeat
           frmMain.ssoServer.Socket.Connections[i].SendText(Text);
           inc(i);
     until i >= frmMain.ssoServer.Socket.ActiveConnections;
   end;
end;

procedure TaskBarAddIcon;
var mytna: TNOTIFYICONDATA;
begin
     mytna.cbSize := sizeof(Tnotifyicondata);
     mytna.Wnd := frmMain.handle;
     mytna.uid := 1;
     mytna.hIcon := frmMain.imgIcon.Picture.Icon.Handle;
     mytna.uFlags := nif_message or nif_Icon or nif_tip;
     mytna.ucallbackmessage := wm_Taskbarevent;
     strcopy(mytna.sztip, 'Intra Chat - Server');
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
     If Regist.GetDataSize('Scrollen') = -1 then
        Regist.WriteBool('Scrollen', true);
     ChatScrollen := Regist.ReadBool('Scrollen');
     If Regist.GetDataSize('Zeilen') = -1 then
        Regist.WriteInteger('Zeilen', 25);
     ChatZeilen := Regist.ReadInteger('Zeilen');
end;

procedure TfrmMain.SendAllUser;
var
   i: Integer;
begin
   If stgBenutzer.RowCount > 1 then
     For i := 1 to stgBenutzer.RowCount - 1 do
         SendToAll('%u%' + stgBenutzer.Cells[0, i] + '@' + stgBenutzer.Cells[1, i] + '%');
end;

procedure TfrmMain.rLogoutUser(Computer: String);
begin
     SendToAll('%o%' + Computer + '%');
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  dw: dWord;
  UserID: PChar;
  Port: String;
begin
// Icon in TNA
     TaskBarAddIcon;
     frmMain.Caption := 'Intra Chat ' + GetVersion + ' [Server]';
     frmMain.lblCopyright.caption := 'Copyright: ' + GetProgrammer;
     stgBenutzer.Cells[0, 0] := 'Benutzer';
     stgBenutzer.Cells[1, 0] := 'Computer';
     dw := 255;
     UserID := StrAlloc(255);
     GetUserName(UserID, dw);
     edtUser.text := UserID;
     edtPort.Text := 'none';
     mmoChat.Text := '';
     mmoProtokoll.Text := '';
     Regist := TRegistry.Create;
     Regist.RootKey := HKey_Current_User;
     Regist.OpenKey('Software\Tommiware\Chat10', True);
     If Regist.GetDataSize('Restart') = -1 then
        Regist.WriteBool('Restart', false);
     If Regist.ReadString('ssoPort') = '' then
        Regist.WriteString('ssoPort', '7350');
     If Regist.GetDataSize('Scrollen') = -1 then
        Regist.WriteBool('Scrollen', true);
     ChatScrollen := Regist.ReadBool('Scrollen');
     If Regist.GetDataSize('Zeilen') = -1 then
        Regist.WriteInteger('Zeilen', 25);
     ChatZeilen := Regist.ReadInteger('Zeilen');

     Port := Regist.ReadString('ssoPort');
     If Regist.ReadBool('Restart') then begin
        ssoServer.Port := StrToInt(Port);
        ssoServer.Active := true;
        edtPort.Text := Port;
        edtPC.Text := ssoServer.Socket.LocalHost;
        Starten1.Checked := true;
        Starten1.Enabled := false;
        mmoChat.Text := ''; mmoProtokoll.Text := '';
        lblActive.Caption := 'open';
     end;
end;

procedure TfrmMain.ssoServerClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
begin
     Ereignis.Text := Socket.ReceiveText;
     Puffer.Add(Ereignis);
     tmrPuffer.Enabled := true;
end;

procedure TfrmMain.Starten1Click(Sender: TObject);
var
   port: String;
begin
     InputQuery('Welcher Service soll benutzt werden?', 'Port:', Port);

     ssoServer.Port := StrToInt(Port);
     ssoServer.Active := true;
     edtPort.Text := Port;
     edtPC.Text := ssoServer.Socket.LocalHost;
     Starten1.Checked := true;
     Starten1.Enabled := false;
     lblActive.Caption := 'open';
end;

procedure TfrmMain.Unterbrechen1Click(Sender: TObject);
begin
     If Unterbrechen1.Checked then begin
        ssoServer.Open;
        Unterbrechen1.Checked := false;
        edtPort.Enabled := true;
        lblActive.Caption := 'open';
        frmMain.Starten1.Enabled := false;
     end else begin
         ssoServer.Close;
         Unterbrechen1.Checked := true;
         edtPort.Enabled := false;
         lblActive.Caption := 'close';
         frmMain.Starten1.Enabled := true;
     end;
end;

procedure TfrmMain.Beenden1Click(Sender: TObject);
begin
        close;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var Zeilen: Integer;
begin
     If MessageBox(0, 'Beim Beenden des Servers werden alle' + #10 + #13 + 'Client- Verbindungen getrennt.' + #10 + #13 + #10 + #13 + 'Sicher?', 'Beenden', MB_YesNo + MB_IconQuestion + MB_ApplModal) = IDNo then abort;
       If frmOptions.ckbWieder.Checked then begin
          Regist.WriteString('ssoPort', IntToStr(ssoServer.Port));
       end;
       Regist.WriteString('ssoPort', IntToStr(ssoServer.Port));
       Regist.WriteBool('Scrollen', frmOptions.ckbScrollen.Checked);
       Zeilen := StrToInt(frmOptions.edtZeilen.text);
       If Zeilen = 0 then Zeilen := 25;
       Regist.WriteInteger('Zeilen', Zeilen);
     TaskBarRemoveIcon;
     ssoServer.Active := false;
     Puffer.Free;
     Ereignis.Free;
end;

procedure TfrmMain.Lschen1Click(Sender: TObject);
begin
     mmoProtokoll.text := 'Protokoll gelöscht' + #13 + #10;
end;

procedure TfrmMain.Optionen1Click(Sender: TObject);
begin
     frmOptions.showModal;
end;

procedure TfrmMain.Info1Click(Sender: TObject);
begin
     ShowSplashFrm('s', 0);
end;



procedure TfrmMain.Anzeigen1Click(Sender: TObject);
begin
     frmMain.show;
end;

procedure TfrmMain.Schliessen1Click(Sender: TObject);
begin
     frmMain.hide;
end;

procedure TfrmMain.Rauswerfen1Click(Sender: TObject);
var rComputer: String;
begin
     InputQuery('Welcher Benutzer soll rausgeworfen werden ?' + #10 + #13, 'Computer:', rComputer);
     frmMain.rLogoutUser(rComputer);
end;

procedure TfrmMain.tmrAktualisierenTimer(Sender: TObject);
begin
   edtConnections.Text := IntToStr(frmMain.ssoServer.Socket.ActiveConnections);
end;

procedure TfrmMain.tmrPufferTimer(Sender: TObject);
var
   Belang: Char;
   i: Integer;
   MyMessage, Computer, Chat, cUser, Text: String;
begin
   If Puffer.Count > 0 then begin
     Ereignis := Puffer[0];
     Text := Ereignis.text;
     Belang := Text[2];

     Case Belang of
          'e': Begin
                    Computer := GetString('%', Text, 2);
                    cUser := GetString('%', Text, 3);
                    mmoProtokoll.Text := mmoProtokoll.Text +'Anmeldung: ' + cUser + '@' + Computer + #13 + #10;
                    stgBenutzer.RowCount := ssoServer.Socket.ActiveConnections + 1;
                    stgBenutzer.Cells[0, ssoServer.Socket.ActiveConnections] := cUser;
                    stgBenutzer.Cells[1, ssoServer.Socket.ActiveConnections] := Computer;
                    SendAllUser;
               end;
          'o': Begin
                    Computer := GetString('%', Text, 2);
                    cUser := GetNameByPc(stgBenutzer, Computer);
                    mmoProtokoll.Text := mmoProtokoll.Text +'Abmeldung: ' + cUser + '@' + Computer + #13 + #10;
                    LogoutUser(stgBenutzer, Computer);
                    SendToAll('%v%' + cUser + '@' + Computer + '%');
               end;
          'c': Begin
                    Chat := GetString('%', Text, 3);
                    Computer := GetString('%', Text, 2);
                    cUser := GetNameByPc(stgBenutzer, Computer);
                    mmoChat.Text := mmoChat.text + cUser + '@' + Computer + ': ' + Chat + #13 + #10;
                    If (mmoChat.Lines.Count >= ChatZeilen) and ChatScrollen then begin
                       For i := 1 to (mmoChat.Lines.Count - Round(ChatZeilen / 5)) do
                           mmoChat.Lines.Delete(0);
                    end;
                    SendToAll('%c%' + cUser + '@' + Computer + ': ' + Chat + '%');
               end;
          'm': Begin
                    Chat := GetString('%', Text, 3);
                    Computer := GetString('%', Text, 2);
                    MyMessage := '%m%' + Computer + '%' + Computer + ':  ' + Chat + '%';
                    SendToAll(MyMessage);
               end;
          'w': Begin
                    Chat := GetString('%', Text, 3);
                    Computer := GetString('%', Text, 2);
                    MyMessage := '%w%' + Computer + '%psst..' + Chat + '%';
                    SendToAll(MyMessage);
               end;
          else SendToAll(Text)
     end;
     Puffer.Delete(0);
   end else tmrPuffer.Enabled := false;
end;

begin
     Puffer := TList.Create;
     Ereignis := MyEreignis.Create;
end.
