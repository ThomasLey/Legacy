
unit uniMain;

interface

uses
  Windows, Messages, SysUtils, Classes, HTTPApp, DBTables, Db;

type
  TwmMain = class(TWebModule)
    taGaeste: TTable;
    dbMain: TDatabase;
    procedure wmMaindefaultAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
  private
    { Private-Deklarationen }
  public
        function GetValue(INIfile, SearchName: ShortString): ShortString;
        function RichtigeEM(text: String):Boolean;
        function GetString(Zeichen: Char; Text: ShortString; Zahler: Integer): ShortString; stdcall;
        function GetProgName(text: string): String;
        function NewString(text: String): String;
        procedure Speichern;
        procedure WorkWithDB;
        procedure SendEMail(sendtext: String);
        procedure IncCounter;
    { Public-Deklarationen }
  end;

var
  wmMain: TwmMain;
   f        : textfile;
   istfehler: boolean;
   TextOut,
   thisProg,
   ArtFehler,
   temp, myparamstr: string;
// Counter das Datenbank
   MyCounter: String;

// Variablen aus INI-Datei
   vProgram,
   vautoexecute,
   vfileexecute,
   vsavetofile,
   vsavefile,
   vdbname,
   vhtmlfile,
   vserverhtml,
   vmailserver,
   vMaxVisit,
   vtoemail: String;

// Übergabeparameter
   gvorname,
   gname,
   gstrasse,
   gsex,
   gplz,
   gort,
   gland,
   gfirma,
   gemail: String;

implementation

{$R *.DFM}

// Speichert die Daten in der Datenbank
procedure TwmMain.Speichern;
begin
     taGaeste.Insert;
     taGaeste.FieldByName('vorname').AsString := gvorname;
     taGaeste.FieldByName('name').AsString := gname;
     taGaeste.FieldByName('sex').AsString := gsex;
     taGaeste.FieldByName('strasse').AsString := gstrasse;
     taGaeste.FieldByName('plz').AsString := gplz;
     taGaeste.FieldByName('ort').AsString := gort;
     taGaeste.FieldByName('land').AsString := gland;
     taGaeste.FieldByName('firma').AsString := gfirma;
     taGaeste.FieldByName('email').AsString := gemail;
     taGaeste.FieldByName('counter').AsString := '1';
     taGaeste.Post;
     MyCounter := '1';
end;
// Gibt den Programmnamen zurück
function TwmMain.GetProgName(text: string): String;
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
// Gibt den x. String aus einem Vollständigen String zurück
function TwmMain.GetString(Zeichen: Char; Text: ShortString; Zahler: Integer): ShortString; stdcall;
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
// Checkt, ob eine e-Mail Adresse richtig sein könnte
function TwmMain.RichtigeEM(text: String):Boolean;
var p: Integer;
    vdot, vat: boolean;
begin
     vdot := false;
     vat := false;
     For p := 1 to length(text) do begin
         If Text[p]='@' then vat := true;
         If Text[p]='.' then vdot := true;
     end;
     If vdot and vat then
        RichtigeEM := true
     else
        RichtigeEM := false;
end;
// Schreibt die Informationen in eine Datei
procedure TwmMain.SendEMail(sendtext: String);
var f: textfile;
    mytemp: String;
