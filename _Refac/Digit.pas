unit digit;

interface

uses
  SysUtils, Classes, Graphics, Controls;

type
  TDigit = class(TGraphicControl)
  private
    { Private-Deklarationen }
    FBmp: array[0..10]of TBitmap;
    FValue: Integer;
    FDigits: Integer;
    FOn: Boolean;
    FOldDisplay: String[10];
    procedure SetValue(Value: Integer);
    procedure SetDigits(Value: Integer);
    procedure SetOn(Value: Boolean);
  protected
    { Protected-Deklarationen }
    procedure Paint; override;
  public
    { Public-Deklarationen }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published-Deklarationen }
    property Value: Integer read FValue write SetValue;
    property Digits: Integer read FDigits write SetDigits;
    property DisplayOn: Boolean read FOn write SetOn;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Neue', [TDigit]);
end;

procedure TDigit.SetValue(Value: Integer);
var
  Display: String[10];
  i: Integer;
begin
  FValue:= Value;
  if not(FOn) then exit;
  Display:= Format('%10d', [abs(FValue)]);
  for i:= 11-fDigits to 10 do
    if Display[i] <> FOldDisplay[i] then
      if Display[i] = ' ' then
        Canvas.Draw(14*(i-(11-FDigits)), 0, FBmp[10])
      else
        Canvas.Draw(14*(i-(11-FDigits)), 0, FBmp[ord(Display[i])-48]);
  FOldDisplay:= Display;
end;

procedure TDigit.SetDigits(Value: Integer);
begin
  if not (Value in [1..10]) then exit;
  if Value = FDigits then exit;
  FDigits:= Value;
  Width:= FDigits * 14;
  Height:= 28;
  Paint;
end;

procedure TDigit.SetOn(Value: Boolean);
begin
  if Value = FOn then exit;
  FOn:= Value;
  if FOn then
    FOldDisplay:= Format('%10d', [abs(FValue)])
  else
    FOldDisplay:= '          ';
  paint;
end;


constructor TDigit.Create(AOwner: TComponent);
var
  i: Integer;
begin
  inherited Create(AOwner);
  FDigits:= 10;
  FOn:= True;
  FValue:= 0;
  Height:= 28;
  Width:= FDigits * 14;
  for i:= 0 to 10 do begin
    FBmp[i]:= TBitmap.Create;
    FBmp[i].LoadFromResourceID(HInstance, i + 100);
  end;
  FOldDisplay:= '          ';
end;

destructor TDigit.Destroy;
var
  i: Integer;
begin
  for i:= 0 to 10 do FBmp[i].Free;
  inherited Destroy;
end;


procedure TDigit.Paint;
var
  i: Integer;
begin
  if Height <> 28 then Height:= 28;
  if Width <> FDigits * 14 then Width:= FDigits * 14;
  for i:= 11-fDigits to 10 do
      if FOldDisplay[i] = ' ' then
        Canvas.Draw(14*(i-(11-fDigits)), 0, FBmp[10])
      else
        Canvas.Draw(14*(i-(11-FDigits)), 0, FBmp[ord(FOldDisplay[i])-48]);
end;

end.
