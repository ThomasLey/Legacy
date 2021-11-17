unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, Menus, DirectXGraphics, D3DX8, Math,
  DX8GFX, D3D8Math, LMGen;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    Menu1: TMenuItem;
    Menu2: TMenuItem;
    Menu3: TMenuItem;
    Menu4: TMenuItem;
    Menu5: TMenuItem;
    Menu6: TMenuItem;
    Menu7: TMenuItem;
    N1: TMenuItem;
    Menu8: TMenuItem;
    N2: TMenuItem;
    Menu9: TMenuItem;
    Menu10: TMenuItem;
    N3: TMenuItem;
    Menu11: TMenuItem;
    procedure AppOnIdle(Sender: TObject; var Done: Boolean);
    procedure AppOnActivate(Sender: TObject);
    procedure AppOnDeactivate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Menu3Click(Sender: TObject);
    procedure Menu2Click(Sender: TObject);
    procedure Menu5Click(Sender: TObject);
    procedure Menu6Click(Sender: TObject);
    procedure Menu7Click(Sender: TObject);
    procedure Menu8Click(Sender: TObject);
    procedure Menu9Click(Sender: TObject);
    procedure Menu10Click(Sender: TObject);
    procedure Menu11Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type
  // The structure of the custom vertex.
  TCustomVertex = record
                    Position : TD3DXVector3; // Position.
                    DColor : dWord;          // Diffuse color.
                    U, V     : Single; // U and V for texture.
                    U2, V2   : single; // U and V for light map.
                  end;

var
  Form1: TForm1;

  FRAMECONTROL : dWord;
  DXReady      : boolean = false;
  WindowReady  : boolean = false;

  // Mesh
  VertexBuffer : IDirect3DVertexBuffer8 = NIL;
  MeshSource   : array[0..3] of TCustomVertex;

  // Texture
  Texture  : IDirect3DTexture8 = NIL;
  LightMap : IDirect3DTexture8 = NIL;

  // Matrices
  matWorld : TD3DXMatrix; // World
  matView  : TD3DXMatrix; // View
  matProj  : TD3DXMatrix; // Projection

  // Ambiental light.
  AmbColor : word = $000000;   // Black

  // Omnidirectional lights.
  Omni1 : TPointlight;
  Omni2 : TPointlight;
  Omni3 : TPointlight;

  // Spot lights
  Spot1 : TSpotlight;

const
  // Flexible vector format (FVF) description.
  // Describes the custom vertex structure (TCustomVertex).
  D3DFVF_CUSTOMVERTEX = D3DFVF_XYZ or D3DFVF_DIFFUSE or
                        D3DFVF_TEX1 or D3DFVF_TEX2;

  USETEXFILTER = true; // Use texture filtering.

  TEXTFILENAME = 'WALL.PNG';

  LIGHTMAPRES  = 16; // 16x16 16-bit lightmaps.

  WRN00 = 'Error initializing 3D Hardware.'#10+
          'Now software will be used...';
  ERR00 = 'Could not initialize DirectX Graphics.'#10+
          'You must have installed DirectX 8 or better '#10+
          'and a 16, 24 or 32 bpp desktop to run this sample.';
  ERR01 = 'Error initializing Vertex Buffer.';
  ERR02 = 'Error loading file: ';
  ERR03 = 'Error creating lightmap.';

// -------------------------------------------------------------------
  
implementation

{$R *.DFM}

// -------------------------------------------------------------------

procedure TForm1.Menu2Click(Sender: TObject);

begin
  Menu2.Checked := true;
end;

procedure TForm1.Menu3Click(Sender: TObject);

begin
  Menu3.Checked := true;
end;

procedure TForm1.Menu5Click(Sender: TObject);

begin
  Menu5.Checked := not Menu5.Checked;
end;

procedure TForm1.Menu6Click(Sender: TObject);

begin
  Menu6.Checked := not Menu6.Checked;
end;

procedure TForm1.Menu7Click(Sender: TObject);

begin
  Menu7.Checked := not Menu7.Checked;
end;

procedure TForm1.Menu8Click(Sender: TObject);

begin
  Menu8.Checked := not Menu8.Checked;
end;

procedure TForm1.Menu11Click(Sender: TObject);

begin
  Menu11.Checked := not Menu11.Checked;
end;

procedure TForm1.Menu9Click(Sender: TObject);

begin
  AmbColor := random($FFFFFF) and $1F1F1F;
end;

procedure TForm1.Menu10Click(Sender: TObject);

begin
  AmbColor := $000000;
end;

// -------------------------------------------------------------------

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
  MessageBox(Form1.Handle, _errMsg, 'Error', MB_ICONERROR);
  Application.Terminate;
end;

// -------------------------------------------------------------------

procedure AnimateLight;

