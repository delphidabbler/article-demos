# Demo code for Article 13

This directory contains demo code for DelphiDabbler's article "[How to run a single instance of an application](https://delphidabbler.com/articles/article-13)".

The demo was not originally developed under version control. It's last update was probably on 9 May 2011. The code was added to the [`delphidabbler/article-demos`](https://github.com/delphidabbler/article-demos) GitHub repository on 14 June 2022.

To learn how to use the demo see `ReadMe.html`.

## About the Demo

The code was originally written in Delphi 4 and was revised using Delphi 7 on 7th August 2005. The code was updated to work correctly when compiled with Unicode versions of Delphi on 9th May 2011 and tested with Delphi 2010. The code should work with versions back to Delphi 4 but this hasn't been tested.

There are two different projects included in the demo – `SingleInstDemo.dpr` and `TemplateDemo.dpr`. Each project is stored in its own sub folder. Both are referenced by the project group file `Article13.bpg` stored in the root folder. The projects are described below.

### `TemplateDemo` Project

`TemplateDemo` is an exact copy of the code presented in the section of the article named "An Initial Approach". It compiles into a do-nothing application. Only one instance of the application can be run at a time. Any minimized window will be restored when an attempt is made to start a second instance.

The purpose of this "do nothing" demo is to provide some code that can be copied into your own projects. Some of the "bolier plate" code can be simply cut and pasted, while other code will need be to be modified to suit. This code is suitable for a one off use, but if you require a reusable or object oriented solution you will need to use the `SingleInstDemo` demo below.

### `SingleInstDemo` Project

This project brings together the code presented in the section of the article named "An Object Oriented Solution". It compiles into an application that displays the parameters passed to it in the form's list box. Only one instance of the application can be run at a time. Any minimized window will be restored when an attempt is made to start a second instance.

The program uses a subclassed version of _TSingleInst_ named _TMySingleInst_. The classes are implemented in `USingleInst.pas` and `UMySingleInst.pas` respectively. _TMySingleInst_ simply provides a window class name for the project's main form along with a watermark to use when passing data between applications. The main form is implemented in `FmDemo.pas` and `FmDemo.dfm`.

The main item of interest here is `UMySingleInst.pas` which is designed to be reusable in various projects – the idea being to include the unit in your project and to override _TSingleInst_ to customise it as required. `UMySingleInst.pas` simply provides an example of how to do this. As noted in the article, you still need to make a few "boiler plate" changes to the project and main form source files. `SingleInstDemo.dpr` and `FmDemo.pas` show how to do this.

## Bug Reports

If you find a bug in the demo code, please report it. See the [main read-me file](https://github.com/delphidabbler/article-demos/blob/master/README.md#bug-reports) for information on how to do so.
