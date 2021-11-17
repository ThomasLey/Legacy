unit uniMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, CoolTrayIcon, Menus, ScktComp, uniBlack, Buttons,
  inifiles;

type
  TfrmMain = class(TForm)
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    e1: TEdit;
    e2: TEdit;
    e3: TEdit;
    e4: TEdit;
    e9: TEdit;
    e8: TEdit;
    e7: TEdit;
    e10: TEdit;
    e11: TEdit;
    e12: TEdit;
    e13: TEdit;
    e17: TEdit;
    e16: TEdit;
    e15: TEdit;
    e14: TEdit;
    c1: TCheckBox;
    c2: TCheckBox;
    c3: TCheckBox;
    c4: TCheckBox;
    e5: TEdit;
    c5: TCheckBox;
    c9: TCheckBox;
    c8: TCheckBox;
    c7: TCheckBox;
    c6: TCheckBox;
    c10: TCheckBox;
    c11: TCheckBox;
    c12: TCheckBox;
    c13: TCheckBox;
    c17: TCheckBox;
    c16: TCheckBox;
    c15: TCheckBox;
    c14: TCheckBox;
    MainMenu1: TMainMenu;
    Datei1: TMenuItem;
    Beenden1: TMenuItem;
    Computer1: TMenuItem;
    Nachrichtenschicken1: TMenuItem;
    Herunterfahren1: TMenuItem;
    CoolTrayIcon1: TCoolTrayIcon;
    PopupMenu1: TPopupMenu;
    System1: TSystem;
    Anzeigen1: TMenuItem;
    ServerSocket: TServerSocket;
    N1: TMenuItem;
    Verbinden1: TMenuItem;
    Nachrichtanallesenden1: TMenuItem;
    N2: TMenuItem;
    Beenden2: TMenuItem;
    Nachrichtenfenster1: TMenuItem;
    e6: TEdit;
    Label5: TLabel;
    Info1: TMenuItem;
    N3: TMenuItem;
    Uhrzeitsenden1: TMenuItem;
    Datumsenden1: TMenuItem;
    Versionausgeben1: TMenuItem;
    Einstellungenspeichern1: TMenuItem;
    Anzeigen2: TMenuItem;
    N4: TMenuItem;
    Programmausfhren1: TMenuItem;
    procedure Anzeigen1Click(Sender: TObject);
    procedure Beenden1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Verbinden1Click(Sender: TObject);
    procedure ServerSocketClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure Nachrichtanallesenden1Click(Sender: TObject);
    procedure Nachrichtenfenster1Click(Sender: TObject);
    procedure Herunterfahren1Click(Sender: TObject);
    procedure Nachrichtenschicken1Click(Sender: TObject);
    procedure Info1Click(Sender: TObject);
    procedure Uhrzeitsenden1Click(Sender: TObject);
    procedure Datumsenden1Click(Sender: TObject);
    procedure Versionausgeben1Click(Sender: TObject);
    procedure Einstellungenspeichern1Click(Sender: TObject);
    procedure Programmausfhren1Click(Sender: TObject);
    procedure Anzeigen21Click(Sender: TObject);
    procedure ServerSocketClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frmMain: TfrmMain;
  DarfGeschlossenWerden: Boolean;

implementation

uses uniMessage, uniAbout;

{$R *.DFM}

function GetString(Zeichen: Char; Text: ShortString; Zahler: Integer): ShortString;
var i, j, Start: Integer;
begin
     j := 0; Start := 1;
     for i := 1 to length(Text) do begin
         If Text[i] = Zeichen then begin
            Inc(j);
            If j = (Zahler) then Start := i + 1;
            If j = (Zahler + 1) then Result := Copy(Text, Start, i - Start);
         end
     end;
end;

procedure SendToAll(Text: String);
var
   i: Byte;
begin
  If frmMain.ServerSocket.Socket.ActiveConnections >= 1 then
     For i := 0 to (frmMain.ServerSocket.Socket.ActiveConnections - 1) do Begin
         frmMain.ServerSocket.Socket.Connections[i].SendText(Text);
     end;
end;

procedure TfrmMain.Anzeigen1Click(Sender: TObject);
begin
     frmNachrichten.close;
     AboutBox.Close;
     frmMain.Show;
     frmMain.Update;
     frmMain.RePaint;
end;

procedure TfrmMain.Beenden1Click(Sender: TObject);
begin
     SendToAll('µxµ');
     ServerSocket.Close;
     DarfGeschlossenWerden := true;
     frmMain.Close;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
   INI: TIniFile;
   Path: ShortString;
