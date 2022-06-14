{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$WARN UNSAFE_TYPE OFF}

unit FmTemplate;

interface

uses
  Windows, Messages, SysUtils, Controls, Forms,
  UStartup;

type
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    procedure ProcessParam(const Param: string);
    procedure UMEnsureRestored(var Msg: TMessage);
      message UM_ENSURERESTORED;
    procedure WMCopyData(var Msg: TWMCopyData);
      message WM_COPYDATA;
  protected
    procedure CreateParams(var Params: TCreateParams);
      override;
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{ TForm1 }

procedure TForm1.CreateParams(var Params: TCreateParams);
begin
  inherited;
  StrCopy(Params.WinClassName, cWindowClassName);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  for I := 1 to ParamCount do
    ProcessParam(ParamStr(I));
end;

procedure TForm1.ProcessParam(const Param: string);
begin
  { TODO : Code to process a parameter }
end;

procedure TForm1.UMEnsureRestored(var Msg: TMessage);
begin
  if IsIconic(Application.Handle) then
    Application.Restore;
  if not Visible then
    Visible := True;
  Application.BringToFront;
  SetForegroundWindow(Self.Handle);
end;

procedure TForm1.WMCopyData(var Msg: TWMCopyData);
var
  PData: PChar;
  Param: string;
begin
  if Msg.CopyDataStruct.dwData <> cCopyDataWaterMark then
    raise Exception.Create(
      'Invalid data structure passed in WM_COPYDATA'
    );
  PData := Msg.CopyDataStruct.lpData;
  while PData^ <> #0 do
  begin
    Param := PData;
    ProcessParam(Param);
    Inc(PData, Length(Param) + 1);
  end;
  Msg.Result := 1;
end;

end.
