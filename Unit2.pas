unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, StdCtrls, ExtCtrls, Grids, DBGrids, DBCtrls, DateUtils,
  ComCtrls;

type
  TFormSetup = class(TForm)
    StatusBar1: TStatusBar;
    PanelTop: TPanel;
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    CheckBoxOpros: TCheckBox;
    ButtonRestartOpros: TButton;
    Editname: TEdit;
    Editip: TEdit;
    Editdbname: TEdit;
    Editlogin: TEdit;
    Editpassword: TEdit;
    Edittimeout_min: TEdit;
    Edittype: TEdit;
    Editsqltext: TEdit;
    Editopros: TEdit;
    ButtonCopy: TButton;
    ButtonAdd: TButton;
    CheckBoxOprosAlways: TCheckBox;
    Timer1: TTimer;
    DataSource1: TDataSource;
    ADOConnection1: TADOConnection;
    ADODataSet1: TADODataSet;
    ADOQuery1: TADOQuery;
    ADOQueryServer: TADOQuery;
    ADOConnectionServer: TADOConnection;
    ADOQuery2: TADOQuery;
    PanelClient: TPanel;
    DBGrid1: TDBGrid;
    PanelBottom: TPanel;
    CheckBoxSysErr: TCheckBox;
    PanelBottomRight: TPanel;
    DBNavigator1: TDBNavigator;
    ButtonClose: TButton;
    procedure Timer1Timer(Sender: TObject);
    procedure ButtonCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonRestartOprosClick(Sender: TObject);
    procedure CheckBoxOprosClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure CheckBoxSysErrClick(Sender: TObject);
    procedure ButtonCopyClick(Sender: TObject);
    procedure ButtonAddClick(Sender: TObject);
    procedure EditnameExit(Sender: TObject);
    procedure EditipExit(Sender: TObject);
    procedure EditdbnameExit(Sender: TObject);
    procedure EditloginExit(Sender: TObject);
    procedure Edittimeout_minExit(Sender: TObject);
    procedure EdittypeExit(Sender: TObject);
    procedure EditsqltextExit(Sender: TObject);
    procedure EditoprosExit(Sender: TObject);
    procedure EditpasswordExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormSetup: TFormSetup;
  Flag, // Чтобы код выполнился только один раз
  NewRecordError, // Если True, были введены некорректные данные для новой записи в список серверов
  StopOprosOnError: Boolean; // Если True, опрос был остановлен из-за ошибки

implementation

uses Unit1;

{$R *.dfm}

procedure TFormSetup.FormCreate(Sender: TObject);
begin
  Flag := False;
  NewRecordError := False;
  StopOprosOnError := False;
  CheckBoxSysErr.Checked := SysError; // Вид сообщения об ошибке
  CheckBoxOpros.Checked := Opros;     // Опрос включен или выключен
  Timer1.Interval := 300;

  // Если флаг опроса при запуске приложения выключен, вызываем код
  // как будто опрос был включен и пользователь его выключил, т.е. обновим визуал
  if not CheckBoxOpros.Checked then CheckBoxOprosClick(Sender);
end;

// ADOQuery1 - запрос чтения локальной БД Access (файл PswListDb.mdb), SQL = 'select * from web_tab where opros=1 order by id asc'
// ADOConnectionServer - подключение к серверу
// ADOQueryServer - запрос к БД сервера. Текст запроса берём из списка серверов (ADOQuery1)
// ADOQuery2 - запрос изменения локальной БД Access во время опроса серверов
procedure TFormSetup.Timer1Timer(Sender: TObject);
var
  id_str, ip, name, dbname, login, password, sqltext: String;
  date_opros, date_now: TDateTime;
  date_now_str, date_str_old, date_str_new: String;
  id, timeout_min, error: Integer;
  NeedConnect, ConnectToServer: Boolean;
