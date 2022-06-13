{
 * This source code accompanies the article "How to customise the TWebBrowser
 * user interface" which can be found at
 * https://delphidabbler.com/articles/article-18
}


{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$WARNINGS ON}


unit FmArtDemo2;

interface

uses
  Forms, Menus, OleCtrls, SHDocVw, Classes, Controls, StdCtrls, XPMan,

  UContainer;


type
  TArtDemoForm2 = class(TForm)
    Button1: TButton;
    WebBrowser1: TWebBrowser;
    PopupMenu1: TPopupMenu;
    ShowtheCSS1: TMenuItem;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ShowtheCSS1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    fWBContainer: TWBContainer;
  end;

var
  ArtDemoForm2: TArtDemoForm2;

implementation

uses
  SysUtils, Windows, Graphics, Dialogs;

{$R *.dfm}

{
  ColorToHTML is taken from the CodeSnip database at
  http://www.delphidabbler.com/codesnip
}
function ColorToHTML(const Color: TColor): string;
var
  ColorRGB: Integer;
begin
  ColorRGB := ColorToRGB(Color);
  Result := Format(
    '#%0.2X%0.2X%0.2X',
    [GetRValue(ColorRGB), GetGValue(ColorRGB), GetBValue(ColorRGB)]
  );
end;


{ TArtDemoForm }

procedure TArtDemoForm2.FormCreate(Sender: TObject);
const
  // Template for default CSS style
  cCSSTplt = 'body {'#13#10
    + '    background-color: %0:s;'#13#10
    + '    color: %1:s;'#13#10
    + '    font-family: "%2:s";'#13#10
    + '    font-size: %3:dpt;'#13#10
    + '    margin: 4px;'#13#10
    + '}'#13#10
    + 'h1 {'#13#10
    + '    font-size: %3:dpt;'#13#10
    + '    font-weight: bold;'#13#10
    + '    text-align: center;'#13#10
    + '}'#13#10
    + 'input#button {'#13#10
    + '    color: %1:s;'#13#10
    + '    font-family: "%2:s";'#13#10
    + '    font-size: %3:dpt;'#13#10
    + '}'#13#10
    + '.ruled {'#13#10
    + '    border-bottom: %4:s solid 2px;'#13#10
    + '    padding-bottom: 6px;'#13#10
    + '}';
var
  FmtCSS: string;  // Stores default CSS
begin
  // Create the CSS from system colours
  FmtCSS := Format(
    cCSSTplt,
    [ColorToHTML(Self.Color), ColorToHTML(Self.Font.Color),
    Self.Font.Name, Self.Font.Size,
    ColorToHTML(clInactiveCaption)]
  );
  // Create web browser container and set required properties
  fWBContainer := TWBContainer.Create(WebBrowser1);
  fWBContainer.UseCustomCtxMenu := True;    // use our popup menu
  fWBContainer.Show3DBorder := False;       // no border
  fWBContainer.ShowScrollBars := False;     // no scroll bars
  fWBContainer.AllowTextSelection := False; // no text selection (**)
  fWBContainer.CSS := FmtCSS;               // CSS to be used
  // load content
  fWBContainer.HostedBrowser.Navigate(
    ExtractFilePath(ParamStr(0)) + '..\Shared\DlgContent.html'
  );
end;

procedure TArtDemoForm2.Button1Click(Sender: TObject);
begin
  Close;  // close the application
end;

procedure TArtDemoForm2.ShowtheCSS1Click(Sender: TObject);
begin
  ShowMessage(fWBContainer.CSS);  // display the CSS code
end;

procedure TArtDemoForm2.FormDestroy(Sender: TObject);
begin
  fWBContainer.Free;  // free the container pbject
end;

end.
