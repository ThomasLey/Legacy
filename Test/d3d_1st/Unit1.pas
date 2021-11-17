unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  DXDraws, DXClass, D3DUtils, DirectX;

type
  TForm1 = class(TDXForm)
    DXDraw: TDXDraw;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    DXTimer: TDXTimer;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure DXTimerActivate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1                    : TForm1;
  n0, n1, n2, n3           : TD3DVector;
  tetEcken                 : Array[0..11] of TD3DVertex;
implementation

{$R *.DFM}

function MakeD3DNormVector(a, b: TD3DVector): TD3DVector;
begin
     result.x := a.y*b.z - a.z*b.y;
     result.y := a.z*b.x - a.x*b.z;
     result.z := a.x*b.y - a.y*b.z;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
     DXDraw.Initialize();
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
     n0 := MakeD3DVector(+0.0, +0.0, +1.0); // Boden
     n1 := MakeD3DVector(+1.0, +0.0, +0.0); // Hinten
     n2 := MakeD3DVector(+0.0, +1.0, +0.0); // Vorne Links
     n3 := MakeD3DVector(-1.0, -1.0, -1.0); // Vorne Rechts

     tetEcken[0] := MakeD3DVertex(MakeD3DVector(0.0, 0.0, 0.0), n0, 0, 0);
     tetEcken[1] := MakeD3DVertex(MakeD3DVector(1.0, 0.0, 0.0), n0, 0, 0);
     tetEcken[2] := MakeD3DVertex(MakeD3DVector(0.0, 1.0, 0.0), n0, 0, 0);

     tetEcken[3] := MakeD3DVertex(MakeD3DVector(0.0, 0.0, 0.0), n1, 0, 0);
     tetEcken[4] := MakeD3DVertex(MakeD3DVector(0.0, 1.0, 0.0), n1, 0, 0);
     tetEcken[5] := MakeD3DVertex(MakeD3DVector(0.0, 0.0, 1.0), n1, 0, 0);

     tetEcken[6] := MakeD3DVertex(MakeD3DVector(0.0, 0.0, 0.0), n2, 0, 0);
     tetEcken[7] := MakeD3DVertex(MakeD3DVector(1.0, 0.0, 0.0), n2, 0, 0);
     tetEcken[8] := MakeD3DVertex(MakeD3DVector(0.0, 0.0, 1.0), n2, 0, 0);

     tetEcken[9] := MakeD3DVertex(MakeD3DVector(1.0, 0.0, 0.0), n3, 0, 0);
     tetEcken[10] := MakeD3DVertex(MakeD3DVector(0.0, 1.0, 0.0), n3, 0, 0);
     tetEcken[11] := MakeD3DVertex(MakeD3DVector(0.0, 0.0, 1.0), n3, 0, 0);
end;

procedure FrameMovie(Time: Double);
var
  matView, matRotate: TD3DMatrix;
begin
  // Set the view matrix so that the camera is backed out along the z-axis,
  // and looks down on the cube (rotating along the x-axis by -0.5 radians).
  FilLChar(matView, SizeOf(matView), 0);
  matView._11 := 1.0;
  matView._22 :=  cos(-0.5);
  matView._23 :=  sin(-0.5);
  matView._32 := -sin(-0.5);
  matView._33 :=  cos(-0.5);
  matView._43 := 5.0;
  matView._44 := 1.0;
  Form1.DXDraw.D3DDevice7.SetTransform( D3DTRANSFORMSTATE_VIEW, matView);

  // Set the world matrix to rotate along the y-axis, in sync with the
  // timekey
  FilLChar(matRotate, SizeOf(matRotate), 0);
  matRotate._11 :=  cos(-Time);
  matRotate._13 :=  sin(Time);
  matRotate._22 :=  1.0;
  matRotate._31 := -sin(Time);
  matRotate._33 :=  cos(Time);
  matRotate._44 :=  1.0;
  Form1.DXDraw.D3DDevice7.SetTransform( D3DTRANSFORMSTATE_WORLD, matRotate);
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  vp: TD3DViewport7;
  mtrl: TD3DMaterial7;
  matProj: TD3DMatrix;
