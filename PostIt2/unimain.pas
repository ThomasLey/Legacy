unit unimain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  CoolTrayIcon, INIFiles, ShellAPI, Menus, Note, ExtCtrls, Black_System, SaveProgressPas;

const tVersion: ShortString = '0.0.1c';
      tName: ShortString = 'WinNote';
      tUser: ShortString = 'Test02';
type
  TfrmMain = class(TForm)
    TrayIcon: TCoolTrayIcon;
    PopupTray: TPopupMenu;
    Hauptfenster1: TMenuItem;
    Beenden1: TMenuItem;
    tmrHide: TTimer;
    System: TSystem;
    N4: TMenuItem;
    NeuerZettel1: TMenuItem;
    N1: TMenuItem;
    Speichern1: TMenuItem;
    MainMenu1: TMainMenu;
    WinNote1: TMenuItem;
    Beenden2: TMenuItem;
    Bearbeiten1: TMenuItem;
    NeuerZettel2: TMenuItem;
    N2: TMenuItem;
    Speichern2: TMenuItem;
    N3: TMenuItem;
    Einstellungen1: TMenuItem;
    TimerAutosave: TTimer;
    N5: TMenuItem;
    N6: TMenuItem;
    Drucken1: TMenuItem;
    PrinterSetup: TPrinterSetupDialog;
    PrintDialog: TPrintDialog;
    procedure FormCreate(Sender: TObject);
    procedure TrayIconDblClick(Sender: TObject);
    procedure Beenden1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tmrHideTimer(Sender: TObject);
    procedure CreateNote(number: Integer; xFile: String);
    procedure NeuerZettel1Click(Sender: TObject);
    procedure Speichern1Click(Sender: TObject);
    procedure Einstellungen1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TimerAutosaveTimer(Sender: TObject);
    procedure N6Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    MCounter, ICounter: Integer;
    Minutes, xMinuten: Integer;
    { Public-Deklarationen }
  end;

var
  frmMain: TfrmMain;
  darfnichtgeschlossenwerden: Boolean = true;
  NewForm: TfrmNote;

implementation

uses Setup;

function GetPathName(text: ShortString): ShortString; stdcall; external 'utils.dll';
function GetInteger(Zeichen: Char; Text: ShortString; Zahler: Integer): Integer; stdcall; external 'utils.dll';
function GetString(Zeichen: Char; Text: ShortString; Zahler: Integer): ShortString; stdcall; external 'utils.dll';

{$R *.DFM}

procedure TfrmMain.CreateNote(number: Integer; xFile: String);
var
   header: String;
begin
     header := ';;;;;';
     NewForm := TfrmNote.Create(Application);
     Newform.hide;
     NewForm.Name := 'note' + IntToStr(number);
     NewForm.MyIndex := number;
     NewForm.MyFile := xFile;
     NewForm.MyItem := TMenuItem.Create(NewForm);
     NewForm.MyState := 's';
// Einlesen der eventuellen Daten
     If xFile = '' then begin
         NewForm.mmoNote.Text := '';
         NewForm.MyItem.Caption := NewForm.Name;
         NewForm.Show;
     end else begin
// ACHTUNG: Problem durch Wordwarp
         NewForm.mmoNote.WordWrap := false;
         NewForm.mmoNote.Lines.LoadFromFile(xFile);
         header := NewForm.mmoNote.Lines[0];
         NewForm.mmoNote.Lines.Delete(0);
         NewForm.mmoNote.WordWrap := true;
         header[1] := ';'; header[length(header)] := ';';
         NewForm.Left := GetInteger(';', header, 1);
         If (NewForm.Left > (Screen.width - NewForm.width)) then (NewForm.Left := (Screen.width - NewForm.width));
         NewForm.Top := GetInteger(';', header, 2);
         If (NewForm.Top > (Screen.height - NewForm.height - 30)) then (NewForm.Top := (Screen.height - NewForm.height - 30));
         NewForm.MyItem.Caption := GetString(';', header, 3);
         NewForm.Caption := NewForm.MyItem.Caption;
         If UpperCase(GetString(';', header, 4)) = 'S' then NewForm.Show else NewForm.MyState := 'h';
     end;
     NewForm.MyItem.OnClick := NewForm.OnClick;
     frmMain.PopupTray.Items.Insert(ICounter, NewForm.MyItem);
     inc(ICounter);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
   Datei: TINIFile;
   tIcon: String;
   Path, User: String;
   fNote: TextFile;
