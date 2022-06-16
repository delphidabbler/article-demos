# Demo code for Article 17

This directory contains demo code for DelphiDabbler's article "[How to set a component's default event handler](https://delphidabbler.com/articles/article-17)".

The demo was not originally developed under version control. The date of its last update before being placed under version control is not known. The code was added to the [`delphidabbler/article-demos`](https://github.com/delphidabbler/article-demos) GitHub repository on 14 June 2022.

## About the Demo

The demo code is contained in `DefEventDemo.pas`. There is no demo project file or application - the code is designed to be added to a design time package and installed into the IDE.

The code was targetted at Delphi 7.

### Test Components

The unit defines the three sample components presented in the article: _TCompA_, _TCompB_ and _TCompC_. You can install the components into a package to test how Delphi determines the default event handler to create when the components are double clicked in the IDE. Comment out various events and rebuild the package and re-test to see how the default event handler changes.

### Component Editors

Both the hard-wired component editor, _TMyCompEditor_, and the reusable versions (the abstract _TCompEditorBase_ and the concrete _TCompEditor_) are provided.

The registration routines for the component editors are commented out to enable the default behaviour of the test components to be investigated (as above).

#### TMyCompEditor

To make _OnFoo_ the default event for _TCompA_ using _TMyCompEditor_ uncomment the line

```pascal
RegisterComponentEditor(TCompA, TMyCompEditor);
```

from the _Register_ procedure and rebuild the component package. Then double click the component and check that the _OnFoo_ event handler has been created.

#### TCompEditor

To make _OnFoo_ the default event for _TCompB_ and/or _TCompC_ using _TCompEditor_ (derived from _TCompEditorBase_) uncomment the lines

```pascal
RegisterComponentEditor(TCompB, TCompEditor);
RegisterComponentEditor(TCompC, TCompEditor);
```

from the _Register_ procedure and rebuild the component package. Once again rebuild the component package and re-test.

#### Going further

To make a different default event for any of the components you can derive a new class from _TCompEditorBase_ and return the name of the required event from the overriden _DefaultEventName_ method. Then register your new class in the _Register_ routine for the required component.

## Bug Reports

If you find a bug in the demo code, please report it. See the [main read-me file](https://github.com/delphidabbler/article-demos/blob/master/README.md#bug-reports) for information on how to do so.
