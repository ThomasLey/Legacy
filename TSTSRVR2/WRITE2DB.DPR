program write2db;

{$APPTYPE CONSOLE}

uses
  HTTPApp,
  CGIApp,
  uniMain in 'uniMain.pas' {wmMain: TWebModule};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TwmMain, wmMain);
  Application.Run;
end.
