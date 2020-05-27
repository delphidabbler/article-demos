{
 * This source code accompanies the article "How to access environment
 * variables" which can be found at
 * http://www.delphidabbler.com/articles?article=6.
 *
 * The code is merely a proof of concept and is intended only to illustrate the
 * article. It is not designed for use in its current form in finished
 * applications. The code is provided on an "AS IS" basis, WITHOUT WARRANTY OF
 * ANY KIND, either express or implied.
 *
 * $Rev: 51 $
 * $Date: 2010-02-19 11:20:45 +0000 (Fri, 19 Feb 2010) $
}

unit FmTestEnvVars;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TEnvVarsForm = class(TForm)
    lbVars: TListBox;
    lblVarName: TLabel;
    lblVarValue: TLabel;
    edVarName: TEdit;
    edVarValue: TEdit;
    lblSize: TLabel;
    staticSize: TStaticText;
    btnUpdate: TButton;
    btnDelete: TButton;
    btnSpawn: TButton;
    btnExit: TButton;
    btnExpand: TButton;
    btnFillBlock: TButton;
    procedure FormCreate(Sender: TObject);
    procedure lbVarsClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure edChange(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure btnSpawnClick(Sender: TObject);
    procedure btnExpandClick(Sender: TObject);
    procedure btnFillBlockClick(Sender: TObject);
  private
    procedure UpdateList;
    procedure UpdateButtons;
  end;

var
  EnvVarsForm: TEnvVarsForm;

implementation

uses
  UEnvVars, FmSpawnProcess, FmTestExpandVars;

{$R *.DFM}

{ TEnvVarsForm }

procedure TEnvVarsForm.btnDeleteClick(Sender: TObject);
  // Delete the env var named in name edit box and update list
var
  ErrCode: Integer; // any error code deleting variable
begin
  if (edVarName.Text <> '') then
  begin
    ErrCode := DeleteEnvVar(edVarName.Text);
    if ErrCode <> 0 then
      ShowMessage('ERROR: ' + SysErrorMessage(ErrCode));
    UpdateList;
  end;
end;

procedure TEnvVarsForm.btnExitClick(Sender: TObject);
  // Exit the program
begin
  Close;
end;

procedure TEnvVarsForm.btnExpandClick(Sender: TObject);
  // Display dlg box where expansion of env vars can be tested
begin
  ExpandVarsDlg.Left := Self.Left + 60;
  ExpandVarsDlg.Top := Self.Top + 60;
  ExpandVarsDlg.ShowModal;
end;

procedure TEnvVarsForm.btnFillBlockClick(Sender: TObject);
  // adds new environment vars until block is full or 10000 env vars added
var
  Idx: Integer;     // loops thru all new env vars
  ErrCode: Integer; // stores any error code when adding vars
begin
  // try to add 10,000 new variables
  for Idx := 0 to 9999 do
  begin
    // store a new env var of form Env9999=9999
    ErrCode := SetEnvVarValue(Format('Env%0.4d', [Idx]),
      Format('%0.4d', [Idx]));
    if ErrCode <> 0 then
    begin
      // there's been an error: show current index and quit loop
      ShowMessage(Format('ERROR adding %dth value: %s',
        [Idx, SysErrorMessage(ErrCode)]));
      Break;
    end;
  end;
  UpdateList;
end;

procedure TEnvVarsForm.btnSpawnClick(Sender: TObject);
  // Display dlg box where a spawned process can be configured
begin
  SpawnDlg.Left := Self.Left + 60;
  SpawnDlg.Top := Self.Top + 60;
  SpawnDlg.ShowModal;
end;

procedure TEnvVarsForm.btnUpdateClick(Sender: TObject);
  // update env var named in name edit with value in value edit. Add new var if
  // doesn't already exist
var
  ErrCode: Integer; // error code returned from SetEnvVarValue
begin
  if (edVarName.Text <> '') and (edVarValue.Text <> '') then
  begin
    ErrCode := SetEnvVarValue(edVarName.Text, edVarValue.Text);
    if ErrCode <> 0 then
      ShowMessage('ERROR: ' + SysErrorMessage(ErrCode));
    UpdateList;
  end;
end;

procedure TEnvVarsForm.edChange(Sender: TObject);
  // an edit box has changed: update state of buttons
begin
  UpdateButtons;
end;

procedure TEnvVarsForm.FormCreate(Sender: TObject);
  // populate list box with current environment
begin
  UpdateList;
end;

procedure TEnvVarsForm.lbVarsClick(Sender: TObject);
  // user clicked an env var: copy name & value to edit boxes
begin
  if lbVars.ItemIndex > -1 then
  begin
    edVarName.Text := lbVars.Items[lbVars.ItemIndex];
    edVarValue.Text := GetEnvVarValue(edVarName.Text);
    UpdateButtons;
  end;
end;

procedure TEnvVarsForm.UpdateButtons;
  // updates state of buttons according to edit controls
var
  NameExists: Boolean; // flag true if env var with name in edit box exists
begin
  NameExists := (lbVars.Items.IndexOf(edVarName.Text) <> -1);
  btnUpdate.Enabled := (edVarName.Text <> '') and (edVarValue.Text <> '');
  if btnUpdate.Enabled then
    if NameExists then
      btnUpdate.Caption := 'Add'
    else
      btnUpdate.Caption := 'Update';
  btnDelete.Enabled := btnUpdate.Enabled and NameExists;
end;

procedure TEnvVarsForm.UpdateList;
  // copies all current env var names into list box and displays block size
var
  Vars: TStringList;  // list of all env vars
  Idx: Integer;       // loops thru env vars
  Size: Integer;      // size of env block
begin
  // get list of current env vars
  Vars := TStringList.Create;
  try
    Size := GetAllEnvVars(Vars);
    // display env names in list box
    lbVars.Clear;
    for Idx := 0 to Pred(Vars.Count) do
      lbVars.Items.Add(Vars.Names[Idx]);
  finally
    Vars.Free;
  end;
  lbVars.ItemIndex := -1;
  // display size of env block
  staticSize.Caption := ' ' + IntToStr(Size) + ' bytes';
  UpdateButtons;
end;

end.
