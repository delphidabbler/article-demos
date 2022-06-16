# Demo code for Article 16

This directory contains demo code for DelphiDabbler's article "[How to use the TListView OnCustomDrawXXX events](https://delphidabbler.com/articles/article-16)".

The demo was not originally developed under version control. The dat of the last update before adding to version control is not known. The code was added to the [`delphidabbler/article-demos`](https://github.com/delphidabbler/article-demos) GitHub repository on 14 June 2022.

## About the Demo

The demo was created with Delphi 4 and has been tested with Delphi 4 and Delphi 7.

Open `CustomLVDemo.dpr`, compile the source and run the program.

Each of the examples from the article is displayed on a different tab of the display. Examine the source code of the various tabs do see how the _OnCustomDrawXXX_ event handlers have been used to customise the appearance of the list view.

There are 5 tabs:

1. _Background Bitmap_: shows how to tile a bitmap in the background of the list view. Check the check box to display the text transparently over the background and clear it to show the text with a window colour background.

2. _Alternating Rows_: shows how to alternately colour the list view rows.

3. _Rainbow Columns_: shows how to display each list view column in a different colour.

4. _Custom Fonts_: shows how to display different fonts or font attributes in a column.

5. _Shaded Column_: shows how to highlight a selected column with a shading colour like Explorer does for the current sort column under Windows XP. Click a column header to highlight its column.

## Bug Reports

If you find a bug in the demo code, please report it. See the [main read-me file](https://github.com/delphidabbler/article-demos/blob/master/README.md#bug-reports) for information on how to do so.
