# Demo code for Article 18

This directory contains demo code for DelphiDabbler's article "[How to customise the TWebBrowser user interface](https://delphidabbler.com/articles/article-18)".

The demo was not originally developed under version control. It's last update before being placed under version control was on 30 May 2010. The code was added to the [`delphidabbler/article-demos`](https://github.com/delphidabbler/article-demos) GitHub repository on 13 June 2022. See [CHANGELOG.md](./CHANGELOG.md) for details of known updates.

## About the Demo

The code was originally targetted at Delphi 7 and later. It has been tested with Delphi 7, 2006 and 2010 and includes project and project group files suitable for all these compilers.

There are two demos:

1. The "phase 1" version of the sample application from the article. This shows an unmodified web browser displaying some HTML in a form. The project is `WBUIArtDemo1.dpr` and it is in the `ArticleDemo\Phase1` folder. The HTML that is displayed is found in the `DlgContent.html` file in the `Shared` folder.

2. The "phase 2" version of the above program. This project configures the web browser control as follows:

    * It uses the same background and fonts and theme as the form.
    * Scroll bars and borders are hidden.
    * A custom context menu is provided.
    * Text selection is prevented.

  The project is named `WBUIArtDemo2.dpr` and it is to be found in the `ArticleDemo\Phase2` folder. This demo uses the same HTML file, `DlgContent.html`, in the `Shared` folder as used in phase 1.
  
You should compile and test the demos then examine the source code. Please review the programs alongside the article.

## Bug Reports

If you find a bug in the demo code, please report it. See the [main read-me file](https://github.com/delphidabbler/article-demos/blob/master/README.md#bug-reports) for information on how to do so.
