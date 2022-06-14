{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}


unit FmLVCustDrawDemo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, StdCtrls;

type
  TFmCustomLVDemo = class(TForm)
    PageControl: TPageControl;
    d1_TabSheet: TTabSheet;
    d1_ListView: TListView;
    d1_Image: TImage;
    d1_Panel: TPanel;
    d1_CheckBox: TCheckBox;
    d2_TabSheet: TTabSheet;
    d2_ListView: TListView;
    d3_TabSheet: TTabSheet;
    d3_ListView: TListView;
    d4_TabSheet: TTabSheet;
    d4_ListView: TListView;
    d5_TabSheet: TTabSheet;
    d5_ListView: TListView;
    procedure d1_ListViewCustomDraw(Sender: TCustomListView;
      const ARect: TRect; var DefaultDraw: Boolean);
    procedure d1_CheckBoxClick(Sender: TObject);
    procedure d2_ListViewCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure d3_ListViewCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure d3_ListViewCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure d4_ListViewCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure d4_ListViewCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure d5_ListViewCustomDraw(Sender: TCustomListView;
      const ARect: TRect; var DefaultDraw: Boolean);
    procedure d5_ListViewCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure d5_ListViewCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure d5_ListViewColumnClick(Sender: TObject; Column: TListColumn);
  private
    procedure d3_SetLVColumnColour(ColIdx: Integer);
  private
    d5_fCurrentCol: Integer; // currently selected column
    procedure d5_SetLVColumnShading(ColIdx: Integer);
  end;

var
  FmCustomLVDemo: TFmCustomLVDemo;

implementation

uses
  CommCtrl;

{$R *.DFM}


// -----------------------------------------------------------------------------
// Demo1: Background Bitmap
// Article reference: Displaying a background bitmap
// -----------------------------------------------------------------------------

{
  Check box clicked: toggles whether list view displays items on transparent
  background.
}
procedure TFmCustomLVDemo.d1_CheckBoxClick(Sender: TObject);
begin
  // Simply invalidate list view: d1_ListViewCustomDraw handles state of
  // checkbox
  d1_ListView.Invalidate;
end;

{
  Handles OnCustomDraw event hander: displays background bitmap when list view
  is redrawn.
}
procedure TFmCustomLVDemo.d1_ListViewCustomDraw(Sender: TCustomListView;
  const ARect: TRect; var DefaultDraw: Boolean);
  {
    Returns height of any header control in list view or 0 if none.
  }
  function GetHeaderHeight: Integer;
  var
    Header: HWND;           // header window handle
    Pl: TWindowPlacement;   // header window placement
  begin
    // Get header window
    Header := SendMessage(d1_ListView.Handle, LVM_GETHEADER, 0, 0);
    // Get header window placement
    FillChar(Pl, SizeOf(Pl), 0);
    Pl.length := SizeOf(Pl);
    GetWindowPlacement(Header, @Pl);
    // Calculate header window height
    Result  := Pl.rcNormalPosition.Bottom - Pl.rcNormalPosition.Top;
  end;
var
  BmpXPos, BmpYPos: Integer;  // X and Y position for bitmap
  Bmp: TBitmap;               // Reference to bitmap
  ItemRect: TRect;            // List item bounds rectangle
  TopOffset: Integer;         // Y pos where bmp drawing starts