begin
     DarfGeschlossenWerden := false;
// Einlesen der Computerdaten
     Path := ParamStr(0);
     Path := Copy(Path, 1, Length(Path) - 3);
     Path := Path + 'ini';
     INI := TIniFile.Create(Path);
     e1.Text := INI.ReadString('Computernamen', 'e1', '');
     e2.Text := INI.ReadString('Computernamen', 'e2', '');
     e3.Text := INI.ReadString('Computernamen', 'e3', '');
     e4.Text := INI.ReadString('Computernamen', 'e4', '');
     e5.Text := INI.ReadString('Computernamen', 'e5', '');
     e6.Text := INI.ReadString('Computernamen', 'e6', '');
     e7.Text := INI.ReadString('Computernamen', 'e7', '');
     e8.Text := INI.ReadString('Computernamen', 'e8', '');
     e9.Text := INI.ReadString('Computernamen', 'e9', '');
     e10.Text := INI.ReadString('Computernamen', 'e10', '');
     e11.Text := INI.ReadString('Computernamen', 'e11', '');
     e12.Text := INI.ReadString('Computernamen', 'e12', '');
     e13.Text := INI.ReadString('Computernamen', 'e13', '');
     e14.Text := INI.ReadString('Computernamen', 'e14', '');
     e15.Text := INI.ReadString('Computernamen', 'e15', '');
     e16.Text := INI.ReadString('Computernamen', 'e16', '');
     e17.Text := INI.ReadString('Computernamen', 'e17', '');
     INI.Free;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     If not DarfGeschlossenWerden then begin
        frmMain.Hide;
        Abort;
     end;
end;

procedure TfrmMain.Verbinden1Click(Sender: TObject);
var
   Port, Path: String;
   INI: TINIFILE;
begin
     If ServerSocket.Active then ServerSocket.Active := false;
     InputQuery('Welcher Port soll benutzt werden?', 'Port:', Port);
     ServerSocket.Port := StrToInt(Port);
     ServerSocket.Active := true;

     AboutBox.edtPort.Text := Port;
     Path := ParamStr(0);
     Path := Copy(Path, 1, Length(Path) - 3);
     Path := Path + 'ini';
     INI := TIniFile.Create(Path);
     Ini.WriteString('Client', 'Port', Port);

     Ini.Free;

     //edtPC.Text := ssoServer.Socket.LocalHost;
     //Starten1.Checked := true;
     //Starten1.Enabled := false;
     //lblActive.Caption := 'open';
end;

procedure TfrmMain.ServerSocketClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
   tText, PC, User, Temp: String;
   Option: Char;
begin
     tText := Socket.ReceiveText;
     PC := UpperCase(GetString('µ', tText, 2));
     User := UpperCase(GetString('µ', tText, 3));
     Temp := GetString('µ', tText, 1);
     Option := Temp[1];
