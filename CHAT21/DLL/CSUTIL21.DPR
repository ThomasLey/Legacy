library csUtil21;

uses
  Grids,
  Forms,
  SysUtils,
  Classes,
  Windows,
  frmSplashForm in 'frmSplashForm.pas' {Copyright};


function GetProgrammer: ShortString;
begin
     Result := 'Thomas Ley';
end;

function GetFirm: ShortString;
begin
     Result := 'Garmhausen GmbH';
end;

function GetVersion: ShortString;
begin
     Result := '2.1';
end;

procedure ShowSplashFrm(ID: Char; timer: Boolean);
begin
    case ID of
// Server
          's': Copyright.lblProgramm.caption := 'Intra Chat - Server';
// Client
          'c': Copyright.lblProgramm.caption := 'Intra Chat - Client';
// Allgemein
     else
          Copyright.lblProgramm.caption := 'Intra Chat';
     end;

     Copyright.Show;
end;

function GetString(Zeichen: Char; Text: ShortString; Zahler: Integer): ShortString; stdcall;
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

function GetInteger(Zeichen: Char; Text: ShortString; Zahler: Integer): Integer; stdcall;
var Zahl: String;
begin
     Zahl := GetString(Zeichen, Text, Zahler);
     Result := StrToInt(Zahl);
end;

procedure LogoutUser(Table: TStringGrid; Computer: ShortString); stdcall;
var Counter, i: Integer;
begin
     Counter := 0;
     Repeat
           inc(Counter)
     until Table.Cells[1, Counter] = Computer;
     If (Counter < (Table.RowCount - 1)) then begin
        For i := Counter to (Table.RowCount - 1) do begin
           Table.Cells[0, i] := Table.Cells[0, i + 1];
           Table.Cells[1, i] := Table.Cells[1, i + 1];
        End;
     end;
     Table.RowCount := Table.RowCount - 1;
     If not Table.RowCount = 0 then Table.FixedRows := 1;
end;

Function GetNameByPc(Table: TStringGrid; Computer: ShortString): ShortString; stdcall;
var i: Integer;
begin
     For i := 1 to (Table.RowCount - 1) do
        If Table.Cells[1, i] = Computer then Result := Table.Cells[0, i];
end;

exports
      ShowSplashFrm,
      GetString,
      GetInteger,
      GetProgrammer,
      GetFirm,
      GetVersion,
      LogoutUser,
      GetNameByPc;

begin
     Copyright := TCopyright.Create(Application);
     ShowSplashFrm('a', true);
end.
