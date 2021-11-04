Чтобы создать файл ресурсов, запустить MakeRes.bat в папке
"C:\Program Files\Borland\Delphi7\Bin"

Там же должен быть файл конфигурации MyRes.rc и сами ресурсы

Получаем MyRes.RES, копируем его в папку проекта, добавляем

...

implementation

uses Unit2;

{$R *.dfm}
{$R MyRes.RES} <--- тут

procedure TForm1.FormCreate(Sender: TObject);

...


========================================================================

В папке "C:\Program Files\Borland\Delphi7\Projects\Bpl"

файлы CoolTrayIcon

========================================================================


