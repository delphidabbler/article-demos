object EditorForm: TEditorForm
  Left = 0
  Top = 0
  Caption = 'EditorForm'
  ClientHeight = 300
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object btnCut: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Cut'
    TabOrder = 0
    OnClick = btnCutClick
  end
  object btnCopy: TButton
    Left = 87
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Copy'
    TabOrder = 1
    OnClick = btnCopyClick
  end
  object btnPaste: TButton
    Left = 168
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Paste'
    TabOrder = 2
    OnClick = btnPasteClick
  end
  object RichEdit1: TRichEdit
    Left = 8
    Top = 39
    Width = 619
    Height = 253
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 3
    OnSelectionChange = RichEdit1SelectionChange
  end
end
