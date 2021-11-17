unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, OleCtrls, MSTSCLib_TLB, ExtCtrls;

type
  TForm1 = class(TForm)
    Term: TMsTscAx;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
begin
     Term.Server := 'IMEX';
     Term.UserName := 'IMEXUser';
     Term.Connect();
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
     Term.Disconnect();
end;

end.
