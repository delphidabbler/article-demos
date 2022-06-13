object ArtDemoForm1: TArtDemoForm1
  Left = 195
  Top = 117
  BorderStyle = bsDialog
  Caption = 'Article 18 Exercise'
  ClientHeight = 176
  ClientWidth = 380
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 156
    Top = 148
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Close'
    Default = True
    TabOrder = 0
    OnClick = Button1Click
  end
  object WebBrowser1: TWebBrowser
    Left = 0
    Top = 0
    Width = 380
    Height = 143
    Align = alTop
    PopupMenu = PopupMenu1
    TabOrder = 1
    ControlData = {
      4C00000046270000C80E00000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object PopupMenu1: TPopupMenu
    Left = 344
    Top = 8
    object ShowtheCSS1: TMenuItem
      Caption = 'Show the CSS...'
    end
  end
end
