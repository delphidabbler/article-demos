{
 * This source code accompanies the article "How to create and use HTML resource
 * files" which can be found at
 * http://www.delphidabbler.com/articles?article=10.
 *
 * The code is merely a proof of concept and is intended only to illustrate the
 * article. It is not designed for use in its current form in finished
 * applications. The code is provided on an "AS IS" basis, WITHOUT WARRANTY OF
 * ANY KIND, either express or implied.
 *
 * $Rev: 15 $
 * $Date: 2009-09-26 04:01:39 +0100 (Sat, 26 Sep 2009) $
}

program Article10;

uses
  Forms,
  FmMain in 'FmMain.pas' {MainForm};

{$R *.res}
{$Resource HTML.res}  // for HTML and other resources

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