begin
  { Viewport }
  FillChar(vp, SizeOf(vp), 0);
  vp.dwX := 0;
  vp.dwY := 0;
  vp.dwWidth := DXDraw.SurfaceWidth;
  vp.dwHeight := DXDraw.SurfaceHeight;
  vp.dvMinZ := 0.0;
  vp.dvMaxZ := 1.0;

  DXDraw.D3DDevice7.SetViewport(vp);

  {  Material  }
  FillChar(mtrl, SizeOf(mtrl), 0);
  mtrl.ambient.r := 0.0;
  mtrl.ambient.g := 1.0;
  mtrl.ambient.b := 0.0;
  mtrl.diffuse.r := 1.0;
  mtrl.diffuse.g := 1.0;
  mtrl.diffuse.b := 1.0;
  DXDraw.D3DDevice7.SetMaterial( mtrl );
  DXDraw.D3DDevice7.SetRenderState( D3DRENDERSTATE_AMBIENT, $ffffffff);

  // Set the projection matrix. Note that the view and world matrices are
  // set in the App_FrameMove() function, so they can be animated each
  // frame.
  FilLChar(matProj, SizeOf(matProj), 0);
  matProj._11 :=  2.0;
  matProj._22 :=  2.0;
  matProj._33 :=  1.0;
  matProj._34 :=  1.0;
  matProj._43 := -1.0;
  DXDraw.D3DDevice7.SetTransform( D3DTRANSFORMSTATE_PROJECTION, matProj );
  { Make CUBE }
//  MakeCUBE;
end;

procedure TForm1.DXTimerActivate(Sender: TObject);
var
  r: TD3DRect;
begin
  if not DXDraw.CanDraw then Exit;

  { Frame Movie }
  FrameMovie(GetTickCount/1000);

  {  Clear Screen  }
  r.x1 := 0;
  r.y1 := 0;
  r.x2 := DXDraw.SurfaceWidth;
  r.y2 := DXDraw.SurfaceHeight;
  if DXDraw.ZBuffer<>nil then
    DXDraw.D3DDevice7.Clear(1, r, D3DCLEAR_TARGET or D3DCLEAR_ZBUFFER, $000000, 1, 0)
  else
    DXDraw.D3DDevice7.Clear(1, r, D3DCLEAR_TARGET, $000000, 1, 0);

  { Draw Screen }
  asm FINIT end;
  DXDraw.D3DDevice7.BeginScene;
{
  Form1.DXDraw.D3DDevice7.DrawPrimitive(D3DPT_TRIANGLESTRIP, D3DFVF_VERTEX, g_pCubeVertices[0], 4, 0);
  Form1.DXDraw.D3DDevice7.DrawPrimitive(D3DPT_TRIANGLESTRIP, D3DFVF_VERTEX, g_pCubeVertices[4], 4, 0);
  Form1.DXDraw.D3DDevice7.DrawPrimitive(D3DPT_TRIANGLESTRIP, D3DFVF_VERTEX, g_pCubeVertices[8], 4, 0);
  Form1.DXDraw.D3DDevice7.DrawPrimitive(D3DPT_TRIANGLESTRIP, D3DFVF_VERTEX, g_pCubeVertices[12], 4, 0);
  Form1.DXDraw.D3DDevice7.DrawPrimitive(D3DPT_TRIANGLESTRIP, D3DFVF_VERTEX, g_pCubeVertices[16], 4, 0);
  Form1.DXDraw.D3DDevice7.DrawPrimitive(D3DPT_TRIANGLESTRIP, D3DFVF_VERTEX, g_pCubeVertices[20], 4, 0);

  Form1.DXDraw.D3DDevice7.EndScene;
  asm FINIT end;
}
  { Draw FrameRate }
  with Form1.DXDraw.Surface.Canvas do
  begin
    try
      Brush.Style := bsClear;
      Font.Color := clWhite;
      Font.Size := 12;
      Textout(0, 0, 'FPS: '+inttostr(DXTimer.FrameRate));
      if doHardware in DXDraw.NowOptions then
        Textout(0, 14, 'Device: Hardware')
      else
        Textout(0, 14, 'Device: Software');
    finally
      Release; {  Indispensability  }
    end;
  end;

  Form1.DXDraw.Flip;
end;

end.
