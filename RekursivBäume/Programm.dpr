program Programm;

uses
  Forms,
  uniMain in 'uniMain.pas' {frmMain},
  uniAbout in 'uniAbout.pas' {AboutBox},
  uniEinstellungen in 'uniEinstellungen.pas' {frmEinstellungen};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Rekursive Bäume';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TfrmEinstellungen, frmEinstellungen);
  Application.Run;
end.
