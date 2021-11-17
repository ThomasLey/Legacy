unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, DirectXGraphics, DX8GFX, D3DX8, Math;

type
  TForm1 = class(TForm)
    procedure AppOnIdle(Sender: TObject; var Done: Boolean);
    procedure AppOnActivate(Sender: TObject);
    procedure AppOnDeactivate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

  FRAMECONTROL : dWord;
  DXReady      : boolean = false;
  WindowReady  : boolean = false;

  VertexBuffer : IDirect3DVertexBuffer8;
  MeshMirror   : IDirect3DVertexBuffer8;

  // Matrices
  matWorld : TD3DXMatrix; // World
  matView  : TD3DXMatrix; // View
  matProj  : TD3DXMatrix; // Projection
  matObj   : TD3DXMatrix; // Object matrix.

  // View.
  vEyePt, vLookatPt, vUpVec : TD3DXVector3;

type
  // The structure of the custom vertex.
  TCustomVertex = record
                    X, Y, Z : single; // Position for the vertex.
                    DColor  : dWord;  // Diffuse color.
                  end;

  TMirrorVertex = record
                    Position : TD3DXVector3;
                    Normal   : TD3DXVector3;
                    DColor   : dWord; // Diffuse color.
                  end;

const
  // Flexible vector format (FVF) descriptions.
  D3DFVF_OBJECTVERTEX = D3DFVF_XYZ or D3DFVF_DIFFUSE;
  D3DFVF_MIRRORVERTEX = D3DFVF_XYZ or D3DFVF_NORMAL or D3DFVF_DIFFUSE;

const
  WRN00 = 'Error initializing 3D Hardware.'#10+
          'Now software will be used...';
  ERR00 = 'Could not initialize DirectX Graphics.'#10+
          'You must have installed DirectX 8 or better '#10+
          'and a 16, 24 or 32 bpp desktop to run this sample.';
  ERR01 = 'Error initializing Vertex Buffer.';

implementation

{$R *.DFM}

// -------------------------------------------------------------------

procedure InitMatrices;

begin
  // Initialize the camera's orientation
  vEyePt    := D3DXVECTOR3(0.0, 2.0, -6.5);
  vLookatPt := D3DXVECTOR3(0.0, 0.0,  0.0);
  vUpVec    := D3DXVECTOR3(0.0, 1.0,  0.0);

  // World.
  D3DXMatrixIdentity(matWorld);
  D3DDEV8.SetTransform(D3DTS_WORLD, matWorld);

  // View.
  D3DXMatrixLookAtLH(matView, vEyePt, vLookatPt, vUpVec);
  D3DDEV8.SetTransform(D3DTS_VIEW, matView);

  // Projection.
  D3DXMatrixPerspectiveFovLH(matProj, PI/4, 512/384, 1.0, 100.0);
  D3DDEV8.SetTransform(D3DTS_PROJECTION, matProj);
end;

// -------------------------------------------------------------------

procedure FrameMove;

var _time : single;

begin
  _time := GetTickCount / 750;

  // Set the teapot's local matrix (rotating about the y-axis)
  D3DXMatrixRotationY(matObj, _time);

  // Move the camera about the z-axis
  vEyePt.x := 4.0 * sin(_time/2.9);
  vEyePt.y := 2.0 * cos(_time/3.7);
  vEyePt.z := -sqrt(40.0 - vEyePt.x*vEyePt.x - vEyePt.y*vEyePt.y);
  D3DXMatrixLookAtLH(matView, vEyePt, vLookatPt, vUpVec);
  D3DDEV8.SetTransform(D3DTS_VIEW, matView);
end;

// -------------------------------------------------------------------

procedure RenderScene;

var _matLocal, _matWorldSaved : TD3DXMatrix;

begin
  // Get a copy of the world matrix.
  D3DDEV8.GetTransform(D3DTS_WORLD, _matWorldSaved);

  // Build the local matrix.
  D3DXMatrixMultiply(_matLocal, matObj, _matWorldSaved);
  D3DDEV8.SetTransform(D3DTS_WORLD, _matLocal);

  // Set the stream source.
  D3DDEV8.SetStreamSource(0, VertexBuffer, sizeof(TCustomVertex));
  // Set the vertex shader.
  D3DDEV8.SetVertexShader(D3DFVF_OBJECTVERTEX);
  // Render the vertices.
  D3DDEV8.DrawPrimitive(D3DPT_TRIANGLELIST, 0, 2);

  // Restore the world matrix
  D3DDEV8.SetTransform(D3DTS_WORLD, _matWorldSaved);
end;

// -------------------------------------------------------------------

procedure RenderMirror;

var _matWorldSaved, _matReflectInMirror : TD3DXMatrix;
    _a, _b, _c, _d : TD3DXVector3;
    _plane : TD3DXPlane;
    _p : pointer;

