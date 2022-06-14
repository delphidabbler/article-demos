unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, OleCtrls, ExtCtrls, {REQUIRED UNITS} SHDocVw, MSHTML,
  ComCtrls {/REQUIRED UNITS};

type
  TForm1 = class(TForm)
    WebBrowser1: TWebBrowser;
    Shape4: TShape;
    Shape7: TShape;
    Edit1: TEdit;
    Label1: TLabel;
    Button3: TButton;
    Panel1: TPanel;
    RichEdit1: TRichEdit;
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{--- HELPER FUNCTIONS ---}

function ExecuteJavaScript(WebBrowser:TWebBrowser; Code: string):Variant;
var
  Document:IHTMLDocument2;
  Window:IHTMLWindow2;
begin
  // execute javascript in webbrowser
  Document:=WebBrowser.Document as IHTMLDocument2;
  if not Assigned(Document) then Exit;
  Window:=Document.parentWindow;
  if not Assigned(Window) then Exit;
  try
    Result:=Window.execScript(Code,'JavaScript');
  except
    on E:Exception do raise Exception.Create('Javascript error '+E.Message+' in: '#13#10+Code);
  end;
end;

function GetElementIdValue(WebBrowser:TWebBrowser; TagName,TagId,TagAttrib:String):String;
var
  Document: IHTMLDocument2;
  Body: IHTMLElement2;
  Tags: IHTMLElementCollection;
  Tag: IHTMLElement;
  I: Integer;
begin
  Result:='';
  if not Supports(WebBrowser.Document, IHTMLDocument2, Document) then
    raise Exception.Create('Invalid HTML document');
  if not Supports(Document.body, IHTMLElement2, Body) then
    raise Exception.Create('Can''t find <body> element');
  Tags := Body.getElementsByTagName(UpperCase(TagName));
  for I := 0 to Pred(Tags.length) do begin
    Tag:=Tags.item(I,EmptyParam) as IHTMLElement;
    if Tag.id=TagId then Result:=Tag.getAttribute(TagAttrib,0);
  end;
end;

{--- "CONSOLE" UTILITY FUNCTIONS ---}
procedure BottomScroll;
begin
  Form1.RichEdit1.SelStart:=Form1.RichEdit1.GetTextLen;
  Form1.RichEdit1.SelLength:=0;
  Form1.RichEdit1.Perform(EM_SCROLLCARET,0,0);
end;

procedure ConsoleBlue(Text:String);
begin
  BottomScroll;
  Form1.RichEdit1.SelAttributes.Color:=clBlue;
  Form1.RichEdit1.SelText:='<< '+Text+#13#10;
end;

procedure ConsoleLime(Text:String);
begin
  BottomScroll;
  Form1.RichEdit1.SelAttributes.Color:=clLime;
  Form1.RichEdit1.SelText:='>> '+Text+#13#10;
end;

procedure ConsoleRed(Text:String);
begin
  BottomScroll;
  Form1.RichEdit1.SelAttributes.Color:=clRed;
  Form1.RichEdit1.SelText:='>> '+Text+#13#10;
end;

{--- FORM CODE ---}

procedure TForm1.FormCreate(Sender: TObject);
begin
  // load html/js
  WebBrowser1.Navigate(ExtractFilePath(Application.ExeName)+'test.htm');
  // write small warning
  ConsoleRed('Similarly to Delphi''s Access Violations, this system''s');
  ConsoleRed(' most annoying error message is EOleException no. 80020101.');
  ConsoleRed('As of now, I can''t make it get more info about these errors,');
  ConsoleRed(' so you''ll have to triple check the JS code yourself.');
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  // eval demo cpde
  try
    ConsoleBlue('DoEval("'+Edit1.Text+'");');
    ExecuteJavaScript(WebBrowser1,'DoEval("'+Edit1.Text+'");');
    ConsoleLime(GetElementIdValue(WebBrowser1,'input','result','value'));
  except
    on E:Exception do ConsoleRed(E.Message);
  end;
end;

end.
