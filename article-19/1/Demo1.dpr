{
  This demo application accompanies the article
  "How to make a TWebBrowser become the active control when clicked" on
  http://www.delphidabbler.com/articles?article=19.

  This demo shows the problem that the article addresses.

  This demo is copyright Peter D Johnson (www.delphidabbler.com) 2009 and
  is licensed under the Creative Commons Attribution-Noncommercial-Share Alike
  2.5 Generic License: http://creativecommons.org/licenses/by-nc-sa/2.5/
}


{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$WARNINGS ON}


program Demo1;

uses
  Forms,
  FmDemo1 in 'FmDemo1.pas' {DemoForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDemoForm, DemoForm);
  Application.Run;
end.

