unit uniVerbinden;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Registry;

type
  TfrmConnection = class(TForm)
    Panel1: TPanel;
    lblPort: TLabel;
    lblIPADDRESS: TLabel;
    edtAdresse: TEdit;
    edtPort: TEdit;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frmConnection: TfrmConnection;
  Regist: TRegistry;

implementation

uses uniMain;

{$R *.DFM}

procedure TfrmConnection.btnOKClick(Sender: TObject);
begin
        frmMain.csoClient.Port := StrToInt(edtPort.Text);
        frmMain.csoClient.Address := edtAdresse.Text;
        frmMain.csoClient.Active := true;
        frmMain.Erstellen1.Enabled := false;
        frmMain.Trennen1.Enabled := true;
        frmMain.stbMain.Panels.Items[0].Text := 'Verbunden mit ' + frmMain.csoClient.Address + ' auf Port ' + IntToStr(frmMain.csoClient.Port);
        frmMain.show;
        frmConnection.Close;;
end;

procedure TfrmConnection.btnCancelClick(Sender: TObject);
begin
     frmMain.show;
     frmConnection.close;
end;

procedure TfrmConnection.FormCreate(Sender: TObject);
begin
// Auslesen von Port und Service aus Registerdatenbank
     Regist := TRegistry.Create;
     Regist.RootKey := HKey_Current_User;
     Regist.OpenKey('Software\Tommiware\Chat10', true);

     frmConnection.edtPort.Text := Regist.ReadString('csoPort');
     IF frmConnection.edtPort.Text = '' Then Begin
        Regist.WriteString('csoPort', '7350');
        frmConnection.edtPort.Text := Regist.ReadString('csoPort');
     End;
     frmConnection.edtAdresse.Text := Regist.ReadString('csoAdresse');
     IF frmConnection.edtAdresse.Text = '' Then Begin
        Regist.WriteString('csoAdresse', '127.0.0.1');
        frmConnection.edtAdresse.Text := Regist.ReadString('csoAdresse');
     End;
end;

end.
