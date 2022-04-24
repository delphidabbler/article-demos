{
  This demo application accompanies the article
  "How to get operating system version information" at
  http://www.delphidabbler.com/articles?article=23.

  This unit defines the main form class.

  This code is copyright (c) P D Johnson (www.delphidabbler.com), 2006.

  v1.0 of 2006/02/19 - original version
}


{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}


unit FmDemo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs,

  UOSInfo, StdCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    procedure Display;
      overload;
    procedure Display(const Title: string);
      overload;
    procedure Display(const Title, Msg: string);
      overload;
    procedure Display(const Title: string; const Flag: Boolean);
      overload;
    procedure Display(const Title: string; const Product: TOSProduct);
      overload;
    procedure Display(const Title: string; const Int: Integer);
      overload;
    procedure Display(const Title: string; const ProductType: TOSProductType);
      overload;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{ TForm1 }

procedure TForm1.Display;
begin
  Memo1.Lines.Add('');
end;

procedure TForm1.Display(const Title: string);
begin
  Memo1.Lines.Add(Title);
  Memo1.Lines.Add(StringOfChar('-', Length(Title)));
end;

procedure TForm1.Display(const Title, Msg: string);
begin
  Memo1.Lines.Add(Format('%-22s : %s', [Title, Msg]));
end;

procedure TForm1.Display(const Title: string; const Flag: Boolean);
const
  cFlag: array[Boolean] of string = ('False', 'True');
begin
  Display(Title, cFlag[Flag]);
end;

procedure TForm1.Display(const Title: string; const Product: TOSProduct);
const
  cProducts: array[TOSProduct] of string = (
    'osUnknown', 'osWin95', 'osWin98', 'osWinMe',
    'osWinNT4', 'osWin2000', 'osWinXP', 'osWinServer2003'
  );
begin
  Display(Title, cProducts[Product]);
end;

procedure TForm1.Display(const Title: string; const Int: Integer);
begin
  Display(Title, IntToStr(Int));
end;

procedure TForm1.Display(const Title: string;
  const ProductType: TOSProductType);
const
  cProductType: array[TOSProductType] of string = (
    'ptNA', 'ptUnknown', 'ptNTWorkstation',
    'ptNTServer', 'ptNTDomainController', 'ptNTAdvancedServer'
  );
begin
  Display(Title, cProductType[ProductType]);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Caption := Application.Title;
  Display('TOSInfo methods');
  Display('IsWin9x', TOSInfo.IsWin9x);
  Display('IsWinNT', TOSInfo.IsWinNT);
  Display('IsServer', TOSInfo.IsServer);
  Display('IsTablet', TOSInfo.IsTablet);
  Display('IsMediaCenter', TOSInfo.IsMediaCenter);
  Display('IsWOW64', TOSInfo.IsWOW64);
  Display('Product', TOSInfo.Product);
  Display('BuildNumber', TOSInfo.BuildNumber);
  Display('ServicePack', TOSInfo.ServicePack);
  Display('ServicePackMajor', TOSInfo.ServicePackMajor);
  Display('ServicePackMinor', TOSInfo.ServicePackMinor);
  Display('ProductType', TOSInfo.ProductType);
  Display('Edition', TOSInfo.Edition);
  Display;

  Display('Delphi RTL Win32XXX Globals');
  Display('Win32Platform', Win32Platform);
  Display('Win32MajorVersion', Win32MajorVersion);
  Display('Win32MinorVersion', Win32MinorVersion);
  Display('Win32BuildNumber', Win32BuildNumber);
  Display('Win32CSDVersion', Win32CSDVersion);
  Display;

  Display('Extended Win32XXX Globals');
  Display('Win32HaveExInfo', Win32HaveExInfo);
  Display('Win32ServicePackMajor', Win32ServicePackMajor);
  Display('Win32ServicePackMinor', Win32ServicePackMinor);
  Display('Win32SuiteMask', Win32SuiteMask);
  Display('Win32ProductType', Win32ProductType);
end;

end.
