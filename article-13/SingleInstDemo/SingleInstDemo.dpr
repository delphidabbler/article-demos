{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$APPTYPE GUI}

program SingleInstDemo;

uses
  Forms,
  FmDemo in 'FmDemo.pas' {Form1},
  USingleInst in 'USingleInst.pas',
  UMySingleInst in 'UMySingleInst.pas';

{$R *.RES}

begin
  if SingleInst.CanStartApp then
  begin
    Application.Initialize;
    Application.CreateForm(TForm1, Form1);
    Application.Run;
  end;
end.
