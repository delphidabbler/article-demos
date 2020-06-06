(*
  All the code presented in this unit is Copyright Peter D Johnson
  www.delphidabbler.com, (c) 2004.

  The code is used at the user's own risk. No guarantee or warranty is provided.
*)

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
