{
  DX8GFX - DirectGraphics 8 unit.
  Copyright © 2001 Lord Trancos.
  <lordtrancos@softhome.net>
}

unit DX8GFX;

// --------------------------------------------------------------------

interface

uses Windows, DirectXGraphics;

var
  D3D8        : IDirect3D8 = NIL;
  D3DDEV8     : IDirect3DDevice8 = NIL;
  D3DDEVCAPS8 : TD3DCaps8;

// Main functions.
function  InitDGfx(_hWnd: hWnd; _fullScreen: boolean;
                   _width, _height, _bpp, _backbufferCount: longint;
                   _HAL, _ZBuffer: boolean): boolean;
procedure CloseDGfx;

// --------------------------------------------------------------------

implementation

// --------------------------------------------------------------------
// Name : InitDGfx
// Desc : Initializes DirectGraphics.
//        _bpp - 16 or 32 bits per pixel.
//        _HAL - Use 3D Hardware.
// --------------------------------------------------------------------

function InitDGfx(_hWnd: hWnd; _fullScreen: boolean;
                  _width, _height, _bpp, _backbufferCount: longint;
                  _HAL, _ZBuffer: boolean): boolean;

var
  _d3dpp : TD3DPresent_Parameters;
  _d3ddm : TD3DDisplayMode;
  _dtype : TD3DDevType;

begin
  Result := false;

  // Create a Direct3D device.
  D3D8 := Direct3DCreate8(D3D_SDK_VERSION);
  if D3D8 = NIL then exit;

  // Set Present Parameters
  Fillchar(_d3dpp, sizeof(_d3dpp), 0);
  with _d3dpp do
    begin
      Windowed      := not _fullScreen;
      hDeviceWindow := _hWnd;
      if _ZBuffer then
        begin
          EnableAutoDepthStencil := true;
          AutoDepthStencilFormat := D3DFMT_D16; // 16-bit z-Buffer
        end;
      if (_fullScreen) then
        begin // FullScreen
          BackBufferWidth  := _width;
          BackBufferHeight := _height;
          case _bpp of
//            15 : BackBufferFormat := D3DFMT_X1R5G5B5;
            16 : BackBufferFormat := D3DFMT_R5G6B5;
//            24 : BackBufferFormat := D3DFMT_X8R8G8B8;
            32 : BackBufferFormat := D3DFMT_A8R8G8B8;
            else begin D3D8 := NIL; exit; end;
          end;
          BackBufferCount := _backbufferCount;
          SwapEffect      := D3DSWAPEFFECT_DISCARD;
        end else begin // Windowed mode
                   // Retrieve the current display mode.
                   if failed(D3D8.GetAdapterDisplayMode(
                             D3DADAPTER_DEFAULT, _d3ddm)) then
                      begin D3D8 := NIL; exit; end;
                   SwapEffect := D3DSWAPEFFECT_DISCARD;
                   BackBufferFormat := _d3ddm.Format;
                 end;
    end;

  // Create the Direct3D device.
  if _hal then _dtype := D3DDEVTYPE_HAL else _dtype := D3DDEVTYPE_REF;
  if failed(D3D8.CreateDevice(D3DADAPTER_DEFAULT, _dtype, _hWnd,
                              D3DCREATE_SOFTWARE_VERTEXPROCESSING,
                              _d3dpp, D3DDEV8)) then
    begin D3D8 := NIL; exit; end;

  // Get Device Caps.
  FillChar(D3DDEVCAPS8, SizeOf(D3DDEVCAPS8), 0);
  if failed(D3DDEV8.GetDeviceCaps(D3DDEVCAPS8)) then
    begin D3DDEV8 := NIL; D3D8 := NIL; exit; end;

  // All right.
  Result := true;
end;

// --------------------------------------------------------------------
// Name : InitDGfx
// Desc : Closes DirectGraphics.
// --------------------------------------------------------------------

procedure CloseDGfx;

begin
  if assigned(D3DDEV8) then D3DDEV8 := NIL;
  if assigned(D3D8) then D3D8 := NIL;
end;

// --------------------------------------------------------------------

end.
