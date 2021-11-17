unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ScktComp, OleCtrls, MSWinsockLib_TLB, ShellAPI, ExtCtrls,
  ComCtrls;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    Winsock1: TWinsock;
    History: TListBox;
    Button11: TButton;
    StatusBar1: TStatusBar;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure Winsock1DataArrival(Sender: TObject; bytesTotal: Integer);
    procedure Winsock1Error(Sender: TObject; Number: Smallint;
      var Description: WideString; Scode: Integer; const Source,
      HelpFile: WideString; HelpContext: Integer;
      var CancelDisplay: WordBool);
    procedure Button2Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    Counter: String;
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

uses uUtils;

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
var
   strLocalIP: String;
begin
    strLocalIP := Winsock1.LocalIP;
    Winsock1.Protocol := sckTCPProtocol;
    Winsock1.RemoteHost := strLocalIP;
    Winsock1.RemotePort := 8765;
    Winsock1.Connect;
    Form1.Caption := 'Verbindung wurde hergestellt!';
    Button1.enabled := false;
    Button2.enabled := true;
    Counter := '  ';
end;

procedure TForm1.Winsock1DataArrival(Sender: TObject; bytesTotal: Integer);
var
    XstrData: OleVariant;
    tString, Taste, ID, FB: String;
begin
    WinSock1.GetData(XstrData, 8);
    tString := XstrData;
    Delete(tString, Length(tString), 1);
{   XstrData sieht wie folgt aus:
      0000000000000002 11 2 m_0042
                       I  N  Fern
                       D  A  bedie
                          M  nung
                          E             }
// ID fängt immer unten an und wird inkrementiert
    ID    := GetString(' ', tString, 2);
    Taste := GetString(' ', tString, 3);
    FB    := GetString(' ', tString, 4);

    If (Counter <= Id) then begin  // Neues Drücken der Fernbedienung
       Edit1.Text := Taste;    //Messagestring from WinLirc
       History.Items.Insert(0, id + '  ' + taste + '  ' + fb);
    end else begin
       History.Items.Insert(0, '*' + id + '  ' + taste + '  ' + fb);
    end;
    Counter := Id;
end;

procedure TForm1.Winsock1Error(Sender: TObject; Number: Smallint;
  var Description: WideString; Scode: Integer; const Source,
  HelpFile: WideString; HelpContext: Integer; var CancelDisplay: WordBool);
begin
      Form1.Caption := 'Fehler ist aufgetreten: ' + Description;
      try
         WinSock1.Close;
      finally
         Button1.Enabled := true;
         Button2.Enabled := false;
      end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
     WinSock1.close;
     Button1.Enabled := true;
     button2.Enabled := false;
end;

procedure TForm1.FormResize(Sender: TObject);
var
   Mitte: Integer;
begin
     If Form1.WindowState = wsMinimized then abort;
     If Form1.Width < 200 then begin
        Form1.Width := 200;
//        Mouse.CursorPos.y := 200;
//        abort;
     end;

     If Height < 200 then begin
        Form1.Height := 200;
//        Mouse.CursorPos.x := 200;
//        abort;
     end;
// Breite der Komponenten
     Mitte := Form1.Width div 2; //Exakte Mitte
     Edit1.Width := Form1.Width - 20;
     Edit1.Left := (Mitte - 5) - Edit1.Width div 2;
     History.Width := Form1.Width - 20;
     History.Left := (Mitte - 5) - History.Width div 2;
//Höhe der Komponenten
     History.Height := Form1.Height - History.Top - 50;

// Erste Reihe mit Buttons
     Mitte := Form1.Width div 3; //Mitte der Buttons
     Button1.left := Mitte * 1 - Button1.Width div 2;
     Button2.left := Mitte * 2 - Button2.Width div 2;
// Zweite Reihe mit Buttons
     Mitte := Form1.Width div 2; //Mitte der Buttons
     Button11.left := Mitte * 1 - Button1.Width div 2;

end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
     Timer1.Enabled := false;
     Form1.Resize;
end;

end.
