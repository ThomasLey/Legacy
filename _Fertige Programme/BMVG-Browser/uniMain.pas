unit uniMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, StdCtrls, OleCtrls, SHDocVw, ComCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Panel2: TPanel;
    StatusBar1: TStatusBar;
    WebBrowser: TWebBrowser;
    Panel1: TPanel;
    edtURL: TEdit;
    Label1: TLabel;
    mMenu: TMainMenu;
    Datei1: TMenuItem;
    Beenden1: TMenuItem;
    btnGo: TButton;
    procedure Beenden1Click(Sender: TObject);
    procedure btnGoClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Beenden1Click(Sender: TObject);
begin
     Close();
end;

procedure TForm1.btnGoClick(Sender: TObject);
begin
     WebBrowser.Navigate(edtURL.text);
end;

end.
