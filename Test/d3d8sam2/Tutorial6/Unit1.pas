unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, DirectXGraphics, DX8GFX, D3DX8;

type
  TForm1 = class(TForm)
    OpenDialog1: TOpenDialog;
    procedure AppOnIdle(Sender: TObject; var Done: Boolean);
    procedure AppOnActivate(Sender: TObject);
    procedure AppOnDeactivate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
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

  ZDist : single; // Camera Z distance.
  CDist : single; // Z-Clipping distance.

  // Matrices
  matWorld : TD3DXMatrix; // World
  matView  : TD3DXMatrix; // View
  matProj  : TD3DXMatrix; // Projection

  // Tutorial 6 stuff.
  MeshFileName : string;
  g_dwNumMaterials : dWord;
  g_pMeshMaterials : array of TD3DMaterial8 = NIL;
  g_pMeshTextures  : array of IDirect3DTexture8 = NIL;
  g_pMesh : ID3DXMesh = NIL;

const
  WRN00 = 'Error initializing 3D Hardware.'#10+
          'Now software will be used...';
  ERR00 = 'Could not initialize DirectX Graphics.'#10+
          'You must have installed DirectX 8 or better '#10+
          'and a 16, 24 or 32 bpp desktop to run this sample.';
  ERR01 = 'Unknown error loading mesh.'#10'(file not found?)';

  SCREENWIDTH  = 512;
  SCREENHEIGHT = 384;

  // Texture filtering.
  USE_TEXTURE_FILTERING = true;

  // Specular lights.
  USE_SPECULAR_LIGHTS = false;

implementation

{$R *.DFM}

// -------------------------------------------------------------------

function InitGeometry: boolean; // Tutorial 6 - Step 1

var _pAdjacency, _pD3DXMtrlBuffer : ID3DXBuffer;
    _d3dxMaterials : PD3DXMaterial;
    _i : longint;

begin
  Result := false;

  // Load mesh.
  _pAdjacency := NIL;
  _pD3DXMtrlBuffer := NIL;
  if failed(D3DXLoadMeshFromX(pChar(MeshFileName), D3DXMESH_SYSTEMMEM,
                              D3DDEV8, _pAdjacency, _pD3DXMtrlBuffer,
                              g_dwNumMaterials, g_pMesh)) then exit;
  _pAdjacency := NIL;

  if g_dwNumMaterials = 0 then exit;

  // After loading the mesh object and material information,
  // we need to extract the material properties and texture
  // names from the material buffer.
  _d3dxMaterials := _pD3DXMtrlBuffer.GetBufferPointer;

  // Creates new mesh and texture objects based on the total
  // number of materials for the mesh.
  try
    SetLength(g_pMeshMaterials, g_dwNumMaterials);
    SetLength(g_pMeshTextures, g_dwNumMaterials);
  except
    exit;
  end;

  // Load materials and textures.
  for _i := 0 to g_dwNumMaterials - 1 do
    begin
      // Copy the material
      g_pMeshMaterials[_i] := _d3dxMaterials^.MatD3D;

      // Set the ambient color for the material (D3DX does not do this)
      g_pMeshMaterials[_i].Ambient := g_pMeshMaterials[_i].Diffuse;

      // Create the texture.
      g_pMeshTextures[_i] := NIL;
      if (_d3dxMaterials^.pTextureFilename = NIL) or
         (failed(D3DXCreateTextureFromFile(D3DDEV8,
                 _d3dxMaterials^.pTextureFilename,
                 g_pMeshTextures[_i])))
        then g_pMeshTextures[_i] := NIL;

      // Next
      inc(_d3dxMaterials);
    end;

  // Done with the material buffer
  _pD3DXMtrlBuffer := NIL;

  // All right.
  Result := true;
end;

// -------------------------------------------------------------------

procedure Cleanup; // Tutorial 6 - Step 3

var _i : longint;

begin
  // Free materials.
  if (g_pMeshMaterials <> NIL) then g_pMeshMaterials := NIL;

  // Free textures.
  if (g_pMeshMaterials <> NIL) and (g_dwNumMaterials > 0) then
    for _i := 0 to g_dwNumMaterials - 1 do
      if g_pMeshTextures[_i] <> NIL
        then g_pMeshTextures[_i] := NIL;
  g_pMeshTextures := NIL;

  // Free mesh.
  if (g_pMesh <> NIL) then g_pMesh := NIL;
end;

// -------------------------------------------------------------------

procedure SetMatrices;

var _v1, _v2, _v3 : TD3DXVector3;

begin
  // World.
  D3DXMatrixRotationY(matWorld, sin(GetTickCount/2500) * Pi);
  D3DDEV8.SetTransform(D3DTS_WORLD, matWorld);

  // View.
  _v1 := D3DXVector3(  0.0,  0.0,   ZDist);
  _v2 := D3DXVector3(  0.0,  0.0,   0.0);
  _v3 := D3DXVector3(  0.0,  1.0,   0.0);
  D3DXMatrixLookAtLH(matView, _v1, _v2, _v3);
  D3DDEV8.SetTransform(D3DTS_VIEW, matView);

  // Projection.
  D3DXMatrixPerspectiveFovLH(matProj, PI/4, SCREENWIDTH/SCREENHEIGHT,
                             1.0, CDist);
  D3DDEV8.SetTransform(D3DTS_PROJECTION, matProj);
