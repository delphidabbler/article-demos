{
  This demo application accompanies the article
  "How to make a TWebBrowser become the active control when clicked" on
  http://www.delphidabbler.com/articles?article=19.

  This demo relates to the second solution presented in the article.

  This demo is copyright Peter D Johnson (www.delphidabbler.com) 2009 and
  is licensed under the Creative Commons Attribution-Noncommercial-Share Alike
  2.5 Generic License: http://creativecommons.org/licenses/by-nc-sa/2.5/
}


{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$WARNINGS ON}


unit FmDemo3;

interface

uses
  Forms, Dialogs, StdCtrls, ExtCtrls, ComCtrls, OleCtrls, SHDocVw, Classes,
  Controls, AppEvnts, Windows;

type
  TDemoForm = class(TForm)
    Memo1: TMemo;
    WebBrowser1: TWebBrowser;
    StatusBar1: TStatusBar;
    Timer1: TTimer;
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    ApplicationEvents1: TApplicationEvents;
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ApplicationEvents1Message(var Msg: tagMSG;
      var Handled: Boolean);
  private
    IEServerWindow: HWND;
  end;

var
  DemoForm: TDemoForm;

implementation

uses
  SysUtils, MSHTML, Messages;

{$R *.dfm}

procedure TDemoForm.FormShow(Sender: TObject);
begin
  WebBrowser1.Navigate('about:blank');
end;

procedure TDemoForm.Timer1Timer(Sender: TObject);
var
  NextWin: HWND;  // handle of various child windows
begin
  while IEServerWindow = 0 do
  begin
    NextWin := FindWindowEx(DemoForm.Handle, 0, 'Shell Embedding', nil);
    NextWin := FindWindowEx(NextWin, 0, 'Shell DocObject View', nil);
    IEServerWindow := FindWindowEx(
      NextWin, 0, 'Internet Explorer_Server', nil
    );
  end;

  if Assigned(ActiveControl) then
    StatusBar1.SimpleText := 'ActiveControl = '
      + ActiveControl.Name
  else
    StatusBar1.SimpleText := 'ActiveControl = nil';
end;

procedure TDemoForm.Button1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    StatusBar1.SimpleText := '';  // fixes SB redraw problem
    if FileExists(OpenDialog1.FileName) then
    begin
      WebBrowser1.Navigate('file://' + OpenDialog1.FileName);
      Memo1.Lines.LoadFromFile(OpenDialog1.FileName);
    end
    else
    begin
      WebBrowser1.Navigate('about:blank');
      Memo1.Text := 'about:blank';
    end;
  end;
end;

procedure TDemoForm.ApplicationEvents1Message(var Msg: tagMSG;
  var Handled: Boolean);
begin
  if (Msg.hwnd = IEServerWindow) then
    if (Msg.message = WM_LBUTTONDOWN) or (Msg.message = WM_RBUTTONDOWN)
      or (Msg.message = WM_MBUTTONDOWN) then
      ActiveControl := WebBrowser1;
end;

end.

