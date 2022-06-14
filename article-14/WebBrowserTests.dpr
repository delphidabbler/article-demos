program WebBrowserTests;

uses
  Forms,
  FmMain in 'FmMain.pas' {MainForm},
  UWebBrowserWrapper in 'UWebBrowserWrapper.pas',
  FmSampleCodeEncodingDlg in 'FmSampleCodeEncodingDlg.pas' {SampleCodeEncodingDlg},
  FmSaveEncodingDlg in 'FmSaveEncodingDlg.pas' {SaveEncodingDlg};

{$R *.res}
{$R HTML.res}   // for html code stored in resources

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TSampleCodeEncodingDlg, SampleCodeEncodingDlg);
  Application.CreateForm(TSaveEncodingDlg, SaveEncodingDlg);
  Application.Run;
end.

