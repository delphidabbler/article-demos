{
  This demo application accompanies the article
  "How to call Delphi code from scripts running in a TWebBrowser" at
  https://delphidabbler.com/articles/article-22

  This is the main project file.

  This code is copyright (c) P D Johnson (www.delphidabbler.com), 2005.
}


{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}


program Article22;


uses
  Forms,
  Article22_TLB in 'Article22_TLB.pas',
  FmDemo in 'FmDemo.pas' {Form1},
  UExternalContainer in 'UExternalContainer.pas',
  UMyExternal in 'UMyExternal.pas',
  IntfDocHostUIHandler in 'IntfDocHostUIHandler.pas',
  UNulContainer in 'UNulContainer.pas';

{$R *.tlb}
{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
