{
  Dummy program for article # 20 "How to extract version information using the
  Windows API" from http://www.delphidabbler.com/articles.php?id=20.

  Do-nothing program with no translations in version information.
  Copyright (c) 2005, P.D.Johnson (DelphiDabbler)
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

