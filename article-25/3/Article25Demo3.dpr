{
  This demo application accompanies the article
  "How to handle drag and drop in a TWebBrowser control" at
  http://www.delphidabbler.com/articles/article-25.

  This is the main project file of example program 3.
}


program Article25Demo3;

uses
  Forms,
  FmDemo3 in 'FmDemo3.pas' {DemoForm3},
  UWBDragDropContainer in '..\Shared\UWBDragDropContainer.pas',
  IntfDocHostUIHandler in '..\Shared\IntfDocHostUIHandler.pas',
  UNulContainer in '..\Shared\UNulContainer.pas',
  UNulDropTarget in 'UNulDropTarget.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDemoForm3, DemoForm3);
  Application.Run;
end.
