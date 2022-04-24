ReadMe file for ExeType demo project
====================================

0) Contents
-----------

1) About the demo
2) Installing the files
3) Compiling the project
4) Using the demo program
5) Copyright


1) About the demo
-----------------

This demo exercises the ExeType function described in the article "How to detect
the types of executable file" on the DelphiDabbler.com website. The article can
be found at http://www.delphidabbler.com/articles.php?article=8


2) Installing the files
-----------------------

Simply unzip the downloaded .zip file into a new folder. The provided files are:

ExeType.cfg     - the demo program project config file
ExeType.dof     - the demo program options file
ExeType.dpr     - the demo program source file
ExeType.res     - the demo program resource file
MainForm.dfm    - the demo program main form
MainForm.pas    - the demo program main form source (includes ExeType function)
PJDropFiles.pas - unit used by main form source file


3) Compiling the projects
-------------------------

This demo contains a project file ExeType.dpr. Load the project into Delphi and
compile. The demo was created using Delphi 4. Attempting to load the projects
into earlier Delphi versions may result in warning about missing or unknown
properties in the form file. It should be safe to remove the properties, save
the revised form files and compile.

MainForm.pas uses the PJDropFiles.pas component unit to enable it to catch files
dragged and dropped from Explorer. The program dynamically creates the component
so the should be no need to install PJDropFiles.pas it into your IDE, providing
the unit is kept in the same folder as MainForm.pas.


4) Using the demo program
-------------------------

Simply start the demo, select some files in Windows Explorer and drag and drop
them onto the demo program's window. The window will come to the front and will
list the names of the dropped file, followed by the file type (using names from
the TExeFileKind enumeration).


5) Copyright
------------

All the code contained in this demo project is copyright (C) 1998-2003 by Peter
Johnson, Llanarth, Wales, UK. The code can be freely used in your own projects
on a non-commercial basis. Please contact the author via
http://www.delphidabbler.com/contact.php if you wish to use the code in any other
way or if you have comments or suggestions.

-- END --