unit uniDatabaseFunctions;
interface

uses ADODB;

function createTable(VAR adoCon: TADOConnection; sTable: String): Boolean;
function dropTable(VAR adoCon: TADOConnection; sTable: String): Boolean;
function renameTable(VAR adoCon: TADOConnection; sTable, dtable: String): Boolean;


implementation
// erstellt eine Tabelle in die Datenbank mit der aktiven Connection
function createTable(VAR adoCon: TADOConnection; sTable: String): Boolean;
var
   sSQL: String;
begin
     result := false;
     sSQL  := 'CREATE TABLE ' + sTable + ' (';
     sSQL  := sSQL + 'sprache11 text(50), ';
     sSQL  := sSQL + 'sprache12 text(50), ';
     sSQL  := sSQL + 'sprache21 text(50), ';
     sSQL  := sSQL + 'sprache22 text(50), ';
     sSQL  := sSQL + 'res1 integer,';
     sSQL  := sSQL + 'res2 integer, ';
     sSQL  := sSQL + 'res3 integer, ';
     sSQL  := sSQL + 'res4 integer);';
     if adoCon.Connected then begin
        adoCon.Execute(sSQL);
        result := true;
     end;
end;
// l�scht eine Tabelle aus der Datenbank mit der aktiven Connection
function dropTable(VAR adoCon: TADOConnection; sTable: String): Boolean;
var
   sSQL: String;
begin
     result := false;
     sSQL  := 'DROP TABLE ' + sTable + ';';
     if adoCon.Connected then begin
        adoCon.Execute(sSQL);
        result := true;
     end;
end;
// benennt eine Tabelle aus der Datenbank mit der aktiven Connection um
function renameTable(VAR adoCon: TADOConnection; sTable, dtable: String): Boolean;
var
   sSQL: String;
begin
     result := false;
     createTable(adoCon, dTable);
     sSQL  := 'INSERT INTO ' + dTable + ' SELECT * FROM ' + sTable + ';';
     if adoCon.Connected then begin
        adoCon.Execute(sSQL);
        result := true;
     end;
     dropTable(adocon, sTable);
end;


end.
