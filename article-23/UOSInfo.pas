unit UOSInfo;

interface

uses
  Windows;

const
  // NT Product types: used by dwProductType field
  VER_NT_WORKSTATION = $0000001;
  VER_NT_DOMAIN_CONTROLLER = $0000002;
  VER_NT_SERVER = $0000003;

  // NT product suite mask values: used by wSuiteMask field
  VER_SUITE_SMALLBUSINESS = $00000001;
  VER_SUITE_ENTERPRISE = $00000002;
  VER_SUITE_BACKOFFICE = $00000004;
  VER_SUITE_COMMUNICATIONS = $00000008;
  VER_SUITE_TERMINAL = $00000010;
  VER_SUITE_SMALLBUSINESS_RESTRICTED = $00000020;
  VER_SUITE_EMBEDDEDNT = $00000040;
  VER_SUITE_DATACENTER = $00000080;
  VER_SUITE_SINGLEUSERTS = $00000100;
  VER_SUITE_PERSONAL = $00000200;
  VER_SUITE_SERVERAPPLIANCE = $00000400;
  VER_SUITE_BLADE = VER_SUITE_SERVERAPPLIANCE;

const
  SM_MEDIACENTER = 87;  // Detects XP Media Center Edition
  SM_TABLETPC = 86;

var
  Win32HaveExInfo: Boolean = False;
  Win32ServicePackMajor: Integer = 0;
  Win32ServicePackMinor: Integer = 0;
  Win32SuiteMask: Integer = 0;
  Win32ProductType: Integer = 0;

type
  TOSVersionInfoEx = packed record
    dwOSVersionInfoSize: DWORD;
    dwMajorVersion: DWORD;
    dwMinorVersion: DWORD;
    dwBuildNumber: DWORD;
    dwPlatformId: DWORD;
    szCSDVersion: array[0..127] of AnsiChar;
    wServicePackMajor: WORD;
    wServicePackMinor: WORD;
    wSuiteMask: WORD;
    wProductType: Byte;
    wReserved: Byte;
  end;

  TOSProduct = (
    osUnknown,          // Unknown OS
    osWin95,            // Windows 95
    osWin98,            // Windows 98
    osWinMe,            // Windows Me
    osWinNT4,           // Windows NT 4.0
    osWin2000,          // Windows 2000
    osWinXP,            // Windows XP
    osWinServer2003     // Windows Server 2003
  );
type
  TOSProductType = (
    ptNA,                 // not applicable: not a Windows NT platform
    ptUnknown,            // unknown NT product type
    ptNTWorkstation,      // NT workstation
    ptNTServer,           // NT server
    ptNTDomainController, // NT domain controller
    ptNTAdvancedServer    // NT advanced server
  );

  TOSInfo = class(TObject)
  private
    class function CheckSuite(const Suite: Integer): Boolean;
    class function GetNT4ProductType: TOSProductType;
    class function IsNT4SP6a: Boolean;
  public
    class function IsWin9x: Boolean;
    class function IsWinNT: Boolean;
    class function IsServer: Boolean;
    class function IsMediaCenter: Boolean;
    class function IsTablet: Boolean;
    class function IsWOW64: Boolean;
    class function Product: TOSProduct;
    class function BuildNumber: Integer;
    class function ServicePack: string;
    class function ServicePackMajor: Integer;
    class function ServicePackMinor: Integer;
    class function ProductType: TOSProductType;
    class function Edition: string;
  end;

implementation

uses
  SysUtils, Registry;

// Definition of SameText function for Delphi 4
// Function is defined in SysUtils for Delphi 5 and up
{$IFDEF VER120}
function SameText(const S1, S2: string): Boolean;
begin
  Result := CompareText(S1, S2) = 0;
end;
{$ENDIF}


procedure InitPlatformIdEx;
var
  OSVI: TOSVersionInfoEx;
  POSVI: POSVersionInfo;
