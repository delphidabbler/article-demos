{
 * This source code accompanies the article "How to customise the TWebBrowser
 * user interface" which can be found at
 * https://delphidabbler.com/articles/article-18.
}


{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$WARNINGS ON}


unit FmArtDemo1;

interface

uses
  Forms, Menus, OleCtrls, SHDocVw, Classes, Controls, StdCtrls, XPMan;

type
  TArtDemoForm1 = class(TForm)
    Button1: TButton;
    WebBrowser1: TWebBrowser;
    PopupMenu1: TPopupMenu;
    ShowtheCSS1: TMenuItem;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  end;

var
  ArtDemoForm1: TArtDemoForm1;

implementation

uses
  SysUtils;

{$R *.dfm}

{ TArtDemoForm }

procedure TArtDemoForm1.FormCreate(Sender: TObject);
begin
  WebBrowser1.Navigate(
    ExtractFilePath(ParamStr(0)) + '..\Shared\DlgContent.html'
  );
end;

procedure TArtDemoForm1.Button1Click(Sender: TObject);
begin
  Close;  // close the application
end;

end.
