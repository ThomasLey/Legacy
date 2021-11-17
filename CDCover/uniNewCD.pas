unit uniNewCD;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ShellAPI;

type
  TfrmNewCD = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Interpret: TEdit;
    Label2: TLabel;
    Album: TEdit;
    Lieder: TMemo;
    Label3: TLabel;
    BitBtn2: TBitBtn;
    BitBtn1: TBitBtn;
    Label4: TLabel;
    CDID: TEdit;
    BitBtn3: TBitBtn;
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frmNewCD: TfrmNewCD;

implementation

uses INIFiles, uniSelectDrive;

{$R *.DFM}

procedure cdEintragen();
var
   p        : PChar;
   winPath  : ShortString;
   myINI    : TINIFile;
   i        : Integer;
begin
  with frmNewCD do begin
     p := StrAlloc(MAX_PATH);
     GetWindowsDirectory(p, MAX_PATH+1);
     winPath := p;
     StrDispose(p);
     myINI := TINIFile.Create(winPath + '\CDPlayer.ini');
     myINI.WriteString(CDID.Text, 'artist', Interpret.Text);
     myINI.WriteString(CDID.Text, 'title', Album.Text);
     myINI.WriteString(CDID.Text, 'EntryType', '1');
     myINI.WriteInteger(CDID.Text, 'numtracks', Lieder.Lines.Count);
     for i := 0 to (Lieder.Lines.Count - 1) do begin
         myINI.WriteString(CDID.Text, intToStr(i), Lieder.Lines[i]);
     end;
     myINI.Free;
  end;
end;

procedure TfrmNewCD.BitBtn2Click(Sender: TObject);
begin
     close();
end;

procedure TfrmNewCD.BitBtn1Click(Sender: TObject);
begin
     if (Album.Text <> '') and (Interpret.Text <> '') and (Lieder.Text <> '') and (CDID.Text <> '') then begin
        cdEintragen();
        close;
     end else
         showMessage('Es müssen alle Felder ausgefüllt werden.');
end;

procedure TfrmNewCD.BitBtn3Click(Sender: TObject);
var
   laufwerk               : String;
   FileSystemNameBuffer,
   VolumeNameBuffer       : PChar;
   VolumeSerialNumber     : PDWord;
   FileSystemFlags,
   MaximumComponentLength : DWORD;
begin
     frmSelDrive := TfrmSelDrive.Create(Application);
     try
        frmSelDrive.ShowModal();
     finally
        laufwerk := frmSelDrive.laufwerk;
        frmSelDrive.Free;
     end;
     laufwerk := laufwerk + ':\';
     VolumeNameBuffer     := StrAlloc(256);
     FileSystemNameBuffer := StrAlloc(256);
     VolumeSerialNumber := nil;
     if GetVolumeInformation(PChar(laufwerk), VolumeNameBuffer, 255, VolumeSerialNumber, MaximumComponentlength, FileSystemFlags, FileSystemNameBuffer, 255) then begin
        CDID.Text := VolumeNameBuffer;
     end;
     strDispose(VolumeNameBuffer);
     strDispose(FileSystemNameBuffer);
end;

end.
