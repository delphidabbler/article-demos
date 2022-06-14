{
  Unit implements class that encapsulates version from an executable file.
}

unit UVerInfoClass;

{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}

interface

uses
  Windows,
  UVerInfoTypes;

type
  {
  TVerInfo:
    Class that encapsulates version information stored in an executable file.
  }
  TVerInfo = class(TObject)
  private
    fFixedFileInfo: TVSFixedFileInfo; // fixed file info record
    fTransTable: TTransRecArray;      // translation table
    fHasVerInfo: Boolean;             // whether file contains ver info
    fVerInfo: Pointer;                // buffer storing ver info
    function GetString(const Trans, Name: string): string;
    function GetTranslation(Idx: Integer): string;
    function GetTranslationCount: Integer;
  public
    constructor Create(const FileName: string);
    destructor Destroy; override;
    property HasVerInfo: Boolean read fHasVerInfo;
    property FixedFileInfo: TVSFixedFileInfo read fFixedFileInfo;
    property Translations[Idx: Integer]: string read GetTranslation;
    property TranslationCount: Integer read GetTranslationCount;
    property Strings[const Trans, Name: string]: string read GetString;
  end;

implementation

uses
  SysUtils,
  UVerInfoRoutines;

{ TVerInfo }

constructor TVerInfo.Create(const FileName: string);
var
  BufSize: Integer;     // size of ver info buffer
begin
  inherited Create;
  // Get size of buffer: no ver info if size = 0
  BufSize := GetVerInfoSize(FileName);
  fHasVerInfo := BufSize > 0;
  if fHasVerInfo then
  begin
    // Read ver info into buffer
    GetMem(fVerInfo, BufSize);
    GetVerInfo(FileName, BufSize, fVerInfo);
    // Read fixed file info and translation table
    fFixedFileInfo := GetFFI(fVerInfo);
    fTransTable := GetTransTable(fVerInfo);
  end;
end;

destructor TVerInfo.Destroy;
begin
  // Free ver info buffer
  FreeMem(fVerInfo);
  inherited;
end;

function TVerInfo.GetString(const Trans, Name: string): string;
begin
  Assert(fHasVerInfo);
  Result := GetVerInfoStr(fVerInfo, Trans, Name);
end;

function TVerInfo.GetTranslation(Idx: Integer): string;
begin
  Assert(fHasVerInfo);
  Assert((Idx >= 0) and (Idx < TranslationCount));
  // Return string representation of translation at given index
  Result := Format(
    '%4.4x%4.4x', [fTransTable[Idx].Lang, fTransTable[Idx].CharSet]
  );
end;

function TVerInfo.GetTranslationCount: Integer;
begin
  Result := Length(fTransTable);
end;

end.
