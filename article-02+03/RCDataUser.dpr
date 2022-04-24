program RCDataUser;

uses
  Forms,
  RCDataUserForm in 'RCDataUserForm.pas' {Form1};

{$R *.RES}

{$R HELLO.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
