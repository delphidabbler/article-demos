{
  This demo application accompanies the article
  "How to handle drag and drop in a TWebBrowser control" at
  http://www.delphidabbler.com/articles/article-25.

  This is the main project file of example program 2.
}


program Article25Demo2;

uses
  Forms,
  FmDemo2 in 'FmDemo2.pas' {DemoForm2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDemoForm2, DemoForm2);
  Application.Run;
end.
