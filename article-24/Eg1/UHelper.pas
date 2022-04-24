{
  This demo application accompanies the article
  "How to receive data dragged from other applications" at
  http://www.delphidabbler.com/articles?article=24.

  This unit defines some utility functions used by example program 1.

  This code is copyright (c) P D Johnson (www.delphidabbler.com), 2006.

  v1.0 of 2006/12/10 - original version
}


{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}


unit UHelper;

interface

uses
  ActiveX;

function CBFormatDesc(const Fmt: TClipFormat): string;

function TymedDesc(const Tymed: Integer): string;

function AspectDesc(const Aspect: Integer): string;

implementation

uses
  Windows;

type
  TCodeDescMap = record
    Code: Integer;
    Desc: string;
  end;

function CodeToDesc(const Code: Integer;
  const Map: array of TCodeDescMap): string;
var
  Idx: Integer;
begin
  Result := '';
  for Idx := Low(Map) to High(Map) do
  begin
    if Map[Idx].Code = Code then
    begin
      Result := Map[Idx].Desc;
      Break;
    end;
  end;
end;

function CBFormatDesc(const Fmt: TClipFormat): string;
const
  cStdFmts: array[0..20] of TCodeDescMap = (
    (Code: CF_LOCALE; Desc: 'CF_LOCALE'),
    (Code: CF_UNICODETEXT; Desc: 'CF_UNICODETEXT'),
    (Code: CF_ENHMETAFILE; Desc: 'CF_ENHMETAFILE'),
    (Code: CF_HDROP; Desc: 'CF_HDROP'),
    (Code: CF_OWNERDISPLAY; Desc: 'CF_OWNERDISPLAY'),
    (Code: CF_BITMAP; Desc: 'CF_BITMAP'),
    (Code: CF_DIB; Desc: 'CF_DIB'),
    (Code: CF_DIF; Desc: 'CF_DIF'),
    (Code: CF_DSPBITMAP; Desc: 'CF_DSPBITMAP'),
    (Code: CF_DSPMETAFILEPICT; Desc: 'CF_DSPMETAFILEPICT'),
    (Code: CF_DSPTEXT; Desc: 'CF_DSPMETAFILEPICT'),
    (Code: CF_METAFILEPICT; Desc: 'CF_DSPMETAFILEPICT'),
    (Code: CF_OEMTEXT; Desc: 'CF_OEMTEXT'),
    (Code: CF_OWNERDISPLAY; Desc: 'CF_OWNERDISPLAY'),
    (Code: CF_PALETTE; Desc: 'CF_PALETTE'),
    (Code: CF_PENDATA; Desc: 'CF_PENDATA'),
    (Code: CF_RIFF; Desc: 'CF_RIFF'),
    (Code: CF_SYLK; Desc: 'CF_SYLK'),
    (Code: CF_TEXT; Desc: 'CF_TEXT'),
    (Code: CF_TIFF; Desc: 'CF_TIFF'),
    (Code: CF_WAVE; Desc: 'CF_WAVE')
  );
var
  Buffer: array[0..255] of Char;
begin
  Result := CodeToDesc(Fmt, cStdFmts);
  if Result = '' then
  begin
    // Not a standard format - we assume it's a registered format - get name
    // from Windows API call (this call doesn't work for standard formats)
    if GetClipBoardFormatName(Fmt, Buffer, 255) > 0 then
      // Got a name - record it
      Result := Buffer;
  end;
end;

function TymedDesc(const Tymed: Integer): string;
const
  cTymeds: array[0..7] of TCodeDescMap = (
    (Code: TYMED_HGLOBAL; Desc: 'TYMED_HGLOBAL'),
    (Code: TYMED_FILE; Desc: 'TYMED_FILE'),
    (Code: TYMED_ISTREAM; Desc: 'TYMED_ISTREAM'),
    (Code: TYMED_ISTORAGE; Desc: 'TYMED_ISTORAGE'),
    (Code: TYMED_GDI; Desc: 'TYMED_GDI'),
    (Code: TYMED_MFPICT; Desc: 'TYMED_MFPICT'),
    (Code: TYMED_ENHMF; Desc: 'TYMED_ENHMF'),
    (Code: TYMED_NULL; Desc: 'TYMED_NULL')
  );
begin
  Result := CodeToDesc(Tymed, cTymeds);
end;

function AspectDesc(const Aspect: Integer): string;
const
  cAspects: array[0..3] of TCodeDescMap = (
    (Code: DVASPECT_CONTENT; Desc: 'DVASPECT_CONTENT'),
    (Code: DVASPECT_THUMBNAIL; Desc: 'DVASPECT_THUMBNAIL'),
    (Code: DVASPECT_ICON; Desc: 'DVASPECT_ICON'),
    (Code: DVASPECT_DOCPRINT; Desc: 'DVASPECT_DOCPRINT')
  );
begin
  Result := CodeToDesc(Aspect, cAspects);
end;

end.
