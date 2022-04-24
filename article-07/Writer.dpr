program Writer;

uses
  Forms,
  FmWriter in 'FmWriter.pas' {WriterForm},
  UPayload in 'UPayload.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TWriterForm, WriterForm);
  Application.Run;
end.
