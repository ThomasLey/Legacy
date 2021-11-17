unit uniEinstellungen;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin;

type
  TfrmEinstellungen = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    se4: TSpinEdit;
    se5: TSpinEdit;
    se1: TSpinEdit;
    se2: TSpinEdit;
    se3: TSpinEdit;
    se6: TSpinEdit;
    se7: TSpinEdit;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Button1: TButton;
    se8: TSpinEdit;
    Label16: TLabel;
    Label17: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frmEinstellungen: TfrmEinstellungen;

implementation

uses uniMain;

{$R *.DFM}

procedure TfrmEinstellungen.Button1Click(Sender: TObject);
begin
     frmEinstellungen.Show;
     frmEinstellungen.Close;
end;



end.
