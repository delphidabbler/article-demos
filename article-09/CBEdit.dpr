program CBEdit;

uses
  Forms,
  FmEditor in 'FmEditor.pas' {EditorForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TEditorForm, EditorForm);
  Application.Run;
end.
