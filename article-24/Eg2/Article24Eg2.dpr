{
  This demo application accompanies the article
  "How to receive data dragged from other applications" at
  https://delphidabbler.com/articles/article-24.

  This is the main project file of example program 2.

  This code is copyright (c) P D Johnson (www.delphidabbler.com), 2006.

  v1.0 of 2006/12/10 - original version
}


{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}


program Article24Eg2;

uses
  Forms,
  FmEg2 in 'FmEg2.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
