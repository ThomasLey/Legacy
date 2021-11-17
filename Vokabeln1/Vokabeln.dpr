program Vokabeln;

uses
  Forms,
  uniMain in 'uniMain.pas' {frmMain},
  uniAddEntry in 'uniAddEntry.pas' {frmAddEntry},
  uniSearchLEO in 'uniSearchLEO.pas' {frmSearch},
  uniDatabaseFunctions in 'uniDatabaseFunctions.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Vokabeln 1';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmAddEntry, frmAddEntry);
  Application.CreateForm(TfrmSearch, frmSearch);
  Application.Run;
end.
