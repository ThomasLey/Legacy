unit uniAddEntry;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, Buttons, DB, ExtCtrls;

type
  TfrmAddEntry = class(TForm)
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    CheckBox3: TCheckBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    BitBtn4: TBitBtn;
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frmAddEntry: TfrmAddEntry;

implementation

uses uniMain, uniSearchLEO;

{$R *.DFM}

procedure TfrmAddEntry.BitBtn2Click(Sender: TObject);
begin
     close();
end;

procedure TfrmAddEntry.BitBtn1Click(Sender: TObject);
begin
     BitBtn3Click(Sender);
     close();
end;

procedure TfrmAddEntry.FormShow(Sender: TObject);
begin
     Edit1.Text := '';
     Edit2.Text := '';
     Edit3.Text := '';
     Edit4.Text := '';
     Edit1.SetFocus();
end;

procedure TfrmAddEntry.BitBtn3Click(Sender: TObject);
begin
     if frmMain.ADOTable.Active = false then begin
        messageBox(0, 'Es ist keine Datenquelle geöffnet', 'Fehler', 0);
        abort;
     end;
     frmMain.ADOTable.Append();
     frmMain.ADOTable.Edit;
     if Edit1.Text <> '' then
        frmMain.ADOTable.Fields.FieldByName('sprache11').AsString := Edit1.Text;
     if Edit2.Text <> '' then
        frmMain.ADOTable.Fields.FieldByName('sprache12').AsString := Edit2.Text;
     if Edit3.Text <> '' then
        frmMain.ADOTable.Fields.FieldByName('sprache21').AsString := Edit3.Text;
     if Edit4.Text <> '' then
        frmMain.ADOTable.Fields.FieldByName('sprache22').AsString := Edit4.Text;
     frmMain.ADOTable.Post;
     FormShow(Sender);
end;

procedure TfrmAddEntry.TimerTimer(Sender: TObject);
begin
     frmAddEntry.BringToFront();
end;

procedure TfrmAddEntry.FormCreate(Sender: TObject);
begin
     with frmAddEntry do begin
          Top  := Screen.height - 30 - Height;
          left := Screen.width - Width;
     end;
end;

procedure TfrmAddEntry.BitBtn4Click(Sender: TObject);
begin
     frmSearch.Show();
end;

end.
