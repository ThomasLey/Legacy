object LIRCSocketForm: TLIRCSocketForm
  Left = 308
  Top = 215
  Width = 112
  Height = 414
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
  PixelsPerInch = 96
  TextHeight = 13
  object History: TListBox
    Left = 0
    Top = 46
    Width = 104
    Height = 322
    Align = alClient
    ItemHeight = 13
    TabOrder = 0
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 368
    Width = 104
    Height = 19
    Panels = <>
    SimplePanel = False
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 104
    Height = 46
    Align = alTop
    TabOrder = 2
    object LastInput: TEdit
      Left = 2
      Top = 3
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
  end
end
