unit note;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Menus, ShellAPI, Printers;

type
  TfrmNote = class(TForm)
    mmoNote: TMemo;
    PopupMenu: TPopupMenu;
    Beenden1: TMenuItem;
    Zettelverschwindenlassen1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    berschriftndern1: TMenuItem;
    Speichern1: TMenuItem;
    Drucken1: TMenuItem;
    N3: TMenuItem;
    procedure Beenden1Click(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Zettelverschwindenlassen1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure berschriftndern1Click(Sender: TObject);
    procedure Speichern1Click(Sender: TObject);
    procedure Drucken1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    MyItem: TMenuItem;
    MyIndex: Integer;
    MyPath: String;
    MyFile: String;
    MyState: String[1];
    { Public-Deklarationen }
  end;

var
  frmNote: TfrmNote;

implementation

uses unimain, Setup;

function GetPathName(text: ShortString): ShortString; stdcall; external 'utils.dll';

{$R *.DFM}

procedure TfrmNote.Beenden1Click(Sender: TObject);
var
   src, dst: String;
   Datei: TextFile;
   j: Integer;
begin
     frmMain.PopupTray.Items.Remove(MyItem);
     dec(frmMain.ICounter);
     src := GetPathName(ParamStr(0)) + '\' + frmMain.System.UserName + '\Notes\' + IntToStr(MyIndex) + '.note';
     dst := GetPathName(ParamStr(0)) + '\' + frmMain.System.UserName + '\Trash\' + IntToStr(MyIndex) + '.note';

     AssignFile(Datei, dst);
     {$i-} ReWrite(Datei) {$i+};
     If IOResult = 0 then begin
        WriteLn(Datei, '[' + IntToStr(Left) + ';' + IntToStr(Top) + ';' + Caption + ';' + MyState + ']');
        For j := 0 to (mmoNote.Lines.Count - 1) do begin
            WriteLn(Datei, mmoNote.Lines[j]);
        end;
     end else begin
        MessageDlg('Error: '+IntToStr(IOResult) + ' ist aufgetreten.', mtError, [mbOk], 0);
     end;
     {$i-} CloseFile(Datei); {$i+};
     DeleteFile(src);
     Destroy;
end;

procedure TfrmNote.FormClick(Sender: TObject);
begin
     show;
     MyState := 's';
end;

procedure TfrmNote.FormCreate(Sender: TObject);
begin
     If MyFile = '' then begin
        left := random(screen.width - width);
        top := random(screen.height - height - 30);
     end;
end;

procedure TfrmNote.Zettelverschwindenlassen1Click(Sender: TObject);
begin
     close;
end;

procedure TfrmNote.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     MyState := 'h';
end;

procedure TfrmNote.berschriftndern1Click(Sender: TObject);
begin
     Caption := InputBox('Überschrift ändern', 'Neue Überschrift', Caption);

     frmMain.PopupTray.Items.Remove(MyItem);
     dec(frmMain.ICounter);
     MyItem.Caption := Caption;
     frmMain.PopupTray.Items.Insert(frmMain.ICounter, MyItem);
     inc(frmMain.MCounter);
end;

procedure TfrmNote.Speichern1Click(Sender: TObject);
begin
     frmMain.Speichern1Click(Sender);
end;

procedure TfrmNote.Drucken1Click(Sender: TObject);
var
   i, j: Integer;
begin
// Hier kommt der Source zum Drucken
     If frmMain.PrintDialog.Execute then begin
        For i := 1 to frmMain.PrintDialog.Copies do begin
            Printer.BeginDoc;
            SetMapMode(Printer.Canvas.Handle, MM_LoMetric);
            Printer.Canvas.Font := mmoNote.Font;
            Printer.Canvas.Font.Size := Round(mmoNote.Font.Size *5);
            Printer.Canvas.TextOut(frmSetup.pLeft*10, frmSetup.pTop*10 + Printer.Canvas.Font.Size, Caption);
            Printer.Canvas.Font.Size := Round(mmoNote.Font.Size *3);
            For j := 0 to (mmoNote.Lines.Count - 1) do begin
//                Printer.Canvas.TextOut(frmSetup.pLeft*10 + 50,10 * j * mmoNote.Font.Height, mmoNote.Lines[j]);
            end;
            Printer.EndDoc;
        end;
     end;
end;

end.