begin
  // Get top offset where bitmap drawing starts
  if d1_ListView.Items.Count > 0 then
  begin
    ListView_GetItemRect(d1_ListView.Handle, 0, ItemRect, LVIR_BOUNDS);
    TopOffset := ListView_GetTopIndex(d1_ListView.Handle) *
      (ItemRect.Bottom - ItemRect.Top);
  end
  else
    TopOffset := 0;
  BmpYPos := ARect.Top - TopOffset + GetHeaderHeight;
  // Draw the bitmap
  // get reference to bitmap
  Bmp := d1_Image.Picture.Bitmap;
  // loop until bmp is past bottom of list view
  while BmpYPos < ARect.Bottom do
  begin
    // draw bitmaps across width of display
    BmpXPos := ARect.Left;
    while BmpXPos < ARect.Right do
    begin
      d1_ListView.Canvas.Draw(BmpXPos, BmpYPos, Bmp);
      Inc(BmpXPos, Bmp.Width);
    end;
    // move to next row
    Inc(BmpYPos, Bmp.Height);
  end;
  // We decide whether to make list items transparent based on state of
  // check box
  if d1_CheckBox.Checked then
  begin
    // ensure that the items are drawn transparently
    SetBkMode(d1_ListView.Canvas.Handle, TRANSPARENT);
    ListView_SetTextBkColor(d1_ListView.Handle, CLR_NONE);
    ListView_SetBKColor(d1_ListView.Handle, CLR_NONE);
  end
  else
  begin
    // ensure that the items are drawn on a window colour background
    SetBkMode(d1_ListView.Canvas.Handle, OPAQUE);
    ListView_SetTextBkColor(d1_ListView.Handle, GetSysColor(COLOR_WINDOW));
    ListView_SetBKColor(d1_ListView.Handle, GetSysColor(COLOR_WINDOW));
  end;
end;


// -----------------------------------------------------------------------------
// Demo2: Alternating Rows
// Article reference: Drawing Rows in Alternating Colors
// -----------------------------------------------------------------------------

{
  OnCustomDrawItem event handler: sets background colour for list items in
  alternating colours.
}
procedure TFmCustomLVDemo.d2_ListViewCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState;
  var DefaultDraw: Boolean);
const
  cStripe = $CCFFCC;  // colour of alternate list items
begin
  if Odd(Item.Index) then
    // odd list items have green background
    d2_ListView.Canvas.Brush.Color := cStripe
  else
    // even list items have window colour background
    d2_ListView.Canvas.Brush.Color := clWindow;
end;


// -----------------------------------------------------------------------------
// Demo3: Rainbow Columns
// Article reference: Drawing Columns in Different Colours
// -----------------------------------------------------------------------------

{
  Helper method that sets required background colour for a given column.
}
procedure TFmCustomLVDemo.d3_SetLVColumnColour(ColIdx: Integer);
const
  // The colours for each list view column
  cRainbow: array[0..3] of TColor = (
    $FFCCCC, $CCFFCC, $CCCCFF, $CCFFFF
  );
begin
  d3_ListView.Canvas.Brush.Color := cRainBow[ColIdx];
end;

{
  OnCustomDrawItem event handler: sets colour of column 0 (Caption column).
}
procedure TFmCustomLVDemo.d3_ListViewCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  // Set the colour for column 0
  d3_SetLVColumnColour(0);
end;

{
  OnCustomDrawSubItem event handler: sets colour of columns with index > 0
  (SubItems columns).
}
procedure TFmCustomLVDemo.d3_ListViewCustomDrawSubItem(Sender: TCustomListView;
  Item: TListItem; SubItem: Integer; State: TCustomDrawState;
  var DefaultDraw: Boolean);
begin
  // Check if SubItem is not 0 (Delphi 4 calls this event with
  // SubItem = 0, while Delphi 7 starts with SubItem = 1
  if SubItem >= 1 then
    // We set the background colour to the colour required for
    // the column per the SubItem parameter
    d3_SetLVColumnColour(SubItem);
end;


// -----------------------------------------------------------------------------
// Demo4: Custom Fonts
// Article reference: Using Different Fonts in Different Columns
// -----------------------------------------------------------------------------

{
  OnCustomDrawItem event handler: sets column 0 (Caption column) to display in
  Comic Sans MS italic font.
}
procedure TFmCustomLVDemo.d4_ListViewCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState;
  var DefaultDraw: Boolean);
