program Pc_Man;

uses
  Forms,
  uniMain in 'uniMain.pas' {frmMain},
  uniMessage in 'uniMessage.pas' {frmNachrichten},
  uniAbout in 'uniAbout.pas' {AboutBox};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'ComputerManager 2000';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmNachrichten, frmNachrichten);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.Run;
end.
