object frmMain: TfrmMain
  Left = 244
  Top = 86
  Width = 531
  Height = 515
  BorderIcons = []
  Caption = 'AutoClear'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 523
    Height = 416
    Hint = 'Verlaufsprotokoll'
    Align = alClient
    Color = clInactiveBorder
    Enabled = False
    ParentShowHint = False
    ScrollBars = ssVertical
    ShowHint = True
    TabOrder = 0
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 416
    Width = 523
    Height = 53
    Align = alBottom
    TabOrder = 1
    object btnAutoExec: TButton
      Left = 293
      Top = 4
      Width = 105
      Height = 25
      Hint = 'Das Löschen jetzt ausführen'
      Caption = 'Jetzt &Ausführen'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = StartClick
    end
    object btnSet: TButton
      Left = 87
      Top = 4
      Width = 101
      Height = 25
      Hint = 'Löschmasken einsehen und ändern'
      Caption = 'Neu &setzen'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = btnSetClick
    end
    object Button1: TButton
      Left = 192
      Top = 8
      Width = 97
      Height = 25
      Hint = 'Das Verlaufsprotokoll löschen'
      Caption = 'Protokoll &löschen'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = Button1Click
    end
    object BitBtn1: TBitBtn
      Left = 496
      Top = 13
      Width = 25
      Height = 25
      Hint = 'Programm minimieren'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = BitBtn1Click
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        333333333333333333333333333333333333333333333333FFF3333333333333
        00333333333333FF77F3333333333300903333333333FF773733333333330099
        0333333333FF77337F3333333300999903333333FF7733337333333700999990
        3333333777333337F3333333099999903333333373F333373333333330999903
        33333333F7F3337F33333333709999033333333F773FF3733333333709009033
        333333F7737737F3333333709073003333333F77377377F33333370907333733
        33333773773337333333309073333333333337F7733333333333370733333333
        3333377733333333333333333333333333333333333333333333}
      NumGlyphs = 2
    end
    object BitBtn2: TBitBtn
      Left = 2
      Top = 13
      Width = 25
      Height = 25
      Hint = 'Programm beenden'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = BitBtn2Click
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00330000000000
        03333377777777777F333301111111110333337F333333337F33330111111111
        0333337F333333337F333301111111110333337F333333337F33330111111111
        0333337F333333337F333301111111110333337F333333337F33330111111111
        0333337F3333333F7F333301111111B10333337F333333737F33330111111111
        0333337F333333337F333301111111110333337F33FFFFF37F3333011EEEEE11
        0333337F377777F37F3333011EEEEE110333337F37FFF7F37F3333011EEEEE11
        0333337F377777337F333301111111110333337F333333337F33330111111111
        0333337FFFFFFFFF7F3333000000000003333377777777777333}
      NumGlyphs = 2
    end
    object CheckBox1: TCheckBox
      Left = 144
      Top = 32
      Width = 201
      Height = 17
      Caption = 'automatisches Löschen'
      Checked = True
      State = cbChecked
      TabOrder = 5
      OnClick = CheckBox1Click
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 469
    Width = 523
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object AutoStart: TTimer
    OnTimer = AutoStartTimer
    Left = 128
    Top = 101
  end
  object CoolTray: TCoolTrayIcon
    CycleInterval = 0
    ShowHint = True
    MinimizeToTray = True
    OnDblClick = CoolTrayDblClick
    Left = 120
    Top = 64
  end
end
