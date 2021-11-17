unit uniMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ClipBrd;

type
  TfrmMain = class(TForm)
    ePath: TEdit;
    eFile: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    btnOK: TButton;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure eFileKeyPress(Sender: TObject; var Key: Char);
    procedure btnOKClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    Version: String;
    { Public-Deklarationen }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.DFM}

procedure TfrmMain.FormCreate(Sender: TObject);
var
   i: Integer;
begin
     frmMain.Version := '1.0.2';
     Application.Title := Application.Title + ' ' + frmMain.Version;
     frmMain.Caption := Application.Title;

     ePath.Text := ExtractFileDir (ParamStr(0));
     i := 0;
     Repeat
           inc(i);
     until not FileExists(ePath.Text + '\' + IntToStr(i) + '.bmp');
     eFile.Text := IntToStr(i) + '.bmp';
end;

procedure TfrmMain.eFileKeyPress(Sender: TObject; var Key: Char);
begin
     If (Key = #13) or (Key = #10) then begin
        Key := ' ';
        frmMain.btnOKClick (Sender);
     end;
end;

procedure TfrmMain.btnOKClick(Sender: TObject);
begin
     If ClipBoard.hasFormat (CF_Bitmap) then begin
        Image1.Picture.Assign (ClipBoard);
        If ExtractFileExt (eFile.Text) = '' then eFile.Text := eFile.Text + '.bmp';
        Image1.Picture.SaveToFile (ePath.Text + '\' + eFile.Text);
     end;
     If ClipBoard.hasFormat (CF_Picture) then begin
        Image1.Picture.Assign (ClipBoard);
        If ExtractFileExt (eFile.Text) = '' then eFile.Text := eFile.Text + '.wmf';
        Image1.Picture.SaveToFile (ePath.Text + '\' + eFile.Text);
     end;
     frmMain.Close;
end;

end.