// Wenn Option = i , dann ist der Benutzer nicht der Administrator
//        (SCHÜLER)
// Wenn Option = j , dann ist der Benutzer der Administrator (lokal und global)
     If (Option = 'i') and (User = 'ADMINISTRATOR') then Option := 'j'
     else
     If (Option = 'i') and (User = 'SCHüLER') then Option := 'k'
     else
     If (Option = 'i') and (User = 'ADMIN') then Option := 'j';



     With e1 do
     If Text = PC then begin
        Case Option of
             'i': begin
                  Color := clBlue;
                  end;
             'j': begin
                  Color := clYellow;
                  end;
             'k': begin
                  Color := clGreen;
                  end;
             'o': begin
                  Color := clRed;
                  end;
        end;
     end;

     With e2 do
     If Text = PC then begin
        Case Option of
             'i': begin
                  Color := clBlue;
                  end;
             'j': begin
                  Color := clYellow;
                  end;
             'k': begin
                  Color := clGreen;
                  end;
             'o': begin
                  Color := clRed;
                  end;
        end;
     end;

     With e3 do
     If Text = PC then begin
        Case Option of
             'i': begin
                  Color := clBlue;
                  end;
             'j': begin
                  Color := clYellow;
                  end;
             'k': begin
                  Color := clGreen;
                  end;
             'o': begin
                  Color := clRed;
                  end;
        end;
     end;

     With e4 do
     If Text = PC then begin
        Case Option of
             'i': begin
                  Color := clBlue;
                  end;
             'j': begin
                  Color := clYellow;
                  end;
             'k': begin
                  Color := clGreen;
                  end;
             'o': begin
                  Color := clRed;
                  end;
        end;
     end;

     With e5 do
     If Text = PC then begin
        Case Option of
             'i': begin
                  Color := clBlue;
                  end;
             'j': begin
                  Color := clYellow;
                  end;
             'k': begin
                  Color := clGreen;
                  end;
             'o': begin
                  Color := clRed;
                  end;
        end;
     end;

     With e6 do
     If Text = PC then begin
        Case Option of
             'i': begin
                  Color := clBlue;
                  end;
             'j': begin
                  Color := clYellow;
                  end;
             'k': begin
                  Color := clGreen;
                  end;
             'o': begin
                  Color := clRed;
                  end;
        end;
     end;

     With e7 do
     If Text = PC then begin
        Case Option of
             'i': begin
                  Color := clBlue;
                  end;
             'j': begin
                  Color := clYellow;
                  end;
             'k': begin
                  Color := clGreen;
                  end;
             'o': begin
                  Color := clRed;
                  end;
        end;
     end;

     With e8 do
     If Text = PC then begin
        Case Option of
             'i': begin
                  Color := clBlue;
                  end;
             'j': begin
                  Color := clYellow;
                  end;
             'k': begin
                  Color := clGreen;
                  end;
             'o': begin
                  Color := clRed;
                  end;
        end;
     end;

     With e9 do
     If Text = PC then begin
        Case Option of
             'i': begin
                  Color := clBlue;
                  end;
             'j': begin
                  Color := clYellow;
                  end;
             'k': begin
                  Color := clGreen;
                  end;
             'o': begin
                  Color := clRed;
                  end;
        end;
     end;

     With e10 do
     If Text = PC then begin
        Case Option of
             'i': begin
                  Color := clBlue;
                  end;
             'j': begin
                  Color := clYellow;
                  end;
             'k': begin
                  Color := clGreen;
                  end;
             'o': begin
                  Color := clRed;
                  end;
        end;
     end;

     With e11 do
     If Text = PC then begin
        Case Option of
             'i': begin
                  Color := clBlue;
                  end;
             'j': begin
                  Color := clYellow;
                  end;
             'k': begin
                  Color := clGreen;
                  end;
             'o': begin
                  Color := clRed;
                  end;
        end;
     end;

     With e12 do
     If Text = PC then begin
        Case Option of
             'i': begin
                  Color := clBlue;
                  end;
             'j': begin
                  Color := clYellow;
                  end;
             'k': begin
                  Color := clGreen;
                  end;
             'o': begin
                  Color := clRed;
                  end;
        end;
     end;

     With e13 do
     If Text = PC then begin
        Case Option of
             'i': begin
                  Color := clBlue;
                  end;
             'j': begin
                  Color := clYellow;
                  end;
             'k': begin
                  Color := clGreen;
                  end;
             'o': begin
                  Color := clRed;
                  end;
        end;
     end;

     With e14 do
     If Text = PC then begin
        Case Option of
             'i': begin
                  Color := clBlue;
                  end;
             'j': begin
                  Color := clYellow;
                  end;
             'k': begin
                  Color := clGreen;
                  end;
             'o': begin
                  Color := clRed;
                  end;
        end;
     end;

     With e15 do
     If Text = PC then begin
        Case Option of
             'i': begin
                  Color := clBlue;
                  end;
             'j': begin
                  Color := clYellow;
                  end;
             'k': begin
                  Color := clGreen;
                  end;
             'o': begin
                  Color := clRed;
                  end;
        end;
     end;

     With e16 do
     If Text = PC then begin
        Case Option of
             'i': begin
                  Color := clBlue;
                  end;
             'j': begin
                  Color := clYellow;
                  end;
             'k': begin
                  Color := clGreen;
                  end;
             'o': begin
                  Color := clRed;
                  end;
        end;
     end;

     With e17 do
     If Text = PC then begin
        Case Option of
             'i': begin
                  Color := clBlue;
                  end;
             'j': begin
                  Color := clYellow;
                  end;
             'k': begin
                  Color := clGreen;
                  end;
             'o': begin
                  Color := clRed;
                  end;
        end;
     end;

end;

