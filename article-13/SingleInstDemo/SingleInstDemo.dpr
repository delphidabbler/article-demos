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
 * $Rev: 94 $
 * $Date: 2011-05-09 11:08:44 +0100 (Mon, 09 May 2011) $
}

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
