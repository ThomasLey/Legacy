program MainWindow;

uses
  Forms,
  uniMain in 'uniMain.pas' {frmMain},
  uniParams in 'uniParams.pas' {frmParams};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'AutoClear 1.0';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmParams, frmParams);
  Application.Run;
end.
