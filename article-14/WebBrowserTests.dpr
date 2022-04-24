{
 * This source code accompanies the article "How to load and save documents in
 * TWebBrowser in a Delphi-like way" which can be found at
 * http://www.delphidabbler.com/articles?article=14.
 *                                   
 * The code is merely a proof of concept and is intended only to illustrate the
 * article. It is not designed for use in its current form in finished
 * applications. The code is provided on an "AS IS" basis, WITHOUT WARRANTY OF
 * ANY KIND, either express or implied.
 *
 * $Rev: 38 $
 * $Date: 2010-02-06 15:36:08 +0000 (Sat, 06 Feb 2010) $
}

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

