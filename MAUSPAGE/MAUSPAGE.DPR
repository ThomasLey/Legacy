program mauspage;

uses
  Forms, SysUtils;

var
   inifile: textfile;
   day, month, year: integer;
   dday, dmonth, dyear: integer;
   istFehler: Boolean;
   textout, tempstr, artFehler, htmlfile: String;

{$R *.RES}

function GetValue(Text: String):String;
var
   i: Integer;
begin
     For i := 1 to Length(Text) do begin
         If Text[i] = '=' then GetValue := Copy(Text, i + 1, Length(Text) - i);
     end;
end;

function NewString(text: String): String;
var
   i: Integer;
   PosAt: Integer;
   CutList, MyTemp: String;
begin
     MyTemp := text;
     PosAt := 0; i := 0;
     While i <= Length(MyTemp) do begin
         inc(i);
         If (MyTemp[i] = '<') then
            If (MyTemp[i+1] = '#') then
               PosAt := i;
         If (MyTemp[i] = '>') and (PosAt <> 0) then begin
            CutList := LowerCase(Copy(MyTemp, PosAt, (i - PosAt) + 1));
            Delete(MyTemp, PosAt, (i - PosAt) + 1);
            If CutList = '<#day>' then insert(inttostr(dday), MyTemp, PosAt);
            If CutList = '<#month>' then insert(inttostr(dmonth), MyTemp, PosAt);
            If CutList = '<#year>' then insert(inttostr(dyear), MyTemp, PosAt);
            If CutList = '<#aday>' then insert(inttostr(dday + (dmonth * 12) + (dyear * 365)), MyTemp, PosAt);
            If CutList = '<#amonth>' then insert(inttostr(dmonth + (dyear * 12)), MyTemp, PosAt);
            If CutList = '<#ayear>' then insert(inttostr(dyear), MyTemp, PosAt);
            i := PosAt;
            PosAt := 0;
         end;
     end;
     NewString := MyTemp;
     MyTemp := '';
end;

procedure SetDMY;
var
   aday, amonth, ayear: Integer;
   vdate: string;
begin
     vdate := datetostr(date);
     aday := strtoint(copy(vdate, 1, 2));
     amonth := strtoint(copy(vdate, 4, 2));
     ayear := strtoint(copy(vdate, 7, 2));
     if ayear < 99 then ayear := ayear + 2000
     else ayear := ayear + 1900;
     dyear := ayear - year;
     dmonth := amonth - month;
     dday := aday - day;
     If dday < 0 then begin
        dmonth := dmonth - 1;
        dday := dday + 30;
     end;
     If dmonth < 0 then begin
        dyear := dyear - 1;
        dmonth := dmonth + 12;
     end;
end;


begin
  Application.Initialize;
  istFehler := false;
  artFehler := '';
  AssignFile(inifile, 'mauspage.ini');
  {$i-} Reset(inifile); {$i+}
  If IOResult = 0 then begin
     ReadLn(inifile, tempstr);
     day := strtoint(GetValue(tempstr));
     ReadLn(inifile, tempstr);
     month := strtoint(GetValue(tempstr));
     ReadLn(inifile, tempstr);
     year := strtoint(GetValue(tempstr));
     ReadLn(inifile, tempstr);
     htmlfile := GetValue(tempstr);
  end else begin
      istFehler := true;
      artFehler := 'Konnte die Datei "mauspage.ini" nicht oeffnen';
  end;
  closefile(inifile);

  SetDMY;

  assignfile(inifile, htmlfile);
  {$i-} Reset(inifile); {$i+}
  If IOResult = 0 then begin
     While not eof(inifile) do begin
           ReadLn(inifile, tempstr);
           If not (tempstr = '') then TextOut := Textout +#10+#13+ NewString(tempstr);
     end;
  end else begin
      istFehler := true;
      artFehler := 'Konnte die HTML-Datei nicht finden';
  end;
  closefile(inifile);

  If istFehler then Textout := '<html><body>' + artFehler + '</body></html>';
  assignfile(inifile, 'mauspage.htm');
  {$i-} Rewrite(inifile); {$i+}
  WriteLn(inifile, Textout);
  closefile(inifile);
  WriteLn(TextOut);
  Application.Run;
end.
