unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, DirectXGraphics, DX8GFX, D3DX8, Menus;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    Menu1: TMenuItem;
    Menu2: TMenuItem;
    Menu3: TMenuItem;
    procedure AppOnIdle(Sender: TObject; var Done: Boolean);
    procedure AppOnActivate(Sender: TObject);
    procedure AppOnDeactivate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Menu3Click(Sender: TObject);
    procedure Menu2Click(Sender: TObject);
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

  Texture1 : IDirect3DTexture8;
  Texture2 : IDirect3DTexture8;

  // Matrices
  matWorld : TD3DXMatrix; // World
  matView  : TD3DXMatrix; // View
  matProj  : TD3DXMatrix; // Projection

type
  // The structure of the custom vertex.
  PCustomVertex = ^TCustomVertex;
  TCustomVertex = record
                    Position : TD3DXVector3; // Position
                    U, V     : Single;
                    U2, V2   : single; // U and V for lightmap
                  end;

const
  // Flexible vector format (FVF) description.
  // Describes the custom vertex structure (TCustomVertex).
  D3DFVF_CUSTOMVERTEX = D3DFVF_XYZ or D3DFVF_TEX1 or D3DFVF_TEX2;

  // Number of faces
  FACENUM = 2;

const
  TEXTFILENAME1 = 'WALL.PNG';
  TEXTFILENAME2 = 'LIGHTMAP.PNG';

  WRN00 = 'Error initializing 3D Hardware.'#10+
          'Now software will be used...';
  ERR00 = 'Could not initialize DirectX Graphics.'#10+
          'You must have installed DirectX 8 or better '#10+
          'and a 16, 24 or 32 bpp desktop to run this sample.';
  ERR01 = 'Error initializing Vertex Buffer.';
  ERR02 = 'Error loading file: ';

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

procedure SetMaterial;

var _mat : TD3DMaterial8;

begin
  // Set Material
  FillChar(_mat, sizeof(_mat), 0 );
  with _mat do
    begin
      Ambient.r := 1.0;
      Ambient.g := 1.0;
      Ambient.b := 1.0;
      Ambient.a := 1.0;
      D3DDEV8.SetMaterial(_mat);
    end;
end;

// -------------------------------------------------------------------

procedure SetupMatrices;

var _v1, _v2, _v3 : TD3DXVector3;
    _time : dWord;

begin
  // World.
  D3DXMatrixIdentity(matWorld);
  D3DDEV8.SetTransform(D3DTS_WORLD, matWorld);

  // Rotate the camera
  _time := GetTickCount;
  _v1.x := -cos(_time/3000.0) * 2.0;
  _v1.y := 0.0;
  _v1.z :=  sin(_time/3000.0) * 2.0;
  _v2 := D3DXVector3(0.0, 0.0, 0.0);
  _v3 := D3DXVector3(0.0, 1.0, 0.0);

  // View.
  D3DXMatrixLookAtLH(matView, _v1, _v2, _v3);
  D3DDEV8.SetTransform(D3DTS_VIEW, matView);

  // Projection.
  D3DXMatrixPerspectiveFovLH(matProj, PI/4, 1, 0.5, 10.0);
  D3DDEV8.SetTransform(D3DTS_PROJECTION, matProj);
end;

// -------------------------------------------------------------------

procedure AnimateLightMap(_timeelapsed: longint);

var _ptr : PCustomVertex;
    _dec : boolean;
    _c : longint;

begin
  if not failed(VertexBuffer.Lock(0, 0, pByte(_ptr), 0)) then
    begin
      _dec := (_ptr^.U2 > 1.0);
      for _c := 0 to (FACENUM * 3) - 1 do
        begin
          _ptr^.U2 := _ptr^.U2 + 0.001 * _timeelapsed;
          if _dec then _ptr^.U2 := _ptr^.U2 - 1.0;
          inc(_ptr);
        end;
      VertexBuffer.Unlock;
    end;
end;

// -------------------------------------------------------------------

procedure RenderFrame(_hWnd: hWnd);

begin
  // Clear the back buffer.
  D3DDEV8.Clear(0, NIL, D3DCLEAR_TARGET, $FF000080, 1.0, 0);

  // Begin the scene.
  D3DDEV8.BeginScene;

  // Set Transform states.
  SetupMatrices;

  // Set the stream source.
  D3DDEV8.SetStreamSource(0, VertexBuffer, sizeof(TCustomVertex));

  // Set the vertex shader.
  D3DDEV8.SetVertexShader(D3DFVF_CUSTOMVERTEX);

  // Draw using multi-pass
  if (Form1.Menu2.Checked) then
    begin
      // Draw the first textures normally.
      // Use the 1st set of tex coords.
      D3DDEV8.SetTextureStageState(0, D3DTSS_TEXCOORDINDEX, 0);
      D3DDEV8.SetTextureStageState(0, D3DTSS_COLORARG1, D3DTA_TEXTURE);
      D3DDEV8.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE);
      D3DDEV8.SetTexture(0, Texture1);
      D3DDEV8.DrawPrimitive(D3DPT_TRIANGLELIST, 0, FACENUM);

      // Draw the lightmap using blending,
      // with the 2nd set of tex coords
      D3DDEV8.SetTextureStageState(0, D3DTSS_TEXCOORDINDEX, 1);
      D3DDEV8.SetRenderState(D3DRS_ALPHABLENDENABLE, 1);
      D3DDEV8.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_ZERO);
      D3DDEV8.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_SRCCOLOR);
      D3DDEV8.SetTexture(0, Texture2);
      D3DDEV8.DrawPrimitive(D3DPT_TRIANGLELIST, 0, FACENUM);

      // Restore state
      D3DDEV8.SetRenderState(D3DRS_ALPHABLENDENABLE, 0);
    end else
      begin // Draw using multi-texture
        // Texture States for first texture (0); the wall
        D3DDEV8.SetTextureStageState(0, D3DTSS_TEXCOORDINDEX, 0);
        D3DDEV8.SetTextureStageState(0, D3DTSS_COLORARG1, D3DTA_TEXTURE);
        D3DDEV8.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE);
        D3DDEV8.SetTexture(0, Texture1);

        // Texture States for second texture (1); the lightmap
        D3DDEV8.SetTextureStageState(1, D3DTSS_TEXCOORDINDEX, 1);
        D3DDEV8.SetTextureStageState(1, D3DTSS_COLORARG1, D3DTA_TEXTURE);
        D3DDEV8.SetTextureStageState(1, D3DTSS_COLORARG2, D3DTA_CURRENT);
        D3DDEV8.SetTextureStageState(1, D3DTSS_COLOROP, D3DTOP_MODULATE);
        D3DDEV8.SetTexture(1, Texture2);

        // Draw mesh.
        D3DDEV8.DrawPrimitive(D3DPT_TRIANGLELIST, 0, FACENUM);

        // Restore state
        D3DDEV8.SetTextureStageState(1, D3DTSS_COLOROP, D3DTOP_DISABLE);
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
  AnimateLightMap(GetTickCount - FRAMECONTROL);
  FRAMECONTROL := GetTickCount;
