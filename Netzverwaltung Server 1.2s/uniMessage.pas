unit uniMessage;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmNachrichten = class(TForm)
    MemoNachricht: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frmNachrichten: TfrmNachrichten;

implementation

{$R *.DFM}

procedure TfrmNachrichten.FormCreate(Sender: TObject);
begin
     MemoNachricht.Text := '';
end;

end.
