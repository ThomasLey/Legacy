unit uLIRCSocket;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ScktComp, OleCtrls, MSWinsockLib_TLB, ShellAPI, ExtCtrls,
  ComCtrls;

type
  TLIRCSocketForm = class(TForm)
    LastInput: TEdit;
    bConnect: TButton;
    bDisconnect: TButton;
    Winsock1: TWinsock;
    History: TListBox;
    bClearHistory: TButton;
    StatusBar: TStatusBar;
    tStart: TTimer;
    procedure bConnectClick(Sender: TObject);
    procedure Winsock1DataArrival(Sender: TObject; bytesTotal: Integer);
    procedure Winsock1Error(Sender: TObject; Number: Smallint;
      var Description: WideString; Scode: Integer; const Source,
      HelpFile: WideString; HelpContext: Integer;
      var CancelDisplay: WordBool);
    procedure bDisconnectClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure tStartTimer(Sender: TObject);
    procedure bClearHistoryClick(Sender: TObject);
  private
    Counter: String;
    { Private-Deklarationen }
  public
    NewSignal: Boolean;
    { Public-Deklarationen }
  end;

var
  LIRCSocketForm: TLIRCSocketForm;

implementation

uses uUtils;

{$R *.DFM}

procedure TLIRCSocketForm.bConnectClick(Sender: TObject);
var
   strLocalIP: String;
begin
    strLocalIP := Winsock1.LocalIP;
    Winsock1.Protocol := sckTCPProtocol;
    Winsock1.RemoteHost := strLocalIP;
    Winsock1.RemotePort := 8765;
    Winsock1.Connect;
    LIRCSocketForm.Caption := 'Verbindung wurde hergestellt!';
    StatusBar.SimpleText := 'mit ' + strLocalIP + ':' + IntToStr(Winsock1.RemotePort) + ' Verbindung hergestellt';
    bConnect.enabled := false;
    bDisconnect.enabled := true;
    Counter := '  ';
end;

procedure TLIRCSocketForm.Winsock1DataArrival(Sender: TObject; bytesTotal: Integer);
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
       LastInput.Text := Taste;       //  Messagestring from WinLirc
       History.Items.Insert(0, id + '  ' + taste + '  ' + fb);
    end else begin
                               // Signal wird ignoriert
    end;
    Counter := Id;
end;

procedure TLIRCSocketForm.Winsock1Error(Sender: TObject; Number: Smallint;
  var Description: WideString; Scode: Integer; const Source,
  HelpFile: WideString; HelpContext: Integer; var CancelDisplay: WordBool);
begin
      StatusBar.SimpleText := 'Fehler: ' + Description;
      try
         WinSock1.Close;
      finally
         bConnect.Enabled := true;
         bDisconnect.Enabled := false;
      end;
end;

procedure TLIRCSocketForm.bDisconnectClick(Sender: TObject);
begin
     WinSock1.close;
     bConnect.Enabled := true;
     bDisconnect.Enabled := false;
end;

procedure TLIRCSocketForm.FormResize(Sender: TObject);
var
   Mitte: Integer;
begin
     If LIRCSocketForm.WindowState = wsMinimized then abort;
     If LIRCSocketForm.Width < 200 then begin
        LIRCSocketForm.Width := 200;
//        Mouse.CursorPos.y := 200;
//        abort;
     end;

     If Height < 200 then begin
        LIRCSocketForm.Height := 200;
//        Mouse.CursorPos.x := 200;
//        abort;
     end;
// Breite der Komponenten
     Mitte := LIRCSocketForm.Width div 2; //Exakte Mitte
     LastInput.Width := LIRCSocketForm.Width - 20;
     LastInput.Left := (Mitte - 5) - LastInput.Width div 2;
     History.Width := LIRCSocketForm.Width - 20;
     History.Left := (Mitte - 5) - History.Width div 2;
//Höhe der Komponenten
     History.Height := LIRCSocketForm.Height - History.Top - 50;

// Erste Reihe mit Buttons
     Mitte := LIRCSocketForm.Width div 3; //Mitte der Buttons
     bConnect.left := Mitte * 1 - bConnect.Width div 2;
     bDisconnect.left := Mitte * 2 - bDisconnect.Width div 2;
// Zweite Reihe mit Buttons
     Mitte := LIRCSocketForm.Width div 2; //Mitte der Buttons
     bClearHistory.left := Mitte * 1 - bConnect.Width div 2;

end;

procedure TLIRCSocketForm.tStartTimer(Sender: TObject);
begin
     tStart.Enabled := false;

     LIRCSocketForm.Resize;
     NewSignal := False;
end;

procedure TLIRCSocketForm.bClearHistoryClick(Sender: TObject);
begin
     History.Clear();
end;

end.
