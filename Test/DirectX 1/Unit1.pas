unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DXClass, DXDraws;

type
  TMainForm = class(TForm)
    DXDraw: TDXDraw;
    DXImageList: TDXImageList;
    DXTimer: TDXTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DXDrawInitialize(Sender: TObject);
    procedure DXDrawFinalize(Sender: TObject);
    procedure DXTimerTimer(Sender: TObject; LagCount: Integer);
  private
    SineMove : array[0..255] of integer; { Sine Table for Movement } 
    CosineMove : array[0..255] of integer; { CoSine Table for Movement } 
    SineTable : array[0..449] of integer; { Sine Table. 449 = 359 + 180 } 
    CenterX, CenterY : Integer; { To hold the CenterX and Y position of our hole }
    TextX, TextY : Integer; { To hold the TextX and Y position message }
    procedure CalculateTables; { Populate our Sine/CosineMove and SineTable arrays }
    procedure PlotPoint( XCenter, YCenter, Radius, Angle : Word); { Draw a Point on the Offscreen surface}
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

procedure TMainForm.CalculateTables; 
var 
  wCount : Word; 
begin 
  { Precalculted Values for movement } 
  for wCount := 0 to 255 do 
  begin 
    SineMove[wCount] := round( sin( pi*wCount/128 ) * 45 ); 
    CosineMove[wCount] := round( cos( pi*wCount/128 ) * 60 ); 
  end; 
  { Precalculated Sine table. Only One table because cos(i) = sin(i + 90) } 
  for wCount := 0 to 449 do 
  begin 
    SineTable[wCount] := round( sin( pi*wCount/180 ) * 128); 
  end; 
end; 

procedure TMainForm.PlotPoint(XCenter, YCenter, Radius, Angle: Word); 
var 
  X, Y : Word; 
begin 
  X := ( Radius * SineTable[90 + Angle]); 
  asm 
    sar x,7 
  end; 
  X := CenterX + XCenter + X; 
  Y := ( Radius * SineTable[Angle] ); 
  asm 
    sar y,7 
  end; 
  Y := CenterY + YCenter + Y; 
  if (X < Width ) and ( Y < Height ) then 
  begin 
    //DXDraw.Surface.Canvas.Pixels[X, Y] := clBlue; 
    DXImageList.Items[0].Draw( DXDraw.Surface, X, Y, 0 );
  end; 
end; 

procedure TMainForm.FormCreate(Sender: TObject);
begin
  CenterX := Width div 2;  
  CenterY := Height div 2;
  TextX := 0;
  TextY := 0;
  CalculateTables;

end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {  Application end  } 
  if Key=VK_ESCAPE then 
    Close;
end;

procedure TMainForm.DXDrawInitialize(Sender: TObject);
begin
     DXTimer.Enabled := true;
end;

procedure TMainForm.DXDrawFinalize(Sender: TObject);
begin
     DXTimer.Enabled := false;
end;

procedure TMainForm.DXTimerTimer(Sender: TObject; LagCount: Integer);
const 
  x : Word = 0; 
  y : Word = 0; 
  IncAngle = 12;
  XMove = 3;
  YMove = 3;
var 
  CountAngle : Word; 
  CountLong : Word; 
  IncLong :Word; 
begin 
  if not DXDraw.CanDraw then exit; 
  IncLong := 2;
  CountLong := 20;
  {Clear the OffScreen Surface}
  DXDraw.Surface.Fill( 0 );
  { Draw Circle } 
  repeat 
    CountAngle := 0; 
    repeat
      PlotPoint(CosineMove[( x + ( 200 - CountLong )) mod 255],
                SineMove[( y + ( 200 - CountLong )) mod 255], CountLong, CountAngle); 
      inc(CountAngle, IncAngle); 
    until CountAngle >= 360; 
    { Another Circle, eventually another color } 
    inc(CountLong, IncLong);
    if ( CountLong mod 3 ) = 0 then 
    begin 
      inc(IncLong);
    end; 
  until CountLong >= 130;
  { move x and y co-ordinates}
  x := XMove + x mod 255; 
  y := YMove + y mod 255; 
  with DXDraw.Surface.Canvas do 
  begin 
    Brush.Style := bsClear;
    Font.Color := clWhite; 
    Font.Size := 12;
    Textout( 0, 30, 'FPS: ' + intToStr(DXTimer.FrameRate));
    Textout( TextY, TextX, 'Zum Verlassen "ESC" drücken.');
    inc(TextY);
    if TextY > Width then TextY := 0;
    Release; {  Always release the surface you have finished drawing on before flipping  }
  end; 
  DXDraw.Flip; 
end; 

end.