begin
If lowercase(vSaveToFile) = 'yes' then begin
     AssignFile(f, vsavefile + '.dat');
     {$i-} ReWrite(f); {$i+}
     If IOResult = 0 then begin
        WriteLn(f, vmailserver);
        WriteLn(f, 'smtp');
        WriteLn(f, gName);
        WriteLn(f, vtoemail);
        WriteLn(f, gemail);
     end;
     CloseFile(f);

     AssignFile(f, vsavefile + '.emo');
     {$i-} ReWrite(f); {$i+}
     If IOResult = 0 then begin
        WriteLn(f, SendText);
        WriteLn(f, 'Name:' + gName);
        WriteLn(f, 'Vorname:' + gVorname);
        WriteLn(f, 'Geschlecht:' + gSex);
        WriteLn(f, 'Strasse:' + gStrasse);
        WriteLn(f, 'Plz:' + gPlz);
        WriteLn(f, 'Ort:' + gOrt);
        WriteLn(f, 'Staat:' + gLand);
        WriteLn(f, 'Firma:' + gFirma);
        WriteLn(f, 'e-Mail: ' + gEMail);
        WriteLn(f, 'Besuche: ' + MyCounter);
     end;
     CloseFile(f);

     AssignFile(f, vsavefile + '.att');
     {$i-} ReWrite(f); {$i+}
     CloseFile(f);

     If lowercase(vautoexecute) = 'yes' then begin
        mytemp := vfileexecute + ' ' + vsavefile;
        WinExec(pchar(mytemp), SW_Hide);
     end;
end;
end;
// Erhöht den Counter und sendet ggf. eine e-Mail
procedure TwmMain.IncCounter;
begin
     MyCounter := IntToStr(StrToInt(MyCounter) + 1);
     If (StrToInt(MyCounter) mod StrToInt(vmaxvisit)) = 0 then begin
        SendEMail('Der Benutzer hat sich zum ' + MyCounter + '. angemeldet');
     end;
end;
// Gibt einen String aus einer INI-Datei wieder
function TwmMain.GetValue(INIfile, SearchName: ShortString): ShortString;
var
   i: Integer;
   p: TextFile;
   name, value, tempstr: ShortString;
begin
     Value := '';
     Name := '';
     AssignFile(p, INIfile);
     {$i-} Reset(p); {$i+}
     If IOResult = 0 then begin
        While not eof(p) do begin
              ReadLn(p, tempstr);
              For i := 1 to Length(tempstr) do begin
                  If tempstr[i] = '=' then begin
                     Value := Copy(tempstr, i + 1, Length(tempstr) - i);
                     Name := Copy(tempstr, 1, i - 1);
                     If Name = SearchName then GetValue := Value;
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
// Ändert einen String mit eigenen Tag's
function TwmMain.NewString(text: String): String;
var
   i: Integer;
   PosAt: Integer;
   CutList, MyTemp, vInsert: String;
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
// If CutList = '<#mytag>' then vInsert := 'Hier kommt der Eintrag'
            If CutList = '<#progname>' then vInsert := vProgram;
            If CutList = '<#vorname>' then vInsert := gVorname;
            If CutList = '<#name>' then vInsert := gName;
            If CutList = '<#geschlecht>' then vInsert := gSex;
            If CutList = '<#adresse>' then vInsert := gStrasse;
            If CutList = '<#plz>' then vInsert := gPlz;
            If CutList = '<#ort>' then vInsert := gOrt;
            If CutList = '<#land>' then vInsert := gLand;
            If CutList = '<#firma>' then vInsert := gFirma;
            If CutList = '<#email>' then vInsert := gEMail;
            If CutList = '<#visit>' then vInsert := MyCounter;
            If CutList = '<#linkurl>' then vInsert := vserverhtml;
            insert(vInsert, MyTemp, PosAt);
            CutList := '';
            i := PosAt;
            PosAt := 0;
         end;
     NewString := MyTemp;
     end;
  end;
end;