begin
  FillChar(OSVI, SizeOf(OSVI), 0);
  {$TYPEDADDRESS OFF}
  POSVI := @OSVI;
  {$TYPEDADDRESS ON}
  OSVI.dwOSVersionInfoSize := SizeOf(TOSVersionInfoEx);
  Win32HaveExInfo := GetVersionEx(POSVI^);
  if Win32HaveExInfo then
  begin
    Win32ServicePackMajor := OSVI.wServicePackMajor;
    Win32ServicePackMinor := OSVI.wServicePackMinor;
    Win32SuiteMask := OSVI.wSuiteMask;
    Win32ProductType := OSVI.wProductType;
  end;
end;

{ TOSInfo }

class function TOSInfo.BuildNumber: Integer;
begin
  Result := Win32BuildNumber;
end;

class function TOSInfo.CheckSuite(const Suite: Integer): Boolean;
begin
  Result := Win32SuiteMask and Suite <> 0;
end;

class function TOSInfo.Edition: string;
begin
  Result := '';
  if IsWinNT then
  begin
    if Win32HaveExInfo then
    begin
      // Test for edition on Windows NT 4 SP6 and later
      if IsServer then
      begin
        // Server type
        case Product of
          osWinNT4:
          begin
            if CheckSuite(VER_SUITE_ENTERPRISE) then
              Result := 'Server 4.0, Enterprise Edition'
            else
              Result := 'Server 4.0';
          end;
          osWin2000:
          begin
            if CheckSuite(VER_SUITE_DATACENTER) then
              Result := 'Datacenter Server'
            else if CheckSuite(VER_SUITE_ENTERPRISE) then
              Result := 'Advanced Server'
            else
              Result := 'Standard Edition';
          end;
          osWinServer2003:
          begin
            if CheckSuite(VER_SUITE_DATACENTER) then
              Result := 'DataCenter Edition'
            else if CheckSuite(VER_SUITE_ENTERPRISE) then
              Result := 'Enterprise Edition'
            else if CheckSuite(VER_SUITE_BLADE) then
              Result := 'Web Edition'
            else
              Result := 'Standard Edition';
          end;
        end;
      end
      else
      begin
        // Workstation type
        case Product of
          osWinNT4:
            Result := 'Workstation 4.0';
          osWin2000:
            Result := 'Professional';
          osWinXP:
          begin
            if IsMediaCenter then
              Result := 'Media Center Edition'
            else if IsTablet then
              Result := 'Tablet PC Edition'
            else if CheckSuite(VER_SUITE_PERSONAL) then
              Result := 'Home Edition'
            else
              Result := 'Professional';
          end;
        end;
      end;
    end
    else
    begin
      // No extended info: use regsitry
      case GetNT4ProductType of
        ptNTWorkstation: Result := 'WorkStation';
        ptNTServer: Result := 'Server';
        ptNTAdvancedServer: Result := 'Advanced Server'
      end;
      if Result <> '' then
        Result := Result + Format(
          ' %d.%d', [Win32MajorVersion, Win32MinorVersion]
        );
    end;
  end;
end;

class function TOSInfo.GetNT4ProductType: TOSProductType;
var
  Reg: TRegistry;
  ProductType: string;
begin
  Result := ptUnknown;
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKeyReadOnly(
      'SYSTEM\CurrentControlSet\Control\ProductOptions'
    ) then
    begin
      ProductType := Reg.ReadString('ProductType');
      if SameText(ProductType, 'WINNT') then
        Result := ptNTWorkstation
      else if SameText(ProductType, 'LANMANNT') then
        Result := ptNTServer
      else if SameText(ProductType, 'SERVERNT') then
        Result := ptNTAdvancedServer;
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;

class function TOSInfo.IsMediaCenter: Boolean;
begin
  Result := GetSystemMetrics(SM_MEDIACENTER) <> 0;
end;

class function TOSInfo.IsNT4SP6a: Boolean;
var
  Reg: TRegistry;
