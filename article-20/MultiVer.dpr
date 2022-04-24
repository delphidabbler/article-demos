{
  Dummy program for article # 20 "How to extract version information using the
  Windows API" from http://www.delphidabbler.com/articles.php?id=20.

  Do-nothing program with multi-language version information.
  Copyright (c) 2005, P.D.Johnson (DelphiDabbler)
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