begin
  // Save the world matrix so it can be restored
  D3DDEV8.GetTransform(D3DTS_WORLD, _matWorldSaved);

  // Get the four corners of the mirror.
  // (This should be dynamic rather than hardcoded.)
  _a := D3DXVector3(-1.5, 1.5, 3.0);
  _b := D3DXVector3( 1.5, 1.5, 3.0);
  _c := D3DXVector3(-1.5,-1.5, 3.0);
  _d := D3DXVector3( 1.5,-1.5, 3.0);

  // Construct the reflection matrix
  D3DXPlaneFromPoints(_plane, _a, _b, _c);
  D3DXMatrixReflect(_matReflectInMirror, _plane);
  D3DDEV8.SetTransform(D3DTS_WORLD, _matReflectInMirror);

  // Reverse the cull mode (since normals will be reflected)
  D3DDEV8.SetRenderState(D3DRS_CULLMODE, D3DCULL_CW);

  // Set the custom clip planes (so geometry is clipped by mirror edges).
  // This is the heart of this sample. The mirror has 4 edges, so there are
  // 4 clip planes, each defined by two mirror vertices and the eye point.
  _p := D3DXPlaneFromPoints(_plane, _b, _a, vEyePt);
  D3DDEV8.SetClipPlane( 0, _p);
  _p := D3DXPlaneFromPoints( _plane, _d, _b, vEyePt);
  D3DDEV8.SetClipPlane( 1, _p);
  _p := D3DXPlaneFromPoints( _plane, _c, _d, vEyePt);
  D3DDEV8.SetClipPlane( 2, _p);
  _p := D3DXPlaneFromPoints( _plane, _a, _c, vEyePt);
  D3DDEV8.SetClipPlane( 3, _p);

  D3DDEV8.SetRenderState(D3DRS_CLIPPLANEENABLE,
        D3DCLIPPLANE0 or D3DCLIPPLANE1 or D3DCLIPPLANE2 or D3DCLIPPLANE3 );

  // Render the scene
  RenderScene;

  // Restore the modified render states
  D3DDEV8.SetTransform(D3DTS_WORLD, _matWorldSaved);
  D3DDEV8.SetRenderState(D3DRS_CLIPPLANEENABLE, 0);
  D3DDEV8.SetRenderState(D3DRS_CULLMODE, D3DCULL_CCW);

  // Finally, render the mirror itself (as an alpha-blended quad)
  D3DDEV8.SetRenderState(D3DRS_ALPHABLENDENABLE, 1);
  D3DDEV8.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA);
  D3DDEV8.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA);

  // Set the stream source.
  D3DDEV8.SetStreamSource(0, MeshMirror, sizeof(TMirrorVertex));
  // Set the vertex shader.
  D3DDEV8.SetVertexShader(D3DFVF_MIRRORVERTEX);
  // Render the vertices.
  D3DDEV8.DrawPrimitive(D3DPT_TRIANGLESTRIP, 0, 2);

  D3DDEV8.SetRenderState(D3DRS_ALPHABLENDENABLE, 0);
end;

// -------------------------------------------------------------------

procedure RenderFrame;

begin
  FrameMove;

  // Clear the back buffer to a black color.
  D3DDEV8.Clear(0, NIL, D3DCLEAR_TARGET or D3DCLEAR_ZBUFFER,
                $FF000080, 1.0, 0);

  // Begin the scene.
  if not failed(D3DDEV8.BeginScene) then
    begin
      RenderScene;  // Render the scene
      RenderMirror; // Render the scene in the mirror
    end;

  // End the scene.
  D3DDEV8.EndScene;

  // Display scene.
  D3DDEV8.Present(NIL, NIL, 0, NIL);
end;

// -------------------------------------------------------------------

procedure TForm1.AppOnIdle(Sender: TObject; var Done: Boolean);

begin
  Done := false;
  if (not DXReady) or (not WindowReady) then exit;
  RenderFrame;
  while GetTickCount - FRAMECONTROL < 1 do Sleep(0);
  FRAMECONTROL := GetTickCount;
end;

// ------------------------------------------------------------------

procedure TForm1.AppOnActivate(Sender: TObject);

begin
  WindowReady := true;
end;

// ------------------------------------------------------------------

procedure TForm1.AppOnDeactivate(Sender: TObject);

begin
  WindowReady := false;
end;

// -------------------------------------------------------------------

procedure hHalt(_errMsg: pChar);

begin
  MessageBox(0, _errMsg, 'Error', MB_ICONERROR);
  Application.Terminate;
end;

// -------------------------------------------------------------------

function GetCustomVertex(_x, _y, _z: single;
                         _dcolor: dWord): TCustomVertex;