begin
// Grunddaten
     Path := GetPathName(ParamStr(0));
     User := System.UserName;
     Minutes := 0;

     Randomize;

     frmMain.Left := 0;
     frmMain.Top := 0;
     height := 44;
     width := 200;

     frmMain.Caption := tName + ' ' + tVersion;
     TrayIcon.hint := frmMain.caption;
     Application.Title := frmMain.caption;

     CreateDir(Path + '\' + User);
     CreateDir(Path + '\' + User + '\Trash');
     CreateDir(Path + '\' + User + '\Notes');

     If not FileExists(Path + '\' + User + '\' + 'config.ini') then begin
        Datei := TINIFile.Create(Path + '\' + User + '\' + 'config.ini');
        Datei.WriteString('Layout', 'Icon', 'noteb01c.ico');
        Datei.WriteInteger('Memo', 'MCounter', 0);
        Datei.WriteInteger('Program', 'Autosave', 5);
        Datei.WriteString('Program', 'Version', tVersion);
        Datei.WriteBool('Program', 'tfAutosave', true);
        Datei.Free;
        AssignFile(fNote, Path + '\' + User + '\Notes\0.note');
        {$i-} ReWrite(fNote) {$i+};
        If IOResult = 0 then begin
           WriteLn(fNote, '[100;100;Information;s]');
           WriteLn(fNote, 'Vielen Dank, dass Sie dieses Programm benutzen.');
           WriteLn(fNote, '');
           WriteLn(fNote, 'Dieses Programm wurde geschrieben von:');
           WriteLn(fNote, 'Thomas Ley');
           WriteLn(fNote, 'e-Mail: 101,91221@germanynet.de');
           WriteLn(fNote, '');
           WriteLn(fNote, 'Schreiben Sie mir doch einfach mal eine Mail, wie Sie dieses Programm finden, und was an diesem Programm noch zu verbessern wäre.');
        end else begin
            MessageDlg('Error: '+IntToStr(IOResult) + ' ist aufgetreten.', mtError, [mbOk], 0);
        end;
        {$i-} CloseFile(fNote); {$i+};
     end;

     Datei := TINIFile.Create(Path + '\' + User + '\' + 'config.ini');
     tIcon := Datei.ReadString('Layout', 'Icon', 'noteb01c.ico');
     If FileExists(tIcon) then frmMain.Icon.LoadFromFile(tIcon);
     TrayIcon.Icon := frmMain.Icon;
     Application.Icon := frmMain.Icon;
     MCounter := Datei.ReadInteger('Memo', 'MCounter', 0);
     xMinuten := Datei.ReadInteger('Program', 'Autosave', 5);
     TimerAutosave.Enabled := Datei.ReadBool('Program', 'tfAutosave', true);
     ICounter := 0;

     Datei.Free;
end;

procedure TfrmMain.TrayIconDblClick(Sender: TObject);
begin
     frmMain.show;
end;

procedure TfrmMain.Beenden1Click(Sender: TObject);
begin
     darfnichtgeschlossenwerden := false;
     close;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     If darfnichtgeschlossenwerden then begin hide; abort; end;
// Source für Beenden
end;

procedure TfrmMain.tmrHideTimer(Sender: TObject);
var
   Path, User: String;
   i: Integer;
begin
     tmrHide.Enabled := false;
//******************
     frmMain.hide;
//******************

// Einlesen von Daten
     Path := GetPathName(ParamStr(0));
     User := System.UserName;

     frmProgress.Caption := 'Öffnen...';
     frmProgress.ProBar.MinValue := 0;
     frmProgress.ProBar.MaxValue := MCounter;
     frmProgress.Probar.Progress := 0;
     frmProgress.lblheader.caption := '...';
     frmProgress.Show;

//     If frmMain.MCounter > 0 then begin
        For i := 0 to frmMain.MCounter do begin
           frmProgress.Probar.Progress := i;
           frmProgress.lblHeader.Caption := IntToStr(i);
           frmProgress.lblHeader.Update;
           If FileExists(Path + '\' + User + '\Notes\' + IntToStr(i) + '.note') then begin
              CreateNote(i, Path + '\' + User + '\Notes\' + IntToStr(i) + '.note');
           end;
        end;
//     end;
     frmProgress.hide;
end;

procedure TfrmMain.NeuerZettel1Click(Sender: TObject);
begin
     inc(MCounter);
     CreateNote(MCounter, '');
end;

procedure TfrmMain.Speichern1Click(Sender: TObject);
var
   i, j, pro: Integer;
   ThisForm: TfrmNote;
   Datei: TextFile;
begin
//     If MCounter > 0 then begin
        pro := 0;
        frmProgress.Caption := 'Speichern...';
        frmProgress.ProBar.MinValue := 0;
        frmProgress.ProBar.MaxValue := ICounter;
        frmProgress.Probar.Progress := 0;
        frmProgress.lblheader.caption := '...';
        frmProgress.Show;
        For i := 0 to MCounter do begin
            ThisForm := TfrmNote(Application.FindComponent('note' + IntToStr(i)));
            If not (ThisForm = nil) then begin
               inc(pro); frmProgress.Probar.Progress := pro;
               frmProgress.lblHeader.Update;
               frmProgress.lblHeader.Caption := IntToStr(i) + ': ' + ThisForm.Caption;
               AssignFile(Datei, GetPathName(ParamStr(0)) + '\' + System.UserName + '\Notes\' + IntToStr(i) + '.note');
               {$i-} ReWrite(Datei) {$i+};
               If IOResult = 0 then begin
                  WriteLn(Datei, '[' + IntToStr(ThisForm.Left) + ';' + IntToStr(ThisForm.Top) + ';' + ThisForm.Caption + ';' + ThisForm.MyState + ']');
                  For j := 0 to (ThisForm.mmoNote.Lines.Count - 1) do begin
                     WriteLn(Datei, ThisForm.mmoNote.Lines[j]);
                  end;
               end else begin
                  MessageDlg('Error: '+IntToStr(IOResult) + ' ist aufgetreten.', mtError, [mbOk], 0);
               end;
               {$i-} CloseFile(Datei); {$i+};
            end;
        end;
        frmProgress.Hide;
//     end;
end;

procedure TfrmMain.Einstellungen1Click(Sender: TObject);
begin
     frmSetup.Show;
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
   Datei: TINIFile;
begin
   If not DarfNichtGeschlossenWerden then begin
     Datei := TINIFile.Create(GetPathName(ParamStr(0)) + '\' + System.UserName + '\' + 'config.ini');
     Datei.WriteInteger('Memo', 'MCounter', MCounter);
     Datei.WriteString('Program', 'Version', tVersion);
     Datei.Free;
     frmMain.Speichern1Click(Sender);
   end;
   CanClose := true;
end;

procedure TfrmMain.TimerAutosaveTimer(Sender: TObject);
begin
     inc(Minutes);
     If Minutes = xMinuten then begin
        frmMain.Speichern1Click(Sender);
        Minutes := 0;
     end;
end;

procedure TfrmMain.N6Click(Sender: TObject);
begin
     PrinterSetup.Execute;
end;

end.
