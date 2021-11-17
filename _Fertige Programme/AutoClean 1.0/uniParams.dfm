object frmParams: TfrmParams
  Left = 279
  Top = 174
  Width = 494
  Height = 413
  Caption = 'Parameter'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 65
    Width = 486
    Height = 280
    Align = alClient
    TabOrder = 1
    object sgParams: TStringGrid
      Left = 1
      Top = 1
      Width = 484
      Height = 278
      TabStop = False
      Align = alClient
      ColCount = 3
      DefaultColWidth = 130
      DefaultRowHeight = 20
      FixedCols = 0
      TabOrder = 0
      ColWidths = (
        172
        187
        98)
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 345
    Width = 486
    Height = 41
    Align = alBottom
    TabOrder = 0
    object btnCancel: TBitBtn
      Left = 272
      Top = 8
      Width = 91
      Height = 25
      Caption = '&Abbrechen'
      TabOrder = 3
      OnClick = btnCancelClick
    end
    object btnOK: TBitBtn
      Left = 376
      Top = 8
      Width = 97
      Height = 25
      Caption = '&OK'
      Default = True
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnNeu: TBitBtn
      Left = 8
      Top = 8
      Width = 113
      Height = 25
      Caption = '&Neuer Task'
      TabOrder = 1
      OnClick = btnNeuClick
    end
    object btnDelete: TBitBtn
      Left = 128
      Top = 8
      Width = 113
      Height = 25
      Caption = 'Task &löschen'
      TabOrder = 2
      OnClick = btnDeleteClick
    end
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 486
    Height = 65
    Align = alTop
    Caption = 'Nächste Ausführung '
    TabOrder = 2
    object Label2: TLabel
      Left = 8
      Top = 16
      Width = 121
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Datum (dd.mm.yyyy):'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label1: TLabel
      Left = 8
      Top = 40
      Width = 121
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Zeit (hh:mm:ss):'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edtNextDay: TMaskEdit
      Left = 136
      Top = 13
      Width = 105
      Height = 21
      TabStop = False
      Enabled = False
      TabOrder = 1
    end
    object edtTime: TMaskEdit
      Left = 136
      Top = 37
      Width = 105
      Height = 21
      TabStop = False
      Enabled = False
      TabOrder = 2
    end
    object BitBtn1: TBitBtn
      Left = 256
      Top = 16
      Width = 217
      Height = 41
      Caption = '&Ändern'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
end
