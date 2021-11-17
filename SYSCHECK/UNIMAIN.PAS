unit uniMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

type
  TForm1 = class(TForm)
    lblFrage: TLabel;
    lblKorrekt: TLabel;
    imgAchtung: TImage;
    btn1: TButton;
    btn2: TButton;
    Label1: TLabel;
    tmrShow: TTimer;
    tmrHide: TTimer;
    Label2: TLabel;
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure Gedruckt;
    procedure FormCreate(Sender: TObject);
    procedure tmrShowTimer(Sender: TObject);
    procedure tmrHideTimer(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;
  Minuten, Zeit: Word;

implementation

{$R *.DFM}

procedure TForm1.Gedruckt;
begin
     MessageBox(Form1.Handle, 'Microsoft Windows empfielt Ihnen, ' + #10 + #13 + 'auf Grund ihrer physischen Probleme, ' + #10 + #13 + 'einen Behindertenparkplatz zu beantragen.' + #10 + #13, 'Anwenderprobleme aufgetreten', MB_OK + MB_IconInformation + MB_SystemModal);
     Close
end;

procedure TForm1.btn1Click(Sender: TObject);
begin
     If btn1.caption = 'Ja' then Gedruckt
     else begin
          btn2.Caption := 'Nein';
          btn1.Caption := 'Ja'
     end
end;

procedure TForm1.btn2Click(Sender: TObject);
begin
     If btn2.caption = 'Ja' then Gedruckt
     else begin
          btn1.Caption := 'Nein';
          btn2.Caption := 'Ja'
     end
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
     ShowWindow(GetWindow(handle, GW_Owner), SW_Hide);
     Minuten := 10;
     Zeit := 0;
     tmrShow.Enabled := true
end;

procedure TForm1.tmrShowTimer(Sender: TObject);
begin
     inc(Zeit);
     If Zeit >= Minuten then begin
        label2.caption := inttostr(Minuten);
        tmrShow.Enabled := false;
        Form1.Show;
     end
end;

procedure TForm1.tmrHideTimer(Sender: TObject);
begin
     tmrHide.Enabled := False;
     Form1.Hide;
end;

end.
