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
     Regist.WriteBool('cRestart', ckbWieder.Checked);
     Regist.WriteBool('cScrollen', ckbScrollen.Checked);
     Zeilen := StrToInt(edtZeilen.text);
     If Zeilen = 0 then Zeilen := 25;
     Regist.WriteInteger('cZeilen', Zeilen);
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
     If Regist.GetDataSize('cRestart') = -1 then
        Regist.WriteBool('cRestart', false);
     ckbWieder.Checked := Regist.ReadBool('cRestart');
     If Regist.GetDataSize('cScrollen') = -1 then
        Regist.WriteBool('cScrollen', false);
     ckbScrollen.Checked := Regist.ReadBool('cScrollen');
     If Regist.GetDataSize('cZeilen') = -1 then
        Regist.WriteInteger('cZeilen', 25);
     edtZeilen.Text := IntToStr(Regist.ReadInteger('cZeilen'));
end;

end.
