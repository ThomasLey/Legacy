library LoNoCache;

{ Wichtiger Hinweis zur DLL-Speicherverwaltung: ShareMem muß sich in der
  ersten Unit der unit-Klausel der Bibliothek und des Projekts befinden (Projekt-
  Quelltext anzeigen), falls die DLL Prozeduren oder Funktionen exportiert, die
  Strings als Parameter oder Funktionsergebnisse weitergibt. Dies trifft auf alle
  Strings zu, die von oder zur DLL weitergegeben werden -- auch diejenigen, die
  sich in Records oder Klassen befinden. ShareMem ist die Schnittstellen-Unit
  zu BORLNDMM.DLL, der gemeinsamen Speicherverwaltung, die zusammen mit
  der DLL weitergegeben werden muß. Um die Verwendung von BORLNDMM.DLL
  zu vermeiden, sollten String-Informationen als PChar oder ShortString übergeben werden. }

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

var
   ListOfFiles: TStrings;
{$R *.RES}

function DelFile(myFile: String): Boolean;
var
  F: file of byte;
begin
     {$i-}
     AssignFile(f, myFile);
     result := true;
     try
        Erase(F);
     except
           result := false;
     end;
     CloseFile(f);
     {$i+}
end;

function GetFileSize(myFile: String): LongInt;
var
   f: File of Byte;
begin
     {$i-}
     AssignFile(f, myFile);
     Reset(f);
     If IOResult = 0 then Result := FileSize(f) else Result := 0;
     CloseFile(f);
     {$i+}
end;

procedure GetAllFiles(mask:string);
var Search: TSearchrec;
    verz  : string;
    such  : string;

begin
  such := ExtractFileName(mask);
  verz := ExtractFilepath(mask);
  if verz[length(verz)]<>'\' then verz := verz + '\';
 { alle Dateien suchen }
  if FindFirst(mask, $23, Search)= 0 then repeat
     ListOfFiles.Add(verz+Search.Name);
  until FindNext(Search)<>0;
  { Unterverzeichnisse durchsuchen }
  if FindFirst(verz + '*.*',fadirectory, Search)= 0 then begin;
  repeat
     if((search.attr and fadirectory)=fadirectory)and(search.name[1]<>'.') then GetAllFiles(verz+ Search.Name + '\' + such);
  until FindNext(Search) <> 0;
  end;
end;

function ExecTask(Params: TStrings; Log: TMemo): Boolean; stdcall;
{ Params:
     1 -> Directory
     2 -> Mask
}
var
   MBSize: Integer;
   notMBSize: Integer;
   delMBSize: Integer;
   notFiles: Integer;
   delFiles: Integer;
   i: Integer;
begin
     result := false;
// Überprüfen der Parameter
     If Params.Count < 3 then begin
        Log.Lines.Add('Nicht genug Parameter, um die Dateien zu löschen');
        Exit;
     end;
// Initialisieren
     ListOfFiles := TStringList.Create;
     ListOfFiles.Clear;
     notMBSize := 0;
     delMBSize := 0;
     notFiles := 0;
     delFiles := 0;
     Log.Lines.Append(DateToStr(Date) + ' ' + TimeToStr(Time) + ' Task ' + Params.Strings[0] + ' wird gestartet...');
// Lesen der Verzeichnisse und das Berechnen der Größe
// Dateien werden gelöscht
     GetAllFiles(Params.Strings[1] + '\' + Params.Strings[2]);
     For i := 0 to (ListOfFiles.Count - 1) do begin
         MBSize := GetFileSize(ListOfFiles.Strings[i]);
         If DelFile(ListOfFiles[i]) then begin
            delMBSize := delMBSize + MBSize;
            inc(delFiles);
         end else begin
            notMBSize := notMBSize + MBSize;
            inc(notFiles);
         end;
     end;
     Log.Lines.Append(DateToStr(Date) + ' ' + TimeToStr(Time) + ' ' + IntToStr(delMBSize) + ' Bytes in ' + IntToStr(delFiles) + ' Dateien freigegeben.');
     Log.Lines.Append(DateToStr(Date) + ' ' + TimeToStr(Time) + ' ' + IntToStr(notMBSize) + ' Bytes in ' + IntToStr(notFiles) + ' Dateien konnten nicht freigegeben werden.');

     Result := true;
     ListOfFiles.Destroy();
end;

exports
       ExecTask;

begin
end.
