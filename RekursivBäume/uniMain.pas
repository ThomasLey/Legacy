unit uniMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, Printers;

type
  TfrmMain = class(TForm)
    MenuMain: TMainMenu;
    Datei1: TMenuItem;
    N1: TMenuItem;
    Beenden1: TMenuItem;
    Hilfe1: TMenuItem;
    Info1: TMenuItem;
    Start1: TMenuItem;
    Einstellungen1: TMenuItem;
    Drucken1: TMenuItem;
    procedure Info1Click(Sender: TObject);
    procedure Beenden1Click(Sender: TObject);
    procedure Einstellungen1Click(Sender: TObject);
    procedure Start1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Drucken1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frmMain: TfrmMain;
  Streckungsfaktor, WinkelLinks, WinkelRechts: Extended;
  Stufe: Byte;
implementation

uses uniAbout, uniEinstellungen;

{$R *.DFM}

procedure Zeichne(Stufe, x, y, laenge: Integer; Winkel: Extended);
begin
     inc(Stufe);
// Setzen des Stiftes
     frmMain.Canvas.MoveTo(x, y);
     If frmMain.Drucken1.Checked then Printer.Canvas.MoveTo(x * frmEinstellungen.se8.Value, (-y * frmEinstellungen.se8.Value) - 700);
// Ändern von x und y nach trigonom. Funktionen
     x := x + round(cos(Winkel) * laenge);
     y := y + round(sin(Winkel) * laenge);
// Zeichenen der Linien
     frmMain.Canvas.LineTo(x, y);
// y * -1 = Koordinatensystem, da y nach oben ausgedruckt
// y - 100 = Für Bemerkungen !!
     If frmMain.Drucken1.Checked then Printer.Canvas.LineTo(x * frmEinstellungen.se8.Value, (-y * frmEinstellungen.se8.Value) - 700);
// Anzeigen der Änderung
//     frmMain.Refresh;
// evtl. neue Verzweigungen
     If Stufe <= (frmEinstellungen.se7.Value) then begin
        Zeichne(Stufe, x, y, round(laenge * (frmEinstellungen.se4.Value * 0.01)), Winkel + (frmEinstellungen.se5.Value / 100));
        Zeichne(Stufe, x, y, round(laenge * (frmEinstellungen.se4.Value * 0.01)), Winkel - (frmEinstellungen.se6.Value / 100));
     end;
end;

procedure TfrmMain.Info1Click(Sender: TObject);
begin
     AboutBox.ShowModal;
end;

procedure TfrmMain.Beenden1Click(Sender: TObject);
begin
     frmMain.Close;
end;

procedure TfrmMain.Einstellungen1Click(Sender: TObject);
begin
     frmEinstellungen.ShowModal;
end;

procedure TfrmMain.Start1Click(Sender: TObject);
begin
     frmMain.Refresh;
     frmMain.Canvas.Pen.Color := clBlack;
     frmMain.Canvas.Brush.Color := clBlack;
     Stufe := 1;
     If frmMain.Drucken1.Checked then begin
        Printer.BeginDoc;
        SetMapMode(printer.canvas.handle, MM_LOMETRIC);
        Printer.Canvas.Font.Height := 50;
        Printer.Canvas.Font.Name := 'Arial';
        Printer.Canvas.TextOut(0,   -0, 'Autor: Thomas Ley');
        Printer.Canvas.TextOut(0,  -60, 'Datum: September 99');
        Printer.Canvas.TextOut(0, -120, 'Länge: ' + IntToStr(frmEinstellungen.se3.Value));
        Printer.Canvas.TextOut(0, -180, 'Streckungsfaktor: ' + IntToStr(frmEinstellungen.se4.Value));
        Printer.Canvas.TextOut(0, -240, 'Winkelabweichung links: ' + IntToStr(frmEinstellungen.se4.Value));
        Printer.Canvas.TextOut(0, -300, 'Winkelabweichung rechts: ' + IntToStr(frmEinstellungen.se6.Value));
        Printer.Canvas.TextOut(0, -360, 'Winkelabweichung ist im Bogenmaß und mit 100 multipliziert!');
        Printer.Canvas.TextOut(0, -420, 'Vertiefungsstufe: ' + IntToStr(frmEinstellungen.se7.Value));
     end;
// Eigentliches Zeichenen des Baumes
     Zeichne(Stufe, frmEinstellungen.se1.Value, frmEinstellungen.se2.Value, frmEinstellungen.se3.Value, 3.1415926 * 0.5);

     If frmMain.Drucken1.Checked then begin
        Printer.EndDoc;
     end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
     frmMain.Refresh;
end;

procedure TfrmMain.Drucken1Click(Sender: TObject);
begin
     Drucken1.Checked := not Drucken1.Checked;
end;

end.
