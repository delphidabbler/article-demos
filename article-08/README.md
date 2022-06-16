# Demo code for Article 8

This directory contains demo code for DelphiDabbler's article "[How to detect the types of executable files](https://delphidabbler.com/articles/article-8)".

The demo was not originally developed under version control. It's last update appears to hav been in 2003. The code was added to the [`delphidabbler/article-demos`](https://github.com/delphidabbler/article-demos) GitHub repository on 14 June 2022.

## About the Demo

This demo exercises the _ExeType_ function described in the article.

### Installing the files

The files included in the demo are as follows:

* `ExeType.dpr` - the demo program source file.
* `ExeType.res` - the demo program resource file.
* `MainForm.dfm` - the demo program main form.
* `MainForm.pas` - the demo program main form source (includes _ExeType_ function).
* `PJDropFiles.pas` - unit used by main form source file.
* `ReadMe.txt` - this file.

### Compiling the projects

This demo contains a project file `ExeType.dpr`. Load the project into Delphi and compile. The demo was created using Delphi 4.

`MainForm.pas` uses the `PJDropFiles.pas` component unit to enable it to catch files dragged and dropped from Explorer. The program dynamically creates the component so there should be no need to install `PJDropFiles.pas` into your IDE, providing the unit is kept in the same folder as `MainForm.pas`.

### Using the demo program

Simply start the demo, select some files in Windows Explorer and drag and drop them onto the demo program's window. The window will come to the front and will list the name(s) of the dropped file(s), followed by the file type(s), using names from the _TExeFileKind_ enumeration.

## Bug Reports

If you find a bug in the demo code, please report it. See the [main read-me file](https://github.com/delphidabbler/article-demos/blob/master/README.md#bug-reports) for information on how to do so.
