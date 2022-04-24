{
  This demo application accompanies the article
  "How to handle drag and drop in a TWebBrowser control" at
  http://www.delphidabbler.com/articles/article-25.

  This is the main form file of example program 2.
}


unit FmDemo2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw;

type
  TDemoForm2 = class(TForm)
    WebBrowser1: TWebBrowser;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  end;

var
  DemoForm2: TDemoForm2;

implementation

uses
  ActiveX;

{$R *.dfm}

procedure TDemoForm2.FormCreate(Sender: TObject);
begin
  OleInitialize(nil);
end;

procedure TDemoForm2.FormDestroy(Sender: TObject);
begin
  OleUninitialize;
end;

end.
