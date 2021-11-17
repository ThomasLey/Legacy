unit uniFunctions;

interface

function createMyHTML: String;

implementation

uses
    Windows, SysUtils, Registry;

const
    MINTAGLENGTH = 4;
var
    htmlfileIN,
    htmlfileOut : TextFile;
    htmlsrc,
    htmldst,
    INtemp      : String;
    Pause       : Cardinal;

// Ließt den n. String aus dem String aus, getrenent durch Punkt
function GetStringDot(Text: String; Zahler: Integer): String;
var i, j, Start: Integer;
begin
     j := 0; Start := 1;
     If not(Text[1] = '.') then Text := '.' + Text;
     If not(Text[length(text)] = '.') then Text := Text + '.';
     for i := 1 to length(Text) do begin
         If Text[i] = '.' then begin
            Inc(j);
            If j = (Zahler) then Start := i + 1;
            If j = (Zahler + 1) then Result := Copy(Text, Start, i - Start);
         end
     end;
end;

function getWindowsDirectory:String;
var P: PChar;
begin
     P:=StrAlloc(MAX_PATH+1);
     windows.GetWindowsDirectory(P,MAX_PATH+1);
     getWindowsDirectory:= P;
     StrDispose(P);
end;

function getSystemDirectory:String;
var P: PChar;
begin
     P:=StrAlloc(MAX_PATH+1);
     windows.GetSystemDirectory(P,MAX_PATH+1);
     getSystemDirectory:= P;
     StrDispose(P);
end;

function getUserName:String;
var P   : PChar;
    size: DWord;
begin
     size :=1024;
     P:=StrAlloc(size);
     windows.GetUserName(P,size);
     getUserName:= P;
     StrDispose(P);
end;

function getComputerName:String;
var P   : PChar;
    size: DWord;
begin
     size :=MAX_COMPUTERNAME_LENGTH+1;
     P:=StrAlloc(size);
     windows.GetComputerName(P,size);
     getComputerName:= P;
     StrDispose(P);
end;

function getTotalPhysMemory: String;
var memory : TMEMORYSTATUS;
begin
    GlobalMemoryStatus(memory);
    getTotalPhysMemory:= intToStr(memory.dwTotalPhys div (1024*1024));
end;

function getAvailPhysMemory: String;
var memory : TMEMORYSTATUS;
begin
    GlobalMemoryStatus(memory);
    getAvailPhysMemory:= intToStr(memory.dwAvailPhys div (1024*1024));
end;

function getTotalPageFile: String;
var memory : TMEMORYSTATUS;
begin
    GlobalMemoryStatus(memory);
    getTotalPageFile:= intToStr(memory.dwTotalPageFile div (1024*1024));
end;

function getAvailPageFile: String;
var memory : TMEMORYSTATUS;
begin
    GlobalMemoryStatus(memory);
    getAvailPageFile:= intToStr(memory.dwAvailPageFile div (1024*1024));
end;

function getProcessorType:String;
var systeminfo:TSystemInfo;
    zw : string;

begin
   GetSystemInfo(systeminfo);
   case systeminfo.dwProcessorType of
               386  : zw := 'Intel 386';
               486  : zw := 'Intel 486';
               586  : zw := 'Intel Pentium';
               860  : zw := 'Intel 860';
              2000  : zw := 'MIPS R2000';
              3000  : zw := 'MIPS R3000';
              4000  : zw := 'MIPS R4000';
             21064  : zw := 'ALPHA 21064';
               601  : zw := 'PPC 601';
               603  : zw := 'PPC 603';
               604  : zw := 'PPC 604';
               620  : zw := 'PPC 620';
   else
                      zw := 'unbekannt';
   end;
   result := zw;
end;

function getProcessorCount: String;
var systeminfo:TSystemInfo;
begin
   GetSystemInfo(systeminfo);
   result := intToStr(systeminfo.dwNumberOfProcessors);
end;

