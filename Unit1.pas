unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Clipbrd, ExtCtrls, XPMan, ComCtrls, IniFiles, ShellAPI,
  CoolTrayIcon, Menus, MStdCtrls;

type
  TForm1 = class(TForm)
    ListBox1: TListBox;
    Panel1: TPanel;
    Timer1: TTimer;
    CoolTrayIcon1: TCoolTrayIcon;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    Panel2: TPanel;
    CheckBoxAuto: TCheckBox;
    ButtonF2: TButton;
    ButtonF3: TButton;
    ButtonSetup: TButton;
    procedure ListBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ListBox1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ReadIniData;
    procedure WriteIniData;
    procedure SetPswToClipboard;
    procedure ErrorMessage(Mess: String);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CheckBoxAutoKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure N4Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure ButtonF2KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ButtonF3KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ButtonF2Click(Sender: TObject);
    procedure ButtonF3Click(Sender: TObject);
    procedure ButtonSetupClick(Sender: TObject);
    procedure ButtonSetupKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  Opros,  // Если True, опрос включен или надо включить
  AppRun, // Если True, приложение уже запущено
  FlagSaveDataIni,   // Если True, будем сохранять Data.ini
  SysError: Boolean; // Если True, сообщения об ошибке выводся как системные, видимые даже при свёрнутом окне приложения
  EditLoginHeader, EditPasswordHeader, ButtonOkHeader: HWND; // Заголовки окон для ввода логина, пароля RAdmin и кнопки ОК
  RadminCaptionStart, rl_start, rl_end, rp_start, rp_end, in_start, in_end, ButtonOkCaption: String;
  DefaultLogin,      // Имя пользователя по умолчанию
  DefaultPassword,   // Пароль по умолчанию
  InfoFileName: String; // Имя файла информации об объекте

implementation

uses Unit2;

{$R *.dfm}
{$R MyRes.RES} // Этот ресурс с иконками создаём сами

// Создание главного окна
procedure TForm1.FormCreate(Sender: TObject);
begin
  Form1.Caption := Application.Title;
  CoolTrayIcon1.Hint := Application.Title;
  AppRun := False;
  FlagSaveDataIni := True;
  SysError := True;
  Opros := False;
  InfoFileName := '';
  ReadIniData; // Чтение ini-файла

  if AppRun then // Если установлен флаг, что приложение уже запущено
  begin
    Timer1.Enabled := False;  // Не обрабатываем заголовки активных окон
    Opros := False;           // Не запускаем опрос серверов
    FlagSaveDataIni := False; // Не сохраняем Data.ini
    SysError := True; // Чтобы вызов сообщения об ошибке был системным
    ErrorMessage('Приложение уже запущено. Флаг AppRun=1 в Data.ini');
    Application.Terminate;   // Form1.Close не работает
  end else
  begin
    AppRun := True;
    WriteIniData; // Запишем, что приложение запущено
  end;
end;

// Чтение ini-файла
procedure TForm1.ReadIniData;
var
  Ini: TIniFile;
  i: Integer;
begin
  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Data.ini');
  try
    Form1.Left   := Ini.ReadInteger('Position', 'X', 5);
    Form1.Top    := Ini.ReadInteger('Position', 'Y', 390);
    Form1.Width  := Ini.ReadInteger('Size', 'Width', 310);
    Form1.Height := Ini.ReadInteger('Size', 'Height', 300);
    CheckBoxAuto.Checked := Ini.ReadBool('Flag', 'Automatic', False);
    AppRun   := Ini.ReadBool('Flag', 'AppRun', False);
    Opros    := Ini.ReadBool('Flag', 'Opros', False);
    SysError := Ini.ReadBool('Flag', 'SysError', True);

    i := Ini.ReadInteger('Flag', 'Timer', 400);
    if (i < 50) or (i > 10000) then i := 400;
    Timer1.Interval := i;  // Интервал в мс между проверками заголовка активного окна Windows 

    RadminCaptionStart := Ini.ReadString('Strings', 'RadminCaptionStart', 'Система безопасности Radmin:');
    rl_start := Ini.ReadString('Strings', 'rl_start', 'rl(');
    rl_end   := Ini.ReadString('Strings', 'rl_end', ')');
    rp_start := Ini.ReadString('Strings', 'rp_start', 'rp(');
    rp_end   := Ini.ReadString('Strings', 'rp_end', ')');
    in_start := Ini.ReadString('Strings', 'in_start', 'i(');
    in_end   := Ini.ReadString('Strings', 'in_end', ')');
    ButtonOkCaption := Ini.ReadString('Strings', 'ButtonOkCaption', 'ОК');
    DefaultLogin    := Ini.ReadString('Strings', 'DefaultLogin', 'DefaultLogin');
    DefaultPassword := Ini.ReadString('Strings', 'DefaultPassword', 'DefaultPassword');
    Ini.ReadSection('Password strings', ListBox1.Items);
  finally
    Ini.Free;
  end;
