unit uniOptions;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Registry;

type
  TfrmOptions = class(TForm)
    Panel1: TPanel;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    ckbWieder: TCheckBox;
    ckbScrollen: TCheckBox;
    edtZeilen: TEdit;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frmOptions: TfrmOptions;
  Regist: TRegistry;
implementation

uses uniMain;

{$R *.DFM}

procedure TfrmOptions.btnOKClick(Sender: TObject);
var Zeilen: Integer;
begin
     Regist.WriteBool('Restart', ckbWieder.Checked);
     Regist.WriteBool('Scrollen', ckbScrollen.Checked);
     Zeilen := StrToInt(edtZeilen.text);
     If Zeilen = 0 then begin
        Zeilen := 25;
        edtZeilen.Text := IntToStr(Zeilen);
     end;
     Regist.WriteInteger('Zeilen', Zeilen);
     frmMain.MyUpdate;
     frmMain.show;
     frmOptions.close;
end;

procedure TfrmOptions.btnCancelClick(Sender: TObject);
begin
     frmMain.show;
     frmOptions.close;
end;

procedure TfrmOptions.FormShow(Sender: TObject);
begin
     Regist := TRegistry.Create;
     Regist.RootKey := HKey_Current_User;
     Regist.OpenKey('Software\Tommiware\Chat10', True);
     If Regist.GetDataSize('Restart') = -1 then
        Regist.WriteBool('Restart', false);
     ckbWieder.Checked := Regist.ReadBool('Restart');
     If Regist.GetDataSize('Scrollen') = -1 then
        Regist.WriteBool('Scrollen', false);
     ckbScrollen.Checked := Regist.ReadBool('Scrollen');
     If Regist.GetDataSize('Zeilen') = -1 then
        Regist.WriteInteger('Zeilen', 25);
     edtZeilen.Text :=IntToStr(Regist.ReadInteger('Zeilen'));
end;

end.
