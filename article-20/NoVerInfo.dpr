{
  Do-nothing program with no version information.
}

program NoVerInfo;

{$APPTYPE CONSOLE}

uses
  Windows;

begin
  WriteLn('This app has no version info');
  Write('Press return to close');
  ReadLn;
end.
