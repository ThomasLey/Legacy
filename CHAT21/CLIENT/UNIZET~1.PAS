unit uniZettel;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, uniMain;

type
  TfrmZettel = class(TForm)
    Label1: TLabel;
    mmoText: TMemo;
    Button1: TButton;
    Button2: TButton;
    cmbUser: TComboBox;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frmZettel: TfrmZettel;

implementation

{$R *.DFM}

procedure TfrmZettel.Button2Click(Sender: TObject);
begin
     frmMain.show;
     frmZettel.close;
end;

procedure TfrmZettel.Button1Click(Sender: TObject);
begin
  If mmoText.Text = '' then
     messagebox(handle, 'Keine Nachricht eingegeben', 'Fehler', mb_ok + mb_applmodal)
  else begin
     frmMain.csoClient.Socket.SendText('%m%' + cmbUser.Text + '%' + mmoText.text + '%');
     frmMain.show;
     frmZettel.close;
  end;
end;

end.
