{-------------------------------------------------------------------
*    TGProgress v1.01 -Gradient Progress Bar                       *
*                                                                  *
*    Igor Popik                                                    *
*    e-mail: igorp@polbox.com                                      *
*    First release: 09.10.1998                                     *
*    This release: 2.11.1998                                       *
*    Quite nice, easy to configure for custom colors,              *
*    visible component developed under Delphi 3. I think it        *
*    looks much better than original Progress Bar.                 *
--------------------------------------------------------------------
*  Any bug reports or suggestions are welcome.                     *
--------------------------------------------------------------------
*  This component is a FREEWARE. You may modify it or do whatever  *
*  You want, but please send me a copy via e-mail. Thank You :-)   *
*  Maybe the source is not a masterpiece but I'm not a professional*
*  programmer...;-)Nothing is guarenteed.                          *
-------------------------------------------------------------------}

unit GProgress;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls;

type
  TGProgress = class(TGraphicControl)
  private
    FColor2: TColor;
    FStep: integer;
    FMax: integer;
    FMin: integer;
    FPos: integer;
    FBackgrnd: TColor;
    FFrame1: TColor;
    FFrame2: TColor;
    FromSub: boolean;
    FGradient: boolean;
    FSolid:boolean;
    FTransparent: boolean;
    LastPos: integer;
    { Private declarations }
  protected
    function GiveColor(count: integer): TColor;
    procedure DrawOne(count: integer);
    procedure Paint; override;
    procedure RePaint; override;
    procedure ShowError;
    { Protected declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure ChangeColor2(C: TColor);
    procedure ChangeSolid(B:boolean);
    procedure ChangeStep(i: integer);
    procedure ChangePosition(P: integer);
    procedure ChangeFrame1Color(C: TColor);
    procedure ChangeFrame2Color(C: TColor);
    procedure ChangeBackgrndColor(C: TColor);
    procedure ChangeMax(i: integer);
    procedure ChangeMin(i: integer);
    procedure ChangeTransparent(b: boolean);
    procedure ChangeGradientBar(b: boolean);
    //procedure ChangeSpacing(i:integer);
    procedure StepIt;
    { Public declarations }
  published
    { Published declarations }
    property Transparent: boolean read FTransparent write ChangeTransparent default false;
    property GradientBar: boolean read FGradient write ChangeGradientBar default false;
    property FrameColor1: TColor read FFrame1 write ChangeFrame1Color default clBtnShadow;
    property FrameColor2: TColor read FFrame2 write ChangeFrame2Color default clBtnHighlight;
    property BackgroundColor: TColor read FBackgrnd write ChangeBackgrndColor default clBtnFace;
    property Step: integer read FStep write ChangeStep default 10;
    property Min: integer read FMin write ChangeMin default 0;
    property Max: integer read FMax write ChangeMax default 100;
    property Position: integer read FPos write ChangePosition default 0;
    property ColorEnd: TColor read FColor2 write ChangeColor2 default clBtnFace;
    property Solid: boolean read FSolid write ChangeSolid default false;
    {inherited properties }
    property Color;
    property Align;
    property Enabled;
    property DragMode;
    property DragCursor;
    property Width;
    property Height;
    property Visible;
    property ShowHint;
    property ParentShowHint;

    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

procedure Register;

implementation

constructor TGProgress.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Height := 16;
  Width := 150;
  FMin := 0;
  Fmax := 100;
  FPos := 0;
  FStep := 10;
  Position := 0;
  LastPos := 0;
  ColorEnd := clBtnFace;
  Color := clHighlight;
  FrameColor1 := clBtnShadow;
  FrameColor2 := clBtnHighlight;
  FBackgrnd := clBtnFace;
  FromSub := false;
  FTransparent := false;
  FGradient := true;
  FSolid:=false;

end;
destructor  TGProgress.destroy;
begin
 inherited destroy;
end;


function TGProgress.GiveColor(count:integer): TColor;
// gradient calculating routine taken from RX Library
var
  BeginColor, EndColor: TColor;
  Colors: integer;
  BeginRGBValue: array[0..2] of Byte; { Begin RGB values }
  RGBDifference: array[0..2] of Integer; { Difference between begin and end RGB values }
  I: Integer;
  R, G, B: Byte; { Color band Red, Green, Blue values }
begin
 if count = width div 10 then
  begin
    Result := ColorEnd; // protects last block of progress bar from being draw in wrong color
    Exit;
  end;
  BeginColor := ColorToRGB(Color);
  EndColor := ColorToRGB(ColorEnd);
  { Set the Red, Green and Blue colors }
  R := BeginRGBValue[0];
  G := BeginRGBValue[1];
  B := BeginRGBValue[2];
  BeginRGBValue[0] := GetRValue(BeginColor);
  BeginRGBValue[1] := GetGValue(BeginColor);
  BeginRGBValue[2] := GetBValue(BeginColor);
  { Calculate the difference between begin and end RGB values }
  RGBDifference[0] := GetRValue(EndColor) - BeginRGBValue[0];
  RGBDifference[1] := GetGValue(EndColor) - BeginRGBValue[1];
  RGBDifference[2] := GetBValue(EndColor) - BeginRGBValue[2];
  Colors := width div 10;
  for I := 0 to Count do
  begin
  { Calculate the color band's color }
      R := BeginRGBValue[0] + MulDiv(I, RGBDifference[0], Colors - 1);
      G := BeginRGBValue[1] + MulDiv(I, RGBDifference[1], Colors - 1);
      B := BeginRGBValue[2] + MulDiv(I, RGBDifference[2], Colors - 1);
  end;
  Result := RGB(R, G, B);
end;


procedure TGProgress.DrawOne(count:integer);
var
  posx, space,sizadd: integer;
  Col: longint;
  begin
  if Position = FMin then Exit;
  Col := GiveColor(count);
  if not GradientBar then Canvas.Brush.Color := Color else Canvas.Brush.Color := Col;
  if solid then
  begin space:=0; sizadd:=10 end else begin space:=2;sizadd:=8;end;
  posx := count * 10 + space;
  if count = 0 then posx := 2;
  Canvas.fillrect(rect(posx, 2, posx + sizadd, height - 2)); //add one box
  Canvas.Pen.Color := FrameColor2; //refresh right side of frame
  Canvas.PolyLine([Point(Width - 1, 1), Point(Width - 1, Height - 1)]);
end;

procedure TGProgress.Paint;
var
  countof, i: integer;
  begin
      // Filling component area
  if not Transparent then
  begin
    Canvas.Brush.Color := FBackgrnd;
    Canvas.Brush.style := bsSolid;
    Canvas.Fillrect(rect(1, 1, Width - 1, Height - 1));
  end; // Drawing  bar position

  countof := (((Position - FMin) * Width - 4) div (FMax - FMin)) div 10;
  for i := 0 to countof do DrawOne(i);
      // Drawing Frame
  Canvas.Pen.Color := FFrame1;
  Canvas.PolyLine([Point(0, Height), Point(0, 0), Point(Width, 0)]);
  Canvas.Pen.Color := FFrame2;
  Canvas.PolyLine([Point(Width - 1, 1), Point(Width - 1, Height - 1), Point(0, Height - 1)]);
  FromSub := false;
end;

procedure TGProgress.RePaint;
var
  countof, i: integer;
begin
  if not visible then Exit;
  if FromSub then // it draws without flicker :-)
  begin
    countof := (((Position - FMin) * Width - 4) div (FMax - FMin)) div 10;
    for i := 0 to countof do DrawOne(i);
    end else Paint;
end;

procedure TGProgress.StepIt;
var
  PosCheck: integer;
begin
  PosCheck := Position + Step;
  if PosCheck > FMax then
  begin
    Position := FMin + Step;
    invalidate;
  end else Position := Position + Step;
end;

procedure TGProgress.ChangeMax(i: integer);
begin
  if i < 0 then
  begin
    ShowError;
//    i := FMax;
  end else
    FMax := i;
  if Position > FMax then Position := FMax;
  Repaint;
end;

procedure TGProgress.ChangeMin(i: integer);
begin
  if i < 0 then
  begin
    ShowError;
//    i := FMin;
  end else
    FMin := i;
  if Position < FMin then Position := FMin;
  Repaint;
end;

procedure TGProgress.ChangePosition(P: integer);
begin
  if P > FMax then P := FMax;
  if P < FMin then P := FMin;
  FPos := P;
  if LastPos > FPos then
  begin
    invalidate;
    LastPos := Position;
    exit;
  end else
  begin
    FromSub := true;
    Repaint;
    LastPos := Position;
  end;
end;

procedure TGProgress.ChangeGradientBar(b: boolean);
begin;
  FGradient := b;
  Invalidate;
end;

procedure TGProgress.ChangeTransparent(b: boolean);
begin
  FTransparent := b;
  Invalidate;
end;

procedure TGProgress.ChangeFrame1Color(C: TColor);
begin
  FFrame1 := C;
  Invalidate;
end;

procedure TGProgress.ChangeFrame2Color(C: TColor);
begin
  FFrame2 := C;
  Invalidate;
end;

procedure TGProgress.ChangeBackgrndColor(C: TColor);
begin
  FBackgrnd := C;
  Invalidate;
end;

procedure TGProgress.ChangeColor2(C: TColor);
begin
  FColor2 := C;
  Invalidate;
end;
procedure TGProgress.ChangeSolid(B:boolean);
begin
FSolid:=B;
Invalidate;
end;
procedure TGProgress.ChangeStep(i: integer);
begin
  if i < 0 then
  begin
    ShowError;
//    i := FStep;
  end else
    FStep := i;
end;

procedure TGProgress.ShowError;
begin
  MessageDlg('Value must be between 0 and 2147483647', mtError,
    [mbOk], 0);
end;

procedure Register;
begin
  RegisterComponents('Neue', [TGProgress]);
end;

end.

