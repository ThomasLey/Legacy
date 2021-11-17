unit Digit2000;

interface

uses
  SysUtils, Classes, Graphics, Controls, Windows;

type
  TDigit2000 = class(TGraphicControl)
  private
         vValue: LongInt;
         vDigits: Byte;
         vDisplayOn: Boolean;
         vBackColor: TColor;
         vFontColor: TColor;
         vFontWidth: Byte;
         a, b, c, d, e, f: TPoint; //Eckpunkte der Balken         
         procedure SetValue(Value: LongInt);
         procedure SetDigits(Value: Byte);
         procedure SetDisplay(Value: Boolean);
         procedure SetBackColor(Value: TColor);
         procedure SetFontColor(Value: TColor);
         procedure SetFontWidth(Value: Byte);
    { Private-Deklarationen }
  protected
           procedure SetCoords(fPos: Byte);
           procedure OneDigit(Value: Byte);
           procedure Clear;
           procedure Paint; override;
    { Protected-Deklarationen }
  public
          constructor Create(AOwner: TComponent); override;
          destructor Destroy; override;
    { Public-Deklarationen }
  published
           property Value: Integer Read vValue Write SetValue;
           property Digits: Byte Read vDigits Write SetDigits;
           property DisplayOn: Boolean Read vDisplayOn Write SetDisplay;
           property BackColor: TColor Read vBackColor Write SetBackColor;
           property FontColor: TColor Read vFontColor Write SetFontColor;
           property FontWidth: Byte Read vFontWidth Write SetFontWidth;
    { Published-Deklarationen }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Ley', [TDigit2000]);
end;

constructor TDigit2000.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);
     Height := 25;
     Width := 75;
     vFontColor := clGreen;
     vBackColor := clBlack;
     vValue := 0;
     vDigits := 3;
     vDisplayOn := true;
     vFontWidth := 3;
end;

destructor TDigit2000.Destroy;
begin
     inherited Destroy;
end;

procedure TDigit2000.SetCoords(fPos: Byte);
begin
     a.x := Round((Self.Width / vDigits) * (fPos - 1) + (Self.Width / vDigits) * (1/5) + (vFontWidth / 2));
     c.x := a.x; e.x := a.x;
     b.x := Round((Self.Width / vDigits) * (fPos) - (Self.Width / vDigits) * (1/7) - (vFontWidth / 2));
     d.x := b.x; f.x := b.x;
     a.y := Round((Self.Height / 20) + (vFontWidth / 2));
     b.y := a.y;
     c.y := Round((Self.Height / 2));
     d.y := c.y;
     e.y := Round((-Self.Height / 20) + (Self.Height) - (vFontWidth / 2));
     f.y := e.y;
end;

procedure TDigit2000.Clear;
begin
     Self.Canvas.Brush.Color := vBackColor;
     Self.Canvas.Pen.Color := vBackColor;
     Self.Canvas.Brush.Style := bsSolid;
     Self.Canvas.Rectangle(0, 0, Width, Height);
end;

procedure TDigit2000.SetValue(Value: LongInt);
begin
        vValue := Value;
        Paint;
end;

procedure TDigit2000.SetDigits(Value: Byte);
begin
        vDigits := Value;
        If vDigits < 1 then vDigits := 1;
        If vDigits > 100 then vDigits := 100;
        Paint;
end;

procedure TDigit2000.SetDisplay(Value: Boolean);
begin
     vDisplayOn := Value;
     Self.Paint;
end;

procedure TDigit2000.Paint;
var
   vDisplay: String[100];
   i       : Byte;
begin
     Self.Clear;
     If vDisplayOn then begin
        Self.Canvas.Pen.Color := vFontColor;
        Self.Canvas.Pen.Width := vFontWidth;
        vDisplay := Format('%100d', [abs(vValue)]);
        For i := vDigits downto 1 do begin
           SetCoords(i);
           If vDisplay[100 + i - vDigits] in ['0'..'9'] then OneDigit(StrToInt(vDisplay[100 + i - vDigits]));
        end;
     end;
end;

procedure TDigit2000.SetBackColor(Value: TColor);
begin
        vBackColor := Value;
        Self.Paint;
end;

procedure TDigit2000.SetFontColor(Value: TColor);
begin
        vFontColor := Value;
        Self.Paint;
