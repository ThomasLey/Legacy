object frmCDSelect: TfrmCDSelect
  Left = 579
  Top = 251
  BorderStyle = bsDialog
  Caption = 'CD ausw�hlen'
  ClientHeight = 313
  ClientWidth = 377
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 361
    Height = 265
    Caption = 'CD ausw�hlen'
    TabOrder = 0
    object INIContents: TComboBox
      Left = 8
      Top = 16
      Width = 345
      Height = 21
      ItemHeight = 13
      TabOrder = 0
      OnClick = INIContentsClick
    end
    object lsbCDs: TListBox
      Left = 8
      Top = 40
      Width = 345
      Height = 217
      ItemHeight = 13
      Sorted = True
      TabOrder = 1
      OnClick = lsbCDsClick
    end
  end
  object BitBtn1: TBitBtn
    Left = 272
    Top = 280
    Width = 99
    Height = 25
    Caption = '&OK'
    TabOrder = 1
    OnClick = BitBtn1Click
  end
  object BitBtn2: TBitBtn
    Left = 166
    Top = 280
    Width = 99
    Height = 25
    Caption = '&Abbrechen'
    TabOrder = 2
    OnClick = BitBtn2Click
  end
  object BitBtn3: TBitBtn
    Left = 6
    Top = 280
    Width = 99
    Height = 25
    Caption = '&Neu...'
    Enabled = False
    TabOrder = 3
  end
end
