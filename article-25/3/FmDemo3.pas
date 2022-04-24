{
  This demo application accompanies the article
  "How to handle drag and drop in a TWebBrowser control" at
  http://www.delphidabbler.com/articles/article-25.

  This is the main form file of example program 3.
}


unit FmDemo3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw,

  UWBDragDropContainer;

type
  TDemoForm3 = class(TForm)
    WebBrowser1: TWebBrowser;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    fWBContainer: TWBDragDropContainer;
  public
    { Public declarations }
  end;

var
  DemoForm3: TDemoForm3;

implementation

uses
  ActiveX, UNulDropTarget;

{$R *.dfm}

procedure TDemoForm3.FormCreate(Sender: TObject);
begin
  OleInitialize(nil);
  fWBContainer := TWBDragDropContainer.Create(WebBrowser1);
  fWBContainer.DropTarget := TNulDropTarget.Create;
  WebBrowser1.Navigate('about:blank');
end;

procedure TDemoForm3.FormDestroy(Sender: TObject);
begin
  fWBContainer.DropTarget := nil;
  OleUninitialize;
  FreeAndNil(fWBContainer);
end;

end.
