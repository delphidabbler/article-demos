unit RCDataCreatorForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
type
  TResHeader = record
    DataSize: DWORD;
    HeaderSize: DWORD;
    ResType: DWORD;
    ResId: DWORD;
    DataVersion: DWORD;
    MemoryFlags: WORD;
    LanguageId: WORD;
    Version: DWORD;
    Characteristics: DWORD;
  end;

procedure CreateResourceFile(
  DataFile, ResFile: string;  // file names
  ResID: Integer              // id of resource
);
var
  FS, RS: TFileStream;
  FileHeader, ResHeader: TResHeader;
  Padding: array[0..SizeOf(DWORD)-1] of Byte;
begin
  FS := TFileStream.Create(  // to read data file
    DataFile, fmOpenRead);
  RS := TFileStream.Create(  // to write res file
    ResFile, fmCreate);
  { Create res file header - all zeros except
    for HeaderSize, ResType and ResID }
  FillChar(FileHeader, SizeOf(FileHeader), #0);
  FileHeader.HeaderSize := SizeOf(FileHeader);
  FileHeader.ResId := $0000FFFF;
  FileHeader.ResType := $0000FFFF;
  { Create data header for RC_DATA file }
  FillChar(ResHeader, SizeOf(ResHeader), #0);
  ResHeader.HeaderSize := SizeOf(ResHeader);
  // resource id - FFFF says "not a string!"
  ResHeader.ResId := $0000FFFF or (ResId shl 16);
  // resource type - RT_RCDATA (from Windows unit)
  ResHeader.ResType := $0000FFFF
    or (WORD(RT_RCDATA) shl 16);
  // data file size is size of file
  ResHeader.DataSize := FS.Size;
  // set required memory flags
  ResHeader.MemoryFlags := $0030;
  { Write the headers to the resource file }
  RS.WriteBuffer(FileHeader, sizeof(FileHeader));
  RS.WriteBuffer(ResHeader, sizeof(ResHeader));
  { Copy the file into the resource }
  RS.CopyFrom(FS, FS.Size);
  { Pad data out to DWORD boundary }
  if FS.Size mod SizeOf(DWORD) <> 0 then
    RS.WriteBuffer(Padding, SizeOf(DWORD) -
      FS.Size mod SizeOf(DWORD));
  { Close the files }
  FS.Free;
  RS.Free;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  // Create out resource file
  CreateResourceFile('Hello.rtf', 'Hello.res', 100);
  // Show a message to say we've done
  ShowMessage('Resource file Hello.res has been created'#10#10
    + 'Now build RCDataUser.dpr and run it');
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  // Close the app
  Close;
end;

end.
