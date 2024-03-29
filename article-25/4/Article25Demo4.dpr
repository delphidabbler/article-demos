{
  This demo application accompanies the article
  "How to handle drag and drop in a TWebBrowser control" at
  http://www.delphidabbler.com/articles/article-25.

  This is the main project file of example program 4.
}


program Article25Demo4;

uses
  Forms,
  FmDemo4 in 'FmDemo4.pas' {DemoForm4},
  UWBDragDropContainer in '..\Shared\UWBDragDropContainer.pas',
  IntfDocHostUIHandler in '..\Shared\IntfDocHostUIHandler.pas',
  UNulContainer in '..\Shared\UNulContainer.pas',
  UCustomDropTarget in 'UCustomDropTarget.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDemoForm4, DemoForm4);
  Application.Run;
end.
