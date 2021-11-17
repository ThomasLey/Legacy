unit uniMalen;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, Buttons, ExtCtrls, StdCtrls, Spin, ColorGrd;

type TMalen = class(TObject)
            x1, x2, y1, y2, Dicke: Integer;
            Farbe: TColor;
            Werkzeug: Char;
            Absender: ShortString;
     end;
type
  TfrmMalen = class(TForm)
    imgPapier: TImage;
    MainMenu1: TMainMenu;
    Fenster1: TMenuItem;
    Schliessen1: TMenuItem;
    spbRectangle: TSpeedButton;
    spbEllipse: TSpeedButton;
    speWidth: TSpinEdit;
    Label1: TLabel;
    cdbColor: TColorDialog;
    ShapeColor: TShape;
    Label2: TLabel;
    spbLine: TSpeedButton;
    N1: TMenuItem;
    Neu1: TMenuItem;
    spbPixel: TSpeedButton;
    tmrPuffer: TTimer;
    procedure Schliessen1Click(Sender: TObject);
    procedure imgPapierMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imgPapierMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GetPaint(text: ShortString);
    procedure Send(Text: ShortString);
    procedure imgPapierMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ShapeColorMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tmrPufferTimer(Sender: TObject);
    procedure Neu1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

procedure SendToPuffer(MyWerkzeug: Char);

var
  frmMalen: TfrmMalen;
  Startx, Starty, Currentx, Currenty: Integer;
  LMBGedruckt, MMBGedruckt, RMBGedruckt: Boolean;
  MPuffer: TList;
  Malen: TMalen;

implementation

uses uniMain;

{$R *.DFM}

procedure SendToPuffer(MyWerkzeug: Char);
// var text: String;
begin
        with Malen do begin
             x1 := Startx;
             y1 := Starty;
             x2 := Currentx;
             y2 := Currenty;
             Dicke := frmMalen.SpeWidth.Value;
             Farbe := frmMalen.ShapeColor.Brush.Color;
             Werkzeug := MyWerkzeug;
             Absender := frmMain.csoClient.Socket.LocalHost;
        end;
        MPuffer.Add(Malen);

{     Text := '%p%' + Malen.Werkzeug + '%' + IntToStr(Malen.x1) + '%' + IntToStr(Malen.y1) + '%' + IntToStr(Malen.x2) + '%' + IntToStr(Malen.y2) + '%' + IntToStr(Malen.Dicke) + '%';
     Text := Text + ColorToString(Malen.Farbe) + '%' + Malen.Absender + '%';
     frmMalen.Send(Text);
}end;

procedure TfrmMalen.Send(Text: ShortString);
begin
     frmMain.csoClient.Socket.SendText(Text);
end;

procedure TfrmMalen.GetPaint(Text: ShortString);
begin
     imgPapier.Canvas.Brush.Color := StringToColor(GetString('%', text, 7));
     imgPapier.Canvas.Pen.Color := imgPapier.Canvas.Brush.Color;
     imgPapier.Canvas.Pen.Width := GetInteger('%', Text, 6);
     imgPapier.Canvas.Brush.Style := bsClear;
     Case text[2] of
          'n': Begin
               imgPapier.Canvas.Brush.Color := clWhite;
               imgPapier.Canvas.Pen.Color := imgPapier.Canvas.Brush.Color;
               imgPapier.Canvas.Pen.Width := 1;
               imgPapier.Canvas.Brush.Style := bsSolid;
               frmMalen.imgPapier.Canvas.Rectangle(0, 0, imgPapier.Width, imgPapier.Height);
               end;
          'p': Begin
               frmMalen.imgPapier.Canvas.Pixels[GetInteger('%', Text, 2), GetInteger('%', Text, 3)] := imgPapier.Canvas.Brush.Color;
          end;
          'r': Begin
               frmMalen.imgPapier.Canvas.Rectangle(GetInteger('%', Text, 2), GetInteger('%', Text, 3), GetInteger('%', Text, 4), GetInteger('%', Text, 5));
          end;
          'e': Begin
               frmMalen.imgPapier.Canvas.Ellipse(GetInteger('%', Text, 2), GetInteger('%', Text, 3), GetInteger('%', Text, 4), GetInteger('%', Text, 5));
          end;
          'm': Begin
               frmMalen.imgPapier.Canvas.MoveTo(GetInteger('%', Text, 2), GetInteger('%', Text, 3));
               frmMalen.imgPapier.Canvas.LineTo(GetInteger('%', Text, 4), GetInteger('%', Text, 5));
          end;
     end; //Case
