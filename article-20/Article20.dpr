program Article20;

uses
  Forms,
  FmDemo in 'FmDemo.pas' {Form1},
  UVerInfoRoutines in 'UVerInfoRoutines.pas',
  UVerInfoClass in 'UVerInfoClass.pas',
  UVerInfoTypes in 'UVerInfoTypes.pas';

{$R *.res}
{$R VArticle20.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
