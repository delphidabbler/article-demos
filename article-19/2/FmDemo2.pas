{
  This demo application accompanies the article
  "How to make a TWebBrowser become the active control when clicked" on
  http://www.delphidabbler.com/articles?article=19.

  This demo relates to the first solution presented in the article.

  This demo is copyright Peter D Johnson (www.delphidabbler.com) 2004-2009 and
  is licensed under the Creative Commons Attribution-Noncommercial-Share Alike
  2.5 Generic License: http://creativecommons.org/licenses/by-nc-sa/2.5/
}


{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$WARNINGS ON}


unit FmDemo2;

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
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure WebBrowser1CommandStateChange(Sender: TObject;
      Command: Integer; Enable: WordBool);
    procedure Button1Click(Sender: TObject);
  end;

var
  DemoForm: TDemoForm;

implementation

uses
  SysUtils, MSHTML;

{$R *.dfm}

procedure TDemoForm.FormShow(Sender: TObject);
begin
  WebBrowser1.Navigate('about:blank');
end;

procedure TDemoForm.Timer1Timer(Sender: TObject);
begin
  if Assigned(ActiveControl) then
    StatusBar1.SimpleText := 'ActiveControl = '
      + ActiveControl.Name
  else
    StatusBar1.SimpleText := 'ActiveControl = nil';
end;

procedure TDemoForm.WebBrowser1CommandStateChange(Sender: TObject;
  Command: Integer; Enable: WordBool);
var
  Doc: IHTMLDocument2;        // document object
  Sel: IHTMLSelectionObject;  // current selection
begin
  // Check we have a valid web browser triggering this event
  if not Assigned(Sender) or not (Sender is TWebBrowser) then
    Exit;
  // Check we have required command
  if TOleEnum(Command) <> CSC_UPDATECOMMANDS then
    Exit;
  // Get ref to document object and check not nil
  Doc := WebBrowser1.Document as IHTMLDocument2;
  if not Assigned(Doc) then
    Exit;
  // Get ref to current selection
  Sel := Doc.selection as IHTMLSelectionObject;
  // If selection is of correct type then we have a mouse click
  if Assigned(Sel) and (Sel.type_ = 'Text') then
  	// Make the web browser the form's active control
    ActiveControl := Sender as TWebBrowser;
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
