{
 * This source code accompanies the article "How to load and save documents in
 * TWebBrowser in a Delphi-like way" which can be found at
 * http://www.delphidabbler.com/articles?article=14
 *
 * The code is merely a proof of concept and is intended only to illustrate the
 * article. It is not designed for use in its current form in finished
 * applications. The code is provided on an "AS IS" basis, WITHOUT WARRANTY OF
 * ANY KIND, either express or implied.
 *
 * $Rev: 38 $
 * $Date: 2010-02-06 15:36:08 +0000 (Sat, 06 Feb 2010) $
}

{$BOOLEVAL OFF}

unit FmMain;

interface

{$IFDEF CONDITIONALEXPRESSIONS}
  {$IF CompilerVersion >= 15.0} // >= Delphi 7
    {$WARN UNSAFE_TYPE OFF}
  {$IFEND}
{$ENDIF}

uses
  SysUtils, Forms, Dialogs, OleCtrls, SHDocVw, StdCtrls, ExtCtrls, Controls,
  Classes, ComCtrls,

  UWebBrowserWrapper;

type
  TMainForm = class(TForm)
    pnlCtrl: TPanel;
    btnSaveString: TButton;
    btnSaveStream: TButton;
    btnSaveFile: TButton;
    btnLoadString: TButton;
    btnLoadStream: TButton;
    btnLoadFile: TButton;
    edURL: TEdit;
    lblURL: TLabel;
    btnNavigateURL: TButton;
    btnNavigateLocal: TButton;
    pnlLeft: TPanel;
    pnlHelp: TPanel;
    wbHelp: TWebBrowser;
    pnlSource: TPanel;
    lblSource: TLabel;
    splitHoriz: TSplitter;
    edSource: TMemo;
    lblHelp: TLabel;
    pnlOutput: TPanel;
    lblTest: TLabel;
    pnlWB: TPanel;
    wbTest: TWebBrowser;
    lblSourceGen: TLabel;
    btnNavigateResource: TButton;
    dlgOpen: TOpenDialog;
    dlgSave: TSaveDialog;
    sbMain: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure btnLoadFileClick(Sender: TObject);
    procedure btnLoadStreamClick(Sender: TObject);
    procedure btnLoadStringClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSaveStringClick(Sender: TObject);
    procedure btnSaveStreamClick(Sender: TObject);
    procedure btnSaveFileClick(Sender: TObject);
    procedure btnNavigateURLClick(Sender: TObject);
    procedure btnNavigateLocalClick(Sender: TObject);
    procedure lblSourceGenClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnNavigateResourceClick(Sender: TObject);
  private
    fWBW: TWebBrowserWrapper;
    {$IFDEF UNICODE}
    fSampleEncoding: TEncoding;
    {$ENDIF}
    procedure UpdateStatusBar;
  end;

var
  MainForm: TMainForm;

implementation

uses
  MSHTML, Windows, FmSaveEncodingDlg, FmSampleCodeEncodingDlg;

{$R *.dfm}

{$IFDEF UNICODE}
function EncodingName(const Encoding: TEncoding): string;
begin
  if TEncoding.IsStandardEncoding(Encoding) then
  begin
    if Encoding = TEncoding.ASCII then
      Result := 'ASCII'
    else if Encoding = TEncoding.BigEndianUnicode then
      Result := 'Unicode (BE)'
    else if Encoding = TEncoding.Default then
      Result := 'Default'
    else if Encoding = TEncoding.Unicode then
      Result := 'Unicode (LE)'
    else if Encoding = TEncoding.UTF7 then
      Result := 'UTF7'
    else if Encoding = TEncoding.UTF8 then
      Result := 'UTF8';
  end
  else
  begin
    if Encoding is TMBCSEncoding then
      Result := 'MBCS'
    else
      Result := 'Unknown';
  end;
end;
{$ENDIF}

{ TMainForm }

procedure TMainForm.btnLoadFileClick(Sender: TObject);
begin
  if dlgOpen.Execute then
  begin
    fWBW.LoadFromFile(dlgOpen.FileName);
    UpdateStatusBar;
  end;
end;

procedure TMainForm.btnLoadStreamClick(Sender: TObject);
var
  Stm: TMemoryStream;
begin
  Stm := TMemoryStream.Create;
  try
    {$IFDEF UNICODE}
    edSource.Lines.SaveToStream(Stm, fSampleEncoding);
    {$ELSE}
    edSource.Lines.SaveToStream(Stm);
    {$ENDIF}
    Stm.Position := 0;
    fWBW.LoadFromStream(Stm);
  finally
    Stm.Free;
  end;
  UpdateStatusBar;
end;

procedure TMainForm.btnLoadStringClick(Sender: TObject);
begin
  {$IFDEF UNICODE}
  fWBW.LoadFromString(edSource.Text, fSampleEncoding);
  {$ELSE}
  fWBW.LoadFromString(edSource.Text);
  {$ENDIF}
  UpdateStatusBar;