procedure TfrmMain.Nachrichtanallesenden1Click(Sender: TObject);
begin
     If (not (frmNachrichten.MemoNachricht.Text = '')) and (ServerSocket.Active) then begin
        SendToAll('µmµ' + frmNachrichten.MemoNachricht.Text + 'µ');
     end else begin
         MessageDlg('Keine Nachricht eingegeben oder die Verbindung ist nicht aktiv', mtError, [mbOK], 0);
     end;
end;

procedure TfrmMain.Nachrichtenfenster1Click(Sender: TObject);
begin
     frmNachrichten.Show;
end;


procedure TfrmMain.Herunterfahren1Click(Sender: TObject);
var
   Rechner: String;
begin
     InputQuery('Welcher Rechner soll heruntergefahren werden ?', 'Name:', Rechner);
     SendToAll('µkµ' + Rechner + 'µ');
end;

procedure TfrmMain.Nachrichtenschicken1Click(Sender: TObject);
var i: Word;
begin
If (not (frmNachrichten.MemoNachricht.Text = '')) and (ServerSocket.Active) then begin
//     frmNachrichten.MemoNachricht.Text := frmNachrichten.MemoNachricht.Text + #13+#10;
     If c1.Checked then if (not (e1.text = '')) and (e1.Color = clGreen) then SendToAll('µnµ' + e1.text + 'µ' + frmNachrichten.MemoNachricht.Text + 'µ');
For i := 1 to 10000 do begin end;
     If c2.Checked then if (not (e2.text = '')) and (e2.Color = clGreen) then SendToAll('µnµ' + e2.text + 'µ' + frmNachrichten.MemoNachricht.Text + 'µ');
For i := 1 to 10000 do begin end;
     If c3.Checked then if (not (e3.text = '')) and (e3.Color = clGreen) then SendToAll('µnµ' + e3.text + 'µ' + frmNachrichten.MemoNachricht.Text + 'µ');
For i := 1 to 10000 do begin end;
     If c4.Checked then if (not (e4.text = '')) and (e4.Color = clGreen) then SendToAll('µnµ' + e4.text + 'µ' + frmNachrichten.MemoNachricht.Text + 'µ');
For i := 1 to 10000 do begin end;
     If c5.Checked then if (not (e5.text = '')) and (e5.Color = clGreen) then SendToAll('µnµ' + e5.text + 'µ' + frmNachrichten.MemoNachricht.Text + 'µ');
For i := 1 to 10000 do begin end;
     If c6.Checked then if (not (e6.text = '')) and (e6.Color = clGreen) then SendToAll('µnµ' + e6.text + 'µ' + frmNachrichten.MemoNachricht.Text + 'µ');
For i := 1 to 10000 do begin end;
     If c7.Checked then if (not (e7.text = '')) and (e7.Color = clGreen) then SendToAll('µnµ' + e7.text + 'µ' + frmNachrichten.MemoNachricht.Text + 'µ');
For i := 1 to 10000 do begin end;
     If c8.Checked then if (not (e8.text = '')) and (e8.Color = clGreen) then SendToAll('µnµ' + e8.text + 'µ' + frmNachrichten.MemoNachricht.Text + 'µ');
For i := 1 to 10000 do begin end;
     If c9.Checked then if (not (e9.text = '')) and (e9.Color = clGreen) then SendToAll('µnµ' + e9.text + 'µ' + frmNachrichten.MemoNachricht.Text + 'µ');
For i := 1 to 10000 do begin end;
     If c10.Checked then if (not (e10.text = '')) and (e10.Color = clGreen) then SendToAll('µnµ' + e10.text + 'µ' + frmNachrichten.MemoNachricht.Text + 'µ');
For i := 1 to 10000 do begin end;
     If c11.Checked then if (not (e11.text = '')) and (e11.Color = clGreen) then SendToAll('µnµ' + e11.text + 'µ' + frmNachrichten.MemoNachricht.Text + 'µ');
For i := 1 to 10000 do begin end;
     If c12.Checked then if (not (e12.text = '')) and (e12.Color = clGreen) then SendToAll('µnµ' + e12.text + 'µ' + frmNachrichten.MemoNachricht.Text + 'µ');
For i := 1 to 10000 do begin end;
     If c13.Checked then if (not (e13.text = '')) and (e13.Color = clGreen) then SendToAll('µnµ' + e13.text + 'µ' + frmNachrichten.MemoNachricht.Text + 'µ');
For i := 1 to 10000 do begin end;
     If c14.Checked then if (not (e14.text = '')) and (e14.Color = clGreen) then SendToAll('µnµ' + e14.text + 'µ' + frmNachrichten.MemoNachricht.Text + 'µ');
