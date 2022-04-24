unit FmReader;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TReaderForm = class(TForm)
    memData: TMemo;
    btnClose: TButton;
    lblHelp: TLabel;
    lblSize: TLabel;
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ReaderForm: TReaderForm;

implementation

uses
  UPayload;

{$R *.DFM}

procedure TReaderForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TReaderForm.FormCreate(Sender: TObject);
var
  PL: TPayload;
  DataStr: string;
begin
  PL := TPayload.Create(ParamStr(0));
  try
    if PL.HasPayload then
    begin
      lblSize.Caption := Format('Payload data size = %d', [PL.PayloadSize]);
      SetLength(DataStr, PL.PayloadSize);
      PL.GetPayload(PChar(DataStr)^);
      memData.Text := DataStr;
    end
    else
    begin
      lblSize.Caption := 'No payload present';
      lblSize.Font.Style := [fsBold];
    end;
  finally
    PL.Free;
  end;

end;

end.
