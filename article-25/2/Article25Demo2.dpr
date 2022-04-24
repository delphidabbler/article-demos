{
  This demo application accompanies the article
  "How to handle drag and drop in a TWebBrowser control" at
  http://www.delphidabbler.com/articles?article=25.

  This is the main project file of example program 2.

  This code is copyright (c) P D Johnson (www.delphidabbler.com), 2007.

  v1.0 of 2007/04/22 - original version
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
