library Word;

uses
  SysUtils,
  Classes,
  ComObj,
  ActiveX,
  INIFiles,
  Windows,
  uniStruc in 'uniStruc.pas';

{$R *.RES}

var ww: Variant;     // Winword Objekt

function getContents(CD: String): TAudioCD; stdcall;
var
   p        : PChar;
   winPath  : ShortString;
   myINI    : TINIFile;
   i        : Integer;
   tmp      : TAudioCD;
begin
     p := StrAlloc(MAX_PATH);
     GetWindowsDirectory(p, MAX_PATH+1);
     winPath := p;
     StrDispose(p);
     clearCD(tmp);
     tmp.CDID := CD;
     if fileExists(winPath + '\CDPlayer.ini') then begin
        myINI := TINIFile.Create(winPath + '\CDPlayer.ini');
        tmp.Interpret := myINI.ReadString(tmp.CDID, 'artist', '');
        tmp.Album := myINI.ReadString(tmp.CDID, 'title', '');
        tmp.Stuecke := myINI.ReadInteger(tmp.CDID, 'numtracks', 0);
        tmp.Lieder := '';
        if tmp.Stuecke > 0 then
           for i := 0 to (tmp.Stuecke - 1) do
               tmp.Lieder := tmp.Lieder + myINI.ReadString(tmp.CDID, intToStr(i), '') + '|';
        myINI.Free;
     end;
     result := tmp;
end;

procedure fillContents(interpret, album: ShortString; index: TStrings; datei: String); stdcall;
var
   i     : Integer;
begin
     CoInitialize(nil);
     ww := CreateOleObject('Word.Application');
     ww.Visible := false;
     ww.Documents.Open(FileName := ExtractFilePath(ParamStr(0)) + '\cdcover.doc');
     ww.ActiveDocument.FormFields.Item('CDInterpret').Result := Interpret;
     ww.ActiveDocument.FormFields.Item('CDName').Result := Album;
     ww.ActiveDocument.FormFields.Item('CDInterpret1').Result := Interpret;
     ww.ActiveDocument.FormFields.Item('CDName1').Result := Album;
     ww.ActiveDocument.FormFields.Item('CDInterpret2').Result := Interpret;
     ww.ActiveDocument.FormFields.Item('CDName2').Result := Album;
     ww.ActiveDocument.FormFields.Item('CDInterpret3').Result := Interpret;
     ww.ActiveDocument.FormFields.Item('CDName3').Result := Album;
     case index.count of
          0: ww.ActiveDocument.FormFields.Item('CDInhalt').Result := '';
          1: ww.ActiveDocument.FormFields.Item('CDInhalt').Result := index.Strings[0];
          else
              for i := 0 to (index.count - 1) do begin
                  if i = 0 then
                     ww.ActiveDocument.FormFields.Item('CDInhalt').Result := index.Strings[i]
                  else
                      ww.ActiveDocument.FormFields.Item('CDInhalt').Result := ww.ActiveDocument.FormFields.Item('CDInhalt').Result + ' - ' + index.Strings[i];
              end;
     end; {CASE}
     ww.ActiveDocument.SaveAs(FileName := datei);
     ww.ActiveDocument.Close;
     ww.Quit;
//     ww := UnAssigned;
//     CoUninitialize();
end;

exports
  getContents,
  fillContents;

begin
end.
