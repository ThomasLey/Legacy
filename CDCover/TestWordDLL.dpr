program TestWordDLL;

uses
  Forms,
  TestProgWordDLL in 'TestProgWordDLL.pas' {Form1},
  uniStruc in 'uniStruc.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