end;

// Сохранение ini-файла
procedure TForm1.WriteIniData;
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Data.ini');
  try
    Ini.WriteInteger('Position', 'X', Form1.Left);
    Ini.WriteInteger('Position', 'Y', Form1.Top);
    Ini.WriteInteger('Size', 'Width', Form1.Width);
    Ini.WriteInteger('Size', 'Height', Form1.Height);
    Ini.WriteBool('Flag', 'Automatic', CheckBoxAuto.Checked);
    Ini.WriteBool('Flag', 'AppRun', AppRun);
    Ini.WriteBool('Flag', 'Opros', Opros);
    Ini.WriteBool('Flag', 'SysError', SysError);
    Ini.WriteInteger('Flag', 'Timer', Timer1.Interval);
    Ini.WriteString('Strings', 'RadminCaptionStart', RadminCaptionStart);
    Ini.WriteString('Strings', 'rl_start', rl_start);
    Ini.WriteString('Strings', 'rl_end', rl_end);
    Ini.WriteString('Strings', 'rp_start', rp_start);
    Ini.WriteString('Strings', 'rp_end', rp_end);
    Ini.WriteString('Strings', 'in_start', in_start);
    Ini.WriteString('Strings', 'in_end', in_end);
    Ini.WriteString('Strings', 'ButtonOkCaption', ButtonOkCaption);
    Ini.WriteString('Strings', 'DefaultLogin', DefaultLogin);
    Ini.WriteString('Strings', 'DefaultPassword', DefaultPassword);
  finally
    Ini.Free;
  end;
end;

procedure TForm1.ListBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  SetPswToClipboard; // Копируем пароль в буфер обмена
end;

// В списке паролей формат такой: пароль - описание.
// Пароль должен быть без пробелов.
// В буфер обмена копируем только пароль.
procedure TForm1.SetPswToClipboard;
var
  Str: String;
  i: Integer;
begin
  if ListBox1.ItemIndex >= 0 then
  try
    Str := Trim(ListBox1.Items[ListBox1.ItemIndex]);
    i := Pos(' ', Str); // Строка уже очищена от пробелов по краям, ищем пробел внутри строки
    if (i > 0) then Str := Copy(Str, 1, i-1);
    Clipboard.AsText := Str;
    Panel1.Caption := ' ' + Str; // На панели отобразим пароль скопированный в буфер обмена
  except
    on E: Exception do ;
  end;
end;

// Выводим сообщение об ошибке. В зависимости от флага SysErr
// оно будет либо поверх всех окон ОС (SysErr = True), либо только в приложении
procedure TForm1.ErrorMessage(Mess: String);
begin
  if SysError then MessageBox(0, PChar(Mess), PChar(Application.Title + ' Ошибка'),
    MB_ICONERROR + MB_OK + MB_SETFOREGROUND + MB_SYSTEMMODAL)
  else MessageDlg(Mess, mtError, [mbOk], 0);
end;

