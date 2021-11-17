program tstsrver;

uses
  Forms,
  SysUtils;

{$R *.RES}

var
   f        : textfile;
   istfehler: boolean;
   TextOut,
   ArtFehler: string;

   vProgram, vScript, vCountryFile,
   vHTMLFiles, thisprog: String;

   temp     : String;

function GetValue(inifile, vname: String):String;
var
   i: Integer;
   p: textfile;
   name, value: String;
   tempstr: String;
begin
     Value := '';
     Name := '';
     AssignFile(p, inifile);
     {$i-} Reset(p); {$i+}
     If IOResult = 0 then begin
        While not eof(p) do begin
              ReadLn(p, tempstr);
              For i := 1 to Length(tempstr) do begin
                  If tempstr[i] = '=' then begin
                     Value := Copy(tempstr, i + 1, Length(tempstr) - i);
                     Name := Copy(tempstr, 1, i - 1);
                     If Name = vName then GetValue := Value;
                  end;
              end;
        end;
     end else begin
         istFehler := true;
         ArtFehler := 'Konnte die Datei nicht finden';
     end;
     If Value = '' then begin
        ArtFehler := 'Konnte einen Eintrag in der INI-Datei nicht finden';
        istFehler := true;
     end;
     CloseFile(p);
end;

function GetString(Zeichen: Char; Text: ShortString; Zahler: Integer): ShortString;
var i, j, Start: Integer;
begin
     j := 0; Start := 1;
     for i := 1 to length(Text) do begin
         If Text[i] = Zeichen then begin
            Inc(j);
            If j = (Zahler) then Start := i + 1;
            If j = (Zahler + 1) then Result := Copy(Text, Start, i - Start);
         end
     end;
end;

function NewString(text: String): String;
var
   i: Integer;
   PosAt: Integer;
   g: TextFile;
   CutList, MyTemp, vInsert, CuntTemp, rTemp: String;
begin
  MyTemp := text;
  If not (MyTemp = '') then begin
     PosAt := 0; i := 0;
     While i <= Length(MyTemp) do begin
         inc(i);
         If (MyTemp[i] = '<') then
            If (MyTemp[i+1] = '#') then
               PosAt := i;
         If (MyTemp[i] = '>') and (PosAt <> 0) then begin
            CutList := LowerCase(Copy(MyTemp, PosAt, (i - PosAt) + 1));
            Delete(MyTemp, PosAt, (i - PosAt) + 1);
            If CutList = '<#progname>' then vInsert := vProgram;
            If CutList = '<#formpara>' then vInsert := '<form method="get" action="' + vScript + '">';
            If CutList = '<#countries>' then begin
               CuntTemp := '';
               AssignFile(g, vCountryFile);
               {$i-} Reset(g) {$i+};
               If IOResult <> 0 then begin
                  IstFehler := true;
                  ArtFehler := 'Konnte die Datei mit den Laendern nicht finden';
               end else begin
                   CuntTemp := '';
                   rTemp := '';
                   While Not eof(g) do begin
                         ReadLn(g, rTemp);
                         If not (rTemp = '') then
                            CuntTemp := CuntTemp + #10+#13 + '<option>' + rTemp;
                   end;
               end;
               vInsert := CuntTemp;
            end;
            insert(vInsert, MyTemp, PosAt);
            CutList := '';
            i := PosAt;
            PosAt := 0;
         end;
     NewString := MyTemp;
     end;
  end;
end;

function GetProgName(text: string): String;
var
	PosAt, i: Integer;
	tempstr: string;
begin
        PosAt := 0;
        tempStr := '';
	for i := length(text) downto 1 do begin
		if text[i] = '.' then PosAt := i;
		if text[i] = '\' then begin
			tempstr := Copy(text, i + 1, (PosAt - i) - 1);
			break;
		end;
	end;
        GetProgName := tempstr;
end;

begin
  Application.Initialize;
  istfehler := false;
  Textout := '';
  ArtFehler := '';
  thisprog := GetProgName(paramstr(0));

  vProgram := GetValue(thisprog + '.ini', 'program');
  vScript := GetValue(thisprog + '.ini', 'script');
  vCountryFile := GetValue(thisprog + '.ini', 'countryfile');
  vHTMLFiles := GetValue(thisprog + '.ini', 'htmlfile');

  If not IstFehler then begin
     AssignFile(f, vHTMLFiles);
     {$i-} Reset(f) {$i+};
     If IOResult <> 0 then begin
        ArtFehler := 'Fehler beim Öffnen der HTML-Seite';
     end else begin
         While not eof(f) do begin
               ReadLn(f, temp);
               If not (temp = '') then TextOut := TextOut +#10+#13+ NewString(temp);
         end;
     end;
     CloseFile(f)
  end;
  If IstFehler then TextOut := '<html><body>' + ArtFehler + '</body></html>';
  WriteLn(TextOut);

//  assignfile(f, thisprog + '.html');
//  {$i-} Rewrite(f); {$i+}
//  WriteLn(f, Textout);
//  closefile(f);


  Application.Run;
end.
