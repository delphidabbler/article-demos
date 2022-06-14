object SaveEncodingDlg: TSaveEncodingDlg
  Left = 656
  Top = 380
  BorderStyle = bsDialog
  Caption = 'Choose Save Encoding'
  ClientHeight = 219
  ClientWidth = 203
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblDesc: TLabel
    Left = 8
    Top = 8
    Width = 162
    Height = 13
    Caption = 'Choose encoding in which to save'
  end
  object rgEncoding: TRadioGroup
    Left = 8
    Top = 27
    Width = 185
    Height = 153
    Caption = 'Encodings'
    ItemIndex = 0
    Items.Strings = (
      'Current Browser Encoding'
      'ANSI'
      'UTF-8'
      'Unicode (UCS-2 Little Endian)'
      'Unicode (UCS-2 Big Endian)')
    TabOrder = 0
  end
  object btnOK: TButton
    Left = 23
    Top = 186
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 104
    Top = 186
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
