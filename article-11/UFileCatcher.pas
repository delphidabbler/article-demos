(*
  All the code presented in this unit is Copyright Peter D Johnson
  www.delphidabbler.com, (c) 2004.

  The code may be used in any way providing it is not sold or passed off as
  the work of another person.

  The code is used at the user's own risk. No guarantee or warranty is provided.
*)

unit UFileCatcher;

interface

uses
  Windows, ShellAPI;

type
  TFileCatcher = class(TObject)
  private
    fDropHandle: HDROP;
    function GetFile(Idx: Integer): string;
    function GetFileCount: Integer;
    function GetPoint: TPoint;
  public
    constructor Create(DropHandle: HDROP);
    destructor Destroy; override;
    property FileCount: Integer read GetFileCount;
    property Files[Idx: Integer]: string read GetFile;
    property DropPoint: TPoint read GetPoint;
  end;

implementation

{ TFileCatcher }

constructor TFileCatcher.Create(DropHandle: HDROP);
begin
  inherited Create;
  fDropHandle := DropHandle;
end;

destructor TFileCatcher.Destroy;
begin
  DragFinish(fDropHandle);
  inherited;
end;

function TFileCatcher.GetFile(Idx: Integer): string;
var
  FileNameLength: Integer;
begin
  FileNameLength := DragQueryFile(fDropHandle, Idx, nil, 0);
  SetLength(Result, FileNameLength);
  DragQueryFile(fDropHandle, Idx, PChar(Result), FileNameLength + 1);
end;

function TFileCatcher.GetFileCount: Integer;
begin
  Result := DragQueryFile(fDropHandle, $FFFFFFFF, nil, 0);
end;

function TFileCatcher.GetPoint: TPoint;
begin
  DragQueryPoint(fDropHandle, Result);
end;

end.