procedure TForm1.ListBox1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Ini: TIniFile;
begin
  case Key of
    // Открываем файл справки приложения
    VK_F1: begin
      ShellExecute(Handle, nil, 'Readme.txt', nil, nil, SW_ShowNormal);
    end;

    // Ping ip-адреса
    VK_F2: begin
      ButtonF2Click(Sender);
    end;

    // Открываем файл информации о последнем объекте
    VK_F3: begin
      ButtonF3Click(Sender);
    end;

    // Открываем окно настройки опроса серверов
    VK_F4: begin
      ButtonSetupClick(Sender);
    end;

    // Обновляем список паролей по F5 и обновляем буфер обмена ОС (Clipboard)
    VK_F5: begin
      Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Data.ini');
      try
        Ini.ReadSection('Password strings', ListBox1.Items);
      finally
        Ini.Free;
      end;
      if ListBox1.Items.Count > 0 then
      begin
        ListBox1.ItemIndex := 0;
        SetPswToClipboard;
      end;
    end;

    // Открываем файл настроек приложения
    VK_F6: begin
      ShellExecute(Handle, nil, 'Data.ini', nil, nil, SW_ShowNormal);
    end;

    // Обновляем буфер обмена ОС
    else SetPswToClipboard;
  end;
end;

function GetWindowTitle(hwnd: HWND): String;
begin
  SetLength(Result, 255);
  SetLength(Result, GetWindowText(hwnd, PChar(Result), 255));
end;

function GetWindowClass(hwnd: HWND): String;
begin
  SetLength(Result, 255);
  SetLength(Result, GetClassName(hwnd, PChar(Result), 255));
end;

function EnumWindowsProc(hwnd: HWND; lParam: Integer): BOOL; stdcall;
begin
  Result := True;
  if GetWindowClass(hwnd) = 'Edit' then
    if EditLoginHeader > 0 then EditPasswordHeader := hwnd else EditLoginHeader := hwnd;
  if (GetWindowClass(hwnd) = 'Button') and (GetWindowTitle(hwnd) = ButtonOkCaption)
    then ButtonOkHeader := hwnd;
end;

// По событию таймера обрабатываем активное окно ОС в поисках окна RAdmin
procedure TForm1.Timer1Timer(Sender: TObject);
var
  Header: HWND;
  Len, p1, p2: Integer;
  Str, s1, s2, Log, Pwd: String;
begin
  if CheckBoxAuto.Checked and Timer1.Enabled then // Режим автоматического ввода паролей включен
  begin
    //EnumWindows(@EnumWindowsProc, Integer(Tree)); // Все окна Windows
    Header := GetForegroundWindow; // Заголовок активного окна Windows
    if Header <> 0 then Str := Trim(GetWindowTitle(Header)); // Название активного окна Windows
    if Pos(RadminCaptionStart, Str) <> 0 then // Это окно RAdmin
    begin
      Timer1.Enabled := False; // Останавливаем таймер, чтобы не обрабатывать одно окно дважды
      EditLoginHeader := 0; EditPasswordHeader := 0; ButtonOkHeader := 0;
      Log := DefaultLogin; Pwd := DefaultPassword; InfoFileName := '';

      Len := Length(Str);

      p1 := Pos(rl_start, Str);
      if p1 <> 0 then
      begin
        s1 := Copy(Str, p1 + Length(rl_start), Len - p1);
        p2 := Pos(rl_end, s1);
        if p2 <> 0 then
        begin
          s2 := Trim(Copy(s1, 1, p2-1));
          if (s2 <> '') then Log := s2;
        end;
      end;

      p1 := Pos(rp_start, Str);
      if p1 <> 0 then
      begin
        s1 := Copy(Str, p1 + Length(rp_start), Len - p1);
        p2 := Pos(rp_end, s1);
        if p2 <> 0 then
        begin
          s2 := Trim(Copy(s1, 1, p2-1));
          if (s2 <> '') then Pwd := s2;
        end;
      end;

      p1 := Pos(in_start, Str);
      if p1 <> 0 then
      begin
        s1 := Copy(Str, p1 + Length(in_start), Len - p1);
        p2 := Pos(in_end, s1);
        if p2 <> 0 then
        begin
          s2 := Trim(Copy(s1, 1, p2-1));
          if (s2 <> '') then InfoFileName := s2;
        end;
      end;

      try
        EnumChildWindows(Header, @EnumWindowsProc, 0); // поиск в цикле дочерних элементов окна

        // Есть два варианта окна RAdmin: с двумя Edit для логина и пароля
        // или с одним Edit для пароля.

        // Если Edit в окне только один, на данном этапе мы можем получить ситуацию,
        // когда EditLoginHeader найден, а EditPasswordHeader нет.
        if (EditLoginHeader > 0) and (EditPasswordHeader = 0) then
        begin
          EditPasswordHeader := EditLoginHeader; // Если Edit один, то он для пароля
          EditLoginHeader := 0;
          Str := ' ' + rp_start + Pwd + rp_end;
        end else Str := ' ' + rl_start + Log + rl_end + ' ' + rp_start + Pwd + rp_end;

        if InfoFileName <> '' then Str := Str + ' ' + in_start + InfoFileName + in_end;

        Panel1.Caption := Str;

        // Заполняем поля логином, паролем и нажимаем кнопку ОК
        if EditLoginHeader    > 0 then SendMessage(EditLoginHeader, WM_SETTEXT, 0, Integer(PChar(Log)));
        if EditPasswordHeader > 0 then SendMessage(EditPasswordHeader, WM_SETTEXT, 0, Integer(PChar(Pwd)));
        if ButtonOkHeader     > 0 then SendMessage(ButtonOkHeader, BM_CLICK, 0, 0);
      except
        on E: Exception do ErrorMessage(E.ClassName + ': ' + E.Message);
      end;
      Timer1.Enabled := True;
    end;
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  if ListBox1.Items.Count > 0 then // Если список паролей не пустой
  begin
    ListBox1.ItemIndex := 0; // Устанавливаем фокус на первую строку
    SetPswToClipboard;       // Копируем пароль в буфер обмена
  end;
