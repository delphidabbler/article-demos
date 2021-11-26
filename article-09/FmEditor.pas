unit FmEditor;

interface

uses
  Forms, StdCtrls, ComCtrls, Classes, Controls, Windows, Messages;

const
  // WM_CLIPBOARDUPDATE is not defined in the Messages unit of all supported
  // versions of Delphi, so we defined it here for safety.
  WM_CLIPBOARDUPDATE  = $031D;

type
  TEditorForm = class(TForm)
    btnCut: TButton;
    btnCopy: TButton;
    btnPaste: TButton;
    RichEdit1: TRichEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure RichEdit1SelectionChange(Sender: TObject);
    procedure btnCutClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure btnPasteClick(Sender: TObject);
  private
    // Flag indicating if the new style clipboard format listener API is
    // available on the current OS.
    fUseNewAPI: Boolean;
    // Handle of next clipboard viewer handle in chain. Used only when old
    // clipboard viewer API is in use, i.e. when fUseNewAPI is False.
    fNextCBViewWnd: HWND;
    // References to AddClipboardFormatListener and
    // RemoveClipboardFormatListenerAPI functions. These references are nil if
    // the functions are not supported by the OS, i.e. if fUseNewAPI is False.
    fAddClipboardFormatListener: function(hwnd: HWND): BOOL; stdcall;
    fRemoveClipboardFormatListener: function(hwnd: HWND): BOOL; stdcall;
    // References to SetClipboardViewer and ChangeClipboardChain API functions.
    // These references is are if the newer clipboard format listener API is
    // available, i.e. if fUseNewAPI is True.
    fSetClipboardViewer: function (hWndNewViewer: HWND): HWND; stdcall;
    fChangeClipboardChain: function(hWndRemove, hWndNewNext: HWND): BOOL;
      stdcall;
    // Message handlers
    procedure WMClipboardUpdate(var Msg: TMessage); message WM_CLIPBOARDUPDATE;
    procedure WMChangeCBChain(var Msg: TMessage); message WM_CHANGECBCHAIN;
    procedure WMDrawClipboard(var Msg: TMessage); message WM_DRAWCLIPBOARD;
  end;

var
  EditorForm: TEditorForm;

implementation

uses
  SysUtils, Clipbrd;

{$R *.dfm}

procedure TEditorForm.btnCopyClick(Sender: TObject);
begin
  RichEdit1.CopyToClipboard;
end;

procedure TEditorForm.btnCutClick(Sender: TObject);
begin
  RichEdit1.CutToClipboard;
end;

procedure TEditorForm.btnPasteClick(Sender: TObject);
begin
  RichEdit1.PasteFromClipboard;
end;

procedure TEditorForm.FormCreate(Sender: TObject);
const
  cUserKernelLib = 'user32.dll';
begin
  // Enable / disable buttons at start-up
  btnPaste.Enabled := Clipboard.HasFormat(CF_TEXT);
  btnCut.Enabled := RichEdit1.SelLength > 0;
  btnCopy.Enabled := btnCut.Enabled;
  // Load required API functions: 1st try to load modern clipboard listener API
  // functions. If that fails try to load old-style clipboard viewer API
  // functions. This should never fail, but we raise an exception if the
  // impossible happens!
  fAddClipboardFormatListener := GetProcAddress(
    GetModuleHandle(cUserKernelLib), 'AddClipboardFormatListener'
  );
  fRemoveClipboardFormatListener := GetProcAddress(
    GetModuleHandle(cUserKernelLib), 'RemoveClipboardFormatListener'
  );
  fUseNewAPI := Assigned(fAddClipboardFormatListener)
    and Assigned(fRemoveClipboardFormatListener);
  if not fUseNewAPI then
  begin
    fSetClipboardViewer := GetProcAddress(
      GetModuleHandle(cUserKernelLib), 'SetClipboardViewer'
    );
    fChangeClipboardChain := GetProcAddress(
      GetModuleHandle(cUserKernelLib), 'ChangeClipboardChain'
    );
    Assert(Assigned(fSetClipboardViewer) and Assigned(fChangeClipboardChain));
  end;
  if fUseNewAPI then
  begin
    // Register window as clipboard listener
    if not fAddClipboardFormatListener(Self.Handle) then
      RaiseLastOSError; // On early Delphis use RaiseLastWin32Error instead
  end
  else
  begin
    // Register window as clipboard viewer, storing handle of next window in
    // chain
    fNextCBViewWnd := fSetClipboardViewer(Self.Handle);
  end;
end;

procedure TEditorForm.FormDestroy(Sender: TObject);
begin
  // Remove clipboard listener or viewer
  if fUseNewAPI then
    fRemoveClipboardFormatListener(Self.Handle)
  else
    fChangeClipboardChain(Self.Handle, fNextCBViewWnd);
end;

procedure TEditorForm.RichEdit1SelectionChange(Sender: TObject);
begin
  btnCut.Enabled := RichEdit1.SelLength > 0;
  btnCopy.Enabled := btnCut.Enabled;
end;

procedure TEditorForm.WMChangeCBChain(var Msg: TMessage);
begin
  Assert(not fUseNewAPI);
  // Windows is detaching a clipboard viewer
  if HWND(Msg.WParam) = fNextCBViewWnd then
    // window being detached is next one: record new "next" window
    fNextCBViewWnd := HWND(Msg.LParam)
  else if fNextCBViewWnd <> 0 then
    // window being detached is not next: pass message along
    SendMessage(fNextCBViewWnd, Msg.Msg, Msg.WParam, Msg.LParam);
end;

procedure TEditorForm.WMClipboardUpdate(var Msg: TMessage);
begin
  // Clipboard content changed: enable paste button if text is on clipboard
  btnPaste.Enabled := Clipboard.HasFormat(CF_TEXT);
end;

procedure TEditorForm.WMDrawClipboard(var Msg: TMessage);
begin
  Assert(not fUseNewAPI);
  // Clipboard content changed
  // enable paste button if text on clipboard
  btnPaste.Enabled := Clipboard.HasFormat(CF_TEXT);
  // pass on message to any next window in viewer chain
  if fNextCBViewWnd <> 0 then
    SendMessage(fNextCBViewWnd, Msg.Msg, Msg.WParam, Msg.LParam);
end;

end.
