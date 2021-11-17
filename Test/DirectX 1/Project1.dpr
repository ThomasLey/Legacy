program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {MainForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Direct X - Test 1';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
