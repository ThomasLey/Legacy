unit uUtils;

interface

function GetString(Zeichen: Char; Text: String; Zahler: Integer): String;



implementation

function GetString(Zeichen: Char; Text: String; Zahler: Integer): String;
var i, j, Start: Integer;
begin
     j := 0; Start := 1;
     If (Text[1] <> Zeichen) then Text := Zeichen + Text; // Damit mit dem ersten angefangen wird
     If (Text[Length(Text)] <> Zeichen) then Text := Text + Zeichen; // Damit ein Ende da ist

     for i := 1 to length(Text) do begin
         If Text[i] = Zeichen then begin
            Inc(j);
            If j = (Zahler) then Start := i + 1;
            If j = (Zahler + 1) then begin
               Result := Copy(Text, Start, i - Start);
               Break;
            end;
         end
     end;
end;



end.
