program Server1a;

uses
  Forms,
  uniMain in 'uniMain.pas' {frmMain},
  uniOptions in 'uniOptions.pas' {frmOptions};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Intra Chat 2.0 - Server';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmOptions, frmOptions);
  Application.Run;
end.
