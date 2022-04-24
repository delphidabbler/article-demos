{
  This demo application accompanies the article
  "How to receive data dragged from other applications" at
  https://delphidabbler.com/articles/article-24.

  This unit defines the main form class of example program 1.
}


{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}


unit FmEg1;

interface

uses
  ActiveX, Controls, ComCtrls, Classes, StdCtrls, Forms, Windows;

type
  TForm1 = class(TForm, IDropTarget)
    lblDesc: TLabel;
    lvDisplay: TListView;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    procedure DisplayDataInfo(const FmtEtc: TFormatEtc);
  protected
    { IDropTarget methods }
    function IDropTarget.DragEnter = DropTargetDragEnter;
    function DropTargetDragEnter(const dataObj: IDataObject;
      grfKeyState: Longint; pt: TPoint; var dwEffect: Longint): HResult;
      stdcall;
    function IDropTarget.DragOver = DropTargetDragOver;
    function DropTargetDragOver(grfKeyState: Longint; pt: TPoint;
      var dwEffect: Longint): HResult;
      stdcall;
    function IDropTarget.DragLeave = DropTargetDragLeave;
    function DropTargetDragLeave: HResult;
      stdcall;
    function IDropTarget.Drop = DropTargetDrop;
    function DropTargetDrop(const dataObj: IDataObject; grfKeyState:
      Longint; pt: TPoint; var dwEffect: Longint): HResult;
      stdcall;
  public
  end;

var
  Form1: TForm1;

implementation

uses
  SysUtils, ComObj,
  UHelper;

{$R *.dfm}

{ TForm1 }

procedure TForm1.DisplayDataInfo(const FmtEtc: TFormatEtc);
var
  LI: TListItem;
begin
  LI := lvDisplay.Items.Add;
  LI.Caption := CBFormatDesc(FmtEtc.cfFormat);
  LI.SubItems.Add(TymedDesc(FmtEtc.tymed));
  LI.SubItems.Add(AspectDesc(FmtEtc.dwAspect));
  LI.SubItems.Add(IntToStr(FmtEtc.lindex));
end;

function TForm1.DropTargetDragEnter(const dataObj: IDataObject;
  grfKeyState: Integer; pt: TPoint; var dwEffect: Integer): HResult;
begin
  dwEffect := DROPEFFECT_COPY;
  Result := S_OK;
end;

function TForm1.DropTargetDragLeave: HResult;
begin
  Result := S_OK;
end;

function TForm1.DropTargetDragOver(grfKeyState: Integer; pt: TPoint;
  var dwEffect: Integer): HResult;
begin
  dwEffect := DROPEFFECT_COPY;
  Result := S_OK;
end;

function TForm1.DropTargetDrop(const dataObj: IDataObject;
  grfKeyState: Integer; pt: TPoint; var dwEffect: Integer): HResult;
var
  Enum: IEnumFormatEtc;
  FormatEtc: TFormatEtc;
begin
  dwEffect := DROPEFFECT_COPY;
  OleCheck(DataObj.EnumFormatEtc(DATADIR_GET, Enum));
  lvDisplay.Clear;
  while Enum.Next(1, FormatEtc, nil) = S_OK do
    DisplayDataInfo(FormatEtc);
  Result := S_OK;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  OleInitialize(nil);
  OleCheck(RegisterDragDrop(Handle, Self));
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  RevokeDragDrop(Handle);
  OleUninitialize;
end;

end.
