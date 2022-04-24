unit RCDataUserForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    RichEdit1: TRichEdit;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
var
  RS: TResourceStream;
begin
  // Create resource stream
  RS := TResourceStream.CreateFromID(HInstance, 100, RT_RCDATA);
  try
    // Load the rich edit component
    RichEdit1.Lines.LoadFromStream(RS);
  finally
    // Free the stream
    RS.Free;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Close;
end;

end.
