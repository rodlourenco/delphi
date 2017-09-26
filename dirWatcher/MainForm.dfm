object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 410
  ClientWidth = 678
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    678
    410)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 44
    Height = 13
    Caption = 'Directory'
  end
  object CheckBox1: TCheckBox
    Left = 159
    Top = 8
    Width = 511
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Watch'
    TabOrder = 0
    OnClick = CheckBox1Click
  end
  object DirectoryListBox1: TDirectoryListBox
    Left = 8
    Top = 27
    Width = 201
    Height = 375
    Anchors = [akLeft, akTop, akBottom]
    TabOrder = 1
    ExplicitHeight = 359
  end
  object Memo1: TMemo
    Left = 215
    Top = 27
    Width = 457
    Height = 375
    Anchors = [akLeft, akTop, akRight, akBottom]
    Lines.Strings = (
      'Memo1')
    TabOrder = 2
    ExplicitWidth = 474
    ExplicitHeight = 359
  end
end
