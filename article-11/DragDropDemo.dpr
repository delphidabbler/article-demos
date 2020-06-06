program DragDropDemo;

uses
  Forms,
  FmMain in 'FmMain.pas' {Form1},
  UFileCatcher in 'UFileCatcher.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
