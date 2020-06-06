program Article10;

uses
  Forms,
  FmMain in 'FmMain.pas' {MainForm};

{$R *.res}
{$Resource HTML.res}  // for HTML and other resources

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
