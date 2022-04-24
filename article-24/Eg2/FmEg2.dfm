object Form1: TForm1
  Left = 211
  Top = 114
  Width = 465
  Height = 467
  Caption = 'DelphiDabbler.com: Article#24, Example 2'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    457
    433)
  PixelsPerInch = 96
  TextHeight = 13
  object lblText: TLabel
    Left = 8
    Top = 8
    Width = 31
    Height = 13
    Caption = 'lblText'
  end
  object lblHTML: TLabel
    Left = 8
    Top = 224
    Width = 40
    Height = 13
    Caption = 'lblHTML'
  end
  object edText: TMemo
    Left = 8
    Top = 24
    Width = 441
    Height = 185
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
  end
  object edHTML: TMemo
    Left = 8
    Top = 240
    Width = 441
    Height = 185
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 1
  end
end
