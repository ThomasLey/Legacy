unit uniSearchLEO;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ShellAPI, Registry, ExtCtrls;

type
  TfrmSearch = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    Panel1: TPanel;
    Label1: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    Button2: TButton;
    procedure FormShow(Sender: TObject);
    procedure doSearch(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure frmClose(Sender: TObject);
  private
    flagEintragen  : Byte;
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frmSearch: TfrmSearch;

implementation

uses uniMain, uniAddEntry;

{$R *.DFM}

procedure TfrmSearch.FormShow(Sender: TObject);
begin
     Edit1.SetFocus();
end;

procedure TfrmSearch.doSearch(Sender: TObject);
var
   link: String;
begin
     link := 'http://dict.leo.org/?search=';
     link := link + Edit1.Text + '&searchLoc=0&relink=on&deStem=standard&lang=de';
     Edit1.SetFocus();
     Edit1.SelectAll();
     case flagEintragen of
          0: frmAddEntry.Edit1.Text := Edit1.Text;
          1: frmAddEntry.Edit3.Text := Edit1.Text;
     end;
     ShellExecute(frmMain.handle, 'open', PChar(link), '', '', SW_SHOWNOACTIVATE);
end;

procedure TfrmSearch.FormCreate(Sender: TObject);
begin
     with frmSearch do begin
          Top  := Screen.height - 30 - Height;
          left := Screen.width div 2 - Width div 2;
     end;
     flagEintragen := 2;
end;

procedure TfrmSearch.RadioButton3Click(Sender: TObject);
begin
     flagEintragen := TRadioButton(Sender).Tag;
end;

procedure TfrmSearch.frmClose(Sender: TObject);
begin
     Close();
end;

end.
