unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TMain = class(TForm)
    OutStrMemo: TMemo;
    Label1: TLabel;
    WriteBtn: TButton;
    ReadBtn: TButton;
    InStrMemo: TMemo;
    Label2: TLabel;
    CloseBtn: TButton;
    procedure WriteBtnClick(Sender: TObject);
    procedure ReadBtnClick(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type
  TStreamWrapper = class(TStream)
  private
    FBaseStream: TStream;   {The "wrapped" stream}
    FCloseStream: Boolean;  {Free wrapped stream on destruction?}
  protected
    procedure SetSize(NewSize: Longint); override;
      {Sets the size of the stream to the given value if the operation is
      supported by the underlying stream}
    property BaseStream: TStream read FBaseStream;
      {Gives access to the underlying stream to descended classes}
  public
    constructor Create(const Stream: TStream;
      const CloseStream: Boolean = False); virtual;
      {If CloseStream is true the given underlying stream is freed when 
      this object is freed}
    destructor Destroy; override;
    // Implementation of abstract methods of TStream 
    function Read(var Buffer; Count: Longint): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    function Seek(Offset: Longint; Origin: Word): Longint; override;
  end;

type
  TStrStream = class(TStreamWrapper)
  public
    procedure WriteString(AString: string);
    function ReadString: string;
  end;

var
  Main: TMain;

implementation

{$R *.DFM}

procedure TMain.WriteBtnClick(Sender: TObject);
var
  SS: TStrStream;
  I: Integer;
begin
  SS := TStrStream.Create(
    TFileStream.Create('test.dat', fmCreate),
    True);
  try
    for I := 0 to OutStrMemo.Lines.Count - 1 do
    begin
      SS.WriteString(OutStrMemo.Lines[I]);
    end;
  finally
    SS.Free;
  end;
end;

procedure TMain.ReadBtnClick(Sender: TObject);
var
  SS: TStrStream;
  Str: string;
begin
  if FileExists('test.dat') then
  begin
    InStrMemo.Clear;
    SS := TStrStream.Create(
      TFileStream.Create('test.dat', fmOpenRead),
      True);
    try
      while SS.Position < SS.Size do
      begin
        Str := SS.ReadString;
        InStrMemo.Lines.Add('<'+Str+'>');
      end;
    finally
      SS.Free;
    end;
  end
  else
    ShowMessage('There is no file to read - try writing some strings!');
end;

procedure TMain.CloseBtnClick(Sender: TObject);
begin
  Close;
end;

{ TStreamWrapper }

constructor TStreamWrapper.Create(const Stream: TStream;
  const CloseStream: Boolean);
begin
  inherited Create;
  // Record wrapped stream and if we free it on destruction
  FBaseStream := Stream;
  FCloseStream := CloseStream;
end;

destructor TStreamWrapper.Destroy;
begin
  // Close wrapped stream if required
  if FCloseStream then
    FBaseStream.Free;
  inherited Destroy;
end;

function TStreamWrapper.Read(var Buffer; Count: Integer): Longint;
begin
  // Simply call underlying stream's Read method
  Result := FBaseStream.Read(Buffer, Count);
end;

function TStreamWrapper.Seek(Offset: Integer; Origin: Word): Longint;
begin
  // Simply call the same method in the wrapped stream
  Result := FBaseStream.Seek(Offset, Origin);
end;

procedure TStreamWrapper.SetSize(NewSize: Integer);
begin
  // Set the size property of the wrapped stream
  FBaseStream.Size := NewSize;
end;

function TStreamWrapper.Write(const Buffer; Count: Integer): Longint;
begin
  // Simply call the same method in the wrapped stream
  Result := FBaseStream.Write(Buffer, Count);
end;

{ TStrStream }

function TStrStream.ReadString: string;
var
  StrLen: Integer;    // the length of the string
  PBuf: PChar;        // buffer to hold the string that is read
begin
  // Get length of string (as 32 bit integer)
  ReadBuffer(StrLen, SizeOf(Integer));
  // Now get string
  // allocate enough memory to hold string
  GetMem(PBuf, StrLen);
  try
    // read chars into buffer and set resulting string
    ReadBuffer(PBuf^, StrLen);
    SetString(Result, PBuf, StrLen);
  finally
    // deallocate buffer
    FreeMem(PBuf, StrLen);
  end;
end;

procedure TStrStream.WriteString(AString: string);
var
  Len: Integer;     // length of string
begin
  // Write out length of string as 32 bit integer
  Len := Length(AString);
  WriteBuffer(Len, SizeOf(Integer));
  // Now write out the string's characters
  WriteBuffer(PChar(AString)^, Len);
end;

end.