// Ersetzt bei dem übergebenem HTML-Text ausgewählte Tag's in eigene Zeichenfolgen um
function newHTMLString(oldhtml: String): String;
var
    tagStart, tagEnde,
    i, letztePosition   : Integer;
    tag                 : String;
    newHTMLtemp         : String; // eigene Variable, da sich die Länge von oldhtml ändert
    computer, wert      : String; // nur eigene Tag's ändern. Bestimmte Eigenschaften
begin
    tagStart := 0;
    letztePosition := 1;
    newHTMLtemp := '';
// Jedes Zeichen wird nach einem Tag abgesucht
    For i := 1 to (length(oldhtml) - MINTAGLENGTH) do begin
        If (oldhtml[i] = '<') and (oldhtml[i + 1] = '§') then tagStart := i + 2; // Damit nur der Tag übrigbleibt
        If (oldhtml[i] = '>') and (tagStart > 0) then begin
            tagEnde := i - 1;
            tag := copy(oldhtml, tagStart, (tagEnde+1) - tagStart);
            computer := getStringDot(tag, 1);
            wert     := getStringDot(tag, 2);
// Hier wird Überprüft, ob der der Tag den eigenen Computer betrifft
            If lowerCase(computer) = lowerCase(getComputerName) then begin
// Eigenschaften des "objektes" Computer
//***************************************************************************
                If lowerCase(wert) = 'name' then begin
                    newHTMLtemp := newHTMLtemp + Copy(oldhtml, letztePosition, (tagStart-2) - letztePosition);
                    newHTMLtemp := newHTMLtemp + getComputerName;
                    letztePosition := tagEnde + 2;
                end;
                If lowerCase(wert) = 'user' then begin
                    newHTMLtemp := newHTMLtemp + Copy(oldhtml, letztePosition, (tagStart-2) - letztePosition);
                    newHTMLtemp := newHTMLtemp + getUserName;
                    letztePosition := tagEnde + 2;
                end;
                If lowerCase(wert) = 'time' then begin
                    newHTMLtemp := newHTMLtemp + Copy(oldhtml, letztePosition, (tagStart-2) - letztePosition);
                    newHTMLtemp := newHTMLtemp + timeToStr(time);
                    letztePosition := tagEnde + 2;
                end;
                If lowerCase(wert) = 'date' then begin
                    newHTMLtemp := newHTMLtemp + Copy(oldhtml, letztePosition, (tagStart-2) - letztePosition);
                    newHTMLtemp := newHTMLtemp + dateToStr(Date);
                    letztePosition := tagEnde + 2;
                end;

                If lowerCase(wert) = 'windir' then begin
                    newHTMLtemp := newHTMLtemp + Copy(oldhtml, letztePosition, (tagStart-2) - letztePosition);
                    newHTMLtemp := newHTMLtemp + getWindowsDirectory;
                    letztePosition := tagEnde + 2;
                end;
                If lowerCase(wert) = 'sysdir' then begin
                    newHTMLtemp := newHTMLtemp + Copy(oldhtml, letztePosition, (tagStart-2) - letztePosition);
                    newHTMLtemp := newHTMLtemp + getSystemDirectory;
                    letztePosition := tagEnde + 2;
                end;

                If lowerCase(wert) = 'totalphysmem' then begin
                    newHTMLtemp := newHTMLtemp + Copy(oldhtml, letztePosition, (tagStart-2) - letztePosition);
                    newHTMLtemp := newHTMLtemp + getTotalPhysMemory + ' MB';
                    letztePosition := tagEnde + 2;
                end;
                If lowerCase(wert) = 'totalvirtualmem' then begin
                    newHTMLtemp := newHTMLtemp + Copy(oldhtml, letztePosition, (tagStart-2) - letztePosition);
                    newHTMLtemp := newHTMLtemp + getTotalPageFile + ' MB';
                    letztePosition := tagEnde + 2;
                end;
                If lowerCase(wert) = 'freephysmem' then begin
                    newHTMLtemp := newHTMLtemp + Copy(oldhtml, letztePosition, (tagStart-2) - letztePosition);
                    newHTMLtemp := newHTMLtemp + getAvailPhysMemory + ' MB';
                    letztePosition := tagEnde + 2;
                end;
                If lowerCase(wert) = 'freevirtualmem' then begin
                    newHTMLtemp := newHTMLtemp + Copy(oldhtml, letztePosition, (tagStart-2) - letztePosition);
                    newHTMLtemp := newHTMLtemp + getAvailPageFile + ' MB';
                    letztePosition := tagEnde + 2;
                end;
                If lowerCase(wert) = 'processortype' then begin
                    newHTMLtemp := newHTMLtemp + Copy(oldhtml, letztePosition, (tagStart-2) - letztePosition);
                    newHTMLtemp := newHTMLtemp + getProcessorType;
                    letztePosition := tagEnde + 2;
                end;
                If lowerCase(wert) = 'processorcount' then begin
                    newHTMLtemp := newHTMLtemp + Copy(oldhtml, letztePosition, (tagStart-2) - letztePosition);
                    newHTMLtemp := newHTMLtemp + getProcessorCount;
                    letztePosition := tagEnde + 2;
                end;
