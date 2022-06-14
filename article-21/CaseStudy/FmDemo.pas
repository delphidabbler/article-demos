{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$WARNINGS ON}

unit FmDemo;

interface

uses
  SHDocVw, Controls, StdCtrls, Classes, OleCtrls, Forms;

type
  TForm1 = class(TForm)
    WebBrowser1: TWebBrowser;
    ComboBox1: TComboBox;
    procedure FormShow(Sender: TObject);
    procedure WebBrowser1DocumentComplete(Sender: TObject;
      const pDisp: IDispatch; var URL: OleVariant);
    procedure ComboBox1Change(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

uses
  SysUtils, Dialogs, MSHTML;

{$R *.dfm}

procedure TForm1.ComboBox1Change(Sender: TObject);
  { Make browser use selected font }
var
  Doc: IHTMLDocument2;      // current HTML document
  HTMLWindow: IHTMLWindow2; // parent window of current HTML document
  JSFn: string;             // stores JavaScipt function call
begin
  // Get reference to current document
  Doc := WebBrowser1.Document as IHTMLDocument2;
  if not Assigned(Doc) then
    Exit;
  // Get parent window of current document
  HTMLWindow := Doc.parentWindow;
  if not Assigned(HTMLWindow) then
    Exit;
  // Run JavaScript
  try
    JSFn := 'SetFont(''' + ComboBox1.Text + ''')';
    HTMLWindow.execScript(JSFn, 'JavaScript');
  except
    // handle exception in case JavaScript fails to run
    ShowMessage('Error running JavaScript');
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
  { Setup combo box and load document }
begin
  // Store screen fonts in combo box and disabled it
  ComboBox1.Items.Assign(Screen.Fonts);
  ComboBox1.Enabled := False;
  // Load the HTML page
  WebBrowser1.Navigate(ExtractFilePath(ParamStr(0)) + 'Test.html');
end;

procedure TForm1.WebBrowser1DocumentComplete(Sender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
  { Document loaded: enable combo box }
begin
  ComboBox1.Enabled := True;
end;

end.

