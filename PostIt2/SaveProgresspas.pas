unit SaveProgresspas;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Gauges;

type
  TfrmProgress = class(TForm)
    ProBar: TGauge;
    lblheader: TLabel;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frmProgress: TfrmProgress;

implementation

{$R *.DFM}

end.
