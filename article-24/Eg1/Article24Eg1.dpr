{
  This demo application accompanies the article
  "How to receive data dragged from other applications" at
  https://delphidabbler.com/articles/article-24.

  This is the main project file of example program 1.
}


{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}


program Article24Eg1;

uses
  Forms,
  FmEg1 in 'FmEg1.pas' {Form1},
  UHelper in 'UHelper.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
