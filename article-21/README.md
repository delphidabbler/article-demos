# Demo code for Article 21

This directory contains demo code for DelphiDabbler's article "[How to call JavaScript functions in a TWebBrowser from Delphi](https://delphidabbler.com/articles/article-21)".

The demo was not originally developed under version control. The date of the last update before adding to version control was probably in 2005. The code was added to the [`delphidabbler/article-demos`](https://github.com/delphidabbler/article-demos) GitHub repository on 14 June 2022.

## About the Demo

Two demos are included in separate sub-directories. They are

### `CaseStudy` directory

This directory contains an implementation by Peter Johnson (DelphiDabbler) of the article's case study. The files are:

* `Article21.dpr` - project file for demo program
* `Article21.res` - icon etc for demo program
* `FmDemo.pas/.dfm` - demo program's main form containing all Pascal code
* `Test.html` - HTML document displayed in _TWebBrowser_ control

To use the demo start Delphi and load `Article21.dpr`. Compile the program and run it.

`Test.html` is displayed in the browser control. Select a font from the combo box and the browser will use that font to display `Test.html`.

Once the program has been tested, examine the code in `FmDemo.pas`.

### `ReturnValue` directory

This directory contains a demo by Christian Sciberras showing how to capture return values from JavaScript functions. The files are:

* `Demo.dpr` - project file for demo program
* `Demo.res` - icon etc for demo program
* `Unit1.pas/.dfm` - demo program's main for containing all Pascal code
* `test.htm` - HTML document displayed in _TWebBrowser_ control

To use the demo start Delphi and load `Demo.dpr`. Compile the program and run it.

`test.htm` is displayed in the browser control. Follow the instructions on screen.

Once the program has been tested, examine the Pascal code in `Unit1.pas` and the
JavaScript in `test.htm`.

## Bug Reports

If you find a bug in the demo code, please report it. See the [main read-me file](https://github.com/delphidabbler/article-demos/blob/master/README.md#bug-reports) for information on how to do so.
