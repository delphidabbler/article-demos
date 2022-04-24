{
  Dummy program for article # 20 "How to extract version information using the
  Windows API" from http://www.delphidabbler.com/articles.php?id=20.

  Do-nothing program with no version information.
  Copyright (c) 2005, P.D.Johnson (DelphiDabbler)
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
