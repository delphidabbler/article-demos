{
 * This source code accompanies the article "How to load and save documents in
 * TWebBrowser in a Delphi-like way" which can be found at
 * http://www.delphidabbler.com/articles?article=14.
 *
 * The code is merely a proof of concept and is intended only to illustrate the
 * article. It is not designed for use in its current form in finished
 * applications. The code is provided on an "AS IS" basis, WITHOUT WARRANTY OF
 * ANY KIND, either express or implied.
 *
 * $Rev: 38 $
 * $Date: 2010-02-06 15:36:08 +0000 (Sat, 06 Feb 2010) $
}

unit FmSampleCodeEncodingDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TSampleCodeEncodingDlg = class(TForm)
    rgFileType: TRadioGroup;
    btnOK: TButton;
    btnCancel: TButton;
  private
    {$IFDEF UNICODE}
    function GetEncoding: TEncoding;
    {$ENDIF}
    function GetResourceName: string;
  public
    {$IFDEF UNICODE}
    property Encoding: TEncoding read GetEncoding;
    {$ENDIF}
    property ResourceName: string read GetResourceName;
  end;

var
  SampleCodeEncodingDlg: TSampleCodeEncodingDlg;

implementation

{$R *.dfm}

{ TSampleCodeEncodingDlg }

{$IFDEF UNICODE}
function TSampleCodeEncodingDlg.GetEncoding: TEncoding;
begin
  Result := nil;
  case rgFileType.ItemIndex of
    0: Result := TEncoding.Default;     // ANSI
    1: Result := TEncoding.UTF8;
    2: Result := TEncoding.Unicode;   // little endian only
  end;
  Assert(Assigned(Result));
end;
{$ENDIF}

function TSampleCodeEncodingDlg.GetResourceName: string;
begin
  Result := '';
  case rgFileType.ItemIndex of
    0: Result := 'SAMPLE_HTML_ANSI';
    1: Result := 'SAMPLE_HTML_UTF8';
    2: Result := 'SAMPLE_HTML_UCS2LE';
  end;
  Assert(Result <> '');
end;

end.

