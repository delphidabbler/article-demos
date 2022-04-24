(*
  All the code presented in this unit is Copyright Peter D Johnson
  www.delphidabbler.com, (c) 2004.

  The code may be used in any way providing it is not sold or passed off as
  the work of another person.

  The code is used at the user's own risk. No guarantee or warranty is provided.
*)

unit FmSendToDemo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TDemoForm = class(TForm)
    btnMakeSCut: TButton;
    edFileList: TMemo;
    btnDelSCut: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnMakeSCutClick(Sender: TObject);
    procedure btnDelSCutClick(Sender: TObject);
  end;

var
  DemoForm: TDemoForm;

implementation

uses
  ShlObj, ActiveX;

{$R *.dfm}

function GetSendToFolder: string;
var
  pidl: PItemIDList;
  PPath: array[0..MAX_PATH] of AnsiChar;
begin
  Result := '';
  if SHGetSpecialFolderLocation(0, CSIDL_SENDTO, pidl) = NOERROR then
  begin
    try
      if SHGetPathFromIDList(pidl, PPath) then
      begin
        Result := PPath;
      end;
    finally
      ActiveX.CoTaskMemFree(pidl);
    end;
  end
  else
    if (Assigned(pidl)) then showmessage('assigned') else showmessage('not assigned');
end;

//
// From code snip database: http://www.delphidabbler.com/codesnip.php
//
function CreateShellLink(const LinkFileName, AssocFileName, Desc, WorkDir,
  Args, IconFileName: string; const IconIdx: Integer): Boolean;
var
  SL: ShlObj.IShellLink;    // shell link object
  PF: ActiveX.IPersistFile; // persistant file interface to shell link object
begin
  // Assume failure
  Result := False;
  // Ensure COM is initialised
  ActiveX.CoInitialize(nil);
  try
    // Create shell link object
    if ActiveX.Succeeded(
      ActiveX.CoCreateInstance(
        ShlObj.CLSID_ShellLink,
        nil,
        ActiveX.CLSCTX_INPROC_SERVER,
        ShlObj.IShellLink, SL
      )
    ) then
    begin
      // Store required properties of shell link
      SL.SetPath(PChar(AssocFileName));
      SL.SetDescription(PChar(Desc));
      SL.SetWorkingDirectory(PChar(WorkDir));
      SL.SetArguments(PChar(Args));
      if (IconFileName <> '') and (IconIdx >= 0) then
        SL.SetIconLocation(PChar(IconFileName), IconIdx);
      // Create persistant file interface to shell link to save link file
      PF := SL as ActiveX.IPersistFile;
      Result := ActiveX.Succeeded(
        PF.Save(PWideChar(WideString(LinkFileName)), True)
      );
    end;
  finally
    // Finalize COM
    ActiveX.CoUninitialize;
  end;
end;


{ TDemoForm }

const
  cShortcutName = 'Send To Demo.lnk';

procedure TDemoForm.btnDelSCutClick(Sender: TObject);
begin
  DeleteFile(GetSendToFolder + '\' + cShortcutName);
end;

procedure TDemoForm.btnMakeSCutClick(Sender: TObject);
var
  SendToFolder: string;
  LinkFileName: string;
begin
  LinkFileName := ChangeFileExt(ExtractFileName(ParamStr(0)), '.lnk');
  SendToFolder := GetSendToFolder;
  CreateShellLink(
    SendToFolder + '\' + cShortcutName,
    ParamStr(0),
    'Test SendTo Application',
    ExtractFileDir(ParamStr(0)),
    '',
    '',
    -1
  );

end;

procedure TDemoForm.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  for I := 1 to ParamCount do
    edFileList.Lines.Add(ParamStr(I));
end;

end.
