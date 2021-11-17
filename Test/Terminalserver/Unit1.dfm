object Form1: TForm1
  Left = 192
  Top = 103
  Width = 696
  Height = 560
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
  object Term: TMsTscAx
    Left = 0
    Top = 0
    Width = 688
    Height = 480
    Align = alClient
    TabOrder = 0
    ControlData = {
      0003000008000200000000000800020000000000080002000000000008000200
      00000000030000000000}
  end
  object Panel1: TPanel
    Left = 0
    Top = 480
    Width = 688
    Height = 53
    Align = alBottom
    TabOrder = 1
    object Button1: TButton
      Left = 8
      Top = 8
      Width = 97
      Height = 33
      Caption = 'Verbinden'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 120
      Top = 16
      Width = 89
      Height = 17
      Caption = 'Trennen'
      TabOrder = 1
      OnClick = Button2Click
    end
  end
end
