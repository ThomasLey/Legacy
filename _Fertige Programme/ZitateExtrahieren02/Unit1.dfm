object Form1: TForm1
  Left = 355
  Top = 196
  Width = 681
  Height = 513
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
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 553
    Height = 161
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssBoth
    TabOrder = 0
    WantReturns = False
    WordWrap = False
  end
  object Button1: TButton
    Left = 568
    Top = 144
    Width = 97
    Height = 81
    Caption = 'JustDoIt'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Memo2: TMemo
    Left = 8
    Top = 200
    Width = 553
    Height = 281
    Lines.Strings = (
      'Memo2')
    ScrollBars = ssBoth
    TabOrder = 2
    WantReturns = False
    WordWrap = False
  end
  object Edit1: TEdit
    Left = 8
    Top = 174
    Width = 553
    Height = 21
    TabOrder = 3
    Text = 'Edit1'
  end
  object OpenDialog: TOpenDialog
    DefaultExt = '*.txt'
    Filter = 'Textdateien|*.txt'
    Left = 480
    Top = 24
  end
  object SaveDialog: TSaveDialog
    DefaultExt = '*.txt'
    Filter = 'Textdateien|*.txt'
    Left = 480
    Top = 64
  end
end
