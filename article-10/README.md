# Demo code for Article 10

This directory contains demo code for DelphiDabbler's article "[How to create and use HTML resource files](https://delphidabbler.com/articles/article-10)".

The demo was not originally developed under version control. It's last update was on 26 September 2009. The code was added to the [`delphidabbler/article-demos`](https://github.com/delphidabbler/article-demos) GitHub repository on 6 June 2020.

## About the Demo

The demo was developed on Delphi 7 and tested with Delphi 7 and Delphi 2010. The code is likely to compile on any version from 7 up and maybe on earlier compilers, though this has not been tested.

Load the project file, `Article10.dpr`, into Delphi and compile and run it. If successful you should see a window, titled "Article #10 Demo", that has four buttons across the top, a greyed-out, empty, edit box and an empty web browser control.

The available buttons are:

* "Show Index Page": loads and displays the HTML resource named `INDEX_PAGE`. Clicking the "Page 1" and "Page 2" links on this page will cause the `PAGE_1` and `PAGE_2` HTML resources to be loaded and displayed, respectively. Clicking the index page's logo accesses the DelphiDabbler website. The page also contains a link to the article.
* "Show Logo Only": displays the DelphiDabber logo GIF on its own. This resource is named `LOGO_GIF` and is also used by other pages.
* "Show Raw CSS": displays the contents of the resource containing the application's Cascading Style Sheets. This resource is linked to by all HTML pages except the one stored in _RT_RCDATA_ resources. The style sheet resource is named `STYLE_CSS` and is displayed without formatting.
* "Show RCDATA Page": displays another HTML resource. This resource has the _RT_RCDATA_ type instead of the _RT_HTML_ type used by the other resources. It also has a numeric resource name (`42`).

The edit box below the buttons displays the `res://` URL used by each button to display the required content. You can copy the URL from the edit box to the clipboard and paste it into Internet Explorer's location bar. Pressing Enter will cause IE to display the resource in the browser. All links will still work.

The source files that are embedded in the application's resources are provided in the HTML sub-folder. `HTML.rc` references all the files in the HTML folder and causes them to be embedded in either _RT_HTML_ or _RT_RCDATA_ resources in the binary resource file `HTML.res` (provided). This resource file is linked into the program in the main project file. The binary file was built using BRCC32.

## Bug Reports

If you find a bug in the demo code, please report it. See the [main read-me file](https://github.com/delphidabbler/article-demos/blob/master/README.md#bug-reports) for information on how to do so.
