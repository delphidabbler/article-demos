{
  This demo application accompanies the article
  "How to handle drag and drop in a TWebBrowser control" at
  http://www.delphidabbler.com/articles/article-25.

  This is the main form file of example program 1.
}


unit FmDemo1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw;

type
  TDemoForm1 = class(TForm)
    WebBrowser1: TWebBrowser;
  end;

var
  DemoForm1: TDemoForm1;

implementation

{$R *.dfm}

end.
