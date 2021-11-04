program PswList;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Unit2 in 'Unit2.pas' {FormSetup};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Password List v1.8';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFormSetup, FormSetup);
  Application.Run;
end.
