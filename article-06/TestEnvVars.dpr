program TestEnvVars;

uses
  Forms,
  FmTestEnvVars in 'FmTestEnvVars.pas' {EnvVarsForm},
  UEnvVars in 'UEnvVars.pas',
  FmSpawnProcess in 'FmSpawnProcess.pas' {SpawnDlg},
  FmTestExpandVars in 'FmTestExpandVars.pas' {ExpandVarsDlg};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TEnvVarsForm, EnvVarsForm);
  Application.CreateForm(TSpawnDlg, SpawnDlg);
  Application.CreateForm(TExpandVarsDlg, ExpandVarsDlg);
  Application.Run;
end.
