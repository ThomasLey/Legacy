unit uniMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs, Registry,
  ExtCtrls;

type
  TCreateHTML = class(TService)
    procedure ServiceExecute(Sender: TService);
  private
    { Private-Deklarationen }
  public
    Timer: TTimer;
    function GetServiceController: TServiceController; override;
    { Public-Deklarationen }
  end;

var
  CreateHTML: TCreateHTML;

implementation

{$R *.DFM}

const
    MINTAGLENGTH = 4;
var
    htmlfileIN,
    htmlfileOut : TextFile;
    htmlsrc,
    htmldst,
    INtemp      : String;

// Lieﬂt den n. String aus dem String aus, getrenent durch Punkt
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

function subTag(tag: String): String;
begin
     result := '';
     If lowercase(tag) = 'name' then result := getComputerName;
     If lowercase(tag) = 'user' then result := getUserName;
     If lowercase(tag) = 'time' then result := timeToStr(time);
     If lowercase(tag) = 'date' then result := dateToStr(Date);
     If lowercase(tag) = 'windir' then result := getWindowsDirectory;
     If lowercase(tag) = 'sysdir' then result := getSystemDirectory;
     If lowercase(tag) = 'totalphysmem' then result := getTotalPhysMemory + ' MB';
     If lowercase(tag) = 'totalvirtualmem' then result := getTotalPageFile + ' MB';
     If lowercase(tag) = 'freephysmem' then result := getAvailPhysMemory + ' MB';
     If lowercase(tag) = 'freevirtualmem' then result := getAvailPageFile + ' MB';
     If lowercase(tag) = 'processortype' then result := getProcessorType;
     If lowercase(tag) = 'processorcount' then result := getProcessorCount;
end;

function newHTMLString(oldhtml: String): String;
var
    tagStart, i         : Integer;
    newHTMLtemp         : String; // eigene Variable, da sich die L‰nge von oldhtml ‰ndert
    tag                 : String; // der Name des Tags
begin
    tagStart := 0;
    newHTMLtemp := '';
// Jedes Zeichen wird nach einem Tag abgesucht
    For i := 1 to (length(oldhtml)) do begin
        If (oldhtml[i] = '<') and (oldhtml[i + 1] = '%') then begin
           tagStart := i; // Damit nur der Tag ¸brigbleibt
        end else
            If (oldhtml[i] = '>') and (tagStart > 0) then begin
               tag := copy(oldHTML, tagStart + 2, (i-tagStart) - 2);
               newHTMLtemp := newHTMLtemp + subTag(tag);
               tagStart := 0;
            end else
                If tagStart = 0 then newHTMLtemp := newHTMLtemp + oldHTML[i];
    end;
    result := newHTMLtemp;
end;

function createMyHTML: String;
var
   reg      : TRegistry;
   strTemp  : String;
begin
        strTemp := 'kein Fehler aufgetreten.';
        reg := TRegistry.Create;
        reg.RootKey := HKEY_LOCAL_MACHINE;
        if reg.OpenKey('\Software\infoHTML\1.0\', true) then begin
           HTMLsrc := reg.ReadString('HTMLsrc');
           HTMLdst := reg.ReadString('HTMLdst');
        end else begin
           reg.WriteString('HTMLsrc', 'C:\in.htm');
           reg.WriteString('HTMLdst', 'C:\out.htm');
           HTMLsrc := reg.ReadString('HTMLsrc');
           HTMLdst := reg.ReadString('HTMLdst');
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
                 strTemp := 'Fehler beim ˆffnen der Datei "' + htmldst + '" aufgetreten. Fehlernummer: ' + intToStr(IOResult);
            end;
            CloseFile(htmlfileIN);
        end else begin
             strTemp := 'Fehler beim ˆffnen der Datei "' + htmlsrc + '" aufgetreten. Fehlernummer: ' + intToStr(IOResult);
        end;
        reg.WriteString('Error', strTemp);
        reg.Free;
end;

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  CreateHTML.Controller(CtrlCode);
end;

function TCreateHTML.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TCreateHTML.ServiceExecute(Sender: TService);
var
   i      : Integer;
begin
     i := 0;
     While not terminated do begin
           If i >= 10 then begin
              createMyHTML();
              i := 0;
           end else begin
               inc(i);
           end;
           Sleep(1000);
     end;
end;

end.
