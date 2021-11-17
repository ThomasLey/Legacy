object Form1: TForm1
  Left = 251
  Top = 112
  Width = 783
  Height = 540
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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 241
    Height = 513
    Align = alLeft
    Caption = 'Panel1'
    TabOrder = 0
    object FileListBox1: TFileListBox
      Left = 16
      Top = 136
      Width = 177
      Height = 337
      ItemHeight = 13
      TabOrder = 0
    end
    object FilterComboBox1: TFilterComboBox
      Left = 16
      Top = 480
      Width = 177
      Height = 21
      TabOrder = 1
    end
  end
  object Button1: TButton
    Left = 296
    Top = 96
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 296
    Top = 144
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 2
    OnClick = Button2Click
  end
end