procedure TwmMain.WorkWithDB;
var ggefunden: Boolean;
begin
     ggefunden := false;
     dbMain.Connected := false;
     dbMain.Params.Clear;
     dbmain.Params.Add('Server Name=' + vDBName);
     dbmain.Params.Add('USER NAME=SYSDBA');
     dbmain.Params.Add('PASSWORD=masterkey');


     dbmain.Connected := true;
     taGaeste.Active := true;

     If (gVorname = '') or (gName = '') or (gsex = '') or (gStrasse = '') or (gOrt = '') or (gland = '') or (gFirma = '') or (gEMail = '') then begin
       If gEmail = '' then begin
          istFehler := true;
          artFehler := 'Es wurde keine e-Mail Adresse angegeben';
       end else begin
            taGaeste.First;
            While not taGaeste.eof do begin
                  If tagaeste.FieldByName('email').AsString = gEMail then begin
                     ggefunden := true;
                     gVorname := tagaeste.FieldByName('vorname').AsString;
                     gName := tagaeste.FieldByName('name').AsString;
                     gSex := tagaeste.FieldByName('sex').AsString;
                     gStrasse := tagaeste.FieldByName('strasse').AsString;
                     gPlz := tagaeste.FieldByName('plz').AsString;
                     gOrt := tagaeste.FieldByName('ort').AsString;
                     gLand := tagaeste.FieldByName('land').AsString;
                     gFirma := tagaeste.FieldByName('firma').AsString;
                     MyCounter := tagaeste.FieldByName('counter').AsString;
                     taGaeste.Edit;
                     IncCounter;
                     tagaeste.FieldByName('counter').AsString := MyCounter;
                     taGaeste.Post;
                  end;
            taGaeste.Next;
            end;
            If not ggefunden then begin
               istFehler := true;
               artFehler := 'Der Eintrag konnte in der Datenbank nicht gefunden werden';
            end;
       end;
    end else begin
        taGaeste.First;
        While not taGaeste.eof do begin
              If tagaeste.FieldByName('EMail').AsString = gEMail then begin
                 ggefunden := true;
                 MyCounter := tagaeste.FieldByName('counter').AsString;
                 taGaeste.Edit;
                 IncCounter;
                 tagaeste.FieldByName('counter').AsString := MyCounter;
                 taGaeste.Post;
              end;
              taGaeste.Next;
        end;
        If not ggefunden then begin
            If RichtigeEM(gEMail) then begin
              Speichern;
              SendEMail('Ein neuer Benutzer hat sich registrieren lassen');
            end else begin
                istfehler := true;
                artFehler := 'Sie haben eine falsche e-Mail Adresse angegeben';
            end;
        end;
    end;
end;


// Eigentliche Procedure, die beim starten aufgerugen wird
procedure TwmMain.wmMaindefaultAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  istfehler := false;
  Textout := '';
  ArtFehler := '';
  thisprog := GetProgName(paramstr(0));

// Einlesen der Übergabeparameter
   gvorname := Request.QueryFields.Values['vorname'];
   gname := Request.QueryFields.Values['name'];
   gstrasse := Request.QueryFields.Values['strasse'];
   gsex := Request.QueryFields.Values['sex'];
   gplz := Request.QueryFields.Values['plz'];
   gort := Request.QueryFields.Values['ort'];
   gland := Request.QueryFields.Values['land'];
   gfirma := Request.QueryFields.Values['firma'];
   gemail := lowercase(Request.QueryFields.Values['email']);
// LESEN DER INI-VARIABLEN
  vProgram := GetValue(thisprog + '.ini', 'program');
  vautoexecute := GetValue(thisprog + '.ini', 'autoexecute');
  vfileexecute := GetValue(thisprog + '.ini', 'fileexecute');
  vsavetofile := GetValue(thisprog + '.ini', 'savetofile');
  vsavefile := GetValue(thisprog + '.ini', 'savefile');
  vdbname := GetValue(thisprog + '.ini', 'dbname');
  vHTMLFile := GetValue(thisprog + '.ini', 'htmlfile');
  vserverhtml := GetValue(thisprog + '.ini', 'serverhtml');
  vmailserver := GetValue(thisprog + '.ini', 'mailserver');
  vtoemail := GetValue(thisprog + '.ini', 'toemail');
  vmaxvisit := GetValue(thisprog + '.ini', 'maxvisit');
// Forschen in der Datenbank
  WorkWithDB;

// Einlesen der HTML-Datei
// Bearbeiten der HTML-Datei
  If not IstFehler then begin
     AssignFile(f, vHTMLFile);
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

// Ausgabe in Datei
//assignfile(f, 'write2db.htm');
//{$i-} Rewrite(f); {$i+}
//WriteLn(f, Textout);
//closefile(f);
end;

end.