end;

// -------------------------------------------------------------------

procedure SetLight;

var _lit : TD3DLight8;
    _tim : single;
    _vecDir : TD3DXVector3;

begin
  // Set Directional Light
  FillChar(_lit, sizeof(_lit), 0 );
  with _lit do
    begin
      _Type := D3DLIGHT_DIRECTIONAL;
      Diffuse.r := 1.0;
      Diffuse.g := 1.0;
      Diffuse.b := 1.0;
      Specular.r := 0.5;
      Specular.g := 0.5;
      Specular.b := 0.5;
      _tim := GetTickCount / 1000;
      _vecDir := D3DXVECTOR3(cos(_tim), 0.0, sin(_tim));
      D3DXVec3Normalize(Direction, _vecDir);
      Range   := 1000.0;
      D3DDEV8.SetLight(0, _lit);
      D3DDEV8.LightEnable(0, true);
    end;
end;

// -------------------------------------------------------------------

procedure RenderFrame;

var _i : longint;

begin
  // Update Matrices and light.
  SetMatrices;
  SetLight;

  // Clear the back buffer to a black color.
  D3DDEV8.Clear(0, NIL, D3DCLEAR_TARGET or D3DCLEAR_ZBUFFER,
                $FF000080, 1.0, 0);

  // Begin the scene.
  D3DDEV8.BeginScene;

  // Draw mesh - // Tutorial 6 - Step 2
  for _i := 0 to g_dwNumMaterials - 1 do
    begin
      // Set the material for the subset.
      D3DDEV8.SetMaterial(g_pMeshMaterials[_i]);
      // Set the texture for the subset.
      D3DDEV8.SetTexture(0, g_pMeshTextures[_i]);
      // Draw subset.
      g_pMesh.DrawSubset(_i);
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
  // Speed control
  while GetTickCount - FRAMECONTROL = 0 do Sleep(0);
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

procedure TForm1.FormCreate(Sender: TObject);

begin
  ClientWidth  := SCREENWIDTH;
  ClientHeight := SCREENHEIGHT;
end;

// -------------------------------------------------------------------

procedure TForm1.FormActivate(Sender: TObject);

var _cnt  : longint;
    _data : PD3DXVector3;
    _vb : IDirect3DVertexBuffer8;
    _x, _z : single;

begin
  FRAMECONTROL := GetTickCount;

  // Initialize application events
  Application.OnIdle       := AppOnIdle;
  Application.OnActivate   := AppOnActivate;
  Application.OnDeactivate := AppOnDeactivate;
  Application.OnRestore    := AppOnActivate;
  Application.OnMinimize   := AppOnDeActivate;

  // Any file as parameter ?
  if (paramcount = 0) or (not fileexists(paramstr(1))) then
    begin
      // Ask file.
      if OpenDialog1.Execute
        then MeshFileName := OpenDialog1.Filename else
          begin Application.Terminate; exit; end;
    end else MeshFileName := paramstr(1);

  // Initialize Direct Graphics (first try with Hardware Accel. (HAL))
  if not InitDGfx(Handle, false, 0, 0, 0, 0, true, true) then
    begin
      MessageBox(0, WRN00, 'Warning.', MB_ICONWARNING);
      CloseDGfx;
      if not InitDGfx(Handle, false, 0, 0, 0, 0, false, true) then
        begin hHalt(ERR00); exit; end;
    end;

  // Load mesh.
  if not InitGeometry then begin hHalt(ERR01); exit; end;

  // Get camera distance.
  ZDist := 0;
  g_pMesh.GetVertexBuffer(_vb);
  _vb.Lock(0, 0, pByte(_data), D3DLOCK_READONLY);
  for _cnt := 0 to g_pMesh.GetNumVertices - 1 do
    begin
      if _data.x < 0 then _x := _data.x * -1 else _x := _data.x;
      if _data.z < 0 then _z := _data.z * -1 else _z := _data.z;
      if ZDist < _x then ZDist := _x;
      if ZDist < _z then ZDist := _z;
      inc(_data);
    end;
  _vb.Unlock;
  _vb := NIL;
  ZDist := ZDist * 3;
  CDist := ZDist * 2;

  // Set ambiental light.
  D3DDEV8.SetRenderState(D3DRS_AMBIENT, $AAAAAA);

  // Enable dithering
  D3DDEV8.SetRenderState(D3DRS_DITHERENABLE, 1);

  // Enable Specular Lights
  if USE_SPECULAR_LIGHTS
    then D3DDEV8.SetRenderState(D3DRS_SPECULARENABLE, 1);

  // Set texture filtering
  if USE_TEXTURE_FILTERING then
    begin
      D3DDEV8.SetTextureStageState(0, D3DTSS_MAGFILTER, D3DTEXF_LINEAR);
      D3DDEV8.SetTextureStageState(0, D3DTSS_MINFILTER, D3DTEXF_LINEAR);
    end;

  // All ok
  DXReady := true;
end;

// -------------------------------------------------------------------

procedure TForm1.FormDestroy(Sender: TObject);

begin
  DXReady := false;
  // Free mesh, textures and materials.
  Cleanup;
  // Free DX
  CloseDGfx;
end;

// -------------------------------------------------------------------

end.