end;

procedure TForm1.CheckBoxAutoKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  ListBox1KeyUp(Sender, Key, Shift);
end;

procedure TForm1.N1Click(Sender: TObject);
begin
  CoolTrayIcon1.ShowMainForm;
end;

procedure TForm1.N2Click(Sender: TObject);
begin
  CoolTrayIcon1.HideMainForm;
end;

procedure TForm1.N4Click(Sender: TObject);
begin
  Form1.Close;
end;

procedure TForm1.ButtonF2KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  ListBox1KeyUp(Sender, Key, Shift);
end;

procedure TForm1.ButtonF3KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  ListBox1KeyUp(Sender, Key, Shift);
end;

procedure TForm1.ButtonSetupKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  ListBox1KeyUp(Sender, Key, Shift);
end;

// Вызов cmd.exe с командой ping и ip-адресом из буфера обмена ОС
procedure TForm1.ButtonF2Click(Sender: TObject);
var
  Str: String;
begin
  if Clipboard.HasFormat(CF_TEXT) then
  begin
    Str := Clipboard.AsText;
    If Length(Str) < 100 then begin
      //Str := 'cmd /c ping ' + Clipboard.AsText +  ' -t';
      //WinExec(Pchar(Str), 1);
      Str := '/k ping ' + Str + ' -t';
      //ShellExecute(0,'open','ping',Pchar(Str),nil,SW_SHOW);
      ShellExecute(0, 'open', 'cmd.exe', PChar(Str), nil, SW_SHOW);
    end;
  end;
end;

procedure TForm1.ButtonF3Click(Sender: TObject);
begin
  if InfoFileName <> '' then
  begin
    // Пытаемся открыть файл информации, если не получилось, выводим сообщение об ошибке
    if ShellExecute(Handle, nil, PChar(InfoFileName+'.txt'), nil, nil, SW_ShowNormal) = 2 then
      MessageDlg('Файл информации ' + InfoFileName + '.txt не найден', mtError, [mbOk], 0);
  end
  else MessageDlg('Файл информации о последнем подключении не задан', mtWarning, [mbOk], 0);
end;

procedure TForm1.ButtonSetupClick(Sender: TObject);
begin
  FormSetup.Show; // Открываем окно настройки опроса серверов
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if FlagSaveDataIni then
  begin
    AppRun := False; // Установим флаг, что приложение закрыто
    WriteIniData;    // Сохраняем ini-файл
  end;
end;

end.