var _time : dWord;

begin
  _time := GetTickCount;
  // Omni 1
  Omni1.Position.x := cos(_time/1500) * 0.5;
  Omni1.Position.y := cos(_time/1000) * 0.5;
  // Spot 1
  Spot1.Target.x := cos(_time/2500) * 1.0;
end;

// -------------------------------------------------------------------

procedure UpdateLightMap;

var _d3dr : TD3DLocked_Rect;
    _cursor : pWord;
    _x, _y  : longint;
    _u, _v  : single;
    _21x, _31x, _21y, _31y, _21z, _31z : single;
    _point  : TD3DXVector3;
    _normal : TD3DXVector3;
    _color  : word;
    _colorT : word;
    _useOmni1 : boolean;
    _useOmni2 : boolean;
    _useOmni3 : boolean;
    _useSpot1 : boolean;
    _lineinc : longint;

begin
  // Get face normal.
  _normal := FaceNormal(MeshSource[0].Position,
                        MeshSource[1].Position,
                        MeshSource[2].Position);

  // Wich lights must be used with this face ?
  _useOmni1 := (Form1.Menu5.Checked) and (PointFacesPlane(
                Omni1.Position, MeshSource[0].Position, _normal));
  _useOmni2 := (Form1.Menu6.Checked) and (PointFacesPlane(
                Omni2.Position, MeshSource[0].Position, _normal));
  _useOmni3 := (Form1.Menu7.Checked) and (PointFacesPlane(
                Omni3.Position, MeshSource[0].Position, _normal));
  _useSpot1 := (Form1.Menu11.Checked) and (PointFacesPlane(
                Spot1.Position, MeshSource[0].Position, _normal));

  // Initialize data for using GetPointInFace function.
  PIFInit(MeshSource[0].Position,
          MeshSource[1].Position,
          MeshSource[2].Position,
          _21x, _31x, _21y, _31y, _21z, _31z);

  // Make the lightmap.
  if not failed(LightMap.LockRect(0, _d3dr, NIL, 0)) then
    begin
      _cursor  := _d3dr.pBits;
      _lineinc := (_d3dr.Pitch shr 1) - LIGHTMAPRES;
      for _y := 0 to LIGHTMAPRES - 1 do
        begin
          for _x := 0 to LIGHTMAPRES - 1 do
            begin
              _u := (1.0 * _x) / (LIGHTMAPRES - 1);
              _v := (1.0 * _y) / (LIGHTMAPRES - 1);

              _point := PointInFace(MeshSource[0].Position,
                                    _21x, _31x, _21y, _31y, _21z, _31z,
                                    _u, _v);

              _color := AmbColor; // Get ambiental color.
              if _useOmni1 then // Omnidirectional light 1
                begin
                  _colorT := RGB8toRGB5(GetOmniColor(_point, Omni1));
                  _color := SumRGB5Colors(_color, _colorT);
                end;
              if _useOmni2 then // Omnidirectional light 2
                begin
                  _colorT := RGB8toRGB5(GetOmniColor(_point, Omni2));
                  _color := SumRGB5Colors(_color, _colorT);
                end;
              if _useOmni3 then // Omnidirectional light 3
                begin
                  _colorT := RGB8toRGB5(GetOmniColor(_point, Omni3));
                  _color := SumRGB5Colors(_color, _colorT);
                end;
              if _useSpot1 then // Spotlight 1
                begin
                  _colorT := RGB8toRGB5(GetSpotColor(_point, Spot1));
                  _color := SumRGB5Colors(_color, _colorT);
                end;
              _cursor^ := _color;
              inc(_cursor);
            end;
          inc(_cursor, _lineinc);
        end;
      LightMap.UnlockRect(0);
    end;
end;

// -------------------------------------------------------------------

procedure SetupMatrices;

var _v1, _v2, _v3 : TD3DXVector3;

begin
  // World.
  D3DXMatrixIdentity(matWorld);
  D3DDEV8.SetTransform(D3DTS_WORLD, matWorld);

  // Camera
  _v1 := D3DXVector3(0.0, 0.0, -2.0);
  _v2 := D3DXVector3(0.0, 0.0, 0.0);
  _v3 := D3DXVector3(0.0, 1.0, 0.0);

  // View.
  D3DXMatrixLookAtLH(matView, _v1, _v2, _v3);
  D3DDEV8.SetTransform(D3DTS_VIEW, matView);

  // Projection.
  D3DXMatrixPerspectiveFovLH(matProj, PI/4, 1{512/384}, 0.5, 10.0);
  D3DDEV8.SetTransform(D3DTS_PROJECTION, matProj);
end;

// -------------------------------------------------------------------

procedure RenderFrame(_hWnd: hWnd);

