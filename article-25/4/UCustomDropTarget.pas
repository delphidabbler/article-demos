{
  This demo application accompanies the article
  "How to handle drag and drop in a TWebBrowser control" at
  http://www.delphidabbler.com/articles?article=25.

  This is an implementation of IDropTarget from example program 4.

  This code is copyright (c) P D Johnson (www.delphidabbler.com), 2007.

  v1.0 of 2007/04/22 - original version.
  v1.1 of 2007/05/20 - changed implementation of TCustomDropTarget.CanDrop.
}


unit UCustomDropTarget;

interface

uses
  Classes, Windows, ActiveX;

type

  IDropHandler = interface(IInterface)
    ['{C6A5B98C-9D4C-4205-B0C2-3F964938DF26}']
    procedure HandleText(const Text: string);
    procedure HandleFiles(const Files: TStrings);
  end;

  TCustomDropTarget = class(TInterfacedObject, IDropTarget)
  private
    fCanDrop: Boolean;
    fDropHandler: IDrophandler;
    function CanDrop(const DataObj: IDataObject): Boolean;
    function MakeFormatEtc(const Fmt: TClipFormat): TFormatEtc;
    function GetTextFromObj(const DataObj: IDataObject;
      const Fmt: TClipFormat): string;
    procedure GetFileListFromObj(const DataObj: IDataObject;
      const FileList: TStrings);
    procedure DisplayData(const DataObj: IDataObject);
    procedure DisplayFileList(const DataObj: IDataObject);
    procedure DisplayText(const DataObj: IDataObject);
  protected
    { IDropTarget methods }
    function DragEnter(const dataObj: IDataObject; grfKeyState: Longint;
      pt: TPoint; var dwEffect: Longint): HResult; stdcall;
    function DragOver(grfKeyState: Longint; pt: TPoint;
      var dwEffect: Longint): HResult; stdcall;
    function DragLeave: HResult; stdcall;
    function Drop(const dataObj: IDataObject; grfKeyState: Longint; pt: TPoint;
      var dwEffect: Longint): HResult; stdcall;
  public
    constructor Create(const Handler: IDropHandler);
  end;

implementation

uses
  ShellAPI, SysUtils, ComObj;

{ TCustomDropTarget }

function TCustomDropTarget.CanDrop(const DataObj: IDataObject): Boolean;
begin
  Result := (DataObj.QueryGetData(MakeFormatEtc(CF_HDROP)) = S_OK)
    or (DataObj.QueryGetData(MakeFormatEtc(CF_TEXT)) = S_OK);
end;

constructor TCustomDropTarget.Create(const Handler: IDropHandler);
begin
  inherited Create;
  fDropHandler := Handler;
end;

procedure TCustomDropTarget.DisplayData(const DataObj: IDataObject);
begin
  if DataObj.QueryGetData(MakeFormatEtc(CF_HDROP)) = S_OK then
    DisplayFileList(DataObj)
  else if DataObj.QueryGetData(MakeFormatEtc(CF_TEXT)) = S_OK then
    DisplayText(DataObj)
  else
    raise Exception.Create('Drop data object not supported');
end;

procedure TCustomDropTarget.DisplayFileList(const DataObj: IDataObject);
var
  Files: TStringList;
begin
  if Assigned(fDropHandler) then
  begin
    Files := TStringList.Create;
    try
      GetFileListFromObj(DataObj, Files);
      fDropHandler.HandleFiles(Files);
    finally
      FreeAndNil(Files);
    end;
  end;
end;

procedure TCustomDropTarget.DisplayText(const DataObj: IDataObject);
begin
  if Assigned(fDropHandler) then
    fDropHandler.HandleText(GetTextFromObj(DataObj, CF_TEXT));
end;

function TCustomDropTarget.DragEnter(const dataObj: IDataObject;
  grfKeyState: Integer; pt: TPoint; var dwEffect: Integer): HResult;
begin
  Result := S_OK;
  fCanDrop := CanDrop(dataObj);
  if fCanDrop and (dwEffect and DROPEFFECT_COPY <> 0) then
    dwEffect := DROPEFFECT_COPY
  else
    dwEffect := DROPEFFECT_NONE;
end;

function TCustomDropTarget.DragLeave: HResult;
begin
  Result := S_OK;
end;

function TCustomDropTarget.DragOver(grfKeyState: Integer; pt: TPoint;
  var dwEffect: Integer): HResult;
begin
  if fCanDrop and (dwEffect and DROPEFFECT_COPY <> 0) then
    dwEffect := DROPEFFECT_COPY
  else
    dwEffect := DROPEFFECT_NONE;
  Result := S_OK;
end;

function TCustomDropTarget.Drop(const dataObj: IDataObject;
  grfKeyState: Integer; pt: TPoint; var dwEffect: Integer): HResult;
begin
  Result := S_OK;
  fCanDrop := CanDrop(dataObj);
  if fCanDrop and (dwEffect and DROPEFFECT_COPY <> 0) then
  begin
    dwEffect := DROPEFFECT_COPY;
    DisplayData(dataObj);
  end
  else
    dwEffect := DROPEFFECT_NONE;
end;

procedure TCustomDropTarget.GetFileListFromObj(const DataObj: IDataObject;
  const FileList: TStrings);
var
  Medium: TStgMedium;         // storage medium containing file list
  DroppedFileCount: Integer;  // number of dropped files
  I: Integer;                 // loops thru dropped files
  FileNameLength: Integer;    // length of a dropped file name
  FileName: string;           // name of a dropped file
begin
  // Get required storage medium from data object
  if DataObj.GetData(MakeFormatEtc(CF_HDROP), Medium) = S_OK then
  begin
    try
      try
        // Get count of files dropped
        DroppedFileCount := DragQueryFile(
          Medium.hGlobal, $FFFFFFFF, nil, 0
        );
        // Get name of each file dropped and process it
        for I := 0 to Pred(DroppedFileCount) do
        begin
          // get length of file name, then name itself
          FileNameLength := DragQueryFile(Medium.hGlobal, I, nil, 0);
          SetLength(FileName, FileNameLength);
          DragQueryFile(
            Medium.hGlobal, I, PChar(FileName), FileNameLength + 1
          );
          // add file name to list
          FileList.Add(FileName);
        end;
      finally
        // Tidy up - release the drop handle
        // don't use DropH again after this
        DragFinish(Medium.hGlobal);
      end;
    finally
      ReleaseStgMedium(Medium);
    end;
  end;
end;

function TCustomDropTarget.GetTextFromObj(const DataObj: IDataObject;
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

function TCustomDropTarget.MakeFormatEtc(const Fmt: TClipFormat): TFormatEtc;
begin
  Result.cfFormat := Fmt;
  Result.ptd := nil;
  Result.dwAspect := DVASPECT_CONTENT;
  Result.lindex := -1;
  Result.tymed := TYMED_HGLOBAL;
end;

end.
