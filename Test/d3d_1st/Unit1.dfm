object Form1: TForm1
  Left = 156
  Top = 266
  Width = 749
  Height = 429
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object DXDraw: TDXDraw
    Left = 8
    Top = 8
    Width = 369
    Height = 249
    AutoInitialize = True
    AutoSize = True
    Color = clBtnFace
    Display.BitCount = 16
    Display.FixedBitCount = True
    Display.FixedRatio = True
    Display.FixedSize = False
    Options = [doAllowReboot, doWaitVBlank, doCenter, do3D, doDirectX7Mode, doHardware, doSelectDriver]
    SurfaceHeight = 249
    SurfaceWidth = 369
    TabOrder = 0
  end
  object Button1: TButton
    Left = 384
    Top = 8
    Width = 177
    Height = 25
    Caption = 'Initialize'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 384
    Top = 72
    Width = 177
    Height = 25
    Caption = 'Tetraeder kreieren'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 384
    Top = 40
    Width = 177
    Height = 25
    Caption = 'Init Surface (TDXDraw)'
    TabOrder = 3
    OnClick = Button3Click
  end
  object DXTimer: TDXTimer
    ActiveOnly = True
    Enabled = True
    Interval = 1
    OnActivate = DXTimerActivate
    Left = 576
    Top = 8
  end
end
