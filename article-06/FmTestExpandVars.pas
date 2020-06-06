unit FmTestExpandVars;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TExpandVarsDlg = class(TForm)
    memoToExpand: TMemo;
    memoExpanded: TMemo;
    cbVars: TComboBox;
    lblVars: TLabel;
    btnClose: TButton;
    btnExpand: TButton;
    procedure cbVarsClick(Sender: TObject);
    procedure btnExpandClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  end;

var
  ExpandVarsDlg: TExpandVarsDlg;

implementation

uses
  UEnvVars;

{$R *.DFM}

procedure TExpandVarsDlg.btnExpandClick(Sender: TObject);
  // expand env vars in string in upper memo and display result in lower memo
begin
  memoExpanded.Text := ExpandEnvVars(memoToExpand.Text);
end;

procedure TExpandVarsDlg.cbVarsClick(Sender: TObject);
  // add environment var with chosen name to upper memo at insertion point
begin
  if (cbVars.ItemIndex > -1) and (cbVars.Items[cbVars.ItemIndex] <> '') then
  begin
    memoToExpand.SelText := '%' + cbVars.Items[cbVars.ItemIndex] + '%';
    memoToExpand.SetFocus;
  end;
end;

procedure TExpandVarsDlg.FormShow(Sender: TObject);
  // populate combo box with current env var names
var
  Vars: TStringList;  // all env vars
  Idx: Integer;       // loops thru env vars
begin
  // get current env vars
  Vars := TStringList.Create;
  try
    GetAllEnvVars(Vars);
    // add names of vars to combo box
    cbVars.Clear;
    for Idx := 0 to Pred(Vars.Count) do
      cbVars.Items.Add(Vars.Names[Idx]);
  finally
    Vars.Free;
  end;
end;


end.
