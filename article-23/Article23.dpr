{
  This demo application accompanies the article
  "How to get operating system version information" at
  http://www.delphidabbler.com/articles?article=23.

  This is the main project file.

  This code is copyright (c) P D Johnson (www.delphidabbler.com), 2006.

  v1.0 of 2006/02/19 - original version
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
