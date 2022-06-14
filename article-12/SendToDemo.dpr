program SendToDemo;

uses
  Forms,
  FmSendToDemo in 'FmSendToDemo.pas' {DemoForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDemoForm, DemoForm);
  Application.Run;
end.
