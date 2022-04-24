{
  This demo application accompanies the article
  "How to get operating system version information" at
  https://delphidabbler.com/articles/article-23.
}


{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}


program Article23;

uses
  Forms,
  FmDemo in 'FmDemo.pas' {Form1},
  UOSInfo in 'UOSInfo.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Article 23 Demo';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
