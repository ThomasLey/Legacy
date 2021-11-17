object frmSearch: TfrmSearch
  Left = 352
  Top = 719
  BorderStyle = bsToolWindow
  Caption = 'Vokabel bei    http://dict.leo.org   nachschlagen...'
  ClientHeight = 45
  ClientWidth = 506
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Edit1: TEdit
    Left = 0
    Top = 0
    Width = 423
    Height = 21
    TabOrder = 0
    Text = 'Edit1'
  end
  object Button1: TButton
    Left = 424
    Top = 0
    Width = 82
    Height = 22
    Caption = '&Suchen'
    Default = True
    TabOrder = 1
    OnClick = doSearch
  end
  object Panel1: TPanel
    Left = 0
    Top = 23
    Width = 423
    Height = 22
    TabOrder = 2
    object Label1: TLabel
      Left = 4
      Top = 4
      Width = 65
      Height = 13
      Caption = 'Eintragen in...'
    end
    object RadioButton1: TRadioButton
      Left = 73
      Top = 3
      Width = 80
      Height = 17
      Caption = 'Sprache &1'
      TabOrder = 0
      OnClick = RadioButton3Click
    end
    object RadioButton2: TRadioButton
      Tag = 1
      Left = 152
      Top = 3
      Width = 73
      Height = 17
      Caption = 'Sprache &2'
      TabOrder = 1
      OnClick = RadioButton3Click
    end
    object RadioButton3: TRadioButton
      Tag = 2
      Left = 224
      Top = 3
      Width = 97
      Height = 17
      Caption = '&nicht Eintragen'
      Checked = True
      TabOrder = 2
      TabStop = True
      OnClick = RadioButton3Click
    end
  end
  object Button2: TButton
    Left = 424
    Top = 22
    Width = 82
    Height = 23
    Caption = '&Abbrechen'
    TabOrder = 3
    OnClick = frmClose
  end
end