end;

procedure TDigit2000.OneDigit(Value: Byte);
begin
     If Value = 0 then begin
        Self.Canvas.MoveTo(a.x, a.y);
        Self.Canvas.LineTo(b.x, b.y);
        Self.Canvas.LineTo(d.x, d.y);
        Self.Canvas.LineTo(f.x, f.y);
        Self.Canvas.LineTo(e.x, e.y);
        Self.Canvas.LineTo(c.x, c.y);
        Self.Canvas.LineTo(a.x, a.y);
     end;
     If Value = 1 then begin
        Self.Canvas.MoveTo(b.x, b.y);
        Self.Canvas.LineTo(d.x, d.y);
        Self.Canvas.LineTo(f.x, f.y);
     end;
     If Value = 2 then begin
        Self.Canvas.MoveTo(a.x, a.y);
        Self.Canvas.LineTo(b.x, b.y);
        Self.Canvas.LineTo(d.x, d.y);
        Self.Canvas.LineTo(c.x, c.y);
        Self.Canvas.LineTo(e.x, e.y);
        Self.Canvas.LineTo(f.x, f.y);
     end;
     If Value = 3 then begin
        Self.Canvas.MoveTo(a.x, a.y);
        Self.Canvas.LineTo(b.x, b.y);
        Self.Canvas.LineTo(d.x, d.y);
        Self.Canvas.LineTo(c.x, c.y);
        Self.Canvas.MoveTo(d.x, d.y);
        Self.Canvas.LineTo(f.x, f.y);
        Self.Canvas.LineTo(e.x, e.y);
     end;
     If Value = 4 then begin
        Self.Canvas.MoveTo(a.x, a.y);
        Self.Canvas.LineTo(c.x, c.y);
        Self.Canvas.LineTo(d.x, d.y);
        Self.Canvas.LineTo(b.x, b.y);
        Self.Canvas.MoveTo(d.x, d.y);
        Self.Canvas.LineTo(f.x, f.y);
     end;
     If Value = 5 then begin
        Self.Canvas.MoveTo(b.x, b.y);
        Self.Canvas.LineTo(a.x, a.y);
        Self.Canvas.LineTo(c.x, c.y);
        Self.Canvas.LineTo(d.x, d.y);
        Self.Canvas.LineTo(f.x, f.y);
        Self.Canvas.LineTo(e.x, e.y);
     end;
     If Value = 6 then begin
        Self.Canvas.MoveTo(b.x, b.y);
        Self.Canvas.LineTo(a.x, a.y);
        Self.Canvas.LineTo(c.x, c.y);
        Self.Canvas.LineTo(d.x, d.y);
        Self.Canvas.LineTo(f.x, f.y);
        Self.Canvas.LineTo(e.x, e.y);
        Self.Canvas.LineTo(c.x, c.y);
     end;
     If Value = 7 then begin
        Self.Canvas.MoveTo(a.x, a.y);
        Self.Canvas.LineTo(b.x, b.y);
        Self.Canvas.LineTo(d.x, d.y);
        Self.Canvas.LineTo(f.x, f.y);
     end;
     If Value = 8 then begin
        Self.Canvas.MoveTo(a.x, a.y);
        Self.Canvas.LineTo(b.x, b.y);
        Self.Canvas.LineTo(d.x, d.y);
        Self.Canvas.LineTo(f.x, f.y);
        Self.Canvas.LineTo(e.x, e.y);
        Self.Canvas.LineTo(c.x, c.y);
        Self.Canvas.LineTo(a.x, a.y);
        Self.Canvas.MoveTo(c.x, c.y);
        Self.Canvas.LineTo(d.x, d.y);
     end;
     If Value = 9 then begin
        Self.Canvas.MoveTo(d.x, d.y);
        Self.Canvas.LineTo(c.x, c.y);
        Self.Canvas.LineTo(a.x, a.y);
        Self.Canvas.LineTo(b.x, b.y);
        Self.Canvas.LineTo(d.x, d.y);
        Self.Canvas.LineTo(f.x, f.y);
        Self.Canvas.MoveTo(e.x, e.y);
     end;
end;

procedure TDigit2000.SetFontWidth(Value: Byte);
begin
     If Value = 0 then Value := 1;
     vFontWidth := Value;
     Self.Paint;
end;

end.
