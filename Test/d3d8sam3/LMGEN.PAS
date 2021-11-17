{
  LMGen - LightMap Generator unit.
  Copyright © 2001 Lord Trancos.
  <lordtrancos@softhome.net>
}

unit LMGen;

// --------------------------------------------------------------------

interface

uses D3DX8, Math;

type
  // Omnidirectional light (Point Light)
  TPointlight = record
                  Position : TD3DXVector3;
                  Color    : longint; // In R8G8B8 format.
                  AttStart : single;  // Attenuation start.
                  AttEnd   : single;  // Attenuation end.
                end;

  // Spotlight
  TSpotlight = record
                 Position : TD3DXVector3;
                 Target   : TD3DXVector3;
                 Theta    : single;   // Inner cone.
                 Phi      : single;   // Outer cone.
                 Color    : longint;  // In R8G8B8 format.
                 AttStart : single;   // Attenuation start.
                 AttEnd   : single;   // Attenuation end.
               end;

// Light Initialization Functions
function Pointlight(_position : TD3DXVector3;
                    _attStart, _attEnd : single;
                    _color : longint): TPointlight;
function Spotlight(_position, _target : TD3DXVector3;
                   _theta, _phi, _attStart, _attEnd : single;
                   _color : longint): TSpotlight;

// Light Main Functions
function GetOmniColor(_point: TD3DXVector3;
                      _light: TPointlight): longint;
function GetSpotColor(_point: TD3DXVector3;
                      _spot: TSpotlight): longint;

// Color Conversion and Addition Functions
function RGB8toRGB4(_color: longint): word;
function RGB8toRGB5(_color: longint): word;
function SumRGB4Colors(_c1, _c2: word): word;
function SumRGB5Colors(_c1, _c2: word): word;

// --------------------------------------------------------------------

implementation

const
  MAXLIGHTVAL = $FF; // Do not change!

// *******************************************************************
// ** Light Initialization Functions *********************************
// *******************************************************************

function Pointlight(_position : TD3DXVector3;
                    _attStart, _attEnd : single;
                    _color : longint): TPointlight;

begin
  with Result do
    begin
      Position := _position;
      Color    := _color;
      AttStart := _attStart;
      AttEnd   := _attEnd;
    end;
end;

// -------------------------------------------------------------------

function Spotlight(_position, _target : TD3DXVector3;
                   _theta, _phi, _attStart, _attEnd : single;
                   _color : longint): TSpotlight;

begin
  with Result do
    begin
      Position := _position;
      Target   := _target;
      Theta    := _theta;
      Phi      := _phi;
      Color    := _color;
      AttStart := _attStart;
      AttEnd   := _attEnd;
    end;
end;

// *******************************************************************
// ** Main Light Functions *******************************************
// *******************************************************************

function FinalColor(_byt: byte; _lightColor: longint): longint;

// Returns the final light color in R8G8B8 format.

var _r, _g, _b : byte;

begin
  // Get RGB Values for light color.
  _r := (_lightColor shr 16) and $FF;
  if _byt < _r then _r := _byt;
  _g := (_lightColor shr 8) and $FF;
  if _byt < _g then _g := _byt;
  _b := _lightColor and $FF;
  if _byt < _b then _b := _byt;

  // Compose color.
  Result := (_r shl 16) + (_g shl 8) + _b;
end;

// -------------------------------------------------------------------

function GetOmniColor(_point: TD3DXVector3;
                      _light: TPointlight): longint;

// Returns the light color in R8G8B8 format.

var _len : single;
    _dif : single;
    _col : longint;
    _byt : byte;

begin
  Result := 0;

  _point.x := _point.x - _light.Position.x;
  _point.y := _point.y - _light.Position.y;
  _point.z := _point.z - _light.Position.z;

  with _point do _len := sqrt(x * x + y * y + z * z);

  // Full attenuated ?
  if _len > _light.AttEnd then exit;

  // Attenuated ?
  if _len > _light.AttStart then
    begin
      _dif := _light.AttEnd - _light.AttStart;
      _len := _len - _light.AttStart;

      _col := round((_len * MAXLIGHTVAL)/_dif);
      if _col > MAXLIGHTVAL then _col := MAXLIGHTVAL;
    end else _col := 0;

  _byt := MAXLIGHTVAL - _col;

  Result := FinalColor(_byt, _light.Color);
