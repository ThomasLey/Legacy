program clpbrd2bmp;

uses
  Forms,
  uniMain in 'uniMain.pas' {frmMain};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'clpbrd2bmp';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
