object LIRCSocketForm: TLIRCSocketForm
  Left = 381
  Top = 211
  Width = 249
  Height = 249
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  Caption = 'LIRC-Receive übersicht:'
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
  object LastInput: TEdit
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
  end
  object bConnect: TButton
    Left = 32
    Top = 40
    Width = 75
    Height = 25
    Caption = 'Verbinden'
    TabOrder = 1
    OnClick = bConnectClick
  end
  object bDisconnect: TButton
    Left = 88
    Top = 40
    Width = 75
    Height = 25
    Caption = 'Trennen'
    Enabled = False
    TabOrder = 2
    OnClick = bDisconnectClick
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
  object bClearHistory: TButton
    Left = 48
    Top = 64
    Width = 75
    Height = 25
    Caption = 'Verlauf löschen'
    TabOrder = 5
    OnClick = bClearHistoryClick
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 203
    Width = 417
    Height = 19
    Panels = <>
    SimplePanel = False
  end
  object tStart: TTimer
    Interval = 1
    OnTimer = tStartTimer
  end
end
