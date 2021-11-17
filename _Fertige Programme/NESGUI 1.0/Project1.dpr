program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'NESGUI 0.0.3';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
