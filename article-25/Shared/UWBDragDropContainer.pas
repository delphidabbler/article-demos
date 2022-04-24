{
  This demo application accompanies the article
  "How to handle drag and drop in a TWebBrowser control" at
  http://www.delphidabbler.com/articles/article-25.

  This shared file provides web browser container that implements
  IOleClientSite, IDocHostUIHandler and exposes a property that can provide a
  IDropTarget implementation to the web browser.

  This code is copyright (c) P D Johnson (www.delphidabbler.com), 2007.

  v1.0 of 2007/04/22 - original version
}


unit UWBDragDropContainer;

interface

uses
  ActiveX,
  IntfDocHostUIHandler, UNulContainer;  // from article #18

type

  TWBDragDropContainer = class(TNulWBContainer,
    IUnknown, IOleClientSite, IDocHostUIHandler
  )
  private
    fDropTarget: IDropTarget;
  protected
    function GetDropTarget(const pDropTarget: IDropTarget;
      out ppDropTarget: IDropTarget): HResult; stdcall;
  public
    property DropTarget: IDropTarget read fDropTarget write fDropTarget;
  end;

implementation

{ TWBDragDropContainer }

function TWBDragDropContainer.GetDropTarget(const pDropTarget: IDropTarget;
  out ppDropTarget: IDropTarget): HResult;
begin
  if Assigned(fDropTarget) then
  begin
    // We are handling drag-drop: notify browser of drop target object to use
    ppDropTarget := fDropTarget;
    Result := S_OK;
  end
  else
    // We are not handling drag-drop: use inherited default behaviour
    Result := inherited GetDropTarget(pDropTarget, ppDropTarget);
end;

end.

