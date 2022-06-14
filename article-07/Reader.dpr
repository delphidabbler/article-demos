program Reader;

uses
  Forms,
  FmReader in 'FmReader.pas' {ReaderForm},
  UPayload in 'UPayload.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TReaderForm, ReaderForm);
  Application.Run;
end.
