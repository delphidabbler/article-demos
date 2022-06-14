object SampleCodeEncodingDlg: TSampleCodeEncodingDlg
  Left = 656
  Top = 380
  BorderStyle = bsDialog
  Caption = 'Choose encoding'
  ClientHeight = 154
  ClientWidth = 203
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object rgFileType: TRadioGroup
    Left = 8
    Top = 8
    Width = 185
    Height = 105
    Caption = 'Choose encoding of sample HTML'
    ItemIndex = 0
    Items.Strings = (
      'ANSI'
      'UTF-8'
      'Unicode (UCS-2)')
    TabOrder = 0
  end
  object btnOK: TButton
    Left = 23
    Top = 119
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 104
    Top = 119
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