For i := 1 to 10000 do begin end;
     If c15.Checked then if (not (e15.text = '')) and (e15.Color = clGreen) then SendToAll('µnµ' + e15.text + 'µ' + frmNachrichten.MemoNachricht.Text + 'µ');
For i := 1 to 10000 do begin end;
     If c16.Checked then if (not (e16.text = '')) and (e16.Color = clGreen) then SendToAll('µnµ' + e16.text + 'µ' + frmNachrichten.MemoNachricht.Text + 'µ');
For i := 1 to 10000 do begin end;
     If c17.Checked then if (not (e17.text = '')) and (e17.Color = clGreen) then SendToAll('µnµ' + e17.text + 'µ' + frmNachrichten.MemoNachricht.Text + 'µ');
end else begin
     MessageDlg('Keine Nachricht eingegeben oder die Verbindung ist nicht aktiv', mtError, [mbOK], 0);
end;
end;

procedure TfrmMain.Info1Click(Sender: TObject);
begin
     AboutBox.Show;
end;

procedure TfrmMain.Uhrzeitsenden1Click(Sender: TObject);
var
   Zeit: ShortString;
   Text: ShortString;
begin
     Zeit := TimeToStr(Time);
     Text := Copy(Zeit, 1, 2) + 'µ' + Copy(Zeit, 4, 2) + 'µ' + Copy(Zeit, 7, 2);
     SendToAll('µsµ' + Text + 'µ');
end;

procedure TfrmMain.Datumsenden1Click(Sender: TObject);
var
   Zeit: ShortString;
   Text: ShortString;
begin
     Zeit := DateToStr(Date);
     Text := Copy(Zeit, 1, 2) + 'µ' + Copy(Zeit, 4, 2) + 'µ' + Copy(Zeit, 7, 2);
     SendToAll('µdµ' + Text + 'µ');
end;

procedure TfrmMain.Versionausgeben1Click(Sender: TObject);
var
   Rechner: String;
begin
     InputQuery('Welcher Rechner soll seine Version ausgeben ?', 'Name:', Rechner);
     SendToAll('µvµ' + Rechner + 'µ');
end;

procedure TfrmMain.Einstellungenspeichern1Click(Sender: TObject);
var
   INI: TIniFile;
   Path: ShortString;
begin
// Schreiben der Computerdaten
     Path := ParamStr(0);
     Path := Copy(Path, 1, Length(Path) - 3);
     Path := Path + 'ini';
     INI := TIniFile.Create(Path);
     INI.WriteString('Computernamen', 'e1', e1.Text);
     INI.WriteString('Computernamen', 'e2', e2.Text);
     INI.WriteString('Computernamen', 'e3', e3.Text);
     INI.WriteString('Computernamen', 'e4', e4.Text);
     INI.WriteString('Computernamen', 'e5', e5.Text);
     INI.WriteString('Computernamen', 'e6', e6.Text);
     INI.WriteString('Computernamen', 'e7', e7.Text);
     INI.WriteString('Computernamen', 'e8', e8.Text);
     INI.WriteString('Computernamen', 'e9', e9.Text);
     INI.WriteString('Computernamen', 'e10', e10.Text);
     INI.WriteString('Computernamen', 'e11', e11.Text);
     INI.WriteString('Computernamen', 'e12', e12.Text);
     INI.WriteString('Computernamen', 'e13', e13.Text);
     INI.WriteString('Computernamen', 'e14', e14.Text);
     INI.WriteString('Computernamen', 'e15', e15.Text);
     INI.WriteString('Computernamen', 'e16', e16.Text);
     INI.WriteString('Computernamen', 'e17', e17.Text);
     INI.Free;
end;

procedure TfrmMain.Programmausfhren1Click(Sender: TObject);
var
   Rechner, Programm: String;
begin
     InputQuery('Welcher Rechner soll eine Anwendung ausführen ?', 'Name:', Rechner);
     InputQuery('Welches Programm soll ausgeführt werden ?', 'Path:', Programm);
     SendToAll('µeµ' + Rechner + 'µ' + Programm + 'µ');

end;

procedure TfrmMain.Anzeigen21Click(Sender: TObject);
begin
     frmMain.Show;
end;

procedure TfrmMain.ServerSocketClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
     frmMain.Uhrzeitsenden1Click(ServerSocket);
     frmMain.Datumsenden1Click(ServerSocket)
end;

end.
