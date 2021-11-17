unit uniCDSelect;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TfrmCDSelect = class(TForm)
    GroupBox1: TGroupBox;
    INIContents: TComboBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    lsbCDs: TListBox;
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure lsbCDsClick(Sender: TObject);
    procedure INIContentsClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frmCDSelect: TfrmCDSelect;

implementation

uses iniFiles;

{$R *.DFM}

function GetString(Zeichen: Char; Text: ShortString; Zahler: Integer): ShortString; stdcall;
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

procedure TfrmCDSelect.FormShow(Sender: TObject);
var
   p        : PChar;
   winPath  : ShortString;
   iniFile  : TextFile;
   tmp      : String;
   myINI    : TINIFile;
   i        : Integer;
begin
     p := StrAlloc(MAX_PATH);
     GetWindowsDirectory(p, MAX_PATH+1);
     winPath := p;
     StrDispose(p);
     if fileExists(winPath + '\CDPlayer.ini') then begin
        AssignFile(iniFile, winPath + '\CDPlayer.ini');
        {$i-} ReSet(iniFile); {$i+}
        if ioResult = 0 then begin
           readln(iniFile, tmp);  // Damit die erste Zeil wegfällt, da WIN-CDPlayer-Zeug
           while not eof(iniFile) do begin
                 readln(iniFile, tmp);
                 tmp := tmp + ' '; // Falls leer !!!
                 if tmp[1] = '[' then
                    INIContents.Items.Add(Copy(tmp, 2, length(tmp) - 3));
           end;
           myINI := TINIFile.Create(winPath + '\CDPlayer.ini');
           for i := 0 to (INIContents.Items.Count - 1) do begin
               tmp := myINI.ReadString(INIContents.Items[i], 'artist', 'Interpret ' + IntToStr(i));
               tmp := tmp + ', ' + myINI.ReadString(INIContents.Items[i], 'title', 'Album ' + IntToStr(i));
               tmp := tmp + '    |' + INIContents.Items[i];
               lsbCDs.Items.Add(tmp);
           end;
           myINI.Free;
        end else
            showMessage('Fehler beim Öffnen der Datei ' + winPath + '\CDPlayer.ini aufgetreten.');
     end else
         showMessage('Die Datei <windir>\CDPlayer.ini ist nicht vorhanden');
end;

procedure TfrmCDSelect.BitBtn1Click(Sender: TObject);
begin
     close();
end;

procedure TfrmCDSelect.BitBtn2Click(Sender: TObject);
begin
     INIContents.Text := '';
     close();
end;

procedure TfrmCDSelect.lsbCDsClick(Sender: TObject);
begin
     INIContents.Text := GetString('|','|' + lsbCDs.Items[lsbCDs.ItemIndex] + '|', 2)
end;

procedure TfrmCDSelect.INIContentsClick(Sender: TObject);
var i: Integer;
begin
     lsbCDs.ItemIndex := -1;
     for i := 0 to (lsbCDs.Items.Count - 1) do
         if GetString('|','|' + lsbCDs.Items[i] + '|', 2) = INIContents.Text then
            lsbCDs.ItemIndex := i;
end;

end.
