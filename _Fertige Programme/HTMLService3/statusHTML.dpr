program statusHTML;

uses
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  SvcMgr,
  Dialogs,
  uniMain in 'uniMain.pas' {CreateHTML};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'info HTML 1.0';
  Application.CreateForm(TCreateHTML, CreateHTML);
  Application.Run;
end.
