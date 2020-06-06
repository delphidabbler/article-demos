unit FmMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Menus, ExtCtrls;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    Memo1: TMemo;
    StatusBar1: TStatusBar;      
    OpenDialog1: TOpenDialog;
    File1: TMenuItem;
    Open1: TMenuItem;
    Exit1: TMenuItem;                                                   
    ListBox1: TListBox;
    Splitter1: TSplitter;
    Close1: TMenuItem;
    procedure Open1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
  private
    function IsSupportedFileType(const FileName: string): Boolean;
    procedure AddFile(const FileName: string);
    procedure DisplayFile(Idx: Integer);
    procedure WMDropFiles(var Msg: TWMDropFiles); message WM_DROPFILES;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  ShellAPI,
  UFileCatcher;

{$R *.dfm}

const
  cSupportedExts = '*.txt;*.html;*.htm;*.pas;*.inc;*.dpr;';

{ TForm1 }

{ Routines relating to Article #11 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  // Tell windows we accept file drops
  DragAcceptFiles(Self.Handle, True);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  // Cancel acceptance of file drops
  DragAcceptFiles(Self.Handle, False);
end;

procedure TForm1.WMDropFiles(var Msg: TWMDropFiles);
  // Handle WM_DROPFILES message
var
  I: Integer;                 // loops thru all dropped files
  DropPoint: TPoint;          // point where files dropped
  Catcher: TFileCatcher;      // file catcher class
begin
  inherited;
  // Create file catcher object to hide all messy details
  Catcher := TFileCatcher.Create(Msg.Drop);
  try
    // Try to add each dropped file to display
    for I := 0 to Pred(Catcher.FileCount) do
      AddFile(Catcher.Files[I]);
    // Get drop point and display message about it
    DropPoint := Catcher.DropPoint;
    ShowMessageFmt('%d file(s) dropped at (%d,%d)',
      [Catcher.FileCount, DropPoint.X, DropPoint.Y]);
  finally
    Catcher.Free;
  end;
  // Notify Windows we handled message
  Msg.Result := 0;
end;

{ Other application routines }

procedure TForm1.AddFile(const FileName: string);
begin
  if IsSupportedFileType(FileName) then
    DisplayFile(ListBox1.Items.Add(FileName))
  else
    ShowMessageFmt('File %s is not a supported type', [FileName]);
end;

procedure TForm1.Close1Click(Sender: TObject);
var
  ItemIdx: Integer;
begin
  ItemIdx := ListBox1.ItemIndex;
  if ItemIdx > -1 then
  begin
    ListBox1.Items.Delete(ItemIdx);
    if ItemIdx >= ListBox1.Items.Count then
      Dec(ItemIdx);
    DisplayFile(ItemIdx);
  end;
end;

procedure TForm1.DisplayFile(Idx: Integer);
var
  FileName: string;
begin
  if Idx >= 0 then
  begin
    FileName := ListBox1.Items[Idx];
    ListBox1.ItemIndex := Idx;
    Memo1.Lines.LoadFromFile(FileName);
    StatusBar1.SimpleText := FileName;
  end
  else
  begin
    Memo1.Clear;
    StatusBar1.SimpleText := 'N0 FILE SELECTED';
  end;
end;

function TForm1.IsSupportedFileType(const FileName: string): Boolean;
begin
  Result := AnsiPos('*' + ExtractFileExt(FileName) + ';', cSupportedExts) > 0;
end;

procedure TForm1.ListBox1Click(Sender: TObject);
begin
  DisplayFile(ListBox1.ItemIndex);
end;

procedure TForm1.Open1Click(Sender: TObject);
begin
  if (OpenDialog1.Execute) then
    AddFile(OpenDialog1.FileName);
end;

end.
