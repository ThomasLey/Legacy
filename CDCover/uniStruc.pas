unit uniStruc;

interface
uses classes;

type TAudioCD = record
         CDID,
         Interpret,
         Album,
         Lieder       : String;
         Stuecke      : Integer;
     end;

procedure clearCD(VAR tmp: TAudioCD);

implementation

procedure clearCD(VAR tmp: TAudioCD);
begin
     tmp.Interpret := '';
     tmp.Album := '';
     tmp.Lieder := '';
     tmp.Stuecke := 0;
end;

end.
 