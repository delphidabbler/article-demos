# Demo code for Article 23

This directory contains demo code for DelphiDabbler's article "[How to get operating system version information](https://delphidabbler.com/articles/article-23)".

The demo was not originally developed under version control. It's last update was on 19 February 2006. The code was added to the [`delphidabbler/article-demos`](https://github.com/delphidabbler/article-demos) GitHub repository on 24 April 2022.

## About the Demo

The demo includes the following files:

* `Article23.dpr` – project file for demo program.
* `Article23.res` – icon etc for demo program.
* `FmDemo.pas/.dfm` – demo program's main form.
* `UOSInfo.pas` – code developed in article.

To use the demo start Delphi and load `Article23.dpr`. Compile the program and run it. The results of all the public methods of the _TOSInfo_ static class are displayed along with the values of the _Win32XXX_ variables defined by Delphi and in `UOSInfo.pas`.

Once the program has been tested, examine the code in the various units.

The code was originally developed using Delphi 7. It should compile with Delphi 4 and later.

## Bug Reports

If you find a bug in the demo code, please report it. See the [main read-me file](https://github.com/delphidabbler/article-demos/blob/master/README.md#bug-reports) for information on how to do so.