begin
  // Set Transform states.
  SetupMatrices;

  // Animate light
  AnimateLight;

  // Update lightmap.
  UpdateLightMap;

(*
  // Clear the back buffer to a black color.
//  D3DDEV8.Clear(0, NIL, D3DCLEAR_TARGET, $FF000000, 1.0, 0);
*)

  // Begin the scene.
  D3DDEV8.BeginScene;

  // Set the stream source.
  D3DDEV8.SetStreamSource(0, VertexBuffer, sizeof(TCustomVertex));

  // Set the vertex shader.
  D3DDEV8.SetVertexShader(D3DFVF_CUSTOMVERTEX);

  // Draw only lightmap ?
  if Form1.Menu8.Checked then
    begin
      D3DDEV8.SetTextureStageState(0, D3DTSS_TEXCOORDINDEX, 1);
      D3DDEV8.SetTextureStageState(0, D3DTSS_COLORARG1, D3DTA_TEXTURE);
      D3DDEV8.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE);
      D3DDEV8.SetTexture(0, LightMap);
      D3DDEV8.DrawPrimitive(D3DPT_TRIANGLESTRIP, 0, 2);
    end else
    begin
      // Draw using multi-pass
      if (Form1.Menu2.Checked) then
        begin
          // Draw the first textures normally.
          // Use the 1st set of tex coords.
          D3DDEV8.SetTextureStageState(0, D3DTSS_TEXCOORDINDEX, 0);
          D3DDEV8.SetTextureStageState(0, D3DTSS_COLORARG1, D3DTA_TEXTURE);
          D3DDEV8.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE);
          D3DDEV8.SetTexture(0, Texture);
          D3DDEV8.DrawPrimitive(D3DPT_TRIANGLESTRIP, 0, 2);

          // Draw the lightmap using blending,
          // with the 2nd set of tex coords
          D3DDEV8.SetTextureStageState(0, D3DTSS_TEXCOORDINDEX, 1);
          D3DDEV8.SetRenderState(D3DRS_ALPHABLENDENABLE, 1);
          D3DDEV8.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_ZERO);
          D3DDEV8.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_SRCCOLOR);
          D3DDEV8.SetTexture(0, LightMap);
          D3DDEV8.DrawPrimitive(D3DPT_TRIANGLESTRIP, 0, 2);

          // Restore state
          D3DDEV8.SetRenderState(D3DRS_ALPHABLENDENABLE, 0);
        end else
          begin // Draw using multi-texture
            // Texture States for first texture (0); the wall
            D3DDEV8.SetTextureStageState(0, D3DTSS_TEXCOORDINDEX, 0);
            D3DDEV8.SetTextureStageState(0, D3DTSS_COLORARG1, D3DTA_TEXTURE);
            D3DDEV8.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE);
            D3DDEV8.SetTexture(0, Texture);

            // Texture States for second texture (1); the lightmap
            D3DDEV8.SetTextureStageState(1, D3DTSS_TEXCOORDINDEX, 1);
            D3DDEV8.SetTextureStageState(1, D3DTSS_COLORARG1, D3DTA_TEXTURE);
            D3DDEV8.SetTextureStageState(1, D3DTSS_COLORARG2, D3DTA_CURRENT);
            D3DDEV8.SetTextureStageState(1, D3DTSS_COLOROP, D3DTOP_MODULATE);
            D3DDEV8.SetTexture(1, LightMap);

            // Draw mesh.
            D3DDEV8.DrawPrimitive(D3DPT_TRIANGLESTRIP, 0, 2);

            // Restore state
            D3DDEV8.SetTextureStageState(1, D3DTSS_COLOROP, D3DTOP_DISABLE);
          end;
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
  RenderFrame(Handle);
  while GetTickCount - FRAMECONTROL < 1 do Sleep(0);
  FRAMECONTROL := GetTickCount;
end;

// -------------------------------------------------------------------

function CustomVertex(_px, _py, _pz, _u, _v, _u2, _v2: single;
                      _color : dWord): TCustomVertex;

begin
  with Result do
   begin
     Position.x := _px;
     Position.y := _py;
     Position.z := _pz;
     DColor := _color;
     U := _u;
     V := _v;
     U2 := _u2;
     V2 := _v2;
   end;
end;

// -------------------------------------------------------------------

function InitVertexBuffer: boolean;

var _ptr : pByte;

