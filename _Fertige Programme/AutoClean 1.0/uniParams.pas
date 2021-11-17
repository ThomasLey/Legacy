unit uniParams;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, Buttons, ExtCtrls, iniFiles, Mask;

const iniDatei = 'Rumpelstielzchen.ini';

type
  TfrmParams = class(TForm)
    Panel2: TPanel;
    Panel3: TPanel;
    btnCancel: TBitBtn;
    btnOK: TBitBtn;
    sgParams: TStringGrid;
    btnNeu: TBitBtn;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    edtNextDay: TMaskEdit;
    Label1: TLabel;
    edtTime: TMaskEdit;
    BitBtn1: TBitBtn;
    btnDelete: TBitBtn;
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnNeuClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frmParams: TfrmParams;

implementation

uses uniMain;

{$R *.DFM}

procedure DeleteSpaces (VAR Tabelle: TStringGrid);
var
   zaehler, i: Integer;
   Gefunden: Boolean;
   procedure Tauschen (a, b: Integer);
   var
      temp: ShortString;
      spalte: Integer;
   begin
        For spalte := 0 to (Tabelle.ColCount - 1) do begin
           temp := Tabelle.Cells[spalte, a];
           Tabelle.Cells[spalte, a] := Tabelle.Cells[spalte, b];
           Tabelle.Cells[spalte, b] := temp;
        end;
   end;
begin
     zaehler := 1;
     While (zaehler <= (Tabelle.RowCount - 1 )) do begin
         If Tabelle.Cells[0, zaehler] = '' then begin
            Gefunden := false;
            For i := (Tabelle.RowCount - 1) downto (zaehler+1) do begin
               If not (Tabelle.Cells[0, i] = '') then begin
                  Tauschen(zaehler, i);
                  Gefunden := true;
               end;
            end;
            If not Gefunden then begin
               Tabelle.RowCount := zaehler;
               Break;
            end;
         end;
         inc (zaehler);
     end;
end;

procedure TfrmParams.btnCancelClick(Sender: TObject);
var
   myINI: TINIFile;
   counter: Integer;
   maxInput: Integer;
