{
  Demo program for article # 20 "How to extract version information using the
  Windows API" from http://www.delphidabbler.com/articles.php?id=20.

  Main project file
  Copyright (c) 2005, P.D.Johnson (DelphiDabbler)
}

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
