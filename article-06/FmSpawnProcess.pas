{
 * This source code accompanies the article "How to access environment
 * variables" which can be found at
 * http://www.delphidabbler.com/articles?article=6.
 *
 * The code is merely a proof of concept and is intended only to illustrate the
 * article. It is not designed for use in its current form in finished
 * applications. The code is provided on an "AS IS" basis, WITHOUT WARRANTY OF
 * ANY KIND, either express or implied.
 *
 * $Rev: 51 $
 * $Date: 2010-02-19 11:20:45 +0000 (Fri, 19 Feb 2010) $
}

unit FmSpawnProcess;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TSpawnDlg = class(TForm)
    rgpBlockType: TRadioGroup;
    memoVars: TMemo;
    lblVars: TLabel;
    btnSpawn: TButton;
    Close: TButton;
    procedure rgpBlockTypeClick(Sender: TObject);
    procedure btnSpawnClick(Sender: TObject);
  private
    function BuildEnvBlock(IncludeCurrent: Boolean): PChar;
  end;

var
  SpawnDlg: TSpawnDlg;

implementation

uses
  UEnvVars;

{$R *.DFM}

{ Helper routines }


function ExecProg(const ProgName: string; EnvBlock: Pointer): Boolean;
  {Creates a new process for given program passing any given environment block}
var
  SI: TStartupInfo;         // start up info
  PI: TProcessInformation;  // process info
  CreateFlags: DWORD;       // process creation flags
  SafeProgName: string;     // program name: safe for CreateProcessW
begin
  // Make ProgName parameter safe for passing to CreateProcess (Delphi 2009
  // and later). Need to ensure memory space is writeable because of issue with
  // CreateProcessW. Problem does not exist with CreateProcessA.
  // Without the following code this problem would arise if this routine was
  // called with a constant or string with -1 reference count as the ProgName
  // parameter.
  // See http://msdn.microsoft.com/en-us/library/ms682425.aspx for an
  // explanation of the problem: look under the lpCommandLine parameter section.
  // Remy Lebeau suggested the workaround used below in his post to
  // https://forums.codegear.com/thread.jspa?threadID=12826
  SafeProgName := ProgName;
  UniqueString(SafeProgName);
  // Set up startup info record: all default values
  FillChar(SI, SizeOf(SI), 0);
  SI.cb := SizeOf(SI);
  // Set up creation flags: special flag required for unicode environments,
  // which is want when unicode support is enabled.
  // NOTE: we are assuming that the environment block is in Unicode of Delphi
  // 2009 or later. However, CreateProcess permits it to be ANSI.
  {$IFDEF UNICODE}
  CreateFlags := CREATE_UNICODE_ENVIRONMENT;  // we are passing a unicode env
  {$ELSE}
  CreateFlags := 0;
  {$ENDIF}
  // Execute the program
  Result := CreateProcess(
    nil, PChar(SafeProgName), nil, nil, True, CreateFlags, EnvBlock, nil, SI, PI
  );
end;

{ TSpawnDlg }

procedure TSpawnDlg.btnSpawnClick(Sender: TObject);
  // create a new process with an environment block per radio buttons
var
  Block: PChar;
begin
  case rgpBlockType.ItemIndex of
    0:  // create process with copy of current environment
      ExecProg(ParamStr(0), nil);
    1:  // create process whose environment is per memo control
    begin
      Block := BuildEnvBlock(False);
      try
        ExecProg(ParamStr(0), Block);
      finally
        StrDispose(Block);
      end;
    end;
    2:  // create process with copy of current environment + entries in memo box
    begin
      Block := BuildEnvBlock(True);
      try
        ExecProg(ParamStr(0), Block);
      finally
        StrDispose(Block);
      end;
    end;
  end;
end;

function TSpawnDlg.BuildEnvBlock(IncludeCurrent: Boolean): PChar;
  // create a new environment block including vars listed in memo + optionally
  // a copy of current process's environment: returns pointer to env block
var
  BlockSize: Integer;   // size of env block
begin
  // get block size
  BlockSize := CreateEnvBlock(memoVars.Lines, IncludeCurrent, nil, 0);
  // create buffer for block and store environment in it
  Result := StrAlloc(BlockSize);
  CreateEnvBlock(memoVars.Lines, IncludeCurrent, Result, BlockSize);
end;

procedure TSpawnDlg.rgpBlockTypeClick(Sender: TObject);
  // enables / disables memo according to if custom env vars to be included
begin
  memoVars.Enabled := rgpBlockType.ItemIndex <> 0;
end;

end.

