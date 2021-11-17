unit Unit3;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;


implementation
{$R *.DFM}

procedure fensterAnzeigen;stdcall;external 'FormDLL.dll';
function berechne1(x,y : single):single;stdcall;external 'FormDLL.dll';
procedure berechne2(x,y: single;var z : single);stdcall;external 'FormDLL.dll';


procedure TForm1.Button1Click(Sender: TObject);
begin
   fensterAnzeigen
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
     Label1.Caption := Format('%f',[berechne1(11.11,22.22)]);
end;

procedure TForm1.Button3Click(Sender: TObject);
var z:single;
begin
     berechne2(11.11,22.22,z);
     Label2.Caption := Format('%f',[z]);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
 Close
end;

end.
