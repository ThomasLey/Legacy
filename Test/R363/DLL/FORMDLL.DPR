library FormDLL;

uses
  Dialogs, SysUtils, Windows,
  Unit1 in 'UNIT1.PAS' {Form1};

procedure fensterAnzeigen;stdcall;
begin
  Form1:= TForm1.Create(nil);
  try
    Form1.ShowModal;
  finally
    Form1.Release // .Free;
  end
end;

function berechne1(x,y : Single): Single;stdcall;
begin
   Result := x+y
end;

procedure berechne2(x,y: single;var z : single);stdcall;
begin
   z := x+y
end;

procedure newExit;
begin
  ShowMessage('DLL wird entladen ... ')
end;

exports
       fensterAnzeigen,
       berechne1,
       berechne2;

begin
   AddExitProc(newExit);
   ShowMessage('DLL wird geladen ...')
end.
