{
  RCDataCreator v1.0
  One of two demo programs to accompany PJSoft website articles about
  embedding files in resource files
  Copyright © PD Johnson, 2000
  This code is free to do what you want with!
}

program RCDataCreator;

uses
  Forms,
  RCDataCreatorForm in 'RCDataCreatorForm.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
