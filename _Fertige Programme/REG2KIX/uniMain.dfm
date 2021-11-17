object Form1: TForm1
  Left = 523
  Top = 274
  Width = 718
  Height = 667
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
  object mmoReg: TMemo
    Left = 0
    Top = 0
    Width = 710
    Height = 225
    Align = alTop
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
  end
  object mmoKix: TMemo
    Left = 0
    Top = 225
    Width = 710
    Height = 375
    Align = alClient
    ScrollBars = ssBoth
    TabOrder = 1
    WordWrap = False
  end
  object Panel1: TPanel
    Left = 0
    Top = 600
    Width = 710
    Height = 40
    Align = alBottom
    TabOrder = 2
    object btnReadREG: TButton
      Left = 8
      Top = 8
      Width = 145
      Height = 25
      Caption = '&Einlesen'
      TabOrder = 0
      OnClick = btnReadREGClick
    end
    object btnCreateKIX: TButton
      Left = 160
      Top = 8
      Width = 145
      Height = 25
      Caption = '&KIX erstellen'
      TabOrder = 1
      OnClick = btnCreateKIXClick
    end
    object btnSaveKIX: TButton
      Left = 312
      Top = 8
      Width = 145
      Height = 25
      Caption = 'KIX &speichern'
      TabOrder = 2
      OnClick = btnSaveKIXClick
    end
  end
  object odlgReg: TOpenDialog
    DefaultExt = '*.reg'
    Filter = 'Registereinträger|*.reg|Alle Dateien|*.*'
    Left = 504
    Top = 16
  end
  object sdlgSaveKIX: TSaveDialog
    DefaultExt = '*.kix'
    Filter = 'KIX-Dateien|*.kix|Alle Dateien|*.*'
    Left = 504
    Top = 56
  end
end
