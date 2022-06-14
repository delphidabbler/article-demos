{
  Do-nothing program with no translations in version information.
}

program NoTransVer;


uses
  Windows;

{$R VNoTransVer.res}

begin
  WriteLn('This app has no translation info');
  Write('Press return to close');
  ReadLn;
end.

