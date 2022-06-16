# Demo code for Article 20

This directory contains demo code for DelphiDabbler's article "[How to extract version information using the Windows API](https://delphidabbler.com/articles/article-20)".

The demo was not originally developed under version control. The last update before being placed under version control appears to have been during 2005. The code was added to the [`delphidabbler/article-demos`](https://github.com/delphidabbler/article-demos) GitHub repository on 14 June 2022.

## About the Demo

The following files are included in the demo:

* `Article20.bpg` - main project group - four programs
* `Article20.dpr` - project file for demo program
* `Article20.res` - icon etc for demo program
* `FmDemo.pas/.dfm` - demo program's main form
* `MultiVer.dpr` - do-nothing program containing 2 string tables / translations
* `NoTransVer.dpr` - do-nothing program containing no string tables / translations
* `NoVerInfo.dpr` - do-nothing program containing no version information at all
* `UVerInfoClass.pas` - unit containing class developed in article.
* `UVerInfoRoutines.pas` - unit containing routines developed in article.
* `UVerInfoTypes.pas` - unit containing types declared in article
* `VArticle20.rc/.res` - resource with single translation in ver info for demo
* `VMultiVer.rc/.res` - resource with two translations in ver info
* `VNoTransVer.rc/.res` - resource with no translations in ver info

To use the demo start Delphi and load `Article20.bpg`. Now build all the projects in the project group.

Run `Article20.exe`. Select one of the programs shown in the list box and click the "Test Class" and "Test Click" buttons to exercise either class.

> **NOTE:** You **must** compile `MultiVer.exe`, `NoTransVer.exe` and `NoVerInfo.exe` before attempting to run `Article20.exe`.

Once the demo program has been tested, examine the code in `UVerInfoClass.pas`, `UVerInfoRoutines.pas` and `UVerInfoTypes.pas` along with the code that exercises them in `FmDemo.pas`.

## Bug Reports

If you find a bug in the demo code, please report it. See the [main read-me file](https://github.com/delphidabbler/article-demos/blob/master/README.md#bug-reports) for information on how to do so.
