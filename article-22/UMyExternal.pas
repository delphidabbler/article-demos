{
  This demo application accompanies the article
  "How to call Delphi code from scripts running in a TWebBrowser" at
  https://delphidabbler.com/articles/article-22

  This unit defines a class that extends the TWebBrowser's external object.
}


{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$WARN UNSAFE_TYPE OFF}


unit UMyExternal;

interface

uses
  Classes, ComObj, Article22_TLB;

type

  TMyExternal = class(TAutoIntfObject, IMyExternal, IDispatch)
  private
    fData: TStringList; // info from data file
    procedure ShowSBMsg(const Msg: string); // helper method
  protected
    { IMyExternal methods }
    function GetPrecis(const ProgID: WideString): WideString;
      safecall;
    procedure ShowURL(const ProgID: WideString); safecall;
    procedure HideURL; safecall;
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  SysUtils, ActiveX, StdActns;

{ TMyExternal }

constructor TMyExternal.Create;
var
  TypeLib: ITypeLib;    // type library information
  ExeName: WideString;  // name of our program's exe file
begin
  // Get name of application
  ExeName := ParamStr(0);
  // Load type library from application's resources
  OleCheck(LoadTypeLib(PWideChar(ExeName), TypeLib));
  // Call inherited constructor
  inherited Create(TypeLib, IMyExternal);
  // Create and load string list from file
  fData := TStringList.Create;
  fData.LoadFromFile(ChangeFileExt(ExeName, '.dat'));
end;

destructor TMyExternal.Destroy;
begin
  fData.Free;
  inherited;
end;

function TMyExternal.GetPrecis(const ProgID: WideString): WideString;
begin
  Result := fData.Values[ProgId];
end;

procedure TMyExternal.HideURL;
begin
  ShowSBMsg('');
end;

procedure TMyExternal.ShowSBMsg(const Msg: string);
var
  HintAct: THintAction;
begin
  HintAct := THintAction.Create(nil);
  try
    HintAct.Hint := Msg;
    HintAct.Execute;
  finally
    HintAct.Free;
  end;
end;

procedure TMyExternal.ShowURL(const ProgID: WideString);
begin
  ShowSBMsg(
    'http://www.delphidabbler.com/software?id=' + ProgID
  );
end;

end.
