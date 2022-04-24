{
  This demo application accompanies the article
  "How to handle drag and drop in a TWebBrowser control" at
  http://www.delphidabbler.com/articles?article=25.

  This is the main form file of example program 4.

  This code is copyright (c) P D Johnson (www.delphidabbler.com), 2007.

  v1.0 of 2007/04/22 - original version
}


unit FmDemo4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw,

  UWBDragDropContainer, UCustomDropTarget;

type
  TDemoForm4 = class(TForm, IDropHandler)
    WebBrowser1: TWebBrowser;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    fWBContainer: TWBDragDropContainer;
    procedure SetBoxInnerHTML(const HTML: string);
  protected
    { IDropHandler methods }
    procedure HandleText(const Text: string);
    procedure HandleFiles(const Files: TStrings);
  end;

var
  DemoForm4: TDemoForm4;

implementation

uses
  ActiveX, MSHTML;

{$R *.dfm}

function MakeSafeHTMLText(TheText: string): string;
var
  Idx: Integer; // loops thru the given text
begin
  Result := '';
  for Idx := 1 to Length(TheText) do
    case TheText[Idx] of
      '<':  // opens tags: replace with special char reference
        Result := Result + '&lt;';
      '>':  // closes tags: replace with special char reference
        Result := Result + '&gt;';
      '&':  // begins char references: replace with special char reference
        Result := Result + '&amp;';
      '"':  // quotes (can be a problem in quoted attributes)
        Result := Result + '&quot;';
      #0..#31, #127..#255:  // control and special chars: replace with encoding
        Result := Result + '&#' + SysUtils.IntToStr(Ord(TheText[Idx])) + ';';
      else  // compatible text: pass thru
        Result := Result + TheText[Idx];
    end;
end;

procedure TDemoForm4.FormCreate(Sender: TObject);
begin
  OleInitialize(nil);
  fWBContainer := TWBDragDropContainer.Create(WebBrowser1);
  fWBContainer.DropTarget := TCustomDropTarget.Create(Self);
  WebBrowser1.Navigate(ExtractFilePath(ParamStr(0)) + 'Demo4.html');
end;

procedure TDemoForm4.FormDestroy(Sender: TObject);
begin
  fWBContainer.DropTarget := nil;
  OleUninitialize;
  FreeAndNil(fWBContainer);
end;

procedure TDemoForm4.FormShow(Sender: TObject);
begin
  while WebBrowser1.ReadyState <> READYSTATE_COMPLETE do
  begin
    Sleep(5);
    Application.ProcessMessages;
  end;
end;

procedure TDemoForm4.HandleFiles(const Files: TStrings);
var
  Idx: Integer;
  HTML: string;
begin
  HTML := '<ul>'#13#10;
  for Idx := 0 to Pred(Files.Count) do
    HTML := HTML + '<li>' + MakeSafeHTMLText(Files[Idx]) + '</li>'#13#10;
  HTML := HTML + '</ul>';
  SetBoxInnerHTML(HTML);
end;

procedure TDemoForm4.HandleText(const Text: string);
begin
  SetBoxInnerHTML('<pre>' + MakeSafeHTMLText(Text) + '</pre>');
end;

procedure TDemoForm4.SetBoxInnerHTML(const HTML: string);
var
  BoxDiv: IHTMLElement;
  Doc: IHTMLDocument3;
begin
  if Supports(WebBrowser1.Document, IHTMLDocument3, Doc) then
  begin
    BoxDiv := Doc.getElementById('box');
    if Assigned(BoxDiv) then
      BoxDiv.innerHTML := HTML;
  end;
end;

end.

