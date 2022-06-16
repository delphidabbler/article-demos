# Demo code for Article 7

This directory contains demo code for DelphiDabbler's article "[How to dynamically add data to an executable file](https://delphidabbler.com/articles/article-7)".

The demo was not originally developed under version control. It's last update was probably in 2005. The code was added to the [`delphidabbler/article-demos`](https://github.com/delphidabbler/article-demos) GitHub repository on 14 June 2022.

## About the Demo

### Demo files

The following files are included in the demo:

* `Payload.bpg` - The Delphi project group file.
* `Reader.dpr` - Project file for the reader program.
* `Reader.res` - Resource file for the reader program.
* `FmReader.pas` - Source file for the reader program's main form.
* `FmReader.dfm` - Form file for the above.
* `Writer.dpr` - Project file for the writer program.
* `Writer.res` - Resource file for the writer program.
* `FmWriter.pas` - Source file for the writer program's main form.
* `FmWriter.dfm` - Form file for the above.
* `UPayload.pas` - Unit containing _TPayload_ class and supporting code.

### Compiling the projects

The code was targetted at Delphi 4, but should work with later versions of the compiler.

There is a project group file `Payload.bpg` which contains two Delphi projects – `Reader.dpr` and `Writer.dpr`. Load `Payload.bpg` into Delphi and then compile both projects in the group.

Note that you cannot use `Writer.exe` until `Reader.exe` has been compiled.

### Using the demo programs

`Reader.exe` detects if any payload data is attached to it and displays any such data (and its size). If no data is attached then the program displays a message to this effect.

`Writer.exe` is used to attach data to `Reader.exe` – you can enter text in a memo control and click the "Store" button to attach this text as a payload to `Reader.exe`. To remove the payload from `Reader.exe` click the "Delete" button on the `Writer.exe` main window.

If no copy of `Reader.exe` exists in the same folder as `Writer.exe` then `Writer.exe` will detect this and won't permit data to be written.

When experimenting with `Reader.exe` and `Writer.exe` you should note the following:

1. `Reader.exe` should always be run from Explorer and not from the Delphi IDE. Using the IDE may cause the program to be re-compiled which will destroy any payload data.
2. Always make sure that `Reader.exe` is closed before altering it using `Writer.exe`. `Reader.exe` can't be written to while running.

The following experiments are suggested:

1. Run `Reader.exe` immediately after compilation: it should report that no payload is present. Close `Reader.exe`.
2. Start `Writer.exe`.
3. Enter some text in `Writer.exe`'s memo control and click the "Store" button. Run `Reader.exe` and note that the text just stored is displayed. Close `Reader.exe`.
4. Enter some longer text in `Writer.exe`'s memo and click "Store". Run `Reader.exe` and note the new text is displayed. Close `Reader.exe`.
5. Repeat 4 using shorter text – this demonstrates that writing shorter data truncates the previous data correctly.
6. Click `Writer.exe`'s "Delete" button. Run `Reader.exe` and note that data is no longer present. Note that removing the payload like this also removes the payload footer record, restoring the `Reader.exe` file to its original state.
7. Ensure there is still text in `Writer.exe`'s memo control and click the "Store" button. Check that the data has been stored by running `Reader.exe`.
8. Clear the text from `Writer.exe`'s memo control and click "Store". Running `Reader.exe` should show that there is no payload present – this shows that writing zero length data is the same as explicitly removing the payload from a file.

## Bug Reports

If you find a bug in the demo code, please report it. See the [main read-me file](https://github.com/delphidabbler/article-demos/blob/master/README.md#bug-reports) for information on how to do so.
