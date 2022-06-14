{
  Do-nothing program with multi-language version information.
}

program MultiVer;

{$APPTYPE CONSOLE}

uses
  Windows;

{$R VMultiVer.res}

begin
  WriteLn('This app has multi-lingual version info');
  Write('Press return to close');
  ReadLn;
end.
