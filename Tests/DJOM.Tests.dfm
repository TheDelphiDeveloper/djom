object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 587
  ClientWidth = 888
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Button1: TButton
    Left = 16
    Top = 24
    Width = 243
    Height = 105
    Caption = 'Valor Existente'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 16
    Top = 152
    Width = 243
    Height = 105
    Caption = 'With Default'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 16
    Top = 272
    Width = 243
    Height = 105
    Caption = 'With Converter'
    TabOrder = 2
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 280
    Top = 24
    Width = 241
    Height = 105
    Caption = 'Validate'
    TabOrder = 3
    OnClick = Button4Click
  end
  object ButtonValidations: TButton
    Left = 280
    Top = 152
    Width = 241
    Height = 98
    Caption = 'ButtonValidations'
    TabOrder = 4
    OnClick = ButtonValidationsClick
  end
  object ButtonConverters: TButton
    Left = 280
    Top = 272
    Width = 241
    Height = 105
    Caption = 'ButtonConverters'
    TabOrder = 5
    OnClick = ButtonConvertersClick
  end
  object ButtonNestedFields: TButton
    Left = 535
    Top = 24
    Width = 226
    Height = 105
    Caption = 'Testar Campo Aninhado'
    TabOrder = 6
    OnClick = ButtonNestedFieldsClick
  end
  object ButtonNestedDeep: TButton
    Left = 535
    Top = 152
    Width = 226
    Height = 98
    Caption = 'Testar user.endereco.cidade'
    TabOrder = 7
    OnClick = ButtonNestedDeepClick
  end
  object ButtonToJson: TButton
    Left = 535
    Top = 272
    Width = 226
    Height = 105
    Caption = 'Testar ToJson'
    TabOrder = 8
    OnClick = ButtonToJsonClick
  end
  object ButtonListTest: TButton
    Left = 16
    Top = 394
    Width = 243
    Height = 103
    Caption = 'Testar Lista de Emails'
    TabOrder = 9
    OnClick = ButtonListTestClick
  end
end
