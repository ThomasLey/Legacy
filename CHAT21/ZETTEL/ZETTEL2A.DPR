program Zettel2a;

uses
  Forms,
  uniMain in 'uniMain.pas' {frmMain};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Intra Chat 2.1 - Zettel';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
