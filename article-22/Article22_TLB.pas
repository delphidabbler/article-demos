unit Article22_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : 1.2
// File generated on 11/02/2006 10:35:45 from Type Library described below.

// ************************************************************************  //
// Type Lib: E:\Prg\Rel\Demos\Article-22\Article22.tlb (1)
// LIBID: {517F7078-5E73-4E5A-B8A2-8F0FF14EF21B}
// LCID: 0
// Helpfile: 
// HelpString: Article22 Library
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  Article22MajorVersion = 1;
  Article22MinorVersion = 0;

  LIBID_Article22: TGUID = '{517F7078-5E73-4E5A-B8A2-8F0FF14EF21B}';

  IID_IMyExternal: TGUID = '{4F995D09-CF9E-4042-993E-C71A8AED661E}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IMyExternal = interface;
  IMyExternalDisp = dispinterface;

// *********************************************************************//
// Interface: IMyExternal
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {4F995D09-CF9E-4042-993E-C71A8AED661E}
// *********************************************************************//
  IMyExternal = interface(IDispatch)
    ['{4F995D09-CF9E-4042-993E-C71A8AED661E}']
    function GetPrecis(const ProgID: WideString): WideString; safecall;
    procedure ShowURL(const ProgID: WideString); safecall;
    procedure HideURL; safecall;
  end;

// *********************************************************************//
// DispIntf:  IMyExternalDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {4F995D09-CF9E-4042-993E-C71A8AED661E}
// *********************************************************************//
  IMyExternalDisp = dispinterface
    ['{4F995D09-CF9E-4042-993E-C71A8AED661E}']
    function GetPrecis(const ProgID: WideString): WideString; dispid 201;
    procedure ShowURL(const ProgID: WideString); dispid 202;
    procedure HideURL; dispid 203;
  end;

implementation

uses ComObj;

end.