begin
  Result := false;

  // Initialize the vertices.
  MeshSource[0] := CustomVertex( -1.0,  1.0,  0.0, 0, 0, 0, 0, $FFFFFFFF);
  MeshSource[1] := CustomVertex(  1.0,  1.0,  0.0, 2, 0, 1, 0, $FFFFFFFF);
  MeshSource[2] := CustomVertex( -1.0, -1.0,  0.0, 0, 2, 0, 1, $FFFFFFFF);
  MeshSource[3] := CustomVertex(  1.0, -1.0,  0.0, 2, 2, 1, 1, $FFFFFFFF);

  // Create a vertex buffer.
  if failed(D3DDEV8.CreateVertexBuffer(SizeOf(MeshSource), 0,
                                       D3DFVF_CUSTOMVERTEX,
                                       D3DPOOL_DEFAULT,
                                       VertexBuffer)) then exit;

  // Lock, fill and unlock vertex buffer.
  if failed(VertexBuffer.Lock(0, SizeOf(MeshSource), _ptr, 0)) then exit;
  Move(MeshSource, _ptr^, SizeOf(MeshSource));
  VertexBuffer.Unlock;

  // All right
  Result := true;
end;

// -------------------------------------------------------------------

procedure TForm1.FormActivate(Sender: TObject);

var _filt : dWord;

begin
  Randomize;
  FRAMECONTROL := GetTickCount;

  // Initialize application events
  Application.OnIdle       := AppOnIdle;
  Application.OnActivate   := AppOnActivate;
  Application.OnDeactivate := AppOnDeactivate;
  Application.OnRestore    := AppOnActivate;
  Application.OnMinimize   := AppOnDeActivate;

  // Initialize Direct Graphics (first try with Hardware Accel. (HAL))
  if not InitDGfx(Handle, false, 0, 0, 0, 0, true, false) then
    begin
      MessageBox(0, WRN00, 'Warning.', MB_ICONWARNING);
      CloseDGfx;
      if not InitDGfx(Handle, false, 0, 0, 0, 0, false, false) then
        begin hHalt(ERR00); exit; end;
    end;

  // Initialize VertexBuffer
  if not InitVertexBuffer then begin hHalt(ERR01); exit; end;

  // Device supports multitexturing ?
  Menu3.Enabled := (D3DDEVCAPS8.MaxSimultaneousTextures > 1);

  // Device supports bilinear filter ?
  _filt := (D3DPTFILTERCAPS_MAGFLINEAR or D3DPTFILTERCAPS_MINFLINEAR);

  if (USETEXFILTER)
   and (D3DDEVCAPS8.TextureFilterCaps and _filt = _filt) then
    begin
      D3DDEV8.SetTextureStageState(0, D3DTSS_MAGFILTER, D3DTEXF_LINEAR);
      D3DDEV8.SetTextureStageState(0, D3DTSS_MINFILTER, D3DTEXF_LINEAR);
      if (D3DDEVCAPS8.MaxSimultaneousTextures > 1) then
        begin
          D3DDEV8.SetTextureStageState(1, D3DTSS_MAGFILTER, D3DTEXF_LINEAR);
          D3DDEV8.SetTextureStageState(1, D3DTSS_MINFILTER, D3DTEXF_LINEAR);
        end;
    end;

  // Turn off D3D lighting, since we are providing
  // our own vertex colors.
  D3DDEV8.SetRenderState(D3DRS_LIGHTING, 0);

  // Enable dithering
  D3DDEV8.SetRenderState(D3DRS_DITHERENABLE, 1);

  // Create texture for lighmap.
  if failed(D3DXCreateTexture(D3DDEV8, LIGHTMAPRES, LIGHTMAPRES, 1,
                          0, D3DFMT_A1R5G5B5, D3DPOOL_MANAGED, LightMap)) then
    begin hHalt(ERR03); exit; end;

  // Load texture.
  if failed(D3DXCreateTextureFromFileA(D3DDEV8, TEXTFILENAME, Texture)) then
    begin hHalt(ERR02 + TEXTFILENAME); exit; end;

  // Initialize ommnidirectional lights.
  Omni1 := Pointlight(D3DXVector3( 0.0,  0.0, -0.25), 0.5, 1.0, $FFFFFF);
  Omni2 := Pointlight(D3DXVector3( 1.0,  1.0, -0.1),  0.5, 1.5, $00FF00);
  Omni3 := Pointlight(D3DXVector3(-1.0, -1.0, -0.1),  0.5, 1.5, $0000FF);

  // Initialize spot lights.
  Spot1 := Spotlight(D3DXVector3( 0.0, -1.5, -0.25),
                     D3DXVector3( 0.0,  0.0,  0.0),
                     PI/32, PI/8, 1.0, 3.5, $FFFFFF);

  // All ok
  DXReady := true;
end;

// -------------------------------------------------------------------

procedure TForm1.FormDestroy(Sender: TObject);

begin
  DXReady := false;
  // Free textures
  LightMap := NIL;
  Texture := NIL;
  // Free Vertex Buffer
  VertexBuffer := NIL;
  // Free DX
  CloseDGfx;
end;

// -------------------------------------------------------------------

end.