end;

procedure TfrmMalen.Schliessen1Click(Sender: TObject);
begin
     frmMalen.hide;
end;

procedure TfrmMalen.imgPapierMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
     Currentx := x; Currenty := y;
     If LMBGedruckt then begin
      frmMalen.Canvas.Pen.Width := speWidth.Value;
      If spbRectangle.Down then begin
         frmMalen.ImgPapier.Refresh;
         frmMalen.Canvas.Brush.Style := bsClear;
         frmMalen.Canvas.Rectangle(Startx + frmMalen.ImgPapier.Left, Starty + frmMalen.ImgPapier.Top, Currentx + frmMalen.ImgPapier.Left, Currenty + frmMalen.ImgPapier.Top);
      end;
      If spbEllipse.Down then begin
         frmMalen.ImgPapier.Refresh;
         frmMalen.Canvas.Brush.Style := bsClear;
         frmMalen.Canvas.Ellipse(Startx + frmMalen.ImgPapier.Left, Starty + frmMalen.ImgPapier.Top, Currentx + frmMalen.ImgPapier.Left, Currenty + frmMalen.ImgPapier.Top);
      end;
      if spbLine.Down then begin
         frmMalen.ImgPapier.Refresh;
         frmMalen.Canvas.Brush.Style := bsClear;
         frmMalen.Canvas.MoveTo(Startx + frmMalen.ImgPapier.Left, Starty + frmMalen.ImgPapier.Top);
         frmMalen.Canvas.LineTo(Currentx + frmMalen.ImgPapier.Left, Currenty + frmMalen.ImgPapier.Top);
      end;
     end;
end;

procedure TfrmMalen.imgPapierMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   Currentx := x; currenty := y;
   IF LMBGedruckt then begin
      If spbRectangle.Down then SendToPuffer('r');
      If spbEllipse.Down then SendToPuffer('e');
      if spbLine.Down then SendToPuffer('m');
   end;
   LMBGedruckt := false;
   MMBGedruckt := false;
   RMBGedruckt := false;
end;

procedure TfrmMalen.imgPapierMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   Startx :=  X; Starty := Y;
   If Button = mbLeft then LMBGedruckt := true;
   If Button = mbMiddle then MMBGedruckt := true;
   If Button = mbRight then RMBGedruckt := true;
end;

procedure TfrmMalen.FormCreate(Sender: TObject);
begin
   frmMalen.imgPapier.Canvas.Create;
   LMBGedruckt := false;
   MMBGedruckt := false;
   RMBGedruckt := false;
end;

procedure TfrmMalen.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     MPuffer.Free;
     Malen.Free;
end;

procedure TfrmMalen.ShapeColorMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     frmMalen.cdbColor.Execute;
     frmMalen.ShapeColor.Brush.Color := frmMalen.cdbColor.Color;
     frmMalen.Canvas.Brush.Color := frmMalen.cdbColor.Color;
     frmMalen.Canvas.Pen.Color := frmMalen.cdbColor.Color;
end;

procedure TfrmMalen.tmrPufferTimer(Sender: TObject);
var Text: ShortString;
begin
   If MPuffer.Count > 0 then begin
     Malen := MPuffer.Items[0];
     Text := '%p%' + Malen.Werkzeug + '%' + IntToStr(Malen.x1) + '%' + IntToStr(Malen.y1) + '%' + IntToStr(Malen.x2) + '%' + IntToStr(Malen.y2) + '%' + IntToStr(Malen.Dicke) + '%';
     Text := Text + ColorToString(Malen.Farbe) + '%' + Malen.Absender + '%';
     frmMalen.Send(Text);
     MPuffer.Delete(0);
   end else begin
       MPuffer.Clear;
   end;
end;

procedure TfrmMalen.Neu1Click(Sender: TObject);
begin
     SendToPuffer('n');
end;

begin
     MPuffer := TList.Create;
     Malen := TMalen.Create;
end.