begin
  if CheckBoxOpros.Checked and Timer1.Enabled then // Опрос серверов включен
  begin
    //Beep;

    // Проверяем нужно ли запускать опрос
    if Flag then
    begin
      Flag := False; // Чтобы код выполнился только один раз
      ButtonRestartOprosClick(Sender); // Запуск опроса как нажатие кнопки "Перезапустить"
    end;

    // При запуске опроса (ButtonRestartOprosClick) могут быть ошибки и отключение опроса
    // Если опрос всё ещё включен и уже запущен, идём дальше
    if CheckBoxOpros.Checked and ADOQuery1.Active then
    begin
      Timer1.Enabled := False;   // Останавливаем таймер до окончания обработки этого цикла
      StopOprosOnError := False; // Флаг остановки опроса из-за ошибки
      ConnectToServer := False;  // Флаг подключения к серверу, т.е. сейчас мы в процессе подключения
      NeedConnect := False;      // Флаг необходимости подключения к серверу
      id_str := '?';
      date_now := Now;           // Текущее время на этом АРМ
      date_opros := date_now;    // Время последнего опроса сервера (временно определяем как текущее время)
      error := 0; // Флаг ошибки

      try
        date_now_str := DateTimeToStr(date_now);

        // Читаем текущую запись списка серверов
        id_str := ADOQuery1.Fields.FieldByName('id').AsString;
        id := StrToInt(id_str);
        ip   := Trim(ADOQuery1.Fields.FieldByName('ip').AsString);
        name := Trim(ADOQuery1.Fields.FieldByName('name').AsString);

        StatusBar1.SimpleText := 'id=' + id_str + ', ' + name + ', ' + ip + '.';

        dbname   := Trim(ADOQuery1.Fields.FieldByName('dbname').AsString);
        login    := Trim(ADOQuery1.Fields.FieldByName('login').AsString);
        password := Trim(ADOQuery1.Fields.FieldByName('password').AsString);
        sqltext  := Trim(ADOQuery1.Fields.FieldByName('sqltext').AsString);
        date_str_old := Trim(ADOQuery1.Fields.FieldByName('date_server').AsString); // результат max(DateTime) в виде строки, а не даты!

        // Если у сервера opros = 1 и error = 1, то его надо опросить, даже если timeout_min ещё не истёк
        if TryStrToInt(Trim(ADOQuery1.Fields.FieldByName('error').AsString), error) and (error = 1) then NeedConnect := True;

        // Если дата последнего опроса сервера не найдена, сервер надо опросить
        // У столбца date_opros в БД тип DateTime, т.е. там либо пусто, либо дата
        if Trim(ADOQuery1.Fields.FieldByName('date_opros').AsString) = '' then NeedConnect := True
        else date_opros := ADOQuery1.Fields.FieldByName('date_opros').AsDateTime;

        if Trim(ADOQuery1.Fields.FieldByName('timeout_min').AsString) = '' then timeout_min := -1
        else timeout_min := ADOQuery1.Fields.FieldByName('timeout_min').AsInteger;
        if (timeout_min = 0) then NeedConnect := True;

        if (timeout_min < 0) or (timeout_min > 1440) then raise Exception.Create('Параметр timeout_min должен быть от 0 до 1440!');
        if ip =      '' then raise Exception.Create('IP-адрес сервера не задан!');
        if dbname  = '' then raise Exception.Create('Имя базы данных сервера не задано!');
        if login   = '' then raise Exception.Create('Логин базы данных сервера не задан!');
        if sqltext = '' then raise Exception.Create('Запрос к базе данных сервера не задан!');

        // Если включен режим постоянного опроса серверов
        if CheckBoxOprosAlways.Checked then NeedConnect := True;

        if not NeedConnect then
        begin
          // Если разница в минутах между текущим временем и временем последнего опроса сервера больше чем тайм-аут,
          // сервер надо опросить. (От перестановки времён разница не становится отрицательной).
          if timeout_min <= MinutesBetween(date_now, date_opros) then NeedConnect := True;
          //ShowMessage(DateTimeToStr(date_now)+'-'+DateTimeToStr(date_opros)+'='+IntToStr(MinutesBetween(date_opros, date_now)));
        end;

        // Если надо подключаться к серверу
        if NeedConnect then
        begin
          ConnectToServer := True; // Установим флаг процесса подключения к серверу
          StatusBar1.SimpleText := StatusBar1.SimpleText + ' Подключение к серверу.';

          // Обновляем дату опроса сервера и сразу ставим ошибку
          ADOQuery2.Close;
          ADOQuery2.SQL.Clear;
          ADOQuery2.SQL.Add('update web_tab set date_opros=''' + date_now_str + ''', error=:error where id=:id');
          ADOQuery2.Parameters.ParamByName('error').Value := 1;
          ADOQuery2.Parameters.ParamByName('id').Value := id;
          ADOQuery2.ExecSQL;
          ADOQuery2.Close;
          ADODataSet1.Refresh; // Обновляем DBGrid

          //Provider=SQLOLEDB.1;Password=sa1;Persist Security Info=True;User ID=sa;Initial Catalog=db1;Data Source=192.168.0.1
          //Provider=SQLOLEDB.1;Password="";Persist Security Info=True;User ID=sa;Initial Catalog=db1;Data Source=192.168.0.1

          if password = '' then password := '""';

          // Настройка подключения к MS SQL Server
          ADOConnectionServer.ConnectionString := 'Provider=SQLOLEDB.1;Password=' +
            password + ';Persist Security Info=True;User ID=' + login + ';Initial Catalog=' +
            dbname + ';Data Source=' + ip;
          //ShowMessage(ADOConnectionServer.ConnectionString);

          ADOQueryServer.SQL.Clear;
          ADOQueryServer.SQL.Add(sqltext);
          ADOConnectionServer.Open; // Подключение к серверу
          ADOQueryServer.Open;      // Выполнение запроса к БД сервера

          // Ожидаем получить последнюю дату сохранённую в БД сервера
          date_str_new := Trim(ADOQueryServer.Fields.Fields[0].AsString); // max(DateTime)

          if ADOQueryServer.IsEmpty or (date_str_new = '') then raise Exception.Create('Пустой результат запроса!');

          // Если максимальная дата на сервере не изменилась, то ошибка
          if (date_str_new = date_str_old) then error := 1 else error := 0;

          ADOQuery2.Close;
          ADOQuery2.SQL.Clear;
          ADOQuery2.SQL.Add('update web_tab set date_server=''' + date_str_new + ''', error=:error where id=:id');
          ADOQuery2.Parameters.ParamByName('error').Value := error;
          ADOQuery2.Parameters.ParamByName('id').Value := id;
          ADOQuery2.ExecSQL;
          ADOQuery2.Close;
          ADODataSet1.Refresh; // Обновляем DBGrid

          if (error = 1) then
          begin
            Application.Icon.Handle := LoadIcon(hInstance, 'YELLOW');
            Form1.CoolTrayIcon1.Icon.Handle := Application.Icon.Handle;
            Form1.CoolTrayIcon1.Hint := 'Опрос включен. Есть ошибки';

            Form1.ErrorMessage('id=' + id_str + ', ' + name + '. Ошибка: максимальная дата не изменилась!');
            // Только в этом случае после нажатия OK опрос не останавливается
          end;

          ADOQueryServer.Close;
          ADOConnectionServer.Close;
          ConnectToServer := False; // Снимаем флаг процесса подключения к серверу
        end else
        begin // NeedConnect = False, к серверу подключаться не надо
          StatusBar1.SimpleText := StatusBar1.SimpleText + ' Пропуск подключения.';
        end;
      except
        on e:Exception do // Произошла ошибка чтения списка серверов или ошибка подключения к серверу
        begin
          ADOQueryServer.Close;
          ADOConnectionServer.Close;
          ADOQuery2.Close;
          ADOQuery1.Close;
          ADODataSet1.Refresh;

          if ConnectToServer then StatusBar1.SimpleText := StatusBar1.SimpleText + ' Ошибка подключения к серверу.'
          else StatusBar1.SimpleText := StatusBar1.SimpleText + ' Ошибка при чтении списка серверов (1).';

          StopOprosOnError := True; // Установим флаг того, что опрос остановлен из-за ошибки
          CheckBoxOpros.Checked := False; // Останавливаем опрос, сработает CheckBoxOprosClick

          // Сообщение об ошибке
          if ConnectToServer then Form1.ErrorMessage('id=' + id_str + ', ' + name + '. Ошибка подключения к серверу: ' + E.Message)
          else Form1.ErrorMessage('id=' + id_str + ', ' + name + '. Ошибка при чтении списка серверов (1): ' + E.Message);
        end;
      end; // end of try

      // Если ошибок не было, переходим к следующему серверу в списке
      if ADOQuery1.Active then
      begin
        try
          ADOQuery1.Next;
          if ADOQuery1.Eof then  // Если конец набора данных
          begin
            ADOQuery1.Close;
            ADOQuery1.Open;      // Если дошли до конца списка серверов, сначала обновляем набор данных
            //ADOQuery1.Requery;
            ADOQuery1.First;     // Переходим к первому серверу в обновлённом списке
            ADODataSet1.Refresh; // Обновляем DBGrid

            // Пасхалка чтобы узнать количество опрашиваемых серверов
            if Trim(Editpassword.Text) = 'количество' then ShowMessage(IntToStr(ADOQuery1.RecordCount));
          end;
        except
          on e:Exception do // Произошла ошибка чтения списка серверов
          begin
            ADOQuery1.Close;
            ADODataSet1.Refresh; // Обновляем DBGrid
            StatusBar1.SimpleText := StatusBar1.SimpleText + ' Ошибка при чтении списка серверов.';
            StopOprosOnError := True; // Установим флаг того, что опрос остановлен из-за ошибки
            CheckBoxOpros.Checked := False; // Останавливаем опрос, сработает CheckBoxOprosClick
            Form1.ErrorMessage('id=' + id_str + ', ' + name + '. Ошибка при чтении списка серверов (2): ' + E.Message);
          end;
        end; // end of try
      end;

      Timer1.Enabled := True; // Запускаем таймер для следующего цикла
    end; // end of "if CheckBoxOpros.Checked and ADOQuery1.Active"
  end; // end of "CheckBoxOpros.Checked and Timer1.Enabled"
end;

// Кнопка "Перезапустить" опрос и код запуска опроса
procedure TFormSetup.ButtonRestartOprosClick(Sender: TObject);
begin
  StatusBar1.SimpleText := 'Запуск опроса.';
  StopOprosOnError := False;
  Application.Icon.Handle := LoadIcon(hInstance, 'GREEN'); // Опрос включен
  Form1.CoolTrayIcon1.Icon.Handle := Application.Icon.Handle;
  Form1.CoolTrayIcon1.Hint := 'Опрос включен';

  try
    ADOQuery1.Close;
    ADOQuery1.Open;
    //ADOQuery1.Requery;
    ADOQuery1.First;
    ADODataSet1.Refresh;

    // Пасхалка для увеличения скорости таймера
    if (Timer1.Interval > 100) and (Trim(Editpassword.Text) = 'скорость') then
    begin
      Beep;
      Timer1.Interval := Timer1.Interval - 100;
    end;

    // Пасхалка чтобы узнать количество опрашиваемых серверов
    if Trim(Editpassword.Text) = 'количество' then ShowMessage(IntToStr(ADOQuery1.RecordCount));
  except
    on e:Exception do
    begin
      StatusBar1.SimpleText := StatusBar1.SimpleText + ' Ошибка при чтении списка серверов.';
      StopOprosOnError := True;
      CheckBoxOpros.Checked := False;
      Form1.ErrorMessage('Ошибка при чтении списка серверов: ' + E.Message);
    end;
  end;

  if ADOQuery1.IsEmpty then
  begin
    StatusBar1.SimpleText := StatusBar1.SimpleText + ' Ошибка: список серверов для опроса пуст.';
    StopOprosOnError := True;
    CheckBoxOpros.Checked := False;
    Form1.ErrorMessage('Ошибка: список серверов для опроса пуст.');
  end;
end;

// Обработка изменения состояния опроса
procedure TFormSetup.CheckBoxOprosClick(Sender: TObject);
begin
  Opros := CheckBoxOpros.Checked;

  if CheckBoxOpros.Checked then // Если опрос включен
  begin
    Flag := True; // При очередном срабатывании таймера (Timer1Timer) будет вызван ButtonRestartOprosClick
    ButtonRestartOpros.Enabled := True; // Сделаем доступной кнопку "Перезапустить"
    CheckBoxOprosAlways.Enabled := True;
  end else
  begin  // Если опрос выключен
    if StopOprosOnError then // Если опрос остановлен из-за ошибки
    begin
      Application.Icon.Handle := LoadIcon(hInstance, 'RED');
      Form1.CoolTrayIcon1.Hint := 'Опрос остановлен. Есть ошибки';
    end else
    begin // Опрос просто остановлен или не запускался
      Application.Icon.Handle := LoadIcon(hInstance, 'GRAY');
      Form1.CoolTrayIcon1.Hint := 'Опрос выключен';
    end;
    Form1.CoolTrayIcon1.Icon.Handle := Application.Icon.Handle;

    ButtonRestartOpros.Enabled := False; // Сделаем недоступной кнопку "Перезапустить"
    CheckBoxOprosAlways.Enabled := False;
    StatusBar1.SimpleText := StatusBar1.SimpleText + ' Опрос остановлен.';
  end;
end;

// Сортировка данных по нажатию на столбец DBGrid
procedure TFormSetup.DBGrid1TitleClick(Column: TColumn);
var
  ss: String;
begin
  if ADODataSet1.FieldByName(Column.FieldName).Tag = 0 then
  begin
    ss := ' ASC';
    ADODataSet1.FieldByName(Column.FieldName).Tag := 1;
  end else
  begin
    ss := ' DESC';
    ADODataSet1.FieldByName(Column.FieldName).Tag := 0;
  end;
  ADODataSet1.Sort := Column.FieldName + ss;
end;

procedure TFormSetup.CheckBoxSysErrClick(Sender: TObject);
begin
  SysError := CheckBoxSysErr.Checked;
end;

// Копировать данные текущего сервера в DBGrid
procedure TFormSetup.ButtonCopyClick(Sender: TObject);
begin
  try
    Editname.Text   := Trim(ADODataSet1.FieldByName('name').AsString);
    Editip.Text     := Trim(ADODataSet1.FieldByName('ip').AsString);
    Editdbname.Text := Trim(ADODataSet1.FieldByName('dbname').AsString);

    Editlogin.Text       := Trim(ADODataSet1.FieldByName('login').AsString);
    Editpassword.Text    := Trim(ADODataSet1.FieldByName('password').AsString);
    Edittimeout_min.Text := Trim(ADODataSet1.FieldByName('timeout_min').AsString);
    if Edittimeout_min.Text = '' then Edittimeout_min.Text := '20';

    Edittype.Text := Trim(ADODataSet1.FieldByName('type').AsString);
    if Edittype.Text = '' then Edittype.Text := '0';

    Editsqltext.Text := Trim(ADODataSet1.FieldByName('sqltext').AsString);
    if Editsqltext.Text = '' then Editsqltext.Text := 'select max(date) from datatable';

    Editopros.Text := Trim(ADODataSet1.FieldByName('opros').AsString);
    if Editopros.Text = '' then Editopros.Text := '1';
  except
    on e:Exception do MessageDlg('Ошибка: ' + E.Message, mtError, [mbOk], 0);
  end;
end;

// Добавить новый сервер в список
procedure TFormSetup.ButtonAddClick(Sender: TObject);
begin
  NewRecordError := False; // сбрасываем ошибку введённых данных

  // вызываем проверку каждого поля ввода
                             EditnameExit(Sender);
  if not NewRecordError then EditipExit(Sender);
  if not NewRecordError then EditdbnameExit(Sender);
  if not NewRecordError then EditloginExit(Sender);
  if not NewRecordError then EditpasswordExit(Sender);
  if not NewRecordError then Edittimeout_minExit(Sender);
  if not NewRecordError then EdittypeExit(Sender);
  if not NewRecordError then EditsqltextExit(Sender);
  if not NewRecordError then EditoprosExit(Sender);

  if not NewRecordError then
  begin
    try
      ADODataSet1.Insert;
      ADODataSet1.FieldByName('name').AsString := Editname.Text;
      ADODataSet1.FieldByName('ip').AsString := Editip.Text;
      ADODataSet1.FieldByName('dbname').AsString := Editdbname.Text;
      ADODataSet1.FieldByName('login').AsString := Editlogin.Text;
      ADODataSet1.FieldByName('password').AsString := Editpassword.Text;
      ADODataSet1.FieldByName('timeout_min').AsInteger := StrToInt(Edittimeout_min.Text);
      ADODataSet1.FieldByName('type').AsInteger := StrToInt(Edittype.Text);
      ADODataSet1.FieldByName('sqltext').AsString := Editsqltext.Text;
      ADODataSet1.FieldByName('opros').AsInteger := StrToInt(Editopros.Text);
      ADODataSet1.Post;
    except
      on e:Exception do
      begin
        ADODataSet1.Cancel;
        MessageDlg('Ошибка при добавлении нового сервера: ' + E.Message, mtError, [mbOk], 0);
      end;
    end; // end of try
  end;
end;

procedure TFormSetup.EditnameExit(Sender: TObject);
begin
  Editname.Text := Trim(Editname.Text);
  if Editname.Text = '' then
  begin
    MessageDlg('Ошибка: Название объекта не задано!', mtError, [mbOk], 0);
    Editname.Text := 'Название объекта';
    NewRecordError := True;
    Editname.SetFocus;
  end;
end;

procedure TFormSetup.EditipExit(Sender: TObject);
begin
  Editip.Text := Trim(Editip.Text);
  if Editip.Text = '' then
  begin
    MessageDlg('Ошибка: Адрес сервера не задан!', mtError, [mbOk], 0);
    Editip.Text := '192.168.1.1';
    NewRecordError := True;
    Editip.SetFocus;
  end;
end;

procedure TFormSetup.EditdbnameExit(Sender: TObject);
begin
  Editdbname.Text := Trim(Editdbname.Text);
  if Editdbname.Text = '' then
  begin
    MessageDlg('Ошибка: Имя базы данных не задано!', mtError, [mbOk], 0);
    Editdbname.Text := 'DB_Name';
    NewRecordError := True;
    Editdbname.SetFocus;
  end;
end;

procedure TFormSetup.EditloginExit(Sender: TObject);
begin
  Editlogin.Text := Trim(Editlogin.Text);
  if Editlogin.Text = '' then
  begin
    MessageDlg('Ошибка: Логин не задан!', mtError, [mbOk], 0);
    Editlogin.Text := 'sa';
    NewRecordError := True;
    Editlogin.SetFocus;
  end;
end;

procedure TFormSetup.EditpasswordExit(Sender: TObject);
begin
  Editpassword.Text := Trim(Editpassword.Text);
end;

procedure TFormSetup.Edittimeout_minExit(Sender: TObject);
var
  i: Integer;
begin
  Edittimeout_min.Text := Trim(Edittimeout_min.Text);
  if TryStrToInt(Edittimeout_min.Text, i) then
  begin
    if (i < 0) or (i > 1440) then
    begin
      MessageDlg('Ошибка: Тайм-аут в минутах должен быть от 0 до 1440!', mtError, [mbOk], 0);
      Edittimeout_min.Text := '20';
      NewRecordError := True;
      Edittimeout_min.SetFocus;
    end;
  end else
  begin
    MessageDlg('Ошибка: Тайм-аут в минутах не задан (число от 0 до 1440)!', mtError, [mbOk], 0);
    Edittimeout_min.Text := '20';
    NewRecordError := True;
    Edittimeout_min.SetFocus;
  end;
end;

procedure TFormSetup.EdittypeExit(Sender: TObject);
var
  i: Integer;
begin
  Edittype.Text := Trim(Edittype.Text);
  if TryStrToInt(Edittype.Text, i) then
  begin
    if (i < 0) or (i > 9) then
    begin
      MessageDlg('Ошибка: Тип сервера должен быть от 0 до 9!', mtError, [mbOk], 0);
      Edittype.Text := '0';
      NewRecordError := True;
      Edittype.SetFocus;
    end;
  end else
  begin
    MessageDlg('Ошибка: Тип сервера не задан (число от 0 до 9)!', mtError, [mbOk], 0);
    Edittype.Text := '0';
    NewRecordError := True;
    Edittype.SetFocus;
  end;
end;

procedure TFormSetup.EditsqltextExit(Sender: TObject);
begin
  Editsqltext.Text := Trim(Editsqltext.Text);
  if Editsqltext.Text = '' then
  begin
    MessageDlg('Ошибка: Текст SQL-запроса к БД не задан!', mtError, [mbOk], 0);
    Editsqltext.Text := 'select max(date) from datatable';
    NewRecordError := True;
    Editsqltext.SetFocus;
  end;
end;

procedure TFormSetup.EditoprosExit(Sender: TObject);
var
  i: Integer;
begin
  Editopros.Text := Trim(Editopros.Text);
  if TryStrToInt(Editopros.Text, i) then
  begin
    if (i < 0) or (i > 1) then
    begin
      MessageDlg('Ошибка: Опрос сервера должен быть 0 или 1!', mtError, [mbOk], 0);
      Editopros.Text := '1';
      NewRecordError := True;
      Editopros.SetFocus;
    end;
  end else
  begin
    MessageDlg('Ошибка: Опрос сервера не задан (число 0 или 1)!', mtError, [mbOk], 0);
    Editopros.Text := '1';
    NewRecordError := True;
    Editopros.SetFocus;
  end;
end;

procedure TFormSetup.ButtonCloseClick(Sender: TObject);
begin
  FormSetup.Close;
end;

procedure TFormSetup.FormDestroy(Sender: TObject);
begin
  ADOQuery1.Close;
  ADOQuery2.Close;
  ADODataSet1.Close;
  ADOConnection1.Close;

  ADOQueryServer.Close;
  ADOConnectionServer.Close;
end;


procedure TFormSetup.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CheckBoxOprosAlways.Checked := False; // При закрытии окна настроек отменим постоянный опрос серверов
end;

end.