begin
  d4_ListView.Canvas.Font.Name := 'Comic Sans MS';
  d4_ListView.Canvas.Font.Style := [fsItalic];
end;

{
  OnCustomDrawSubItem event handler: sets columns with index > 0 to normal
  font unless this is the "Amount" column 3 (SubItems[2]) with a negative
  value when the font displays in red.
}
procedure TFmCustomLVDemo.d4_ListViewCustomDrawSubItem(Sender: TCustomListView;
  Item: TListItem; SubItem: Integer; State: TCustomDrawState;
  var DefaultDraw: Boolean);
begin
  if SubItem = 0 then
    Exit;   // Ensure SubItem 0 not updated here in Delphi 4
  if (SubItem = 3) and (Pos('(', Item.SubItems[2]) > 0) then
    // Display negative values in "Amount" column in red
    d4_ListView.Canvas.Font.Color := clRed
  else
    // Display all other sub item colums in black
    d4_ListView.Canvas.Font.Color := clBlack;
end;


// -----------------------------------------------------------------------------
// Demo5: Shaded Column
// Article reference: Display a Shaded Column
// -----------------------------------------------------------------------------

const
  // Colour of the shaded column
  cShade = $F7F7F7;

{
  OnColumnClick event handler: updates index of shaded column to the one that
  was clicked.
}
procedure TFmCustomLVDemo.d5_ListViewColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  // Updates the index of the shaded column
  d5_fCurrentCol := Column.Index;
  // Redisplays list view with new column highlighted
  d5_ListView.Invalidate;
end;

{
  OnCustomDraw event handler: displays shading in any area of list view not
  occupied by list items.
}
procedure TFmCustomLVDemo.d5_ListViewCustomDraw(Sender: TCustomListView;
  const ARect: TRect; var DefaultDraw: Boolean);
  // Displays shading in any area not occupied by list items
var
  ColLeft: Integer; // left edge of selected column
  ColBounds: TRect; // bounds of the selected column
  I: Integer;       // loops thru columns
begin
  // Calculate left side of selected column
  ColLeft := ARect.Left;
  for I := 0 to Pred(d5_fCurrentCol) do
    ColLeft := ColLeft + ListView_GetColumnWidth(d5_ListView.Handle, I);
  // Calculate bounding rectangle of selected column
  ColBounds := Rect(
    ColLeft,
    ARect.Top,
    ColLeft + ListView_GetColumnWidth(d5_ListView.Handle, d5_fCurrentCol),
    ARect.Bottom
  );
  // Shade the column
  // other event handlers overwrite this where there are list
  // items but this code ensures shading extends to bottom of
  // list view client rectangle
  d5_ListView.Canvas.Brush.Color := cShade;
  d5_ListView.Canvas.FillRect(ColBounds);
end;

{
  Helper method that sets background colour of given column to be shaded if the
  column is selected or in the window colour if column is not selected.
}
procedure TFmCustomLVDemo.d5_SetLVColumnShading(ColIdx: Integer);
begin
  if d5_fCurrentCol = ColIdx then
    // given column is selected: shade it
    d5_ListView.Canvas.Brush.Color := cShade
  else
    // given column not shaded: ensure correct background used
    d5_ListView.Canvas.Brush.Color := ColorToRGB(d5_ListView.Color);
end;

{
  OnCustomDrawItem event handler: shades column 0 (Caption column) if required.
}
procedure TFmCustomLVDemo.d5_ListViewCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  d5_SetLVColumnShading(0);
end;

{
  OnCustomDrawSubItem: shades column > 0 (SubItems columns) if required.
}
procedure TFmCustomLVDemo.d5_ListViewCustomDrawSubItem(Sender: TCustomListView;
  Item: TListItem; SubItem: Integer; State: TCustomDrawState;
  var DefaultDraw: Boolean);
begin
  if SubItem > 0 then // ensure not column 0 (Delphi 4)
    d5_SetLVColumnShading(SubItem);
end;

end.
