program CustomLVDemo;

uses
  Forms,
  FmLVCustDrawDemo in 'FmLVCustDrawDemo.pas' {FmCustomLVDemo};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFmCustomLVDemo, FmCustomLVDemo);
  Application.Run;
end.
