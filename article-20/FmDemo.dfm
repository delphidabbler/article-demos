object Form1: TForm1
  Left = 192
  Top = 114
  Width = 696
  Height = 480
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
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 161
    Height = 13
    Caption = 'Choose app to test for version info'
  end
  object ListBox1: TListBox
    Left = 16
    Top = 32
    Width = 241
    Height = 84
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    IntegralHeight = True
    ItemHeight = 20
    Items.Strings = (
      'This app (single translation)'
      'MultiVer.exe'
      'NoTransVer.exe'
      'NoVerInfo.exe')
    ParentFont = False
    TabOrder = 0
  end
  object btnTestClass: TButton
    Left = 288
    Top = 32
    Width = 97
    Height = 25
    Caption = 'Test Class'
    TabOrder = 1
    OnClick = btnTestClassClick
  end
  object Memo1: TMemo
    Left = 16
    Top = 120
    Width = 665
    Height = 321
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssBoth
    TabOrder = 2
    WordWrap = False
  end
  object btnTestRoutines: TButton
    Left = 288
    Top = 64
    Width = 97
    Height = 25
    Caption = 'Test Routines'
    TabOrder = 3
    OnClick = btnTestRoutinesClick
  end
end