begin
     sgParams.Cells[0, 0] := 'Beschreibung';
     sgParams.Cells[1, 0] := 'Verzeichnis';
     sgParams.Cells[2, 0] := 'Maske';

     sgParams.RowCount := 1;
     myINI := TINIFile.Create(ExtractFileDir(ParamStr(0)) + '\' + iniDatei);
     frmMain.NextTime := myINI.ReadString('Config', 'Uhrzeit', '22:00:00');
     frmMain.NextDay := myINI.ReadString('Config', 'NächsterTag', '01.01.2001');
     edtTime.Text := frmMain.NextTime;
     edtNextDay.Text := frmMain.NextDay;
     maxInput := myINI.ReadInteger('Config', 'Counter', 0);

     For counter := 1 to maxInput do begin
           sgParams.RowCount := sgParams.RowCount + 1;
           sgParams.Cells[0, counter] := myINI.ReadString('Parameter', IntToStr(counter) + 'Desc', '');
           sgParams.Cells[1, counter] := myINI.ReadString('Parameter', IntToStr(counter) + 'Dir', '');
           sgParams.Cells[2, counter] := myINI.ReadString('Parameter', IntToStr(counter) + 'Mask', '');
     end;
     myINI.Free;

//     frmMain.StatusBar1.SimpleText := frmMain.NextTime;
     frmParams.Close;
end;

procedure TfrmParams.FormCreate(Sender: TObject);
var
   myINI: TINIFile;
   counter: Integer;
   maxInput: Integer;
begin
     sgParams.Cells[0, 0] := 'Beschreibung';
     sgParams.Cells[1, 0] := 'Verzeichnis';
     sgParams.Cells[2, 0] := 'Maske';

     sgParams.RowCount := 1;
     myINI := TINIFile.Create(ExtractFileDir(ParamStr(0)) + '\' + iniDatei);
     frmMain.NextTime := myINI.ReadString('Config', 'Uhrzeit', '22:00:00');
     frmMain.NextDay := myINI.ReadString('Config', 'NächsterTag', '01.01.2001');
     edtTime.Text := frmMain.NextTime;
     edtNextDay.Text := frmMain.NextDay;
     maxInput := myINI.ReadInteger('Config', 'Counter', 0);

     For counter := 1 to maxInput do begin
           sgParams.RowCount := sgParams.RowCount + 1;
           sgParams.Cells[0, counter] := myINI.ReadString('Parameter', IntToStr(counter) + 'Desc', '');
           sgParams.Cells[1, counter] := myINI.ReadString('Parameter', IntToStr(counter) + 'Dir', '');
           sgParams.Cells[2, counter] := myINI.ReadString('Parameter', IntToStr(counter) + 'Mask', '');
     end;
     myINI.Free;

     If sgParams.RowCount > 1 then sgParams.FixedRows := 1;
end;

procedure TfrmParams.btnNeuClick(Sender: TObject);
var
   temp1, temp2, temp3: String;
begin
     temp1 := InputBox('Beschreibung', 'Geben Sie eine Beschreibung für diesen Löschvorgang ein:', '');
     If temp1 = '' then exit;

     temp2 := InputBox('Verzeichnis', 'Geben Sie ein Verzeichnis an:', '');
     If temp2 = '' then exit;

     temp3 := InputBox('Löschmaske', 'Nach welcher Maske soll gelöscht werden?:', '');
     If temp3 = '' then exit;

     sgParams.RowCount := sgParams.RowCount + 1;
     sgParams.Cells[0, sgParams.RowCount - 1] := Temp1;
     sgParams.Cells[1, sgParams.RowCount - 1] := Temp2;
     sgParams.Cells[2, sgParams.RowCount - 1] := Temp3;
     If sgParams.RowCount > 1 then sgParams.FixedRows := 1;
end;

procedure TfrmParams.btnOKClick(Sender: TObject);
var
   myINI: TINIFile;
   counter: Integer;
begin
     myINI := TINIFile.Create(ExtractFileDir(ParamStr(0)) + '\' + iniDatei);
     frmMain.NextTime := edtTime.Text;
     frmMain.NextDay := edtNextDay.Text;
     myINI.WriteString('Config', 'Uhrzeit', frmMain.NextTime);
     myINI.WriteInteger('Config', 'Counter', sgParams.RowCount - 1);
     myINI.WriteString('Config', 'NächsterTag', frmMain.NextDay);

     for counter := 1 to (sgParams.RowCount - 1) do begin
           myINI.WriteString('Parameter', IntToStr(counter) + 'Desc', sgParams.Cells[0, counter]);
           myINI.WriteString('Parameter', IntToStr(counter) + 'Dir', sgParams.Cells[1, counter]);
           myINI.WriteString('Parameter', IntToStr(counter) + 'Mask', sgParams.Cells[2, counter]);
     end;
     myINI.Free;

     frmMain.StatusBar1.SimpleText := 'nächste Ausführung: ' + frmMain.NextDay + ' ' + frmMain.NextTime;
     Close();
end;


procedure TfrmParams.Button1Click(Sender: TObject);
var
   temp1, temp2: String;
begin
     temp1 := InputBox('Datum', 'Geben Sie das Datum der ersten Ausführung ein:', frmMain.NextDay);
     If temp1 = '' then begin
     end else begin
         frmParams.edtNextDay.Text := temp1;
     end;

     temp2 := InputBox('Verzeichnis', 'Geben Sie eine Uhrzeit an:', frmMain.NextTime);
     If temp2 = '' then begin
     end else begin
         frmParams.edtTime.Text := temp2;
     end;
end;

procedure TfrmParams.btnDeleteClick(Sender: TObject);
begin
     If sgParams.RowCount = 1 then Exit;
     sgParams.Cells[0, frmParams.sgParams.Row] := '';
     sgParams.Cells[1, frmParams.sgParams.Row] := '';
     sgParams.Cells[2, frmParams.sgParams.Row] := '';
     DeleteSpaces(sgParams);
     If sgParams.RowCount > 1 then sgParams.FixedRows := 1;
end;

end.
