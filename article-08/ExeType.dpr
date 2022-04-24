(*
  DEMO Code for article 8 - How to detect the types of executable files.
  from the Hints & Tips page at www.delphidabbler.com

  COPYRIGHT: This code is copyright (C) 2003 by Peter D Johnson, Llanarth,
  Ceredigion, Wales, UK.
*)

program ExeType;

uses
  Forms,
  MainForm in 'MainForm.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