end;

// -------------------------------------------------------------------

function GetCustomVertex(_px, _py, _pz, _u, _v: single): TCustomVertex;

begin
  with Result do
   begin
     Position.x := _px;
     Position.y := _py;
     Position.z := _pz;
     U := _u;
     V := _v;
     U2 := _u;
     V2 := _v;
   end;
end;

// -------------------------------------------------------------------

function InitVertexBuffer: boolean;

var _vb  : array[0..5] of TCustomVertex;
    _ptr : pByte;

begin
  Result := false;

  // Initialize the vertices.
  _vb[ 0] := GetCustomVertex( -1.0, -1.0,  0.0, 0.0, 1.0);
  _vb[ 1] := GetCustomVertex(  1.0,  1.0,  0.0, 1.0, 0.0);
  _vb[ 2] := GetCustomVertex(  1.0, -1.0,  0.0, 1.0, 1.0);

  _vb[ 3] := _vb[0];
  _vb[ 4] := GetCustomVertex( -1.0,  1.0,  0.0, 0.0, 0.0);
  _vb[ 5] := _vb[1];

  // Create a vertex buffer.
  if failed(D3DDEV8.CreateVertexBuffer(SizeOf(_vb), 0,
                                       D3DFVF_CUSTOMVERTEX,
                                       D3DPOOL_DEFAULT,
                                       VertexBuffer)) then exit;

  // Lock, fill and unlock vertex buffer.
  if failed(VertexBuffer.Lock(0, SizeOf(_vb), _ptr, 0)) then exit;
  Move(_vb, _ptr^, SizeOf(_vb));
  VertexBuffer.Unlock;

  // All right
  Result := true;
end;

// -------------------------------------------------------------------

procedure TForm1.FormActivate(Sender: TObject);

var _filt : dWord;

begin
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

  // Set Material
  SetMaterial;

  // Device supports multitexturing ?
  Menu3.Enabled := (D3DDEVCAPS8.MaxSimultaneousTextures > 1);

  // Device supports bilinear filter ?
  _filt := (D3DPTFILTERCAPS_MAGFLINEAR or D3DPTFILTERCAPS_MINFLINEAR);
  if (D3DDEVCAPS8.TextureFilterCaps and _filt = _filt) then
    begin
      D3DDEV8.SetTextureStageState(0, D3DTSS_MAGFILTER, D3DTEXF_LINEAR);
      D3DDEV8.SetTextureStageState(0, D3DTSS_MINFILTER, D3DTEXF_LINEAR);
      if (D3DDEVCAPS8.MaxSimultaneousTextures > 1) then
        begin
          D3DDEV8.SetTextureStageState(1, D3DTSS_MAGFILTER, D3DTEXF_LINEAR);
          D3DDEV8.SetTextureStageState(1, D3DTSS_MINFILTER, D3DTEXF_LINEAR);
        end;
    end;

  // Disable culling.
  D3DDEV8.SetRenderState(D3DRS_CULLMODE, D3DCULL_NONE);

  // Set ambiental light.
  D3DDEV8.SetRenderState(D3DRS_AMBIENT, $FFFFFF);

  // Enable dithering
  D3DDEV8.SetRenderState(D3DRS_DITHERENABLE, 1);

  // Load textures.
  if failed(D3DXCreateTextureFromFileA(D3DDEV8, TEXTFILENAME1, Texture1)) then
    begin hHalt(ERR02 + TEXTFILENAME1); exit; end;
  if failed(D3DXCreateTextureFromFileA(D3DDEV8, TEXTFILENAME2, Texture2)) then
    begin hHalt(ERR02 + TEXTFILENAME2); exit; end;

  // All ok
  DXReady := true;
end;

// -------------------------------------------------------------------

procedure TForm1.FormDestroy(Sender: TObject);

begin
  DXReady := false;
  // Free textures
  Texture1 := NIL;
  Texture2 := NIL;
  // Free Vertex Buffer
  VertexBuffer := NIL;
  // Free DX
  CloseDGfx;
end;

// -------------------------------------------------------------------

end.
