(*
  All the code presented in this unit is Copyright Peter D Johnson
  www.delphidabbler.com, (c) 2004.

  The code may be used in any way providing it is not sold or passed off as
  the work of another person.

  The code is used at the user's own risk. No guarantee or warranty is provided.
*)

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
