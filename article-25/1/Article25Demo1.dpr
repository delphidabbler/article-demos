{
  This demo application accompanies the article
  "How to handle drag and drop in a TWebBrowser control" at
  http://www.delphidabbler.com/articles/article-25.

  This is the main project file of example program 1.
}


{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}


program Article25Demo1;

uses
  Forms,
  FmDemo1 in 'FmDemo1.pas' {DemoForm1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDemoForm1, DemoForm1);
  Application.Run;
end.
