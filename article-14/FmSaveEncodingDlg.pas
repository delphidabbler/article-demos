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

