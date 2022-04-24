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

unit FmSaveEncodingDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TSaveEncodingDlg = class(TForm)
    rgEncoding: TRadioGroup;
    btnOK: TButton;
    btnCancel: TButton;
    lblDesc: TLabel;
    procedure FormShow(Sender: TObject);
  private
    {$IFDEF UNICODE}
    function GetEncoding: TEncoding;
    {$ENDIF}
  public
    {$IFDEF UNICODE}
    property Encoding: TEncoding read GetEncoding;
    {$ENDIF}
  end;

var
  SaveEncodingDlg: TSaveEncodingDlg;

implementation

{$R *.dfm}

{ TSaveEncodingDlg }

procedure TSaveEncodingDlg.FormShow(Sender: TObject);
begin
  // select default browser encoding option each time shown
  rgEncoding.ItemIndex := 0;
end;

{$IFDEF UNICODE}
function TSaveEncodingDlg.GetEncoding: TEncoding;
begin
  case rgEncoding.ItemIndex of
    1: Result := TEncoding.Default;
    2: Result := TEncoding.UTF8;
    3: Result := TEncoding.Unicode;
    4: Result := TEncoding.BigEndianUnicode;
    else Result := nil; // includes case 0 - default browser encoding
  end;
end;
{$ENDIF}

end.

