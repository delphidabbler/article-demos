unit UPayload;

interface

type
  TPayload = class(TObject)
  private
    fFileName: string;     
    fOldFileMode: Integer; 
    fFile: File;           
    procedure Open(Mode: Integer);
    procedure Close;
  public
    constructor Create(const FileName: string);
    function HasPayload: Boolean;
    function PayloadSize: Integer;
    procedure SetPayload(const Data; const DataSize: Integer);
    procedure GetPayload(var Data);
    procedure RemovePayload;
  end;

implementation

uses
  ActiveX;

type
  TPayloadFooter = packed record
    WaterMark: TGUID;
    ExeSize: LongInt;
    DataSize: LongInt;
  end;

const
  cWaterMarkGUID: TGUID =
    '{9FABA105-EDA8-45C3-89F4-369315A947EB}';
  cReadOnlyMode = 0;
  cReadWriteMode = 2;

procedure InitFooter(out Footer: TPayloadFooter);
begin
  FillChar(Footer, SizeOf(Footer), 0);
  Footer.WaterMark := cWaterMarkGUID;
end;

function ReadFooter(var F: File;
  out Footer: TPayloadFooter): Boolean;
var
  FileLen: Integer;
begin
  // Check that file is large enough for a footer!
  FileLen := FileSize(F);
  if FileLen > SizeOf(Footer) then
  begin
    // Big enough: move to start of footer and read it
    Seek(F, FileLen - SizeOf(Footer));
    BlockRead(F, Footer, SizeOf(Footer));
  end
  else
    // File not large enough for footer: zero it
    // .. this ensures watermark is invalid
    FillChar(Footer, SizeOf(Footer), 0);
  // Return if watermark is valid
  Result := IsEqualGUID(Footer.WaterMark, cWaterMarkGUID);
end;

procedure TPayload.Close;
begin
  // close file and restores previous file mode
  CloseFile(fFile);
  FileMode := fOldFileMode;
end;

constructor TPayload.Create(const FileName: string);
begin
  inherited Create;
  fFileName := FileName;
end;

procedure TPayload.GetPayload(var Data);
var
  Footer: TPayloadFooter;
begin
  // open file as read only
  Open(cReadOnlyMode);
  try
    // read footer
    if ReadFooter(fFile, Footer) 
      and (Footer.DataSize > 0) then
    begin
      // move to end of exe code and read data
      Seek(fFile, Footer.ExeSize);
      BlockRead(fFile, Data, Footer.DataSize);
    end;
  finally
    // close file
    Close;
  end;
end;

function TPayload.HasPayload: Boolean;
begin
  // we have a payload if size is greater than 0
  Result := PayloadSize > 0;
end;

procedure TPayload.Open(Mode: Integer);
begin
  // open file with given mode, recording current one
  fOldFileMode := FileMode;
  AssignFile(fFile, fFileName);
  FileMode := Mode;
  Reset(fFile, 1);
end;

function TPayload.PayloadSize: Integer;
var
  Footer: TPayloadFooter;
begin
  // open file and assume no data
  Result := 0;
  Open(cReadOnlyMode);
  try
    // read footer and if valid return data size
    if ReadFooter(fFile, Footer) then
      Result := Footer.DataSize;
  finally
    Close;
  end;
end;

procedure TPayload.RemovePayload;
var
  PLSize: Integer;
  FileLen: Integer;
begin
  // get size of payload
  PLSize := PayloadSize;
  if PLSize > 0 then
  begin
    // we have payload: open file and get size
    Open(cReadWriteMode);
    FileLen := FileSize(fFile);
    try
      // seek to end of exec code an truncate file there
      Seek(fFile, FileLen - PLSize - SizeOf(TPayloadFooter));
      Truncate(fFile);
    finally
      Close;
    end;
  end;
end;

procedure TPayload.SetPayload(const Data; 
  const DataSize: Integer);
var
  Footer: TPayloadFooter;
begin
  // remove any existing payload
  RemovePayload;
  if DataSize > 0 then
  begin
    // we have some data: open file for writing
    Open(cReadWriteMode);
    try
      // create a new footer with required data
      InitFooter(Footer);
      Footer.ExeSize := FileSize(fFile);
      Footer.DataSize := DataSize;
      // write data and footer at end of exe code
      Seek(fFile, Footer.ExeSize);
      BlockWrite(fFile, Data, DataSize);
      BlockWrite(fFile, Footer, SizeOf(Footer));
    finally
      Close;
    end;
  end;
end;

end.
