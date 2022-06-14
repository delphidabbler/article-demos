unit FmDemo;

{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    ListBox1: TListBox;
    Label1: TLabel;
    btnTestClass: TButton;
    Memo1: TMemo;
    btnTestRoutines: TButton;
    procedure btnTestClassClick(Sender: TObject);
    procedure btnTestRoutinesClick(Sender: TObject);
  private
    function GetExeName: string;
    procedure Display(const S: string);
  end;

var
  Form1: TForm1;

implementation

uses
  UVerInfoTypes, UVerInfoClass, UVerInfoRoutines;


{$R *.dfm}


const
  // List of all standard string name
  cStrNames: array[0..11] of string = (
    'Comments','CompanyName','FileDescription','FileVersion','InternalName',
    'LegalCopyright','LegalTrademarks','OriginalFilename','PrivateBuild',
    'ProductName','ProductVersion','SpecialBuild'
  );


{ TForm 1 }

procedure TForm1.btnTestClassClick(Sender: TObject);
  {Displays version info from selected file using a TVerInfo object}
var
  FileName: string;
  VI: TVerInfo;
  FFI: TVSFixedFileInfo;
  TransIdx: Integer;
  Trans: string;
  StrIdx: Integer;
  StrName: string;
begin
  // Choose file name
  FileName := GetExeName;

  // Create version info object
  VI := TVerInfo.Create(FileName);
  try
    Memo1.Clear;
    Display(FileName);
    if VI.HasVerInfo then
    begin
      // Get fixed file info and display subset of fields
      FFI := VI.FixedFileInfo;
      Display(Format('FFI: Product Version: %d.%d.%d.%d',
        [HiWord(FFI.dwProductVersionMS), LoWord(FFI.dwProductVersionMS),
        HiWord(FFI.dwProductVersionLS), LoWord(FFI.dwFileVersionLS)]));
      Display(Format('FFI: File Version: %d.%d.%d.%d',
        [HiWord(FFI.dwFileVersionMS), LoWord(FFI.dwFileVersionMS),
        HiWord(FFI.dwFileVersionLS), LoWord(FFI.dwFileVersionLS)]));
      // Get number of translations
      Display(Format('Number of Translations: %d', [VI.TranslationCount]));
      // Display details of each translation
      for TransIdx := 0 to Pred(VI.TranslationCount) do
      begin
        // display translation number
        Trans := VI.Translations[TransIdx];
        Display(Format('Translation: %s', [Trans]));
        // display all standard strings
        for StrIdx := Low(cStrNames) to High(cStrNames) do
        begin
          StrName := cStrNames[StrIdx];
          Display(Format('  %s = "%s"', [StrName, VI.Strings[Trans, StrName]]));
        end;
      end;
    end
    else
      // File contains no version info
      Display('*** No version information ***');
  finally
    VI.Free;
  end;

end;

procedure TForm1.Display(const S: string);
begin
  Memo1.Lines.Add(S);
end;

function TForm1.GetExeName: string;
var
  FileIdx: Integer;
begin
  // Choose file name
  FileIdx := ListBox1.ItemIndex;
  if FileIdx = -1 then
    Result := ''
  else if FileIdx = 0 then
    Result := ParamStr(0)
  else
    Result := ExtractFilePath(ParamStr(0)) + ListBox1.Items[FileIdx];
end;

procedure TForm1.btnTestRoutinesClick(Sender: TObject);
  {Displays version info from selected file using version info routines}
var
  FileName: string;
  VerInfo: Pointer;
  Size: Integer;
  FFI: TVSFixedFileInfo;
  TransTable: TTransRecArray;
  TransIdx: Integer;
  StrIdx: Integer;
  Trans: TTransRec;
  TransStr: string;
  StrName: string;
begin
  Memo1.Clear;
  FileName := GetExeName;
  Display(FileName);
  Size := UVerInfoRoutines.GetVerInfoSize(FileName);
  if Size > 0 then
  begin
    GetMem(VerInfo, Size);
    try
      UVerInfoRoutines.GetVerInfo(FileName, Size, VerInfo);
      // Get fixed file info and display subset of fields
      FFI := GetFFI(VerInfo);
      Display(Format('FFI: Product Version: %d.%d.%d.%d',
        [HiWord(FFI.dwProductVersionMS), LoWord(FFI.dwProductVersionMS),
        HiWord(FFI.dwProductVersionLS), LoWord(FFI.dwFileVersionLS)]));
      Display(Format('FFI: File Version: %d.%d.%d.%d',
        [HiWord(FFI.dwFileVersionMS), LoWord(FFI.dwFileVersionMS),
        HiWord(FFI.dwFileVersionLS), LoWord(FFI.dwFileVersionLS)]));
      // Get number of translations
      TransTable := GetTransTable(VerInfo);
      Display(Format('Number of Translations: %d', [Length(TransTable)]));
      // Display details of each translation
      for TransIdx := Low(TransTable) to High(TransTable) do
      begin
        // display translation number
        Trans := TransTable[TransIdx];
        TransStr := Format('%4.4X%4.4X', [Trans.Lang, Trans.CharSet]);
        Display(Format('Translation: %s', [TransStr]));
        // display all standard strings
        for StrIdx := Low(cStrNames) to High(cStrNames) do
        begin
          StrName := cStrNames[StrIdx];
          Display(
            Format(
              '  %s = "%s"',
              [StrName, GetVerInfoStr(VerInfo, TransStr, StrName)]
            )
          );
        end;
      end;
    finally
      FreeMem(VerInfo, Size);
    end;
  end
  else
  begin
    // File contains no version info
    Display('*** No version information ***');
  end;
end;

end.
