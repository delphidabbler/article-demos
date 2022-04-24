This ReadMe file explains how to use the demo source code that accompanies the
article "How to extract version information using the Windows API" at
http://www.delphidabbler.com/articles.php?article=20.

Included in the download are the following files:

Article20.bpg          : main project group - four programs
Article20.dpr          : project file for demo program
Article20.res          : icon etc for demo program
FmDemo.pas/.dfm        : demo program's main form
MultiVer.dpr/.exe      : do-nothing program containing 2 string tables / trans
NoTransVer.dpr/.exe    : do-nothing program containing no string tables / trans
NoVerInfo.dpr/.exe     : do-nothing program containing no version information
UVerInfoClass.pas      : unit containing class developed in article.
UVerInfoRoutines.pas   : unit containing routines developed in article.
UVerInfoTypes.pas      : unit containing types declared in article
VArticle20.rc/.res     : resource with single translation in ver info for demo
VMultiVer.rc/.res      : resource with two translations in ver info
VNoTransVer.rc/.res    : resource with no translations in ver info

To use the demo start Delphi and load Article20.bpg and select Article20.exe.
Compile the program and run it.

Select one of the list programs in the list box and and click the Test Class and
Test Click buttons to exercise either class.

There is no need to compile the MultiVer.exe, NoTransVer.exe or NoVerInfo.exe
do-nothing programs since they are supplied ready compiled.

Once the program has been tested, examine the code in UVerInfoClass.pas,
UVerInfoRoutines.pas and UVerInfoTypes.pas along with the code that excerises
them in FmDemo.pas.