end;

// -------------------------------------------------------------------

function GetSpotColor(_point: TD3DXVector3;
                      _spot: TSpotlight): longint;

// Returns the light color in R8G8B8 format.

var _v1, _v2 : TD3DXVector3;
    _v1l, _v2l : single;
    _a, _dif : single;
    _val : longint;
    _byt : byte;
    _att : byte;

begin
  Result := 0;

  // Get vectors using spot origin as axis.
  _v1.x := _point.x - _spot.Position.x;
  _v1.y := _point.y - _spot.Position.y;
  _v1.z := _point.z - _spot.Position.z;
  _v2.x := _spot.Target.x - _spot.Position.x;
  _v2.y := _spot.Target.y - _spot.Position.y;
  _v2.z := _spot.Target.z - _spot.Position.z;

  // Get the length of _v1 and _v2.
  with _v1 do _v1l := sqrt(x * x + y * y + z * z);
  with _v2 do _v2l := sqrt(x * x + y * y + z * z);

  // Get the angle between _v1 and _v2
  _a := arccos(D3DXVec3Dot(_v1, _v2) / (_v1l * _v2l));

  // Outside the cone or full attenuated ?
  if (_a > _spot.Phi) or (_v1l > _spot.AttEnd) then exit;

  // Inside theta cone ?
  if (_a > _spot.Theta) then
    begin
      // Between theta and phi
      _dif := _spot.Phi - _spot.Theta;
      _a := _a - _spot.Theta;

      _val := round((MAXLIGHTVAL*_a)/_dif);
      if _val > MAXLIGHTVAL then _val := MAXLIGHTVAL;

      _byt := MAXLIGHTVAL - _val;
    end else _byt := MAXLIGHTVAL;

  // Attenuation ?
  if (_v1l > _spot.AttStart) then
    begin
      _dif := _spot.AttEnd - _spot.AttStart;
      _v1l := _v1l - _spot.AttStart;

      _val := round((MAXLIGHTVAL*_v1l)/_dif);
      if _val > MAXLIGHTVAL then _val := MAXLIGHTVAL;

      _att := _val;
    end else _att := 0;

  // Get final value.
  _val := _byt - _att;
  if _val < 0 then _val := 0;
  _byt := _val;

  // Get final color.
  Result := FinalColor(_byt, _spot.Color);
end;

// *******************************************************************
// ** Color Conversion and Addition Functions ************************
// *******************************************************************

function RGB8toRGB4(_color: longint): word;

// R8G8B8 to R4G4B4 conversion.

begin
  Result := (((_color shr 20) and $F) shl 8) +
            (((_color shr 12) and $F) shl 4) +
            ((_color shr 4) and $F);
end;

// -------------------------------------------------------------------

function RGB8toRGB5(_color: longint): word;

// R8G8B8 to R5G5B5 conversion.

begin
  Result := ((_color shr 19) and $1F) shl 10 +
            ((_color shr 11) and $1F) shl 5 +
            ((_color shr 3) and $1F);
end;

// -------------------------------------------------------------------

function SumRGB4Colors(_c1, _c2: word): word;

var _r, _g, _b: word;

begin
  _r := ((_c1 shr 8) and $F) + ((_c2 shr 8) and $F);
  if _r > $F then _r := $F;
  _g := ((_c1 shr 4) and $F) + ((_c2 shr 4) and $F);
  if _g > $F then _g := $F;
  _b := (_c1 and $F) + (_c2 and $F);
  if _b > $F then _b := $F;
  Result := (_r shl 8) + (_g shl 4) + _b;
end;

// -------------------------------------------------------------------

function SumRGB5Colors(_c1, _c2: word): word;

var _r, _g, _b: word;

begin
  _r := ((_c1 shr 10) and $1F) + ((_c2 shr 10) and $1F);
  if _r > $1F then _r := $1F;
  _g := ((_c1 shr 5) and $1F) + ((_c2 shr 5) and $1F);
  if _g > $1F then _g := $1F;
  _b := (_c1 and $1F) + (_c2 and $1F);
  if _b > $1F then _b := $1F;
  Result := (_r shl 10) + (_g shl 5) + _b;
end;

// -------------------------------------------------------------------

end.
