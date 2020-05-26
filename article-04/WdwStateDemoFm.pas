unit WdwStateDemoFm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Registry, StdCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

const
  CRegKey = 'Software\Demos\WdwStateDemo\1.0';

// Helper function to read registry values, and deal with
// cases where no values exist
function ReadIntFromReg(Reg: TRegistry; Name: string;
  Def: Integer): Integer;
  {Reads integer with given name from registry and returns it
  If no such value exists, returns Def default value}
begin
 if Reg.ValueExists(Name) then
    Result := Reg.ReadInteger(Name)
  else
    Result := Def;
end;

procedure TForm1.FormDestroy(Sender: TObject);
var
  Reg: TRegistry;         // the registry
  State: Integer;         // state of wdw
  Pl : TWindowPlacement;  // used for API call
  R: TRect;               // used for wdw pos
begin
  {Calculate window's normal size and position using
  Windows API call - the form's Width, Height, Top and
  Left properties will give maximized window size if
  form is maximised, which is not what we want here}
  Pl.Length := SizeOf(TWindowPlacement);
  GetWindowPlacement(Self.Handle, @Pl);
  R := Pl.rcNormalPosition;
  Reg := TRegistry.Create;
  try
    // Open required key - and create it if it doesn't exist
    Reg.RootKey := HKEY_CURRENT_USER;
    Reg.OpenKey(CRegKey, True);
    // Write window size and position
    Reg.WriteInteger('Width', R.Right-R.Left);
    Reg.WriteInteger('Height', R.Bottom-R.Top);
    Reg.WriteInteger('Left', R.Left);
    Reg.WriteInteger('Top', R.Top);
    // Write out state of window
    {Record window state (maximised, minimised or normal)
    - special case when minimized since form window is simply
    hidden when minimised, and application window is actually
    the one minimised - so we check to see if application
    window *is* minimized and act accordingly}
    if IsIconic(Application.Handle) then
      {minimized - write that state}
      State := Ord(wsMinimized)
    else
      {not mimimized - we can rely on window state of form}
      State := Ord(Self.WindowState);
    Reg.WriteInteger('State', State);
  finally
    Reg.Free;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  Reg: TRegistry;   // the registry
  State: Integer;   // state of wdw
begin
  Reg := TRegistry.Create;
  try
    // Open required key - and exit it if it doesn't exist
    Reg.RootKey := HKEY_CURRENT_USER;
    if not Reg.OpenKey(CRegKey, False) then Exit;
    // Read the window size and position
    // - designed form sizes are defaults
    Self.Width := ReadIntFromReg(Reg, 'Width', Self.Width);
    Self.Height := ReadIntFromReg(Reg, 'Height', Self.Height);
    Self.Left := ReadIntFromReg(Reg, 'Left', Self.Left);
    Self.Top := ReadIntFromReg(Reg, 'Top', Self.Top);
    // Now get window state and restore
    State := ReadIntFromReg(Reg, 'State', Ord(wsNormal));
    {check if window was minimised - we have special
    processing for minimized state since Delphi doesn't
    minimize windows - it uses application window
    instead}
    if State = Ord(wsMinimized) then
    begin
      {we need to set visible true else form won't restore
      properly - but this causes a brief display of form
      any ideas on how to stop this?}
      Self.Visible := True;
      Application.Minimize;
    end
    else
      Self.WindowState := TWindowState(State);
  finally
    Reg.Free;
  end;
end;

end.