begin
  Result.X := _x;
  Result.Y := _y;
  Result.Z := _z;
  Result.DColor := _dcolor;
end;

// -------------------------------------------------------------------

function GetMirrorVertex(_x, _y, _z, _nx, _ny, _nz: single;
                         _dcolor: dWord): TMirrorVertex;

begin
  Result.Position.X := _x;
  Result.Position.Y := _y;
  Result.Position.Z := _z;
  Result.Normal.X := _nx;
  Result.Normal.Y := _ny;
  Result.Normal.Z := _nz;
  Result.DColor := _dcolor;
end;

// -------------------------------------------------------------------

function InitVertexBuffer: boolean;

var _vb1 : array[0..5] of TCustomVertex;
    _vb2 : array[0..3] of TMirrorVertex;
    _ptr : pByte;

begin
  Result := false;

  // Init geometry - object
  _vb1[0] := GetCustomVertex(-1, -1, 0.0, $FFFF0000);
  _vb1[1] := GetCustomVertex( 1, -1, 0.0, $FF00FF00);
  _vb1[2] := GetCustomVertex( 0,  1, 0.0, $FF0000FF);
  _vb1[3] := GetCustomVertex( 0,  1, 0.0, $FFFF00FF);
  _vb1[4] := GetCustomVertex( 1, -1, 0.0, $FF00FFFF);
  _vb1[5] := GetCustomVertex(-1, -1, 0.0, $FFFFFF00);

  // Init geometry - mirror
  _vb2[0] := GetMirrorVertex(-1.5,-1.5, 3.0, 0.0, 0.0,-1.0, $40FFFFFF);
  _vb2[1] := GetMirrorVertex(-1.5, 1.5, 3.0, 0.0, 0.0,-1.0, $40FFFFFF);
  _vb2[2] := GetMirrorVertex( 1.5,-1.5, 3.0, 0.0, 0.0,-1.0, $40FFFFFF);
  _vb2[3] := GetMirrorVertex( 1.5, 1.5, 3.0, 0.0, 0.0,-1.0, $40FFFFFF);

  // Create object vertex buffer.
  if failed(D3DDEV8.CreateVertexBuffer(SizeOf(_vb1), 0,
                                       D3DFVF_OBJECTVERTEX,
                                       D3DPOOL_DEFAULT,
                                       VertexBuffer)) then exit;

  // Create mirror vertex buffer.
  if failed(D3DDEV8.CreateVertexBuffer(sizeof(_vb2), 0,
                                       D3DFVF_MIRRORVERTEX,
                                       D3DPOOL_DEFAULT,
                                       MeshMirror)) then exit;

  // Lock, fill and unlock object vertex buffer.
  if failed(VertexBuffer.Lock(0, 0, _ptr, 0)) then exit;
  Move(_vb1, _ptr^, SizeOf(_vb1));
  VertexBuffer.Unlock;

  // Lock, fill and unlock mirror vertex buffer.
  if failed(MeshMirror.Lock(0, 0, _ptr, 0)) then exit;
  Move(_vb2, _ptr^, SizeOf(_vb2));
  MeshMirror.Unlock;

  // All right
  Result := true;
end;

// -------------------------------------------------------------------

procedure TForm1.FormActivate(Sender: TObject);

begin
  FRAMECONTROL := GetTickCount;

  // Initialize application events
  Application.OnIdle       := AppOnIdle;
  Application.OnActivate   := AppOnActivate;
  Application.OnDeactivate := AppOnDeactivate;
  Application.OnRestore    := AppOnActivate;
  Application.OnMinimize   := AppOnDeActivate;

  // Initialize Direct Graphics (first try with Hardware Accel. (HAL))
  if not InitDGfx(Handle, false, 0, 0, 0, 0, true, true) then
    begin
      MessageBox(0, WRN00, 'Warning.', MB_ICONWARNING);
      CloseDGfx;
      if not InitDGfx(Handle, false, 0, 0, 0, 0, false, true) then
        begin hHalt(ERR00); exit; end;
    end;

  // Initialize VertexBuffer
  if not InitVertexBuffer then begin hHalt(ERR01); exit; end;

  // Turn off D3D lighting, since we are providing our own vertex colors
  D3DDEV8.SetRenderState(D3DRS_LIGHTING, Ord(false));

  // Enable dithering.
  D3DDEV8.SetRenderState(D3DRS_DITHERENABLE, 1);

  // Initialize matrices
  InitMatrices;

  // All ok
  DXReady := true;
end;

// -------------------------------------------------------------------

procedure TForm1.FormDestroy(Sender: TObject);

begin
  DXReady := false;
  // Free Vertex Buffer
  MeshMirror := NIL;
  VertexBuffer := NIL;
  // Free DX
  CloseDGfx;
end;

// -------------------------------------------------------------------

end.
