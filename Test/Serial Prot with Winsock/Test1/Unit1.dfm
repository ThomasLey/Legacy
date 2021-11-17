object Form1: TForm1
  Left = 247
  Top = 109
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
  object Winsock1: TWinsock
    Left = 0
    Top = 48
    Width = 28
    Height = 28
    OnError = Winsock1Error
    OnDataArrival = Winsock1DataArrival
    ControlData = {
      2143341208000000E5020000E502000092D88D24000006000000000000000000
      0000000000000000}
  end
  object History: TListBox
    Left = 8
    Top = 88
    Width = 121
    Height = 97
    ItemHeight = 13
    TabOrder = 4
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
end
