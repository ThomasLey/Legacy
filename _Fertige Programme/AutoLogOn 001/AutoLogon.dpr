program AutoLogon;

uses
  Forms,
  Registry,
  SysUtils,
  Windows;

var
   userName, Password: ShortString;
{$R *.RES}

procedure SetRegistry;
var
   reg: TRegistry;
begin
     reg := TRegistry.Create;
     reg.RootKey := HKEY_LOCAL_MACHINE;
     if reg.OpenKey('\Software\Microsoft\Windows NT\CurrentVersion\Winlogon', false) then begin
        reg.WriteString('DefaultUserName', userName);
        reg.WriteString('DefaultPassword', Password);
        reg.WriteString('AutoAdminLogon', '1');
          WriteLn('Die Eintr�ge wurden erstellt.');
     end else begin
         Writeln('Dieses Programm ist f�r Windows NT 4  und Windows 2000 geschrieben worden.');
     end;
     reg.Free;
end;

procedure DelRegistry;
var
   reg: TRegistry;
begin
     reg := TRegistry.Create;
     reg.RootKey := HKEY_LOCAL_MACHINE;
     if reg.OpenKey('\Software\Microsoft\Windows NT\CurrentVersion\Winlogon', false) then begin
       try
          reg.DeleteValue('DefaultUserName');
          reg.DeleteValue('DefaultPassword');
          reg.DeleteValue('AutoAdminLogon');
          WriteLn('Die Eintr�ge wurden gel�scht.');
       except
             Writeln('Beim l�schen der Eintr�ge ist ein Fehler aufgetreten.');
       end;
     end else begin
         Writeln('Dieses Programm ist f�r Windows NT 4  und Windows 2000 geschrieben worden.');
     end;
     reg.Free;
end;

begin
  Application.Initialize;

  If UpperCase(ParamStr(1)) = '/F' then begin
     DelRegistry;
  end;
  If UpperCase(ParamStr(1)) = '/N' then begin
     userName := ParamStr(2);
     Password := ParamStr(3);
     SetRegistry;
  end;
  Application.Run;
end.
