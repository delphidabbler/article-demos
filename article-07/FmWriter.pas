unit FmWriter;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TWriterForm = class(TForm)
    lblHelp: TLabel;
    memData: TMemo;
    btnStore: TButton;
    btnDelete: TButton;
    btnClose: TButton;
    procedure btnCloseClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnStoreClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  WriterForm: TWriterForm;

implementation

uses
  UPayload;

const
  cReaderFile = 'Reader.exe';

{$R *.DFM}

procedure TWriterForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TWriterForm.btnDeleteClick(Sender: TObject);
var
  PL: TPayload;
begin
  PL := TPayload.Create(cReaderFile);
  try
    PL.RemovePayload;
  finally
    PL.Free;
  end;
end;

procedure TWriterForm.btnStoreClick(Sender: TObject);
var
  PL: TPayload;
begin
  PL := TPayload.Create(cReaderFile);
  try
    PL.SetPayload(PChar(memData.Text)^, Length(memData.Text));
  finally
    PL.Free;
  end;
end;

procedure TWriterForm.FormCreate(Sender: TObject);
begin
  if not FileExists(cReaderFile) then
  begin
    lblHelp.Caption :=
      'ERROR:'#13#10'You must compile Reader.exe before using this program.';
    lblHelp.Font.Color := clRed;
    lblHelp.Font.Style := [fsBold];
    btnDelete.Enabled := False;
    btnStore.Enabled := False;
  end;
end;

end.
