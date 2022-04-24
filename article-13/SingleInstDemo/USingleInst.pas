{
 * This source code accompanies the article "How to run a single instance of an
 * application" which can be found at
 * http://www.delphidabbler.com/articles?article=13.
 *
 * The code is merely a proof of concept and is intended only to illustrate the
 * article. It is not designed for use in its current form in finished
 * applications. The code is provided on an "AS IS" basis, WITHOUT WARRANTY OF
 * ANY KIND, either express or implied.
 *
 * $Rev: 93 $
 * $Date: 2011-05-09 11:07:10 +0100 (Mon, 09 May 2011) $
}

{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}

unit USingleInst;

interface

uses
  Windows, Controls, Messages;

type
  TSingleInstParamHandler =
    procedure(const Param: string) of object;

  TSingleInstClass = class of TSingleInst;

  TSingleInst = class(TObject)
  private
    fOnProcessParam: TSingleInstParamHandler;
    fEnsureRestoreMsg: UINT;
  protected
    function WdwClassName: string; virtual;
    function WaterMark: DWORD; virtual;
    function FindDuplicateMainWdw: HWND; virtual;
    function SendParamsToPrevInst(Wdw: HWND): Boolean;
      virtual;
    function SwitchToPrevInst(Wdw: HWND): Boolean;
    procedure EnsureRestore(Wdw: HWND; var Msg: TMessage);
      dynamic;
    procedure WMCopyData(var Msg: TMessage); dynamic;
  public
    constructor Create;
    procedure CreateParams(var Params: TCreateParams);
    function HandleMessages(Wdw: HWND;
      var Msg: TMessage): Boolean;
    function CanStartApp: Boolean;
    property OnProcessParam: TSingleInstParamHandler
      read fOnProcessParam write fOnProcessParam;
  end;

  procedure RegisterSingleInstClass(Cls: TSingleInstClass);
  function SingleInst: TSingleInst;

implementation

uses
  SysUtils, Forms;

var
  // Globals storing SingleInst singleton and class of SingleInst
  gSingleInst: TSingleInst = nil;
  gSingleInstClass: TSingleInstClass = nil;

function SingleInst: TSingleInst;
begin
  if not Assigned(gSingleInst) then
  begin
    if Assigned(gSingleInstClass) then
      gSingleInst := gSingleInstClass.Create
    else
      gSingleInst := TSingleInst.Create;
  end;
  Result := gSingleInst;
end;

procedure RegisterSingleInstClass(Cls: TSingleInstClass);
begin
  gSingleInstClass := Cls;
end;

{ TSingleInst }

function TSingleInst.CanStartApp: Boolean;
var
  Wdw: HWND;
begin
  Wdw := FindDuplicateMainWdw;
  if Wdw = 0 then
    Result := True
  else
    Result := not SwitchToPrevInst(Wdw);
end;

constructor TSingleInst.Create;
begin
  inherited;
  fEnsureRestoreMsg := RegisterWindowMessage(
    'USINGLEINST_ENSURERESTORE'
  );
end;

procedure TSingleInst.CreateParams(
  var Params: TCreateParams);
begin
  inherited;
  StrPLCopy(
    Params.WinClassName,
    WdwClassName,
    SizeOf(Params.WinClassName) div SizeOf(Char) - 1
  );
end;

procedure TSingleInst.EnsureRestore(Wdw: HWND;
  var Msg: TMessage);
begin
  if IsIconic(Application.Handle) then
    Application.Restore;
  if Assigned(Application.MainForm)
    and not Application.MainForm.Visible then
    Application.MainForm.Visible := True;
  Application.BringToFront;
  SetForegroundWindow(Wdw);
end;

function TSingleInst.FindDuplicateMainWdw: HWND;
begin
  Result := FindWindow(PChar(WdwClassName), nil);
end;

function TSingleInst.HandleMessages(Wdw: HWND;
  var Msg: TMessage): Boolean;
begin
  if Msg.Msg = WM_COPYDATA then
  begin
    WMCopyData(Msg);
    Result := True;
  end
  else if Msg.Msg = fEnsureRestoreMsg then
  begin
    EnsureRestore(Wdw, Msg);
    Result := True;
  end
  else
    Result := False;
end;

function TSingleInst.SendParamsToPrevInst(Wdw: HWND): Boolean;
var
  CopyData: TCopyDataStruct;
  I: Integer;
  CharCount: Integer;
  Data: PChar;
  PData: PChar;
begin
  CharCount := 0;
  for I := 1 to ParamCount do
    Inc(CharCount, Length(ParamStr(I)) + 1);
  Inc(CharCount);
  Data := StrAlloc(CharCount);
  try
    PData := Data;
    for I := 1 to ParamCount do
    begin
      StrPCopy(PData, ParamStr(I));
      Inc(PData, Length(ParamStr(I)) + 1);
    end;
    PData^ := #0;
    CopyData.lpData := Data;
    CopyData.cbData := CharCount * SizeOf(Char);
    CopyData.dwData := WaterMark;
    Result := SendMessage(
      Wdw, WM_COPYDATA, 0, LPARAM(@CopyData)
    ) = 1;
  finally
    StrDispose(Data);
  end;
end;

function TSingleInst.SwitchToPrevInst(Wdw: HWND): Boolean;
begin
  Assert(Wdw <> 0);
  if ParamCount > 0 then
    Result := SendParamsToPrevInst(Wdw)
  else
    Result := True;
  if Result then
    SendMessage(Wdw, fEnsureRestoreMsg, 0, 0);
end;

function TSingleInst.WaterMark: DWORD;
begin
  Result := 0;
end;

function TSingleInst.WdwClassName: string;
begin
  Result := 'SingleInst.MainWdw';
end;

procedure TSingleInst.WMCopyData(var Msg: TMessage);
var
  PData: PChar;
  Param: string;
begin
  if TWMCopyData(Msg).CopyDataStruct.dwData = WaterMark then
  begin
    PData := TWMCopyData(Msg).CopyDataStruct.lpData;
    while PData^ <> #0 do
    begin
      Param := PData;
      if Assigned(fOnProcessParam) then
        fOnProcessParam(Param);
      Inc(PData, Length(Param) + 1);
    end;
    Msg.Result := 1;
  end
  else
    Msg.Result := 0;
end;

initialization


finalization

gSingleInst.Free;

end.