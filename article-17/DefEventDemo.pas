{
  This code accompanies the article "How to set a component's default event
  handler" at http://www.delphidabbler.com/articles.php?article=17.

  The code is copyright (c) 2004, PD Johnson, www.delphidabbler.com.

  See the ReadMe.html file that accompanies this download for details of how to
  use this code.
}

{$A8,B-,C+,D-,E-,F-,G+,H+,I+,J+,K-,L-,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y-,Z1}


unit DefEventDemo;

interface

uses
  Classes, DesignIntf, DesignEditors;

type
  TCompA = class(TComponent)
  private
    fOnFoo: TNotifyEvent;
    fOnBar: TNotifyEvent;
    fOnClick: TNotifyEvent;
    fOnChange: TNotifyEvent;
    fOnChanged: TNotifyEvent;
    fOnCreate: TNotifyEvent;
  published
    property OnFoo: TNotifyEvent read fOnFoo write fOnFoo;
    property OnBar: TNotifyEvent read fOnBar write fOnBar;
    property OnChange: TNotifyEvent read fOnChange write fOnChange;
    property OnChanged: TNotifyEvent read fOnChanged write fOnChanged;
    property OnClick: TNotifyEvent read fOnClick write fOnClick;
    property OnCreate: TNotifyEvent read fOnCreate write fOnCreate;
  end;

  TCompB = class(TComponent)
  private
    fOnFoo: TNotifyEvent;
    fOnBar: TNotifyEvent;
    fOnClick: TNotifyEvent;
  published
    property OnFoo: TNotifyEvent read fOnFoo write fOnFoo;
    property OnBar: TNotifyEvent read fOnBar write fOnBar;
    property OnClick: TNotifyEvent read fOnClick write fOnClick;
  end;

  TCompC = class(TComponent)
  private
    fOnFoo: TNotifyEvent;
    fOnBar: TNotifyEvent;
  published
    property OnFoo: TNotifyEvent read fOnFoo write fOnFoo;
    property OnBar: TNotifyEvent read fOnBar write fOnBar;
  end;

  TMyCompEditor = class(TDefaultEditor)
  protected
    procedure EditProperty(const PropertyEditor: IProperty;
      var Continue: Boolean); override;
  end;

  TCompEditorBase = class(TDefaultEditor)
  protected
    function DefaultEventName: string; virtual; abstract;
      { returns the name of the default event }
    procedure EditProperty(const PropertyEditor: IProperty;
      var Continue: Boolean); override;
      { records the property editor of the default event }
  end;

  TCompEditor = class(TCompEditorBase)
  protected
    function DefaultEventName: string; override;
  end;

procedure Register;

implementation

uses
  SysUtils;

procedure Register;
begin
  // This registers the components
  RegisterComponents('DelphiDabbler', [TCompA, TCompB, TCompC]);
  // These register the component editors
  // un-comment as required
//  RegisterComponentEditor(TCompA, TMyCompEditor);
//  RegisterComponentEditor(TCompB, TCompEditor);
//  RegisterComponentEditor(TCompC, TCompEditor);
end;

{ TMyCompEditor }

procedure TMyCompEditor.EditProperty(const PropertyEditor: IProperty;
  var Continue: Boolean);
begin
  // only call inherited method if required event name
  if CompareText(PropertyEditor.GetName, 'OnFoo') = 0 then
    inherited;
end;

{ TCompEditorBase }

procedure TCompEditorBase.EditProperty(const PropertyEditor: IProperty;
  var Continue: Boolean);
begin
  if CompareText(PropertyEditor.GetName, DefaultEventName) = 0 then
    inherited;
end;

{ TCompEditor }

function TCompEditor.DefaultEventName: string;
begin
   Result := 'OnFoo';
end;

end.
