{
  This demo application accompanies the article
  "How to make a TWebBrowser become the active control when clicked" on
  http://www.delphidabbler.com/articles?article=19.

  This demo shows the problem that the article addresses.

  This demo is copyright Peter D Johnson (www.delphidabbler.com) 2009 and
  is licensed under the Creative Commons Attribution-Noncommercial-Share Alike
  2.5 Generic License: http://creativecommons.org/licenses/by-nc-sa/2.5/
}


{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$WARNINGS ON}


unit FmDemo1;

interface

uses
  Forms, Dialogs, StdCtrls, ExtCtrls, ComCtrls, OleCtrls, SHDocVw, Classes,
  Controls;

type
  TDemoForm = class(TForm)
    Memo1: TMemo;
    WebBrowser1: TWebBrowser;
    StatusBar1: TStatusBar;
    Timer1: TTimer;
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  end;

var
  DemoForm: TDemoForm;

implementation

uses
  SysUtils, MSHTML;

{$R *.dfm}

procedure TDemoForm.Timer1Timer(Sender: TObject);
begin
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

end.

