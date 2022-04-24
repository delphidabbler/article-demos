program StrWrapArtPrj;

uses
  Forms,
  MainForm in 'MainForm.pas' {Main};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMain, Main);
  Application.Run;
end.
