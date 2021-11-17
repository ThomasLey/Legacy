program client1a;

uses
  Forms,
  uniVerbinden in 'uniVerbinden.pas' {frmConnection},
  uniMain in 'uniMain.pas' {frmMain},
  uniOptions in 'uniOptions.pas' {frmOptions},
  uniZettel in 'uniZettel.pas' {frmZettel},
  uniBenutzer in 'uniBenutzer.pas' {frmBenutzer},
  uniMalen in 'uniMalen.pas' {frmMalen};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Intra Chat 2.1 - Client';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmConnection, frmConnection);
  Application.CreateForm(TfrmOptions, frmOptions);
  Application.CreateForm(TfrmZettel, frmZettel);
  Application.CreateForm(TfrmBenutzer, frmBenutzer);
  Application.CreateForm(TfrmMalen, frmMalen);
  Application.Run;
end.
