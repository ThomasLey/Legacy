object Form1: TForm1
  Left = 192
  Top = 107
  Width = 881
  Height = 618
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = mMenu
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 873
    Height = 36
    Align = alTop
    TabOrder = 0
    Visible = False
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 553
    Width = 873
    Height = 19
    Panels = <>
    SimplePanel = False
  end
  object WebBrowser: TWebBrowser
    Left = 0
    Top = 66
    Width = 873
    Height = 487
    Align = alClient
    TabOrder = 2
    ControlData = {
      4C0000003A5A0000553200000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object Panel1: TPanel
    Left = 0
    Top = 36
    Width = 873
    Height = 30
    Align = alTop
    TabOrder = 3
    object Label1: TLabel
      Left = 5
      Top = 5
      Width = 61
      Height = 19
      AutoSize = False
      Caption = 'Adresse:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edtURL: TEdit
      Left = 70
      Top = 4
      Width = 776
      Height = 21
      TabOrder = 0
    end
    object btnGo: TButton
      Left = 850
      Top = 5
      Width = 21
      Height = 21
      Caption = 'go'
      TabOrder = 1
      OnClick = btnGoClick
    end
  end
  object mMenu: TMainMenu
    Left = 105
    Top = 235
    object Datei1: TMenuItem
      Caption = '&Datei'
      object Beenden1: TMenuItem
        Caption = '&Beenden'
        OnClick = Beenden1Click
      end
    end
  end
end
