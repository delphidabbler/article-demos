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

{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$APPTYPE GUI}


program TemplateDemo;

uses
  Forms,
  Windows,
  FmTemplate in 'FmTemplate.pas' {Form1},
  UStartup in 'UStartup.pas';

{$R *.res}

function CanStart: Boolean;
var
  Wdw: HWND;
begin
  Wdw := FindDuplicateMainWdw;
  if Wdw = 0 then
    Result := True
  else
    Result := not SwitchToPrevInst(Wdw);
end;

begin
  if CanStart then
  begin
    Application.Initialize;
    Application.CreateForm(TForm1, Form1);
    Application.Run;
  end;
end.