begin
  if (Product = osWinNT4)
    and SameText(Win32CSDVersion, 'Service Pack 6') then
  begin
    // System is reporting NT4 SP6
    // we have SP 6a if particular registry key exists
    Reg := TRegistry.Create;
    try
      Reg.RootKey := HKEY_LOCAL_MACHINE;
      Result := Reg.KeyExists(
        'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Hotfix\Q246009'
      );
    finally
      Reg.Free;
    end;
  end
  else
    // System not reporting NT4 SP6, so not SP6a!
    Result := False;
end;

class function TOSInfo.IsServer: Boolean;
begin
  Result := ProductType in
    [ptNTServer, ptNTDomainController, ptNTAdvancedServer];
end;

class function TOSInfo.IsTablet: Boolean;
begin
  Result := GetSystemMetrics(SM_TABLETPC) <> 0;
end;

class function TOSInfo.IsWin9x: Boolean;
begin
  Result := (Win32Platform = VER_PLATFORM_WIN32_WINDOWS);
end;

class function TOSInfo.IsWinNT: Boolean;
begin
  Result := (Win32Platform = VER_PLATFORM_WIN32_NT);
end;

class function TOSInfo.IsWOW64: Boolean;
type
  TIsWow64Process = function( // Type of IsWow64Process API fn
    Handle: THandle;
    var Res: BOOL
  ): BOOL; stdcall;
var
  IsWow64Result: BOOL;              // result from IsWow64Process
  IsWow64Process: TIsWow64Process;  // IsWow64Process fn reference
begin
  // Try to load required function from kernel32
  IsWow64Process := GetProcAddress(
    GetModuleHandle('kernel32'), 'IsWow64Process'
  );
  if Assigned(IsWow64Process) then
  begin
    // Function is implemented: call it
    if not IsWow64Process(GetCurrentProcess, IsWow64Result) then
      raise Exception.Create('Bad process handle');
    // Return result of function
    Result := IsWow64Result;
  end
  else
    // Function not implemented: can't be running on Wow64
    Result := False;
end;

class function TOSInfo.Product: TOSProduct;
begin
  Result := osUnknown;
  if IsWin9x then
  begin
    case Win32MajorVersion of
      4:
      begin
        case Win32MinorVersion of
          0: Result := osWin95;
          10: Result := osWin98;
          90: Result := osWinMe;
        end;
      end;
    end;
  end
  else if IsWinNT then
  begin
    case Win32MajorVersion of
      4:
      begin
        case Win32MinorVersion of
          0: Result := osWinNT4;
        end;
      end;
      5:
      begin
        case Win32MinorVersion of
          0: Result := osWin2000;
          1: Result := osWinXP;
          2: Result := osWinServer2003;
        end;
      end;
    end;
  end;
end;

class function TOSInfo.ProductType: TOSProductType;
begin
  if IsWinNT then
  begin
    if Win32HaveExInfo then
    begin
      case Win32ProductType of
        VER_NT_WORKSTATION: Result := ptNTWorkstation;
        VER_NT_SERVER: Result := ptNTServer;
        VER_NT_DOMAIN_CONTROLLER: Result := ptNTDomainController;
        else Result := ptUnknown;
      end;
    end
    else
      Result := GetNT4ProductType;
  end
  else
    Result := ptNA;
end;

class function TOSInfo.ServicePack: string;
begin
  Result := '';
  if IsWin9x then
  begin
    if Win32CSDVersion <> '' then
    begin
      case Product of
        osWin95:
          if UpCase(Win32CSDVersion[1]) in ['B', 'C'] then
            Result := 'OSR2';
        osWin98:
          if UpCase(Win32CSDVersion[1]) = 'A' then
            Result := 'SE';
      end;
    end;
  end
  else if IsWinNT then
  begin
    if IsNT4SP6a then
      Result := 'Service Pack 6a'
    else
      Result := Win32CSDVersion;
  end;
end;

class function TOSInfo.ServicePackMajor: Integer;
begin
  Result := Win32ServicePackMajor;
end;

class function TOSInfo.ServicePackMinor: Integer;
begin
  Result := Win32ServicePackMinor;
end;

initialization

InitPlatformIdEx;

end.