end;

procedure TMainForm.btnNavigateLocalClick(Sender: TObject);
begin
  if dlgOpen.Execute then
  begin
    fWBW.NavigateToLocalFile(dlgOpen.FileName);
    UpdateStatusBar;
  end;
end;

procedure TMainForm.btnNavigateResourceClick(Sender: TObject);
begin
  fWBW.NavigateToResource(HInstance, 'HTMLRES_HTML');
  UpdateStatusBar;
end;

procedure TMainForm.btnNavigateURLClick(Sender: TObject);
begin
  if edURL.Text <> '' then
  begin
    fWBW.NavigateToURL(edURL.Text);
    UpdateStatusBar;
  end;
end;

procedure TMainForm.btnSaveFileClick(Sender: TObject);
begin
  if dlgSave.Execute then
  begin
    {$IFDEF UNICODE}
    if SaveEncodingDlg.ShowModal <> mrOK then
      Exit;
    if Assigned(SaveEncodingDlg.Encoding) then
      fWBW.SaveToFile(dlgSave.FileName, SaveEncodingDlg.Encoding)
    else
      fWBW.SaveToFile(dlgSave.FileName);
    {$ELSE}
    fWBW.SaveToFile(dlgSave.FileName);
    {$ENDIF}
  end;
end;

procedure TMainForm.btnSaveStreamClick(Sender: TObject);
var
  Stm: TMemoryStream;
begin
  Stm := TMemoryStream.Create;
  try
    {$IFDEF UNICODE}
    if SaveEncodingDlg.ShowModal <> mrOK then
      Exit;
    if Assigned(SaveEncodingDlg.Encoding) then
    begin
      fWBW.SaveToStream(Stm, SaveEncodingDlg.Encoding);
      fSampleEncoding := SaveEncodingDlg.Encoding;
    end
    else
    begin
      fWBW.SaveToStream(Stm);
      fSampleEncoding := fWBW.Encoding;
    end;
    {$ELSE}
    fWBW.SaveToStream(Stm);
    {$ENDIF}
    Stm.Position := 0;
    edSource.Lines.LoadFromStream(Stm);
  finally
    Stm.Free;
  end;
end;

procedure TMainForm.btnSaveStringClick(Sender: TObject);
begin
  edSource.Text := fWBW.SaveToString;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  fWBW := TWebBrowserWrapper.Create(wbTest);
  {$IFDEF UNICODE}
  Caption := 'Article#14 Demo [Unicode version]';
  fSampleEncoding := TEncoding.Default; // ANSI
  {$ELSE}
  Caption := 'Article#14 Demo [ANSI version]';
  {$ENDIF}
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  fWBW.Free;
end;

procedure TMainForm.FormShow(Sender: TObject);
var
  Wrapper: TWebBrowserWrapper;
begin
  // Load help html from resources to r/h browser window
  Wrapper := TWebBrowserWrapper.Create(wbHelp);
  try
    Wrapper.NavigateToResource(HInstance, 'HELP_HTML');
  finally
    Wrapper.Free;
  end;
  // Load blank document into test browser
  Wrapper := TWebBrowserWrapper.Create(wbTest);
  try
    Wrapper.NavigateToURL('about:blank');
  finally
    Wrapper.Free;
  end;
end;

procedure TMainForm.lblSourceGenClick(Sender: TObject);
var
  RS: TResourceStream;
  ResName: string;
begin
  if SampleCodeEncodingDlg.ShowModal <> mrOK then
    Exit;
  ResName := SampleCodeEncodingDlg.ResourceName;
  // Display sample HTML code in edSource memo
  RS := TResourceStream.Create(HInstance, PChar(ResName), RT_RCDATA);
  try
    {$IFDEF UNICODE}
    edSource.Lines.LoadFromStream(RS, SampleCodeEncodingDlg.Encoding);
    fSampleEncoding := SampleCodeEncodingDlg.Encoding;
    {$ELSE}
    edSource.Lines.LoadFromStream(RS);
    {$ENDIF}
  finally
    RS.Free;
  end;
end;

procedure TMainForm.UpdateStatusBar;
var
  Doc: IHTMLDocument2;
begin
  if not Assigned(fWBW.WebBrowser.Document) then
    exit;
  // wait for document to load
  while fWBW.WebBrowser.ReadyState <> READYSTATE_COMPLETE do
    Application.ProcessMessages;
  if fWBW.WebBrowser.Document.QueryInterface(IHTMLDocument2, Doc) = S_OK then
    {$IFDEF UNICODE}
    sbMain.SimpleText := Format(
      'Charset: %s    Encoding: %s', [Doc.charset, EncodingName(fWBW.Encoding)]
    );
    {$ELSE}
    sbMain.SimpleText := Format('Charset: %s', [Doc.charset]);
    {$ENDIF}
end;

end.

