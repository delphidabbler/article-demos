{ ##
  @FILE                     PJDropFiles.pas
  @COMMENTS                 The component source code.
  @PROJECT_NAME             Drop files components
  @PROJECT_DESC             Components that enable files dragged and dropped
                            from explorer to be "caught". One component catches
                            files in its own "container" window (that can
                            contain other components) and the other enables a
                            form to catch dropped files.
  @AUTHOR                   Peter Johnson, LLANARTH, Ceredigion, Wales, UK
  @EMAIL                    peter.johnson@openlink.org
  @WEBSITE                  http://www.delphidabbler.com/
  @COPYRIGHT                © Peter D Johnson, 1998-2002.
  @LEGAL_NOTICE             This component, related component and property
                            editors and source code are placed in the public
                            domain. They may be freely copied and circulated on
                            a not-for-profit basis providing that the code is
                            unmodified and this notice and information about the
                            author and his copyright remains attached to the
                            source code.
  @OTHER_NAMES              + Original unit name was DrpFiles.pas
                            + Changed to PJDropFiles.pas at v2.0
  @HISTORY(
    @REVISION(
      @VERSION              1.0
      @DATE                 15/05/1998
      @COMMENTS             Original version.
    )
    @REVISION(
      @VERSION              1.1
      @DATE                 12/10/1998
      @COMMENTS             Changed 2nd parameter to DragQueryFile when used to
                            find number of files dropped from $FFFF to
                            Cardinal(-1) to make it portable across 16 and 32
                            bit platforms. This was needed to allow the
                            component to compile under Delphi 2.
    )
    @REVISION(
      @VERSION              1.1a
      @DATE                 09/04/1999
      @COMMENTS             Changed installation palette from "Own" to "PJ
                            Stuff".
    )
    @REVISION(
      @VERSION              2.0
      @DATE                 29/04/2001
      @COMMENTS             Major rewrite:
                            + Added new FileName, PassThrough and
                              ForegroundOnDrop properties to TPJDropFiles.
                            + Added new component TPJFormDropFiles to intercept
                              files dropped directly on form (subclasses form's
                              window proc).
                            + Moved all common code for two components into
                              helper classes.
                            + Removed support for 16 bit Delphi.
                            + Changed OnDropFiles event so no longer provides
                              drop coordinates: use DropPoint property instead.
                            + Changed unit name to PJDropFiles from DrpFiles.
    )
    @REVISION(
      @VERSION              2.1
      @DATE                 13/05/2001
      @COMMENTS             Fixed bug where length of file name strings was
                            being set incorrectly when collecting dropped files.
    )
    @REVISION(
      @VERSION              3.0
      @DATE                 26/10/2002
      @COMMENTS             Major update:
                            + Added facility to recurse through
                              dropped folders and include all files in folders
                              and sub folders in file list.
                            + Also added facility to exclude folder and/or file
                              names from list.
                            + New Options property provides access to above new
                              facilities.
                            + Added new OnBeforeDrop event that is triggered
                              before dropped files are processed.
                            + Added new IsFolder array property that informs if
                              a dropped file is a file or folder.
                            + Fixed a bug in TPJFormDropFiles that was causing
                              program to halt on exceptions.
                            + Changed component palette name from PJ Stuff to
                              DelphiDabbler.
                            + Moved string literals in error messages to
                              resource strings.\
                            Backwards compatible with v2.
    )
  )
}


unit PJDropFiles;

interface


uses
  // Delphi
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms;


