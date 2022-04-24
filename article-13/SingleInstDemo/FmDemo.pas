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
 * $Rev: 93 $
 * $Date: 2011-05-09 11:07:10 +0100 (Mon, 09 May 2011) $
}

{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}

unit FmDemo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    ListBox1: TListBox;
    procedure FormCreate(Sender: TObject);
  protected
    procedure WndProc(var Msg: TMessage); override;
    procedure HandleParam(const Param: string);
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  Form1: TForm1;

implementation

uses
  USingleInst;

{$R *.DFM}

{ TForm1 }

procedure TForm1.CreateParams(var Params: TCreateParams);
begin
  inherited;
  SingleInst.CreateParams(Params);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  SingleInst.OnProcessParam := HandleParam;
  for I := 1 to ParamCount do
    HandleParam(ParamStr(I));
end;

procedure TForm1.HandleParam(const Param: string);
begin
  ListBox1.Items.Add(Param);
end;

procedure TForm1.WndProc(var Msg: TMessage);
begin
  if not SingleInst.HandleMessages(Self.Handle, Msg) then
    inherited;
end;

end.
