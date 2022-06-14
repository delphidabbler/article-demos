{
  Unit declares types used in reading version information.
}

unit UVerInfoTypes;

interface

type

  {
  TTransRec:
    Translation record: stores language code and character set (code page).
  }
  TTransRec = packed record
  Lang,             // language code
  CharSet: Word;    // character set (code page)
  end;

  {
  PTransRec:
    Pointer to translation record.
  }
  PTransRec = ^TTransRec;

  {
  TTransRecArray:
    Dynamic array of translation records: the translation table.
  }
  TTransRecArray = array of TTransRec;

implementation

end.
