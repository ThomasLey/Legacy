object Form1: TForm1
  Left = 649
  Top = 457
  Width = 467
  Height = 342
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Edit1: TEdit
    Left = 0
    Top = 0
    Width = 417
    Height = 39
    AutoSize = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Courier New'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    Text = 'Edit1'
  end
  object Button1: TButton
    Left = 32
    Top = 40
    Width = 75
    Height = 25
    Caption = 'con'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 88
    Top = 40
    Width = 75
    Height = 25
    Caption = 'discon'
    Enabled = False
    TabOrder = 2
    OnClick = Button2Click
  end
  object History: TListBox
    Left = 8
    Top = 88
    Width = 121
    Height = 97
    ItemHeight = 13
    TabOrder = 3
  end
  object Button11: TButton
    Left = 48
    Top = 64
    Width = 75
    Height = 25
    Caption = 'clear'
    TabOrder = 5
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 296
    Width = 459
    Height = 19
    Panels = <>
    SimplePanel = False
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
  end
  object WinSock1: TWSocket
    Proto = 'tcp'
    MultiThreaded = False
    OnDataAvailable = WinSock1DataAvailable
    OnError = Winsock1Error
    FlushTimeout = 60
    SendFlags = wsSendNormal
    LingerOnOff = wsLingerOn
    LingerTimeout = 0
    Left = 176
    Top = 88
  end
end
