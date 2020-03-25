type 
  BOOL = LongBool;
  TSVGAINFO = record
    ModeAttributes      : Smallint;
    WinAAttributes      : Byte;
    WinBAttributes      : Byte;
    WinGranularity      : Smallint;
    WinSize             : Smallint;
    WinASegment         : Smallint;
    WinBSegment         : Smallint;
    WinFuncPtr          : Longword;
    BytesPerScanLine    : Smallint;
  {---------------------- rest is optional info (since Version 1.2) }
    XResolution         : Smallint;
    YResolution         : Smallint;
    XCharSize           : Byte ;
    YCharSize           : Byte ;
    NumberOfPlanes      : Byte;
    BitsPerPixel        : Byte;
    NumberOfBanks       : Byte;
    MemoryModel         : Byte;
    BankSize            : Byte;
    NumberOfImagePages  : Byte;
    Reserved            : Byte;
    RedMaskSize         : Byte;
    RedFieldPosition    : Byte;
    GreenMaskSize       : Byte;
    GreenFieldPosition  : Byte;
    BlueMaskSize        : Byte;
    BlueFieldPosition   : Byte;
    RsvdMaskSize        : Byte;
    RsvdFieldPosition   : Byte;
    DirectColorModeInfo : Byte;
  {--------------------- since Version 2.0 }
    PhysBasePtr         : Longword;
    OffScreenMemOffset  : Longword;
    OffScreenMemSize    : Smallint;
    Reserved2           : array[0..205] of Byte;
  end;

