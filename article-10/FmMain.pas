{
 * This source code accompanies the article "How to create and use HTML resource
 * files" which can be found at
 * http://www.delphidabbler.com/articles?article=10.
 *
 * The code is merely a proof of concept and is intended only to illustrate the
 * article. It is not designed for use in its current form in finished
 * applications. The code is provided on an "AS IS" basis, WITHOUT WARRANTY OF
 * ANY KIND, either express or implied.
 *
 * $Rev: 16 $
 * $Date: 2009-09-26 04:04:46 +0100 (Sat, 26 Sep 2009) $
}

unit FmMain;

interface

{$BOOLEVAL OFF}

{$IFDEF CONDITIONALEXPRESSIONS}
  {$IF CompilerVersion >= 15.0} // >= Delphi 7
    {$WARN UNSAFE_TYPE OFF}
  {$IFEND}
{$ENDIF}

uses
  Forms, StdCtrls, OleCtrls, SHDocVw, Controls, ExtCtrls, Classes;

type
  TMainForm = class(TForm)
    btnIndex: TButton;
    btnLogo: TButton;
    pnlBrowser: TPanel;
    webBrowser: TWebBrowser;
    btnCSS: TButton;
    btnRCDATA: TButton;
    edURL: TEdit;
    Label1: TLabel;
    procedure btnIndexClick(Sender: TObject);
    procedure btnLogoClick(Sender: TObject);
    procedure btnCSSClick(Sender: TObject);
    procedure btnRCDATAClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure ShowURL(const URL: string);
  end;

var
  MainForm: TMainForm;

implementation

uses
  SysUtils, Windows;

{$R *.dfm}

{
  Do not use this function to URL encode query strings: see the more flexible
  version in the Code Snippets Database at
  http://www.delphidabbler.com/codesnip?action=named&routines=URLEncode
}
function URLEncode(const S: string): string;
var
  Idx: Integer; // loops thru characters in string
begin
  Result := '';
  for Idx := 1 to Length(S) do
  begin
    {$IFDEF UNICODE}
    if CharInSet(S[Idx], ['A'..'Z', 'a'..'z', '0'..'9', '-', '_', '.']) then
    {$ELSE}
    if S[Idx] in ['A'..'Z', 'a'..'z', '0'..'9', '-', '_', '.'] then
    {$ENDIF}
      Result := Result + S[Idx]
    else
      Result := Result + '%' + IntToHex(Ord(S[Idx]), 2);
  end;
end;

function FormatResNameOrType(ResID: PChar): string;
begin
  if HiWord(LongWord(ResID)) = 0 then
    // high word = 0 => numeric resource id
    // numeric value is stored in low word
    Result := Format('#%d', [LoWord(LongWord(ResID))])
  else
    // high word <> 0 => string value
    // PChar is implicitly converted to string
    Result := ResID;
end;

function MakeResourceURL(const ModuleName: string; const ResName: PChar;
  const ResType: PChar = nil): string; overload;
begin
  Assert(ModuleName <> '');
  Assert(Assigned(ResName));
  Result := 'res://' + URLEncode(ModuleName);
  if Assigned(ResType) then
    Result := Result + '/' + URLEncode(FormatResNameOrType(ResType));
  Result := Result + '/' + URLEncode(FormatResNameOrType(ResName));
end;

function MakeResourceURL(const Module: HMODULE; const ResName: PChar;
  const ResType: PChar = nil): string; overload;
begin
  Result := MakeResourceURL(GetModuleName(Module), ResName, ResType);
end;

procedure TMainForm.btnIndexClick(Sender: TObject);
begin
  ShowURL(MakeResourceURL(HInstance, 'INDEX_PAGE'));
end;

procedure TMainForm.btnLogoClick(Sender: TObject);
const
  RT_HTML = MakeIntResource(23);
begin
  ShowURL(MakeResourceURL(HInstance, 'LOGO_GIF', RT_HTML));
end;

procedure TMainForm.btnCSSClick(Sender: TObject);
begin
  ShowURL(MakeResourceURL(HInstance, 'STYLE_CSS'));
end;

procedure TMainForm.btnRCDATAClick(Sender: TObject);
begin
  ShowURL(MakeResourceURL(HInstance, MakeIntResource(42), RT_RCDATA));
end;

procedure TMainForm.ShowURL(const URL: string);
begin
  edURL.Text := URL;
  edURL.SelStart := Length(URL);
  webBrowser.Navigate(URL);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  webBrowser.Navigate('about:blank');
end;

end.

