# Demo code for Article 24

This directory contains demo code for DelphiDabbler's article "[How to receive data dragged from other applications](https://delphidabbler.com/articles/article-24)".

The demo was not originally developed under version control. It's last update was on 10 Dec 2006: this is probably the only version released. The code was added to the [`delphidabbler/article-demos`](https://github.com/delphidabbler/article-demos) GitHub repository on 24 April 2022.

## About the Demo

Two example programs are provided. They can be found in subdirectories `Eg1` and `Eg2`. Available files are:

* `Article24.bpg` – project group file that references both example projects.
* `Eg1\Article24Eg1.dpr` – project file for first example demo program.
* `Eg1\Article24Eg1.res` – icon etc for first example demo program.
* `Eg1\FmEg1.pas/.dfm` – main form for first example demo program.
* `Eg1\UHelper.pas` – helper functions for first example demo program.
* `Eg2\Article24Eg2.dpr` – project file for second example demo program.
* `Eg2\Article24Eg2.res` – icon etc for second example demo program.
* `Eg2\FmEg2.pas/.dfm` – main form for second example demo program.

To compile the demos start Delphi and load `Article24.bpg`. Build all the projects.

The code was developed and tested using Delphi 7.

### Example 1

Drag any object from a _drag-drop enabled_ application and drop it on the program's main window. All the data formats supported by the data object will be listed in the display.

## Example 2

The program accepts plain text and HTML dragged and dropped from other applications. Select some text or HTML from a _drag-drop enabled_ application, drag the selection over the program's main window and drop it. Any data object that does not support one of the two supported formats will cause the no-entry cursor to be displayed and dropping will be inhibited.

Plain text is displayed in the upper text box and HTML (if present) in the lower text box, as source code.

Pressing _Shift_ while dragging will change the copy cursor to a move cursor if the source application permits moving. Dropping will then delete the text from the host application.

> **Warning:** Don't try the Move operation with important data since the source text could be lost.

## Bug Reports

If you find a bug in the demo code, please report it. See the [main read-me file](https://github.com/delphidabbler/article-demos/blob/master/README.md#bug-reports) for information on how to do so.
