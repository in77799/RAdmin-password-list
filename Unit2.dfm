object FormSetup: TFormSetup
  Left = 123
  Top = 140
  Width = 1330
  Height = 890
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1086#1087#1088#1086#1089#1072' '#1089#1077#1088#1074#1077#1088#1086#1074
  Color = clBtnFace
  Constraints.MinHeight = 700
  Constraints.MinWidth = 1330
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 838
    Width = 1322
    Height = 23
    Panels = <>
    SimplePanel = True
  end
  object PanelTop: TPanel
    Left = 0
    Top = 0
    Width = 1322
    Height = 103
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Bevel1: TBevel
      Left = 121
      Top = 10
      Width = 9
      Height = 81
      Shape = bsLeftLine
    end
    object Label1: TLabel
      Left = 136
      Top = 16
      Width = 38
      Height = 13
      Caption = #1054#1073#1098#1077#1082#1090
    end
    object Label2: TLabel
      Left = 136
      Top = 43
      Width = 41
      Height = 13
      Caption = 'ip-'#1072#1076#1088#1077#1089
    end
    object Label3: TLabel
      Left = 136
      Top = 70
      Width = 41
      Height = 13
      Caption = #1048#1084#1103' '#1041#1044
    end
    object Label4: TLabel
      Left = 407
      Top = 16
      Width = 31
      Height = 13
      Caption = #1051#1086#1075#1080#1085
    end
    object Label5: TLabel
      Left = 407
      Top = 43
      Width = 38
      Height = 13
      Caption = #1055#1072#1088#1086#1083#1100
    end
    object Label6: TLabel
      Left = 407
      Top = 70
      Width = 46
      Height = 13
      Caption = #1058#1072#1081#1084'-'#1072#1091#1090
    end
    object Label7: TLabel
      Left = 680
      Top = 16
      Width = 19
      Height = 13
      Caption = #1058#1080#1087
    end
    object Label8: TLabel
      Left = 680
      Top = 43
      Width = 37
      Height = 13
      Caption = #1047#1072#1087#1088#1086#1089
    end
    object Label9: TLabel
      Left = 680
      Top = 70
      Width = 32
      Height = 13
      Caption = #1054#1087#1088#1086#1089
    end
    object Label10: TLabel
      Left = 785
      Top = 70
      Width = 130
      Height = 13
      Caption = '0 - '#1074#1099#1082#1083#1102#1095#1077#1085', 1 - '#1074#1082#1083#1102#1095#1077#1085
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label11: TLabel
      Left = 785
      Top = 15
      Width = 76
      Height = 13
      Caption = #1095#1080#1089#1083#1086' '#1086#1090' 0 '#1076#1086' 9'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object CheckBoxOpros: TCheckBox
      Left = 11
      Top = 10
      Width = 103
      Height = 17
      Hint = #1054#1087#1088#1086#1089' '#1089#1077#1088#1074#1077#1088#1086#1074' '#1091' '#1082#1086#1090#1086#1088#1099#1093' '#1087#1086#1083#1077' opros = 1'
      Caption = #1054#1087#1088#1086#1089
      TabOrder = 0
      OnClick = CheckBoxOprosClick
    end
    object ButtonRestartOpros: TButton
      Left = 11
      Top = 35
      Width = 95
      Height = 25
      Hint = #1055#1077#1088#1077#1079#1072#1087#1091#1089#1090#1080#1090#1100' '#1086#1087#1088#1086#1089' '#1077#1089#1083#1080' '#1089#1087#1080#1089#1086#1082' '#1089#1077#1088#1074#1077#1088#1086#1074' '#1073#1099#1083' '#1080#1079#1084#1077#1085#1105#1085
      Caption = #1055#1077#1088#1077#1079#1072#1087#1091#1089#1090#1080#1090#1100
      TabOrder = 1
      OnClick = ButtonRestartOprosClick
    end
    object Editname: TEdit
      Left = 183
      Top = 12
      Width = 190
      Height = 21
      Hint = 'name'
      MaxLength = 150
      TabOrder = 3
      OnExit = EditnameExit
    end
    object Editip: TEdit
      Left = 183
      Top = 39
      Width = 190
      Height = 21
      Hint = 'ip'
      MaxLength = 50
      TabOrder = 4
      OnExit = EditipExit
    end
    object Editdbname: TEdit
      Left = 183
      Top = 66
      Width = 190
      Height = 21
      Hint = 'dbname'
      MaxLength = 150
      TabOrder = 5
      OnExit = EditdbnameExit
    end
    object Editlogin: TEdit
      Left = 459
      Top = 12
      Width = 190
      Height = 21
      Hint = 'login'
      MaxLength = 50
      TabOrder = 6
      OnExit = EditloginExit
    end
    object Editpassword: TEdit
      Left = 459
      Top = 39
      Width = 190
      Height = 21
      Hint = 'password'
      MaxLength = 50
      TabOrder = 7
      OnExit = EditpasswordExit
    end
    object Edittimeout_min: TEdit
      Left = 459
      Top = 66
      Width = 190
      Height = 21
      Hint = 'timeout_min ('#1095#1080#1089#1083#1086' '#1086#1090' 0 '#1076#1086' 1440)'
      MaxLength = 4
      TabOrder = 8
      OnExit = Edittimeout_minExit
    end
    object Edittype: TEdit
      Left = 727
      Top = 12
      Width = 50
      Height = 21
      Hint = 'type ('#1095#1080#1089#1083#1086' '#1086#1090' 0 '#1076#1086' 9)'
      MaxLength = 1
      TabOrder = 9
      OnExit = EdittypeExit
    end
    object Editsqltext: TEdit
      Left = 727
      Top = 39
      Width = 300
      Height = 21
      Hint = 'sqltext'
      MaxLength = 255
      TabOrder = 10
      OnExit = EditsqltextExit
    end
    object Editopros: TEdit
      Left = 727
      Top = 66
      Width = 50
      Height = 21
      Hint = 'opros (0 '#1080#1083#1080' 1)'
      MaxLength = 1
      TabOrder = 11
      OnExit = EditoprosExit
    end
    object ButtonCopy: TButton
      Left = 1057
      Top = 20
      Width = 85
      Height = 25
      Hint = #1057#1082#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1089#1087#1080#1089#1082#1072' '#1089#1077#1088#1074#1077#1088#1086#1074
      Caption = #1057#1082#1086#1087#1080#1088#1086#1074#1072#1090#1100
      TabOrder = 12
      OnClick = ButtonCopyClick
    end
    object ButtonAdd: TButton
      Left = 1057
      Top = 55
      Width = 85
      Height = 25
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1085#1086#1074#1099#1081' '#1089#1077#1088#1074#1077#1088' '#1074' '#1089#1087#1080#1089#1086#1082
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      TabOrder = 13
      OnClick = ButtonAddClick
    end
    object CheckBoxOprosAlways: TCheckBox
      Left = 11
      Top = 69
      Width = 97
      Height = 17
      Hint = #1054#1087#1088#1086#1089' '#1089#1077#1088#1074#1077#1088#1086#1074' '#1085#1077#1089#1084#1086#1090#1088#1103' '#1085#1072' '#1090#1072#1081#1084'-'#1072#1091#1090
      Caption = #1055#1086#1089#1090#1086#1103#1085#1085#1086
      TabOrder = 2
    end
  end
  object PanelClient: TPanel
    Left = 0
    Top = 103
    Width = 1322
    Height = 665
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object DBGrid1: TDBGrid
      Left = 0
      Top = 0
      Width = 1322
      Height = 665
      Align = alClient
      DataSource = DataSource1
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnTitleClick = DBGrid1TitleClick
      Columns = <
        item
          Expanded = False
          FieldName = 'id'
          Width = 25
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'name'
          Width = 164
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ip'
          Width = 100
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'dbname'
          Width = 107
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'login'
          Width = 32
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'password'
          Width = 60
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'timeout_min'
          Width = 60
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'type'
          Width = 26
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'date_opros'
          Width = 117
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'date_server'
          Width = 120
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'sqltext'
          Width = 380
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'error'
          Width = 35
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'opros'
          Width = 35
          Visible = True
        end>
    end
  end
  object PanelBottom: TPanel
    Left = 0
    Top = 768
    Width = 1322
    Height = 70
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object CheckBoxSysErr: TCheckBox
      Left = 13
      Top = 28
      Width = 380
      Height = 17
      Caption = #1057#1086#1086#1073#1097#1077#1085#1080#1103' '#1086#1073' '#1086#1096#1080#1073#1082#1072#1093' '#1087#1086#1074#1077#1088#1093' '#1074#1089#1077#1093' '#1086#1082#1086#1085' '#1054#1057' Windows'
      TabOrder = 0
      OnClick = CheckBoxSysErrClick
    end
    object PanelBottomRight: TPanel
      Left = 929
      Top = 0
      Width = 393
      Height = 70
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      object DBNavigator1: TDBNavigator
        Left = 12
        Top = 25
        Width = 240
        Height = 25
        DataSource = DataSource1
        Hints.Strings = (
          #1055#1077#1088#1074#1072#1103' '#1089#1090#1088#1086#1082#1072
          #1055#1088#1077#1076#1099#1076#1091#1097#1072#1103' '#1089#1090#1088#1086#1082#1072
          #1057#1083#1077#1076#1091#1102#1097#1072#1103' '#1089#1090#1088#1086#1082#1072
          #1055#1086#1089#1083#1077#1076#1085#1103#1103' '#1089#1090#1088#1086#1082#1072
          #1044#1086#1073#1072#1074#1080#1090#1100' '#1079#1072#1087#1080#1089#1100
          #1059#1076#1072#1083#1080#1090#1100
          #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100
          #1055#1088#1080#1084#1077#1085#1080#1090#1100
          #1054#1090#1084#1077#1085#1080#1090#1100
          #1054#1073#1085#1086#1074#1080#1090#1100)
        TabOrder = 0
        TabStop = True
      end
      object ButtonClose: TButton
        Left = 286
        Top = 25
        Width = 75
        Height = 25
        Hint = #1047#1072#1082#1088#1099#1090#1100' '#1086#1082#1085#1086
        Caption = #1047#1072#1082#1088#1099#1090#1100
        TabOrder = 1
        OnClick = ButtonCloseClick
      end
    end
  end
  object Timer1: TTimer
    Interval = 300
    OnTimer = Timer1Timer
    Left = 408
    Top = 723
  end
  object DataSource1: TDataSource
    DataSet = ADODataSet1
    Left = 368
    Top = 723
  end
  object ADOConnection1: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=PswListDb.mdb;Mode=' +
      'ReadWrite;Persist Security Info=False'
    LoginPrompt = False
    Mode = cmReadWrite
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 296
    Top = 723
  end
  object ADODataSet1: TADODataSet
    Active = True
    Connection = ADOConnection1
    CursorType = ctStatic
    CommandText = 'select * from web_tab order by id asc'
    Parameters = <>
    Left = 331
    Top = 723
  end
  object ADOQuery1: TADOQuery
    Connection = ADOConnection1
    Parameters = <>
    SQL.Strings = (
      'select * from web_tab where opros=1 order by id asc')
    Left = 464
    Top = 723
  end
  object ADOQueryServer: TADOQuery
    Connection = ADOConnectionServer
    Parameters = <>
    Left = 638
    Top = 724
  end
  object ADOConnectionServer: TADOConnection
    KeepConnection = False
    LoginPrompt = False
    Left = 598
    Top = 724
  end
  object ADOQuery2: TADOQuery
    Connection = ADOConnection1
    Parameters = <>
    Left = 504
    Top = 723
  end
end
