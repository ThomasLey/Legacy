program Syscheck;

uses
  Forms,
  uniMain in 'uniMain.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Penis-Check';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