//***************************************************************************
// Tag soll erhalten bleiben wenn dieser nicht dieses Computer betrifft
            end else begin
                newHTMLtemp := newHTMLtemp + Copy(oldhtml, letztePosition, letztePosition - (tagEnde+1));
                letztePosition := tagEnde + 2;
            end;
            tagStart := 0;
        end;
    end;
    newHTMLTemp := newHTMLTemp + copy(oldhtml, letztePosition, (length(oldhtml)+1) - letztePosition);
    result := newHTMLTemp;
end;

function createMyHTML: String;
var
   reg      : TRegistry;
   strTemp  : String;
begin
        strTemp := 'kein Fehler aufgetreten.';
        reg := TRegistry.Create;
        reg.RootKey := HKEY_LOCAL_MACHINE;
        if reg.OpenKey('\Software\Unilog Integrata\AutoHTML', false) then begin
           HTMLsrc := reg.ReadString('HTMLsrc');
           HTMLdst := reg.ReadString('HTMLdst');
           Pause := reg.ReadInteger('Refresh');
        end else begin
           reg.WriteString('HTMLsrc', 'C:\in.htm');
           reg.WriteString('HTMLdst', 'C:\out.htm');
           reg.WriteInteger('Refresh', 30);
           HTMLsrc := reg.ReadString('HTMLsrc');
           HTMLdst := reg.ReadString('HTMLdst');
           Pause := reg.ReadInteger('Refresh');
        end;
        If Pause < 10 then begin
           Pause := 10;
           reg.WriteInteger('Refresh', Pause);
        end;
        If Pause > 3600 then begin
           Pause := 3600;
           reg.WriteInteger('Refresh', Pause);
        end;

        AssignFile(htmlfileIN, htmlsrc);
        {$i-}ReSet(htmlfileIN);{$i+}
        If IOResult = 0 then begin
            AssignFile(htmlfileOUT, htmldst);
            {$i-}ReWrite(htmlfileOUT);{$i+}
            If IOResult = 0 then begin
                While not eof(htmlfileIN) do begin
                    ReadLN(htmlfileIN, INTemp);
                    WriteLn(htmlfileOUT, newHTMLString(INTemp));
                end;
                CloseFile(htmlfileOUT);
            end else begin
                 strTemp := 'Fehler beim öffnen der Datei "' + htmldst + '" aufgetreten. Fehlernummer: ' + intToStr(IOResult);
            end;
            CloseFile(htmlfileIN);
        end else begin
             strTemp := 'Fehler beim öffnen der Datei "' + htmlsrc + '" aufgetreten. Fehlernummer: ' + intToStr(IOResult);
        end;
        reg.WriteString('Error', strTemp);
        reg.Free;

        Sleep(Pause);
end;

end.
