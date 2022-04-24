{
  This demo application accompanies the article
  "How to call Delphi code from scripts running in a TWebBrowser" at
  http://www.delphidabbler.com/articles?article=22.

  This unit defines the main form class.

  This code is copyright (c) P D Johnson (www.delphidabbler.com), 2005-2006.

  v1.0 of 2005/05/09 - original version
  v1.1 of 2006/02/11 - changed to use revised container object that implements
                       IDocHostUIHandler.GetExternal
}


{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}


unit FmDemo;

interface

uses
  SysUtils, OleCtrls, SHDocVw, Classes, Controls, ComCtrls, Forms,
  UExternalContainer;

type
  TForm1 = class(TForm)
    StatusBar1: TStatusBar;
    WebBrowser1: TWebBrowser;
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
  private
    fContainer: TExternalContainer;
  end;

var
  Form1: TForm1;

implementation


{$R *.dfm}

procedure TForm1.FormShow(Sender: TObject);
begin
  fContainer := TExternalContainer.Create(WebBrowser1);
  WebBrowser1.Navigate(
    ExtractFilePath(ParamStr(0)) + 'Article22.html'
  );
end;

procedure TForm1.FormHide(Sender: TObject);
begin
  fContainer.Free;
end;

end.
