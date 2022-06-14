object Form1: TForm1
  Left = 192
  Top = 122
  Width = 569
  Height = 501
  Caption = 'JS Web Demo, (C) Covac Research / Christian Sciberras'
  Color = 16758590
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    553
    465)
  PixelsPerInch = 96
  TextHeight = 13
  object Shape4: TShape
    Left = 8
    Top = 8
    Width = 537
    Height = 265
    Anchors = [akLeft, akTop, akRight, akBottom]
  end
  object Shape7: TShape
    Left = 8
    Top = 280
    Width = 537
    Height = 177
    Anchors = [akLeft, akRight, akBottom]
  end
  object Label1: TLabel
    Left = 16
    Top = 290
    Width = 54
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Expression:'
    Transparent = True
  end
  object Edit1: TEdit
    Left = 80
    Top = 286
    Width = 377
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 0
    Text = '500+23/4'
  end
  object Button3: TButton
    Left = 464
    Top = 284
    Width = 73
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Eval it!'
    TabOrder = 1
    OnClick = Button3Click
  end
  object Panel1: TPanel
    Left = 16
    Top = 16
    Width = 521
    Height = 249
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Caption = 'Panel1'
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 2
    object WebBrowser1: TWebBrowser
      Left = 0
      Top = 0
      Width = 519
      Height = 247
      Align = alClient
      TabOrder = 0
      ControlData = {
        4C000000A4350000871900000100000001020000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126208000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
  end
  object RichEdit1: TRichEdit
    Left = 16
    Top = 312
    Width = 521
    Height = 137
    Anchors = [akLeft, akRight, akBottom]
    BorderStyle = bsNone
    Color = clGray
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Lucida Console'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 3
    WordWrap = False
  end
end
