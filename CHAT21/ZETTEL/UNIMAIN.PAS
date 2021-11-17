unit uniMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, StdCtrls, Buttons;

type
  TfrmMain = class(TForm)
    BitBtn1: TBitBtn;
    ppmMain: TPopupMenu;
    mmoText: TMemo;
    Info1: TMenuItem;
    N1: TMenuItem;
    Beenden1: TMenuItem;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.DFM}

procedure TfrmMain.Button1Click(Sender: TObject);
begin
close;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
   Datei: String;
begin
     If ParamCount < 1 then
        mmoText.Text := 'Nicht genügend Parameter'
     else begin
         Datei := ParamStr(1);
         If IOResult = 0 then begin
            mmoText.Lines.LoadFromFile(Datei);
         end else
             mmoText.Text := 'Konnte die Datei "' + Datei + '" nicht finden.';
     end;
end;

end.
