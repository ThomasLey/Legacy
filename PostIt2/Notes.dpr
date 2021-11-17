program Notes;

uses
  Forms,
  unimain in 'unimain.pas' {frmMain},
  note in 'note.pas' {frmNote},
  SaveProgresspas in 'SaveProgresspas.pas' {frmProgress},
  Setup in 'Setup.pas' {frmSetup};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Noname';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmProgress, frmProgress);
  Application.CreateForm(TfrmSetup, frmSetup);
  Application.Run;
end.
