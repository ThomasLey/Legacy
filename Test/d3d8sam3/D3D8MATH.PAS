{
  D3D8Math - Math unit for Direct3D 8.
  Copyright © 2001 Lord Trancos.
  <lordtrancos@softhome.net>
}

unit D3D8MATH;

// --------------------------------------------------------------------

interface

uses D3DX8, Math;

function  PointFacesPlane(_point, _v1, _normal: TD3DXVector3): boolean;
function  FaceNormal(_v1, _v2, _v3: TD3DXVector3): TD3DXVector3;
procedure PIFInit(_v1, _v2, _v3: TD3DXVector3;
                  var _21x, _31x, _21y, _31y, _21z, _31z: single);
function  PointInFace(_v1: TD3DXVector3;
                      _21x, _31x, _21y, _31y, _21z, _31z,
                      _u, _v: single): TD3DXVector3;

// --------------------------------------------------------------------

implementation

// --------------------------------------------------------------------

function PointFacesPlane(_point, _v1, _normal: TD3DXVector3): boolean;

// Returns true if a point faces a plane.
// _v1 is the plane's first vertex.
// _normal is the plane's normal.

var _v : TD3DXVector3;
    _d : single;

begin
  _v.x := _v1.x - _point.x;
  _v.y := _v1.y - _point.y;
  _v.z := _v1.z - _point.z;
  _d := D3DXVec3Dot(_v, _normal);
  Result := (_d > 0.0001);
end;

// -------------------------------------------------------------------

function FaceNormal(_v1, _v2, _v3: TD3DXVector3): TD3DXVector3;

// Returns the face's normal.

var _nv1, _nv2, _n: TD3DXVector3;
    _len : single;

begin
  // Get vectors for calculating face normal.
  _nv1.x  := _v3.x - _v1.x;
  _nv1.y  := _v3.y - _v1.y;
  _nv1.z  := _v3.z - _v1.z;
  _nv2.x  := _v2.x - _v1.x;
  _nv2.y  := _v2.y - _v1.y;
  _nv2.z  := _v2.z - _v1.z;

  // Get face normal.
  _n.x := (_nv1.y * _nv2.z) - (_nv1.z * _nv2.y);
  _n.y := (_nv1.z * _nv2.x) - (_nv1.x * _nv2.z);
  _n.z := (_nv1.x * _nv2.y) - (_nv1.y * _nv2.x);
  _len := sqrt(_n.x * _n.x + _n.y * _n.y + _n.z * _n.z);
  _n.x := _n.x / _len;
  _n.y := _n.y / _len;
  _n.z := _n.z / _len;

  // Done
  Result := _n;
end;

// -------------------------------------------------------------------

procedure PIFInit(_v1, _v2, _v3: TD3DXVector3;
                  var _21x, _31x, _21y, _31y, _21z, _31z: single);

// Returns values used by PointInFace function.

begin
  _21x := _v2.x - _v1.x;
  _31x := _v3.x - _v1.x;
  _21y := _v2.y - _v1.y;
  _31y := _v3.y - _v1.y;
  _21z := _v2.z - _v1.z;
  _31z := _v3.z - _v1.z;
end;

// -------------------------------------------------------------------

function PointInFace(_v1: TD3DXVector3;
                     _21x, _31x, _21y, _31y, _21z, _31z,
                     _u, _v: single): TD3DXVector3;

// Converts the U and V face coordinates to X,Y,Z coordinates.

begin
  Result.x := _v1.x + (_21x * _u) + (_31x * _v);
  Result.y := _v1.y + (_21y * _u) + (_31y * _v);
  Result.z := _v1.z + (_21z * _u) + (_31z * _v);
end;

// -------------------------------------------------------------------

end.
