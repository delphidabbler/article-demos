unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    ListBox1: TListBox;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  System.IOUtils,
  System.Win.Registry;

{$R *.dfm}

type
  TDelphiInfo = record
    Name: string;
    RegKey: string;
  end;

const
  AllDelphis: array[0..24] of TDelphiInfo = (
    (Name: '2'; RegKey: '\SOFTWARE\Borland\Delphi\2.0'),
    (Name: '3'; RegKey: '\SOFTWARE\Borland\Delphi\3.0'),
    (Name: '4'; RegKey: '\SOFTWARE\Borland\Delphi\4.0'),
    (Name: '5'; RegKey: '\SOFTWARE\Borland\Delphi\5.0'),
    (Name: '6'; RegKey: '\SOFTWARE\Borland\Delphi\6.0'),
    (Name: '7'; RegKey: '\SOFTWARE\Borland\Delphi\7.0'),
    (Name: '2005'; RegKey: '\SOFTWARE\Borland\BDS\3.0'),
    (Name: '2006'; RegKey: '\SOFTWARE\Borland\BDS\4.0'),
    (Name: '2007'; RegKey: '\SOFTWARE\Borland\BDS\5.0'),
    (Name: '2009'; RegKey: '\SOFTWARE\CodeGear\BDS\6.0'),
    (Name: '2010'; RegKey: '\SOFTWARE\CodeGear\BDS\7.0'),
    (Name: 'XE'; RegKey: '\Software\Embarcadero\BDS\8.0'),
    (Name: 'XE2'; RegKey: '\Software\Embarcadero\BDS\9.0'),
    (Name: 'XE3'; RegKey: '\Software\Embarcadero\BDS\10.0'),
    (Name: 'XE4'; RegKey: '\Software\Embarcadero\BDS\11.0'),
    (Name: 'XE5'; RegKey: '\Software\Embarcadero\BDS\12.0'),
    (Name: 'XE6'; RegKey: '\Software\Embarcadero\BDS\14.0'),
    (Name: 'XE7'; RegKey: '\Software\Embarcadero\BDS\15.0'),
    (Name: 'XE8'; RegKey: '\Software\Embarcadero\BDS\16.0'),
    (Name: '10 Seattle'; RegKey: '\Software\Embarcadero\BDS\17.0'),
    (Name: '10.1 Berlin'; RegKey: '\Software\Embarcadero\BDS\18.0'),
    (Name: '10.2 Tokyo'; RegKey: '\Software\Embarcadero\BDS\19.0'),
    (Name: '10.3 Rio'; RegKey: '\Software\Embarcadero\BDS\20.0'),
    (Name: '10.4 Sydney'; RegKey: '\Software\Embarcadero\BDS\21.0'),
    (Name: '11 Alexandria'; RegKey: '\Software\Embarcadero\BDS\22.0')
  );

function IsRegisteredInRootKey(RootKey: HKEY; SubKey: string): Boolean;
begin
  var Reg: TRegistry := TRegistry.Create(KEY_READ);
  try
    Reg.RootKey := RootKey;
    Result := Reg.OpenKeyReadOnly(SubKey);
    if Result then
      Reg.CloseKey;
  finally
    Reg.Free;
  end;
end;

function IsRegistered(SubKey: string): Boolean;
begin
  Result := IsRegisteredInRootKey(HKEY_LOCAL_MACHINE, SubKey);
  if not Result then
    Result := IsRegisteredInRootKey(HKEY_CURRENT_USER, SubKey);
end;

function GetRegRootKey(SubKey: string): HKEY;
begin
  if IsRegisteredInRootKey(HKEY_LOCAL_MACHINE, SubKey) then
    Result := HKEY_LOCAL_MACHINE
  else if IsRegisteredInRootKey(HKEY_CURRENT_USER, SubKey) then
    Result := HKEY_CURRENT_USER
  else
    Result := 0;  // not registered
end;

function GetInstallDir(SubKey: string): string;
begin
  var RootKey: HKEY := GetRegRootKey(SubKey);
  if RootKey = 0 then
    Exit('');
  var Reg: TRegistry := TRegistry.Create(KEY_READ);
  try
    if not Reg.OpenKeyReadOnly(SubKey) then
      Exit('');
    Result := Reg.ReadString('RootDir');
    Reg.CloseKey;
  finally
    Reg.Free;
  end;
end;

function InstallDirExists(SubKey: string): Boolean;
begin
  var InstDir: string := GetInstallDir(SubKey);
  if InstDir = '' then
    Exit(False);
  Result := TDirectory.Exists(InstDir);
end;

function DCC32Exists(SubKey: string): Boolean;
begin
  if not InstallDirExists(SubKey) then
    Exit(False);
  var FileName: string := IncludeTrailingPathDelimiter(GetInstallDir(SubKey))
    + 'Bin' + PathDelim + 'DCC32.exe';
  Result := TFile.Exists(FileName);
end;

function FindInstallations: TArray<TDelphiInfo>;
begin
  SetLength(Result, Length(AllDelphis));
  var FoundCount: Integer := 0;
  for var Rec: TDelphiInfo in AllDelphis do
  begin
    if IsRegistered(Rec.RegKey) then
    begin
      Result[FoundCount] := Rec;
      Inc(FoundCount);
    end;
  end;
  SetLength(Result, FoundCount);
end;

function FindInstallations2: TArray<TDelphiInfo>;
begin
  SetLength(Result, Length(AllDelphis));
  var FoundCount: Integer := 0;
  for var Rec: TDelphiInfo in AllDelphis do
  begin
    if IsRegistered(Rec.RegKey) and InstallDirExists(Rec.RegKey) then
    begin
      Result[FoundCount] := Rec;
      Inc(FoundCount);
    end;
  end;
  SetLength(Result, FoundCount);
end;

function FindInstallations3: TArray<TDelphiInfo>;
begin
  SetLength(Result, Length(AllDelphis));
  var FoundCount: Integer := 0;
  for var Rec: TDelphiInfo in AllDelphis do
  begin
    if IsRegistered(Rec.RegKey) and DCC32Exists(Rec.RegKey) then
    begin
      Result[FoundCount] := Rec;
      Inc(FoundCount);
    end;
  end;
  SetLength(Result, FoundCount);
end;

function TryGetFilePath(BaseName, SubKey: string; out Path: string): Boolean;
begin
  Path := '';
  if not InstallDirExists(SubKey) then
    Exit(False);
  Path := IncludeTrailingPathDelimiter(GetInstallDir(SubKey))
    + 'Bin' + PathDelim + BaseName;
  Result := TFile.Exists(Path);
end;

procedure TForm1.FormCreate(Sender: TObject);
const
  DCC32FN = 'DCC32.exe';
  DCC64FN = 'DCC64.exe';

  procedure AddDCCInfo(DCC: string; Rec: TDelphiInfo);
  begin
    var Path: string;
    var Installed: Boolean := TryGetFilePath(DCC, Rec.RegKey, Path);
    if Installed then
      ListBox1.Items.Add('   ' + DCC + ' installed at: ' + Path)
    else
      ListBox1.Items.Add('   ' + DCC + ' not available');
  end;

begin
  var Installations: TArray<TDelphiInfo> := FindInstallations2;
  for var Rec: TDelphiInfo in Installations do
  begin
    ListBox1.Items.Add('Delphi ' + Rec.Name);
    AddDCCInfo(DCC32FN, Rec);
    AddDCCInfo(DCC64FN, Rec);
  end;
end;

end.
