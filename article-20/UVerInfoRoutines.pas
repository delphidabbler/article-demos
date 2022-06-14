{
  Unit provides routines used to wrap version information API functions.
}

{$WARN UNSAFE_TYPE OFF}

unit UVerInfoRoutines;

interface

uses
  Windows,
  UVerInfoTypes;

{
GetVerInfoSize:
  Thin wrapper around API routine that returns size of version information
  data from a given file. Returns 0 if no version information in the file.
}
function GetVerInfoSize(const FileName: string): Integer;

{
GetVerInfo:
  Thin wrapper around API routine. Loads version information for a given file
  into a buffer. Raises exception if version information can't be read.
}
procedure GetVerInfo(const FileName: string; const Size: Integer;
  const Buffer: Pointer);

{
GetFFI:
  Fetches fixed file information from a buffer containing version information.
  Raises exception if record can't be read or if it is the wrong size.
}
function GetFFI(const Buffer: Pointer): TVSFixedFileInfo;

{
GetTransTable:
  Fetches translation table from a buffer containing version information.
  Returns a dynamic array of TTransRec records - one for each translation.
}
function GetTransTable(const Buffer: Pointer): TTransRecArray;

{
GetVerInfoStr:
  Returns string value for a given string name in a string table associated with
  given translation string.
}
function GetVerInfoStr(const Buffer: Pointer;
  const Trans, StrName: string): string;


implementation

uses
  SysUtils;

function GetVerInfoSize(const FileName: string): Integer;
var
  Dummy: DWORD; // Dummy handle parameter
begin
  Result := GetFileVersionInfoSize(PChar(FileName), Dummy);
end;

procedure GetVerInfo(const FileName: string; const Size: Integer;
  const Buffer: Pointer);
begin
  if not GetFileVersionInfo(PChar(FileName), 0, Size, Buffer) then
    raise Exception.Create('Can''t load version information');
end;

function GetFFI(const Buffer: Pointer): TVSFixedFileInfo;
var
  Size: DWORD;  // Size of fixed file info read
  Ptr: Pointer; // Pointer to FFI data
begin
  // Read the fixed file info
  if not VerQueryValue(Buffer, '\', Ptr, Size) then
    raise Exception.Create('Can''t read fixed file information');
  // Check that data read is correct size
  if Size <> SizeOf(TVSFixedFileInfo) then
    raise Exception.Create('Fixed file information record wrong size');
  Result := PVSFixedFileInfo(Ptr)^;
end;

function GetTransTable(const Buffer: Pointer): TTransRecArray;
var
  TransRec: PTransRec;  // pointer to a translation record
  Size: DWORD;          // size of data read
  RecCount: Integer;    // number of translation records
  Idx: Integer;         // loops thru translation records
begin
  // Read translation data
  VerQueryValue(Buffer, '\VarFileInfo\Translation', Pointer(TransRec), Size);
  // Get record count and set length of array
  RecCount := Size div SizeOf(TTransRec);
  SetLength(Result, RecCount);
  // Loop thru table storing records in array
  for Idx := 0 to Pred(RecCount) do
  begin
    Result[Idx] := TransRec^;
    Inc(TransRec);
  end;
end;

function GetVerInfoStr(const Buffer: Pointer;
  const Trans, StrName: string): string;
var
  Value: PChar;   // the string value data
  Dummy: DWORD;   // size of value data (unused)
  Path: string;   // "path" to string value
begin
  // Build path from translation and string name
  Path := '\StringFileInfo\' + Trans + '\' + StrName;
  // Read the string: return '' if string doesn't exist
  if VerQueryValue(Buffer, PChar(Path), Pointer(Value), Dummy) then
    Result := Value
  else
    Result := '';
end;


end.
