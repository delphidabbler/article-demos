object Form1: TForm1
  Left = 211
  Top = 114
  Width = 468
  Height = 347
  Caption = 'DelphiDabbler.com: Article#24, Example 1'
  Color = clBtnFace
  Constraints.MinHeight = 200
  Constraints.MinWidth = 468
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    460
    313)
  PixelsPerInch = 96
  TextHeight = 13
  object lblDesc: TLabel
    Left = 8
    Top = 8
    Width = 305
    Height = 13
    Caption = 'Drag and drop any object over this form to see supported formats'
  end
  object lvDisplay: TListView
    Left = 8
    Top = 32
    Width = 444
    Height = 273
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        Caption = 'Format'
        Width = 130
      end
      item
        Caption = 'Storage Medium'
        Width = 120
      end
      item
        Caption = 'Aspect'
        Width = 140
      end
      item
        Caption = 'lindex'
      end>
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
  end
end
