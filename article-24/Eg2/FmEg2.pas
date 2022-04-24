{
  This demo application accompanies the article
  "How to receive data dragged from other applications" at
  http://www.delphidabbler.com/articles?article=24.

  This unit defines the main form class of example program 2.

  This code is copyright (c) P D Johnson (www.delphidabbler.com), 2006.

  v1.0 of 2006/12/10 - original version
}


{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}


unit FmEg2;

interface

uses
  ActiveX, Controls, StdCtrls, Classes, Forms, Windows;

type
  TForm1 = class(TForm, IDropTarget)
    lblText: TLabel;
    edText: TMemo;
    lblHTML: TLabel;
    edHTML: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    fCanDrop: Boolean;
    function CanDrop(const DataObj: IDataObject): Boolean;
    function CursorEffect(const AllowedEffects: Longint;
      const KeyState: Longint): Longint;
    procedure DisplayData(const DataObj: IDataObject);
    function GetTextFromObj(const DataObj: IDataObject;
      const Fmt: TClipFormat): string;
    function MakeFormatEtc(const Fmt: TClipFormat): TFormatEtc;
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
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  ComObj;

{$R *.dfm}

var
  CF_HTML: TClipFormat; // identifier of HTML clipboard format


{ TForm1 }

function TForm1.CanDrop(const DataObj: IDataObject): Boolean;
begin
  Result := DataObj.QueryGetData(MakeFormatEtc(CF_TEXT)) = S_OK;
  if not Result then
    Result := DataObj.QueryGetData(MakeFormatEtc(CF_HTML)) = S_OK;
end;

function TForm1.CursorEffect(const AllowedEffects: Longint;
  const KeyState: Integer): Longint;
begin
  Result := DROPEFFECT_NONE;
  if fCanDrop then
  begin
    if (KeyState and MK_SHIFT = MK_SHIFT) and
      (DROPEFFECT_MOVE and AllowedEffects = DROPEFFECT_MOVE) then
      Result := DROPEFFECT_MOVE
    else if (DROPEFFECT_COPY and AllowedEffects = DROPEFFECT_COPY) then
      Result := DROPEFFECT_COPY;
  end;
end;

procedure TForm1.DisplayData(const DataObj: IDataObject);
begin
  edText.Text := GetTextFromObj(DataObj, CF_TEXT);
  edHTML.Text := GetTextFromObj(DataObj, CF_HTML);
end;

function TForm1.DropTargetDragEnter(const dataObj: IDataObject;
  grfKeyState: Integer; pt: TPoint; var dwEffect: Integer): HResult;
begin
  Result := S_OK;
  fCanDrop := CanDrop(dataObj);
  dwEffect := CursorEffect(dwEffect, grfKeyState);
end;

function TForm1.DropTargetDragLeave: HResult;
begin
  Result := S_OK;
end;

function TForm1.DropTargetDragOver(grfKeyState: Integer; pt: TPoint;
  var dwEffect: Integer): HResult;
begin
  Result := S_OK;
  dwEffect := CursorEffect(dwEffect, grfKeyState);
end;

function TForm1.DropTargetDrop(const dataObj: IDataObject;
  grfKeyState: Integer; pt: TPoint; var dwEffect: Integer): HResult;
begin
  Result := S_OK;
  fCanDrop := CanDrop(dataObj);
  dwEffect := CursorEffect(dwEffect, grfKeyState);
  DisplayData(dataObj);
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

function TForm1.GetTextFromObj(const DataObj: IDataObject;
  const Fmt: TClipFormat): string;
var
  Medium: TStgMedium;
  PText: PChar;
begin
  if DataObj.GetData(MakeFormatEtc(Fmt), Medium) = S_OK then
  begin
    Assert(Medium.tymed = MakeFormatEtc(Fmt).tymed);
    try
      PText := GlobalLock(Medium.hGlobal);
      try
        Result := PText;
      finally
        GlobalUnlock(Medium.hGlobal);
      end;
    finally
      ReleaseStgMedium(Medium);
    end;
  end
  else
    Result := '';
end;

function TForm1.MakeFormatEtc(const Fmt: TClipFormat): TFormatEtc;
begin
  Result.cfFormat := Fmt;
  Result.ptd := nil;
  Result.dwAspect := DVASPECT_CONTENT;
  Result.lindex := -1;
  Result.tymed := TYMED_HGLOBAL;
end;

initialization

CF_HTML := RegisterClipboardFormat('HTML Format');

end.
