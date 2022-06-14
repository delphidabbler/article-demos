{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}

unit UMySingleInst;

interface

uses
  Windows,
  USingleInst;

type
  TMySingleInst = class(TSingleInst)
  protected
    function WdwClassName: string; override;
    function WaterMark: DWORD; override;
  end;

implementation

{ TMySingleInst }

function TMySingleInst.WaterMark: DWORD;
begin
  Result := $DE1F1DAB;
end;

function TMySingleInst.WdwClassName: string;
begin
  Result := 'DelphiDabbler.SingleInstDemo.1';
end;

initialization

RegisterSingleInstClass(TMySingleInst);

end.
