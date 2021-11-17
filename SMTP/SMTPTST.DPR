program smtptst;

uses
  Forms,
  smtptst1 in 'smtptst1.pas' {SmtpTestForm};

{$R *.RES}

begin
  Application.Title := 'Send Mail - 1.0';
  Application.CreateForm(TSmtpTestForm, SmtpTestForm);
  Application.Run;
end.
