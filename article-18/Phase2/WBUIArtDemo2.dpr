{
 * This source code accompanies the article "How to customise the TWebBrowser
 * user interface" which can be found at
 * https://delphidabbler.com/articles/article-18
}


{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$WARNINGS ON}


program WBUIArtDemo2;

uses
  Forms,
  FmArtDemo2 in 'FmArtDemo2.pas' {ArtDemoForm2},
  UNulContainer in 'UNulContainer.pas',
  IntfDocHostUIHandler in 'IntfDocHostUIHandler.pas',
  UContainer in 'UContainer.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TArtDemoForm2, ArtDemoForm2);
  Application.Run;
end.
