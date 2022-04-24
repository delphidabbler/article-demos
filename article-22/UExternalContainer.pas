{
  This demo application accompanies the article
  "How to call Delphi code from scripts running in a TWebBrowser" at
  http://www.delphidabbler.com/articles?article=22.

  This unit defines the IDocHostUIHandler implementation that provides the
  external object to the TWebBrowser.

  This code is copyright (c) P D Johnson (www.delphidabbler.com), 2005-2006.

  v1.0 of 2005/05/09 - original version named UExternalUIHandler.pas
  v2.0 of 2006/02/11 - revised to descend from new TNulWBContainer class
}

           
{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}


unit UExternalContainer;

interface

uses
  // Delphi
  ActiveX, SHDocVw,
  // Project
  IntfDocHostUIHandler, UNulContainer, UMyExternal;

type

  {
  TExternalContainer:
    UI handler that extends browser's external object.
  }
  TExternalContainer = class(TNulWBContainer, IDocHostUIHandler, IOleClientSite)
  private
    fExternalObj: IDispatch;  // external object implementation
  protected
    { Re-implemented IDocHostUIHandler method }
    function GetExternal(out ppDispatch: IDispatch): HResult; stdcall;
  public
    constructor Create(const HostedBrowser: TWebBrowser);
  end;


implementation


{ TExternalContainer }

constructor TExternalContainer.Create(const HostedBrowser: TWebBrowser);
begin
  inherited;
  fExternalObj := TMyExternal.Create;
end;

function TExternalContainer.GetExternal(out ppDispatch: IDispatch): HResult;
begin
  ppDispatch := fExternalObj;
  Result := S_OK; // indicates we've provided script
end;

end.

