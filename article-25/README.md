# Demo code for Article 25

This directory contains demo code for DelphiDabbler's article "[How to handle drag and drop in a TWebBrowser control](https://delphidabbler.com/articles/article-25)".

The demo was not originally developed under version control. It's last update was on 20 May 2007. The code was added to the [`delphidabbler/article-demos`](https://github.com/delphidabbler/article-demos) GitHub repository on 24 April 2022. See [CHANGELOG.md](./CHANGELOG.md) for details of known updates.

## About the Demo

Four example programs are included in the demo, in subdirectories `1`, `2`, `3` and `4`. All projects belong to the same project group. Some shared code is stored in the `Shared` subdirectory. Files are:

* `Article25Demos.bpg` – project group file.
* `1\Article25Demo1.dpr` – project file for first example demo program.
* `1\Article25Demo1.res` – icon etc for first example demo program.
* `1\FmDemo1.pas/.dfm` – main form for first example demo program.
* `2\Article25Demo2.dpr` – project file for second example demo program.
* `2\Article25Demo2.res` – icon etc for second example demo program.
* `2\FmDemo2.pas/.dfm` – main form for second example demo program.
* `3\Article25Demo3.dpr` – project file for third example demo program.
* `3\Article25Demo3.res` – icon etc for third example demo program.
* `3\FmDemo3.pas/.dfm` – main form for third example demo program.
* `3\UNulDropTarget.pas` – do nothing implementation of _IDropTarget_.
* `4\Article25Demo4.dpr` – project file for fourth example demo program.
* `4\Article25Demo4.res` – icon etc for fourth example demo program.
* `4\Demo.html` – HTML document displayed in main form's web browser control.
* `4\FmDemo4.pas/.dfm` – main form for fourth example demo program.
* `4\UCustomDropTarget.pas` – _IDropTarget_ implementation that provides custom drag drop handling for web browser control.
* `Shared\IntfDocHostUIHandler.pas` – Declares _IDocHostUIHandler_ interface and related types.
* `Shared\MainIcon.ico` – Icon used by all demo programs.
* `Shared\UNulContainer.pas` – Do nothing implementation of _IDocHostUIHandler_.
* `Shared\UWBDragDropContainer.pas` – OLE client site for web browser control that provides a drag drop enabled implementation of _IDocHostUIHandler_.

To compile the demos start Delphi and load `Article25Demos.bpg`. Build all the projects.

The code was developed and tested using Delphi 7.

### Demo 1

This demo simply provides a _TWebBrowser_ control in a non OLE enabled application. Try dragging and dropping files or text onto the window. You should find that the browser control does not accept drag drop.

### Demo 2

This program is the same as that in Demo 1 except that OLE is initialised. Again try dropping various kinds of files onto the browser control. Some files will be loaded and displayed, while for others a dialogue box offering to download the files will be displayed. This illustrates _TWebBrowser_'s default drag drop handling.

### Demo 3

This program again simply displays a _TWebBrowser_ control and has OLE initialised. However, this time we have provided a _IDropTarget_ implementation to the browser control that inhibits drag drop. Once again the browser control will reject all attempts to drop data on it.

### Demo 4

This final demo shows how customise _TWebBrowser_'s handling of drag drop. Dragging and dropping one or more files onto the control will cause the names of the dropped files to be displayed - the browser control will no longer attempt to load the files. Additionally, if text is dragged and dropped from a suitable drag and drop enabled editor the program will display the dropped text.

## Bug Reports

If you find a bug in the demo code, please report it. See the [main read-me file](https://github.com/delphidabbler/article-demos/blob/master/README.md#bug-reports) for information on how to do so.
