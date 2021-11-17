unit uniMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, ExtCtrls, CoolTrayIcon;

type
  TfrmMain = class(TForm)
    Memo1: TMemo;
    pnlButtons: TPanel;
    btnAutoExec: TButton;
    btnSet: TButton;
    StatusBar1: TStatusBar;
    AutoStart: TTimer;
    Button1: TButton;
    CoolTray: TCoolTrayIcon;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    CheckBox1: TCheckBox;
    procedure StartClick(Sender: TObject);
    procedure btnSetClick(Sender: TObject);
    procedure AutoStartTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CoolTrayDblClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    NextDay: ShortString;
    NextTime: ShortString;
    Mask: ShortString;
    Directory: String;
    { Public-Deklarationen }
  end;

var
  frmMain: TfrmMain;
  ListOfFiles: TStrings;

implementation

uses uniParams;
function ExecTask(Params: TStrings; Log: TMemo): Boolean; stdcall;external 'LoNoCache.dll';

{$R *.DFM}

procedure TfrmMain.StartClick(Sender: TObject);
var
   myParam: TStrings;
   counter: Integer;
begin
//     Memo1.Clear();
     myParam := TStringList.Create();
     For counter := 1 to (frmParams.sgParams.RowCount - 1) do begin
         myParam.Clear();
         myParam.Add(frmParams.sgParams.Cells[0, counter]);
         myParam.Add(frmParams.sgParams.Cells[1, counter]);
         myParam.Add(frmParams.sgParams.Cells[2, counter]);
         If not ExecTask(myParam, Memo1) then Memo1.Lines.Append('Fehler aufgetreten');
         Application.ProcessMessages;
     end;
     myParam.Destroy;
     Memo1.Lines.Append('');
end;

procedure TfrmMain.btnSetClick(Sender: TObject);
begin
     frmParams.Show;
end;

procedure TfrmMain.AutoStartTimer(Sender: TObject);
begin
     AutoStart.Enabled := false;
     frmMain.StatusBar1.SimpleText := 'nächste Ausführung: ' + frmMain.NextDay + ' ' + frmMain.NextTime;
     If StrToDate(frmMain.NextDay)>Date then begin
     end;
     If StrToDate(frmMain.NextDay)=Date then begin
        If StrToTime(frmMain.NextTime) <= Time then begin
           frmMain.StartClick(Sender);
           frmMain.NextDay := DateToStr(Date + 1);
           frmParams.edtNextDay.Text := frmMain.NextDay;
           frmParams.btnOKClick(Sender);
        end;
     end;
     If StrToDate(frmMain.NextDay)<Date then begin
           frmMain.StartClick(Sender);
           frmMain.NextDay := DateToStr(Date + 1);
           frmParams.edtNextDay.Text := frmMain.NextDay;
           frmParams.btnOKClick(Sender);
     end;
     AutoStart.Enabled := true;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     frmParams.btnOKClick(Sender);
end;

procedure TfrmMain.Button1Click(Sender: TObject);
begin
     Memo1.Clear;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
     frmMain.Caption := '       ' + Application.Title;
     CoolTray.Hint := Application.Title;
     CoolTray.Icon := Application.Icon;
end;

procedure TfrmMain.CoolTrayDblClick(Sender: TObject);
begin
     frmMain.Show();
end;

procedure TfrmMain.BitBtn1Click(Sender: TObject);
begin
     frmMain.Hide;
end;

procedure TfrmMain.BitBtn2Click(Sender: TObject);
begin
     frmParams.btnOKClick(Sender);
     frmMain.Close();
end;

procedure TfrmMain.CheckBox1Click(Sender: TObject);
begin
     AutoStart.Enabled := CheckBox1.Checked;
end;

end.
