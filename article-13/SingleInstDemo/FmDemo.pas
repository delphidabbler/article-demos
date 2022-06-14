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