type

  {
  TPJDropFilesOption:
    Enumeration containing all possible values for Options property.
  }
  TPJDropFilesOption = (
    dfoIncFolders,
    dfoIncFiles,
    dfoRecurseFolders
  );

  {
  TPJDropFilesOptions:
    Set containing possible values of Options property.
  }
  TPJDropFilesOptions = set of TPJDropFilesOption;

  {
  TPJAbstractDropFilesHelper:
    Helper class that implements interface to windows drag drop events and other
    common functionality for twp drop files classes. This can't be done in
    common base class for drop files classes since classes inherit from
    different components.
  }
  TPJAbstractDropFilesHelper = class(TObject)
  private
    fComp: TComponent;
      {Reference to the component the helper is working with}
  protected
    function GetHWnd: THandle; virtual;
      {Returns window handle that related control receives messages from. This
      is window handle of container returned by GetContainer method}
    function GetContainer: TWinControl; virtual; abstract;
      {Abstract method to return reference to the related windowed control that
      the component works with}
    procedure HandleFile(const FileName: string);
      {Processes the given file and updates file list according to
      RecurseFolders and ExcludeFolders properties. If ExcludeFolders is true
      then any folder names encoutnered are exlcuded from file list. If
      RecurseFolders is true then any folders and examined and the files in the
      folder are added to list (taking note of ExcludeFolders). Any subfolders
      are also searched recursively}
  public
    fForeGroundOnDrop: Boolean;
      {Value of related control's ForegroundOnDrop property: determines if
      window is brought to foreground when files dropped}
    fOnDropFiles: TNotifyEvent;
      {Value of related control's OnDropFiles event handler: triggered when
      files dropped and after they have been processed}
    fOnBeforeDrop: TNotifyEvent;
      {Value of related control's OnBeforeDrop property: triggered when files
      droped but before they are processed. Files property has no defined value
      when this event is triggered}
    fOnAfterDrop: procedure(hDrop: THandle) of object;
      {Event triggered after drop is complete but before drop handle is
      destroyed: this permits associated controls to perform additional
      processing with drop handle if required}
    fDropPoint: TPoint;
      {Point at which drop occured: can be changed by related components if
      necessary}
    fFileList: TStringList;
      {List of files dropped}
    fOptions: TPJDropFilesOptions;
      {Value related to control's Options property. The options apply to the
      handling of files and folders: determines if files and/or folders are
      listed and if folders are recursed}
    function GetDropControl: TControl;
      {Returns reference to control at position where cursor was released, or
      nil if no control under drop point}
    constructor Create(Comp: TComponent);
      {Class constructor: records reference to related component and helper
      object}
    destructor Destroy; override;
      {Class destructor: frees helper object}
    procedure AcceptFiles(Flag: Boolean);
      {Calls DragAcceptFiles with given value, if not designing and if related
      window handle exists}
    procedure FilesDropped(hDrop: THandle);
      {Uses drop handle to get list of dropped files and to set drop point.
      Triggers OnAfterDrop event before drop handle is destroyed}
    procedure DropFiles; virtual;
      {Called after dropped files are processed and drop handle has been freed.
      Triggers OnDropFiles event and brings drop target to front if required}
    procedure BeforeDrop; virtual;
      {Called before dropped files are processed. Triggers OnBeforeDrop event}
  end;


  {
  TPJDropFilesHelper:
    Helper class customised to TPJDropFiles.
  }
  TPJDropFilesHelper = class(TPJAbstractDropFilesHelper)
  protected
    function GetContainer: TWinControl; override;
      {Returns return reference to the component's related windowed control:
      this is the control itself in this class}
  end;


  {
  TPJFormDropFilesHelper:
    Helper class customised to TPJFormDropFiles.
  }
  TPJFormDropFilesHelper = class(TPJAbstractDropFilesHelper)
  protected
    function GetContainer: TWinControl; override;
      {Returns return reference to the component's related windowed control:
      this is the form on which owns the component}
  end;


  {
  TPJDropFiles:
    Component that provides a container window which catches files dropped on it
    or any components parented by container.
  }
  TPJDropFiles = class(TCustomControl)
  private // properties
    fPassThrough: Boolean;
    function GetCount: Integer;
    function GetFile(Idx: Integer): string;
    function GetDropControl: TControl;
    function GetFileName: string;
    function GetOnDropFiles: TNotifyEvent;
    procedure SetOnDropFiles(const Value: TNotifyEvent);
    function GetDropPoint: TPoint;
    function GetForegroundOnDrop: Boolean;
    procedure SetForegroundOnDrop(const Value: Boolean);
    function GetOnBeforeDrop: TNotifyEvent;
    procedure SetOnBeforeDrop(const Value: TNotifyEvent);
    function GetOptions: TPJDropFilesOptions;
    procedure SetOptions(const Value: TPJDropFilesOptions);
    function GetIsFolder(Idx: Integer): Boolean;
  private // other
    fHelper: TPJDropFilesHelper;
      {Helper class that undertakes most of drag drop handling}
    fPJDropFilesMsg: UInt;
      {ID of custom PJ_DROPFILES message}
  protected
    procedure CreateWnd; override;
      {Window creation method - registers that window can accept dropped files}
    procedure WMDropFiles(var Msg: TMessage); message WM_DROPFILES;
      {File drop message handler - used to record info about dropped files}
    procedure CMEnabledChanged(var Msg: TMessage); message CM_ENABLEDCHANGED;
      {Message triggered when Enabled property changes - used to toggle whether
      files can be accepted or not}
    procedure DoPassThrough(hDrop: THandle);
      {Event handler called by helper class that passes a customised drop files
      message on to owner control when PassThrough property is true}
  public
    constructor Create(AOwner: TComponent); override;
      {Control constructor - sets default values of properties and creates owned
      helper object}
    destructor Destroy; override;
      {Control destructor - frees owned helper object}
    procedure Paint; override;
      {Control paint handler - draws dashed outline to control only when
      designing}
    property Count: Integer read GetCount;
      {The number of files dropped}
    property Files[Idx: Integer]: string read GetFile;
      {The names of the dropped files}
    property FileName: string read GetFileName;
      {The name of the first file dropped, if any, otherwise empty string}
    property IsFolder[Idx: Integer]: Boolean read GetIsFolder;
      {Whether the dropped files in Files property are folders (true) or files
      (false)}
    property DropPoint: TPoint read GetDropPoint;
      {The mouse coordinates where the last files were dropped}
    property DropControl: TControl read GetDropControl;
      {The child control (if any) under the mouse when files are dropped -
      returns nil if no control under mouse}
  published
    {Inherited protected properties published}
    property Enabled stored True;
      {Enables/disables ability to receive dropped files}
    property Align;
    property ParentShowHint;
    property ShowHint;
    {Inherited published properties given new defaults}
    property Width default 80;
    property Height default 60;
    {New properties}
    property PassThrough: Boolean
      read fPassThrough write fPassThrough;
      {Passes drop information on to main window as a custom message: can be
      intercepted by TPJFormDropFiles}
    property ForegroundOnDrop: Boolean
      read GetForegroundOnDrop write SetForegroundOnDrop;
      {When true the window containing the component is brought to front after
      files have been dropped}
    property OnDropFiles: TNotifyEvent
      read GetOnDropFiles write SetOnDropFiles;
      {Event triggered when files have been dropped and have been processed (
      Files property has been updated)}
    property OnBeforeDrop: TNotifyEvent
      read GetOnBeforeDrop write SetOnBeforeDrop;
      {Event triggered just as drop occurs - before files have been processed
      (Files property is not valid at this point and shouldn't be accessed)}
    property Options: TPJDropFilesOptions
      read GetOptions write SetOptions;
      {Set of options that govern how dropped files are processed: whether
      simple files or folders are included in Files property and whether any
      folders are recursed}
  end;


  {
  TPJFormDropFiles:
    Component that subclasses owner form window to provide ability to catch
    files dropped anywhere on form window.
  }
  TPJFormDropFiles = class(TComponent)
  private
    fOldWndProc, fNewWndProc: Pointer;
    fEnabled: Boolean;
    procedure SetEnabled(const Value: Boolean);
    function GetCount: Integer;
    function GetFile(Idx: Integer): string;
    function GetDropControl: TControl;
    function GetFileName: string;
    function GetOnDropFiles: TNotifyEvent;
    procedure SetOnDropFiles(const Value: TNotifyEvent);
    function GetDropPoint: TPoint;
    function GetForegroundOnDrop: Boolean;
    procedure SetForegroundOnDrop(const Value: Boolean);
    function GetOnBeforeDrop: TNotifyEvent;
    procedure SetOnBeforeDrop(const Value: TNotifyEvent);
    function GetOptions: TPJDropFilesOptions;
    procedure SetOptions(const Value: TPJDropFilesOptions);
    function GetIsFolder(Idx: Integer): Boolean;
  private // other
    fHelper: TPJFormDropFilesHelper;
      {The list of files dropped}
    fPJDropFilesMsg: UInt;
      {ID of custom PJ_DROPFILES message}
  protected
    procedure NewWndProc(var Msg: TMessage); virtual;
      {Window procedure used to sub-class owning form's window procedure to
      enable drop-file events to be handled}
    function FormHandle: THandle;
      {Returns window handle of owner form, or 0 if there is no owner}
  public
    constructor Create(AOwner: TComponent); override;
      {Component constructor: ensures that owner is a form and that no more that
      one of these components is on the owner form, subclasses the form window
      to respond to WM_DROPFILES messages, sets default property value and
      creates owned helper object}
    destructor Destroy; override;
      {Component destructor: restores original window procedure and then frees
      owned objects}
    property DropPoint: TPoint read GetDropPoint;
      {The mouse coordinates where the last files were dropped}
    property DropControl : TControl read GetDropControl;
      {The child control (if any) under the mouse when files are dropped -
      returns nil if no control under mouse}
    property Count: Integer read GetCount;
      {The number of files dropped}
    property Files[Idx: Integer]: string read GetFile;
      {The names of the dropped files}
    property FileName: string read GetFileName;
      {The name of the first file dropped, if any, otherwise empty string}
    property IsFolder[Idx: Integer]: Boolean read GetIsFolder;
      {Whether the dropped files in Files property are folders (true) or files
      (false)}
  published
    property Enabled: Boolean
      read fEnabled write SetEnabled default True;
      {Enables/disables ability to receive dropped files}
    property ForegroundOnDrop: Boolean
      read GetForegroundOnDrop write SetForegroundOnDrop;
      {When true the window containing the component is brought to front after
      files have been dropped}
    property OnDropFiles: TNotifyEvent
      read GetOnDropFiles write SetOnDropFiles;
      {Event triggered when files have been dropped and have been processed (
      Files property has been updated)}
    property OnBeforeDrop: TNotifyEvent
      read GetOnBeforeDrop write SetOnBeforeDrop;
      {Event triggered just as drop occurs - before files have been processed
      (Files property is not valid at this point and shouldn't be accessed)}
    property Options: TPJDropFilesOptions
      read GetOptions write SetOptions;
      {Set of options that govern how dropped files are processed: whether
      simple files or folders are included in Files property and whether any
      folders are recursed}
  end;


procedure Register;
  {Delphi registration routine}


implementation

uses
  // Delphi
  ShellAPI;

resourcestring
  // Error messages
  sOwnerNotForm = 'TPJFormDropFiles owner must be a form';
  sOnlyOneAllowed = 'Only one TPJFormDropFiles component is permitted on a '
    + 'form: %0:s is already present on %1:s';


{ Component regsitration procedure }

procedure Register;
  {Registers the components with Delphi}
begin
  RegisterComponents('DelphiDabbler', [TPJDropFiles, TPJFormDropFiles]);
end;

{ Helper function }

function RegisterPJDropFilesMsg: UINT;
  {Registers the PJ_DROPFILES message with a unique value and returns it}
begin
  Result := RegisterWindowMessage('PJ_DROPFILES');
end;

{ TPJDropFiles }

procedure TPJDropFiles.CMEnabledChanged(var Msg : TMessage);
  {Message triggered when Enabled property changes - used to toggle whether
  files can be accepted or not}
begin
  inherited;
  fHelper.AcceptFiles(Enabled);
end;

constructor TPJDropFiles.Create(AOwner : TComponent);
  {Control constructor - sets default values of properties and creates owned
  helper object}
begin
  inherited Create(AOwner);
  // Make control accept child controls
  ControlStyle := ControlStyle + [csAcceptsControls];
  // Set default size
  Width := 80;
  Height := 60;
  // Ensure we're not a tab-stop
  TabStop := False;
  // Get ID of PJ_DROPFILES message
  fPJDropFilesMsg := RegisterPJDropFilesMsg;
  // Create helper object and set pass through handler
  fHelper := TPJDropFilesHelper.Create(Self);
  fHelper.fOnAfterDrop := DoPassThrough;
end;

procedure TPJDropFiles.CreateWnd;
  {Window creation method - registers that window can accept dropped files}
begin
  inherited CreateWnd;
  fHelper.AcceptFiles(Enabled);
end;

destructor TPJDropFiles.Destroy;
  {Control destructor - frees owned helper object}
begin
  fHelper.Free;
  inherited Destroy;
end;

procedure TPJDropFiles.DoPassThrough(hDrop: THandle);
  {Event handler called by helper class that passes a customised drop files
  message on to owner control when PassThrough property is true}
var
  OwnerCtrl: TWinControl; // control that owns this component
  ScreenPos: TPoint;      // screen position of drop point
  OwnerPos: TSmallPoint;  // position of drop point relative to owner control
begin
  // Only pass the event through if required by PassThrough property
  if fPassThrough
    and (Owner <> nil)
    and (Owner is TForm) then
  begin
    // Get reference to owning control
    OwnerCtrl := Owner as TWinControl;
    // Calculate drop position relative to owner control's window
    ScreenPos := ClientToScreen(fHelper.fDropPoint);
    OwnerPos := PointToSmallPoint(OwnerCtrl.ScreenToClient(ScreenPos));
    // Send the custom message to owner control containing new drop position
    SendMessage(OwnerCtrl.Handle, fPJDropFilesMsg, hDrop, Integer(OwnerPos));
  end;
end;

function TPJDropFiles.GetCount : integer;
  {Read access method for Count property - gets number of files dropped}
begin
  Result := fHelper.fFileList.Count;
end;

function TPJDropFiles.GetDropControl : TControl;
  {Read access method for DropControl property - returns child control which was
  under mouse when files were dropped, or nil if no child control was under
  mouse}
begin
  Result := fHelper.GetDropControl;
end;

function TPJDropFiles.GetDropPoint: TPoint;
  {Read access method for DropPoint property}
begin
  Result := fHelper.fDropPoint;
end;

function TPJDropFiles.GetFile(Idx: Integer): string;
  {Read access method for Files array property - returns name of file at the
  given array index}
begin
  Result := fHelper.fFileList[Idx];
end;

function TPJDropFiles.GetFileName: string;
  {Read access method for FileName property: returns name of first file dropped,
  if any, otherwise returns empty string}
begin
  if Count > 0 then
    Result := GetFile(0)
  else
    Result := '';
end;

function TPJDropFiles.GetForegroundOnDrop: Boolean;
  {Read access method for ForegroundOnDrop property}
begin
  Result := fHelper.fForegroundOnDrop;
end;

function TPJDropFiles.GetIsFolder(Idx: Integer): Boolean;
  {Read access method for IsFolder property}
begin
  Result := Boolean(fHelper.fFileList.Objects[Idx]);
end;

function TPJDropFiles.GetOnBeforeDrop: TNotifyEvent;
  {Read access method for OnBeforeDrop event property}
begin
  Result := fHelper.fOnBeforeDrop;
end;

function TPJDropFiles.GetOnDropFiles: TNotifyEvent;
  {Read access method for OnDropFiles event property}
begin
  Result := fHelper.fOnDropFiles;
end;

function TPJDropFiles.GetOptions: TPJDropFilesOptions;
  {Read access method for Options property}
begin
  Result := fHelper.fOptions;
end;

procedure TPJDropFiles.Paint;
  {Control paint handler - draws dashed outline to control only when designing}
begin
  if csDesigning in ComponentState then
    with Canvas do
    begin
      Pen.Style := psDash;
      Brush.Style := bsClear;
      Rectangle(0, 0, Width, Height);
    end;
end;

procedure TPJDropFiles.SetForegroundOnDrop(const Value: Boolean);
  {Write access method for ForegroundOnDrop property}
begin
  fHelper.fForegroundOnDrop := Value;
end;

procedure TPJDropFiles.SetOnBeforeDrop(const Value: TNotifyEvent);
  {Write access method for OnBeforeDrop event property}
begin
  fHelper.fOnBeforeDrop := Value;
end;

procedure TPJDropFiles.SetOnDropFiles(const Value: TNotifyEvent);
  {Write access method for OnDropFiles event property}
begin
  fHelper.fOnDropFiles := Value;
end;

procedure TPJDropFiles.SetOptions(const Value: TPJDropFilesOptions);
  {Write access method for Options property}
begin
  fHelper.fOptions := Value;
end;

procedure TPJDropFiles.WMDropFiles(var Msg: TMessage);
  {File drop message handler - used to record info about dropped files}
begin
  // Trigger event that indicates drop is about to start
  fHelper.BeforeDrop;
  // Collect dropped files
  fHelper.FilesDropped(Msg.WParam);
  // Trigger drop files event
  fHelper.DropFiles;
  // We handled message
  Msg.Result := 0;
end;

{ TPJFormDropFiles }

constructor TPJFormDropFiles.Create(AOwner: TComponent);
  {Component constructor: ensures that owner is a form and that no more that one
  of these components is on the owner form, subclasses the form window to
  respond to WM_DROPFILES messages, sets default property value and creates
  owned helper object}
var
  Idx: Integer; // scans thru components on owner form
begin
  // Check if owner is a form
  if (AOwner = nil) or not (AOwner is TForm) then
    raise Exception.Create(sOwnerNotForm);
  // Ensure that component is unique
  for Idx := 0 to Pred(AOwner.ComponentCount) do
    if AOwner.Components[Idx] is TPJFormDropFiles then
      raise Exception.CreateFmt(sOnlyOneAllowed,
        [AOwner.Components[Idx].Name, AOwner.Name]);
  inherited Create(AOwner);
  // Get ID of custom PJ_DROPFILES message
  fPJDropFilesMsg := RegisterPJDropFilesMsg;
  // Set default property values
  fEnabled := True;
  // Create helper class
  fHelper := TPJFormDropFilesHelper.Create(Self);
  // Subclass the form (run time only)
  if not (csDesigning in ComponentState) then
  begin
    // install new window procedure and record previous one
    fNewWndProc := MakeObjectInstance(NewWndProc);
    fOldWndProc := Pointer(SetWindowLong(
      FormHandle,
      GWL_WNDPROC,
      Integer(fNewWndProc)));
    // if enabled, notify that we can accept files
    fHelper.AcceptFiles(Enabled);
  end
  else
  begin
    fNewWndProc := nil;
    fOldWndProc := nil;
  end;
end;

destructor TPJFormDropFiles.Destroy;
  {Component destructor: restores original window procedure and then frees owned
  objects}
begin
  // Restore original window procedure (if sub-classed)
  if Assigned(fNewWndProc) then
  begin
    fHelper.AcceptFiles(False);
    if FormHandle <> 0 then
      SetWindowLong(FormHandle, GWL_WNDPROC, Integer(fOldWndProc));
    FreeObjectInstance(fNewWndProc);
  end;
  // Free owned objects
  fHelper.Free;
  inherited Destroy;
end;

function TPJFormDropFiles.FormHandle: THandle;
  {Returns window handle of owner form, or 0 if there is no owner}
begin
  if Assigned(Owner) and (Owner is TForm) then
    Result := (Owner as TForm).Handle
  else
    Result := 0;
end;

function TPJFormDropFiles.GetCount: Integer;
  {Read access method for Count property}
begin
  Result := fHelper.fFileList.Count;
end;

function TPJFormDropFiles.GetDropControl: TControl;
  {Read access method for DropControl property - returns child control of owner
  form which was under mouse when files were dropped, or nil if if no child
  control was under mouse}
begin
  Result := fHelper.GetDropControl;
end;

function TPJFormDropFiles.GetDropPoint: TPoint;
  {Read access method for DropPoint property}
begin
  Result := fHelper.fDropPoint;
end;

function TPJFormDropFiles.GetFile(Idx: Integer): string;
  {Read access method for Files property}
begin
  Result := fHelper.fFileList[Idx];
end;

function TPJFormDropFiles.GetFileName: string;
  {Read access method for FileName property: returns name of first file dropped,
  if any, otherwise returns empty string}
begin
  if Count > 0 then
    Result := GetFile(0)
  else
    Result := '';
end;

function TPJFormDropFiles.GetForegroundOnDrop: Boolean;
  {Read access method for ForegroundOnDrop property}
begin
  Result := fHelper.fForegroundOnDrop;
end;

function TPJFormDropFiles.GetIsFolder(Idx: Integer): Boolean;
  {Read access method for IsFolder property}
begin
  Result := Boolean(fHelper.fFileList.Objects[Idx])
end;

function TPJFormDropFiles.GetOnBeforeDrop: TNotifyEvent;
  {Read access method for OnBeforeDrop event property}
begin
  Result := fHelper.fOnBeforeDrop;
end;

function TPJFormDropFiles.GetOnDropFiles: TNotifyEvent;
  {Read access method for OnDropFiles event property}
begin
  Result := fHelper.fOnDropFiles;
end;

function TPJFormDropFiles.GetOptions: TPJDropFilesOptions;
  {Read access method for Options property}
begin
  Result := fHelper.fOptions;
end;

procedure TPJFormDropFiles.NewWndProc(var Msg: TMessage);
  {Window procedure used to sub-class owning form's window procedure to enable
  drop-file events to be handled}
begin
  // Handle messages
  if (Msg.Msg = WM_DROPFILES) or (Msg.Msg = fPJDropFilesMsg) then
  begin
    try
      // We only handle WM_DROPFILES and PJ_DROPFILES messages
      // check if control enabled
      if fEnabled then
      begin
        // trigger OnBeforeDrop event
        fHelper.BeforeDrop;
        // collect dropped files
        fHelper.FilesDropped(Msg.WParam);
        if Msg.Msg = fPJDropFilesMsg then
          // msg passed thru: change drop point to be relative to this window
          fHelper.fDropPoint := SmallPointToPoint(TSmallPoint(Msg.LParam));
        // trigger OnDropFiles event
        fHelper.DropFiles;
      end;
      // we handled message
      if Msg.Msg = fPJDropFilesMsg then
        Msg.Result := 1
      else
        Msg.Result := 0;
    except
      // Get application to handle exceptions: they cause app to halt otherwise
      on E: Exception do
        Application.HandleException(E);
    end;
  end
  else
    // All other messages are handled by original window proc for form
    Msg.Result := CallWindowProc(fOldWndProc, FormHandle, Msg.Msg,
      Msg.WParam, Msg.LParam);
end;

procedure TPJFormDropFiles.SetEnabled(const Value: Boolean);
  {Write access method for Enabled property: sets value and whether accepts
  dragged files}
begin
  if fEnabled <> Value then
  begin
    fEnabled := Value;
    fHelper.AcceptFiles(Value);
  end;
end;

procedure TPJFormDropFiles.SetForegroundOnDrop(const Value: Boolean);
  {Write access method for ForegroundOnDrop property}
begin
  fHelper.fForegroundOnDrop := Value;
end;

procedure TPJFormDropFiles.SetOnBeforeDrop(const Value: TNotifyEvent);
  {Write access method for OnBeforeDrop event property}
begin
  fHelper.fOnBeforeDrop := Value;
end;

procedure TPJFormDropFiles.SetOnDropFiles(const Value: TNotifyEvent);
  {Write access method for OnDropFiles event property}
begin
  fHelper.fOnDropFiles := Value;
end;

procedure TPJFormDropFiles.SetOptions(const Value: TPJDropFilesOptions);
  {Write access method for Options property}
begin
  fHelper.fOptions := Value;
end;

{ TPJAbstractDropFilesHelper }

procedure TPJAbstractDropFilesHelper.AcceptFiles(Flag: Boolean);
  {Calls DragAcceptFiles with given value, if not designing and if related
  window handle exists}
var
  Handle: THandle;  // window handle that receives drag drop messages
begin
  Handle := GetHWnd;
  if not (csDesigning in fComp.ComponentState) and (Handle <> 0) then
    DragAcceptFiles(Handle, Flag);
end;

procedure TPJAbstractDropFilesHelper.BeforeDrop;
  {Called before dropped files are processed. Triggers OnBeforeDrop event}
begin
  if Assigned(fOnBeforeDrop) then
    fOnBeforeDrop(fComp);
end;

constructor TPJAbstractDropFilesHelper.Create(Comp: TComponent);
  {Class constructor: records reference to related component and helper object}
begin
  inherited Create;
  fComp := Comp;
  fFileList := TStringList.Create;
  fOptions := [dfoIncFolders, dfoIncFiles];
end;

destructor TPJAbstractDropFilesHelper.Destroy;
  {Class destructor: frees helper object}
begin
  fFileList.Clear;
  inherited Destroy;
end;

procedure TPJAbstractDropFilesHelper.DropFiles;
  {Called after dropped files are processed and drop handle has been freed.
  Triggers OnDropFiles event and brings drop target to front if required}
begin
  // Bring window to foreground if required
  if fForegroundOnDrop then
    SetForegroundWindow(GetHWnd);
  // Trigger OnDropFiles event
  if Assigned(fOnDropFiles) then
    fOnDropFiles(fComp);
end;

procedure TPJAbstractDropFilesHelper.FilesDropped(hDrop: THandle);
  {Uses drop handle to get list of dropped files and to set drop point. Triggers
  OnAfterDrop event before drop handle is destroyed}
var
  FileName: string; // name of a dropped file
  NameLen: Word;    // length of buffer required for name of dropped file
  NumDropped: Word; // number of files dropped
  Idx: Integer;     // loops through all dropped files
begin
  try
    // Clear file list
    fFileList.Clear;
    // Find number of files dropped
    NumDropped := DragQueryFile(hDrop, Cardinal(-1), nil, 0);
    for Idx := 0 to Pred(NumDropped) do
    begin
      // Find size required for filename buffer (without terminal #0)
      NameLen := DragQueryFile(hDrop, Idx, nil, 0);
      // Get name of dropped file
      SetLength(FileName, NameLen);   // Delphi adds space for terminal #0
      DragQueryFile(hDrop, Idx, PChar(FileName), NameLen + 1);
      // Process name of dropped file: add to list or optionally recurse if
      // folder
      HandleFile(FileName);
    end;
    // Find co-ordinates where files dropped
    DragQueryPoint(hDrop, fDropPoint);
    // Perform any additional special processing before drop handle destroyed
    if Assigned(fOnAfterDrop) then
      fOnAfterDrop(hDrop);
  finally
    // Release handle assoc. with drag/drop
    DragFinish(hDrop);
  end;
end;

function TPJAbstractDropFilesHelper.GetDropControl: TControl;
  {Returns reference to control at position where cursor was released, or nil if
  no control under drop point}
var
  Idx: Integer;           // loop control for scanning thru all child controls
  Container: TWinControl; // reference to control that contains child controls
begin
  // Set default nil (not found) result
  Result := nil;
  // Get reference to container holding child controls
  Container := GetContainer;
  // Iterate across all child controls looking for one under mouse
  for Idx := 0 to Container.ControlCount - 1 do
  begin
    if PtInRect(Container.Controls[Idx].BoundsRect,
      Point(fDropPoint.X, fDropPoint.Y)) then
    begin
      Result := Container.Controls[Idx];
      Break;
    end;
  end;
end;

function TPJAbstractDropFilesHelper.GetHWnd: THandle;
  {Returns window handle that related control receives messages from. This is
  window handle of container returned by GetContainer method}
var
  Ctrl: TWinControl;  // Control that related component works with
begin
  // Get related control
  Ctrl := GetContainer;
  // Now return any handle
  if Assigned(Ctrl) then
    Result := Ctrl.Handle
  else
    Result := 0;
end;

procedure TPJAbstractDropFilesHelper.HandleFile(const FileName: string);
  {Processes the given file and updates file list according to RecurseFolders
  and ExcludeFolders properties. If ExcludeFolders is true then any folder names
  encoutnered are exlcuded from file list. If RecurseFolders is true then any
  folders and examined and the files in the folder are added to list (taking
  note of ExcludeFolders). Any subfolders are also searched recursively}

  // ---------------------------------------------------------------------------
  function MakePath(FolderName: string): string;
    {Esnures the given folder name ends with a '\'}
  begin
    Result := FolderName;
    if (Length(Result) > 0) and (Result[Length(Result)] <> '\') then
      Result := Result + '\';
  end;

  function IsFolder(const FileName: string): Boolean;
    {Returns true if given file name is a folder and false if not}
  begin
    Result := SysUtils.FileGetAttr(FileName) and faDirectory = faDirectory;
  end;

  procedure UpdateList(const FileName: string; FileIsFolder: Boolean);
    {Updates file list with given file name. Name is added to list if it is
    required by Options property}
  begin
    if FileIsFolder then
    begin
      // this is folder: only record if folders are included
      if dfoIncFolders in fOptions then
        fFileList.AddObject(FileName, Pointer(True));
    end
    else
    begin
      // this is file: only record if files are included
      if dfoIncFiles in fOptions then
        fFileList.AddObject(FileName, Pointer(False));
    end;
  end;
  // ---------------------------------------------------------------------------

var
  Path: string;     // folder name as a path
  SR: TSearchRec;   // record used by file search functions
  Res: Integer;     // result of file search functions (0 on success)
begin
  // Decide whether we need to examine files in a folder
  if IsFolder(FileName) then
  begin
    // We have a folder: add to list if we're including folders
    UpdateList(FileName, True);
    if (dfoRecurseFolders in fOptions) then
    begin
      // We have a folder and we want to recurse it
      // ensure folder name is a valid '\' terminated path
      Path := MakePath(FileName);
      // find all files in folder and recursively process each one found
      // (providing it is not a '.' or '..' special folder)
      Res := SysUtils.FindFirst(Path  + '*.*', faAnyFile, SR);
      try
        while Res = 0 do
        begin
          if (SR.Name <> '.') and (SR.Name <> '..') then
            HandleFile(Path + SR.Name);
          Res := SysUtils.FindNext(SR);
        end;
      finally
        SysUtils.FindClose(SR);
      end;
    end;
  end
  else
    // Not a folder - this is simple file: add to list if we're including files
    UpdateList(FileName, False);
end;

{ TPJDropFilesHelper }

function TPJDropFilesHelper.GetContainer: TWinControl;
  {Returns return reference to the component's related windowed control: this is
  the control itself in this class}
begin
  Result := fComp as TWinControl;
end;

{ TPJFormDropFilesHelper }

function TPJFormDropFilesHelper.GetContainer: TWinControl;
  {Returns return reference to the component's related windowed control: this is
  the form on which owns the component}
var
  Owner: TComponent;  // owning control (a form)
begin
  // Get reference to component's owner
  Owner := (fComp as TPJFormDropFiles).Owner;
  // Return reference to owner or nil if no owner
  if Owner is TWinControl then
    Result := Owner as TWinControl
  else
    Result := nil;
end;

end.
