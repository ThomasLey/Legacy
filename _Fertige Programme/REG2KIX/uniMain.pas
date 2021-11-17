unit uniMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    mmoReg: TMemo;
    odlgReg: TOpenDialog;
    mmoKix: TMemo;
    Panel1: TPanel;
    btnReadREG: TButton;
    btnCreateKIX: TButton;
    btnSaveKIX: TButton;
    sdlgSaveKIX: TSaveDialog;
    procedure btnReadREGClick(Sender: TObject);
    procedure btnCreateKIXClick(Sender: TObject);
    procedure btnSaveKIXClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

function getString(Text: String; Zahler: Integer): String;
var i, j, Start: Integer;
begin
     Text := '=' + Text + '=';
     j := 0; Start := 1;
     for i := 1 to length(Text) do begin
         If Text[i] = '=' then begin
            Inc(j);
            If j = (Zahler) then Start := i + 1;
            If j = (Zahler + 1) then Result := Copy(Text, Start, i - Start);
         end
     end;
end;
procedure TForm1.btnReadREGClick(Sender: TObject);
begin
     If odlgReg.Execute then begin
        mmoReg.Lines.LoadFromFile(odlgReg.FileName);
     end;
end;

procedure TForm1.btnCreateKIXClick(Sender: TObject);
var
   intCount: Integer;
   strKey,
   strValue,
   strExpr,
   strType,
   strTemp: String;
begin
     mmoKIX.Clear();
     mmoKix.Lines.Append('');
     mmoKix.Lines.Append(';      ' + DateToStr(Date));
     mmoKix.Lines.Append('; Integrata Unternehmensberatung:   REG2KIX  (C)Thomas Ley');
     mmoKix.Lines.Append('');
     mmoKix.Lines.Append('');

     strKey := '';
     intCount := 0;
     While intCount < mmoReg.Lines.Count do
         If Copy(mmoReg.Lines[intCount], 1, 1) = '[' then begin
            strKey := Copy(mmoReg.Lines[intCount], 2, length(mmoReg.Lines[intCount]) - 2);
            mmoKIX.Lines.Append('$key = "' + strKey + '"');
            mmoKIX.Lines.Append('IF ExistKey ("$key" ) <> 0 AddKey ( "$key" ) ENDIF');
            mmoKIX.Lines.Append('');
            inc(intCount);
         end else
            If (strKey <> '') and (mmoReg.Lines[intCount] <> '') then begin
               strValue := GetString(mmoReg.Lines[intCount], 1);
               strExpr := GetString(mmoReg.Lines[intCount], 2);
               mmoKIX.Lines.Append('$value = ' + strValue);
               if lowerCase(Copy(strExpr, 1, 5)) = 'dword' then begin
                  strType := '"REG_DWORD"';
                  Delete(strExpr, 1, 6);
                  mmoKIX.Lines.Append('$expr = "' + strExpr + '"');
                  inc(intCount);
               end else
                  if lowerCase(Copy(strExpr, 1, 3)) = 'hex' then begin
                     strType := '"REG_BINARY"';
                     Delete(strExpr, 1, 4);
                     mmoKIX.Lines.Append('$expr = "' + strExpr + '"');
                     inc(intCount);
                     While (Copy(mmoReg.Lines[intCount], 1, 2) = '  ') do begin
                           strTemp := mmoKIX.Lines[mmoKIX.Lines.Count - 1];
                           Delete(strTemp, length(strTemp), 1);
                           mmoKIX.Lines[mmoKIX.Lines.Count - 1] := strTemp;
                           mmoKIX.Lines.Append(mmoReg.Lines[intCount] + '"');
                           inc(intCount);
                     end;
                     end else begin
                        strType := '"REG_SZ"';
                        Delete(strExpr, 1, 1);
                        Delete(strExpr, length(strExpr), 1);
                        mmoKIX.Lines.Append('$expr = "' + strExpr + '"');
                        inc(intCount);
                     end;
               mmoKIX.Lines.Append('$return_status = WriteValue ( "$key", "$value", "$expr", ' + strType + ')');
               mmoKIX.Lines.Append('IF $return_status <> 0 ? " -> Setzen eines Registry g.V. fehlgeschlagen!" else ? "Internet Explorer Wert wurde gesetzt" ENDIF');
               mmoKIX.Lines.Append('');
            end else begin
                inc(intCount);
            end;
end;

procedure TForm1.btnSaveKIXClick(Sender: TObject);
begin
     if sdlgSaveKIX.Execute then begin
        mmoKIX.Lines.SaveToFile(sdlgSaveKIX.FileName);
     end;
end;

end.
