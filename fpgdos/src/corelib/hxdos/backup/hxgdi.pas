
{
  UNIT  hxgdi    Pascal interface to HXDOS from Japeth

}

unit hxgdi;

{$mode objfpc}{$H+}{$define HX_DOS}

interface

uses
  Classes, SysUtils, qtwinapi;

const
  gdidll = {$ifdef link_dynamic}'c:\Users\Konta\mseide\lib\msedos\hxdos\dgdi32.dll'{$else}'c:\lazarus\fpgui-1.4.1\src\lib\i386go32\DGDI32S.LIB'{$endif};

type
  TGCPResultsW = TGCPResults;
  tagFontEnumProc = function(
    var lpelf: EnumLogfontEx;
    var lpntm: NEWTEXTMETRICEX;
    FontType: Integer;
    lparm: LPARAM
  ): Integer; stdcall;
  FONTENUMPROCA = tagFontEnumProc;

type
  EnumFontsProc = function(
    {_In_} const lplf   : PLOGFONT;
    {_In_} const lptm   : PTEXTMETRIC;
    {_In_}       dwType : DWORD;
    {_In_}       lpData : LPARAM
  ): Integer;


{$I osdefs.inc}

function Arc(dc: HDC; x1,y1,x2,y2,x3,y3,x4,y4: Integer): BOOL;

function BitBlt(DestDC: HDC; X, Y, Width, Height: Integer; SrcDC: HDC; XSrc, YSrc: Integer; Rop: DWORD): Boolean;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'BitBlt';
{$endif}

function CombineRgn(hrgnDst,hrgnSrc1,hrgnSrc2: HRGN; imode: Integer): Integer;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'CombineRgn';
{$endif}

function CreateBitmap(Width, Height: Integer; Planes, BitCount: Longint; BitmapBits: Pointer): HBITMAP;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'CreateBitmap';
{$endif}

function CreateCompatibleBitmap(DC: HDC; Width, Height: Integer): HBITMAP;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'CreateCompatibleBitmap';
{$endif}

function CreateCompatibleDC(DC: HDC): HDC;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'CreateCompatibleDC';
{$endif}

function CreateDIBSection(
  dc: HDC;
  pbmi: BITMAPINFO;
  usage: UINT;
  ppvbits: Pointer;
  hSection: HANDLE;
  offset: DWORD
  ): HBITMAP;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'CreateDIBSection';
{$endif}

function CreateFontA(
  cHeight        : integer;
  cWidth         : integer;
  cEscapement    : integer;
  cOrientation   : integer;
  cWeight        : integer;
  bItalic        : DWORD;
  bUnderline     : DWORD;
  bStrikeOut     : DWORD;
  iCharSet       : DWORD;
  iOutPrecision  : DWORD;
  iClipPrecision : DWORD;
  iQuality       : DWORD;
  iPitchAndFamily: DWORD;
  pszFaceName    : LPCSTR
): HFONT;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'CreateFontA';
{$endif}

function CreateFontW(
  cHeight        : integer;
  cWidth         : integer;
  cEscapement    : integer;
  cOrientation   : integer;
  cWeight        : integer;
  bItalic        : DWORD;
  bUnderline     : DWORD;
  bStrikeOut     : DWORD;
  iCharSet       : DWORD;
  iOutPrecision  : DWORD;
  iClipPrecision : DWORD;
  iQuality       : DWORD;
  iPitchAndFamily: DWORD;
  pszFaceName    : LPCWSTR
): HFONT;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'CreateFontW';
{$endif}

function CreateFontIndirectA(lplf: PLOGFONTA): HFONT;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'CreateFontIndirectA';
{$endif}

function CreateFontIndirectW(lplf: PLOGFONTW): HFONT;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'CreateFontIndirectW';
{$endif}

function CreatePalette(pal: LOGPALETTE): HPALETTE;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'CreatePalette';
{$endif}

function CreateSolidBrush(Color: COLORREF): HBRUSH;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'CreateSolidBrush';
{$endif}

function CreatePatternBrush(hbm: HBITMAP): HBRUSH;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'CreatePatternBrush';
{$endif}

function CreatePen(iStyle,cWidth: Integer; color: COLORREF): HPEN;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'CreatePen';
{$endif}

function CreateRectRgn(x1,y1,x2,y2: Integer): HRGN;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'CreateRectRgn';
{$endif}

function CreateRectRgnIndirect(rect: LPRECT): HRGN;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'CreateRectRgnIndirect';
{$endif}

function DeleteDC(hDC: HDC): Boolean;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'DeleteDC';
{$endif}

function DeleteObject(GDIObject: HGDIOBJ): Boolean;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'DeleteObject';
{$endif}

function EnumFontFamilies(
  dc        : HDC;
  lpLogfont : LPCSTR;
  lpProc    : FONTENUMPROCA;
  lParam    : LPARAM
  ): Integer;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'EnumFontFamiliesA';
{$endif}

function EnumFontFamiliesA(
  dc        : HDC;
  lpLogfont : LPCSTR;
  lpProc    : FONTENUMPROCA;
  lParam    : LPARAM
  ): Integer;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'EnumFontFamiliesA';
{$endif}

function EnumFontFamiliesEx(
    dc        : HDC;
    lpLogfont : LPLOGFONTA;
    lpProc    : FONTENUMPROCA;
    lParam    : LPARAM;
    dwFlags   : DWORD
  ): Integer;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'EnumFontFamiliesExA';
{$endif}

function EnumFontFamiliesExA(
    dc        : HDC;
    lpLogfont : LPLOGFONTA;
    lpProc    : FONTENUMPROCA;
    lParam    : LPARAM;
    dwFlags   : DWORD
  ): Integer;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'EnumFontFamiliesExA';
{$endif}

function ExtCreatePen(
  iPenStyle: DWORD;
  cWidth: DWORD;
  var plbrush: LOGBRUSH;
  cStyle : DWORD;
  const pstyle: DWORD_PTR
  ): HPEN;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'ExtCreatePen';
{$endif}

function ExtTextOutA(
  dc: HDC;
  x: integer;
  y: integer;
  options     : UINT;
  const lprect: PRECT;
  lpString    : LPCSTR;
  c: UINT;
  const lpDx  : INT_PTR
  ): BOOL;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'ExtTextOutA';
{$endif}

function ExtTextOutW(
  dc: HDC;
  x: integer;
  y: integer;
  options     : UINT;
  const lprect: PRECT;
  lpwString   : LPCWSTR;
  c: UINT;
  const lpDx  : INT_PTR
  ): BOOL;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'ExtTextOutW';
{$endif}

//The GdiFlush function flushes the calling thread's current batch.
function GdiFlush: BOOL;
function GetArcDirection(dc: HDC): Integer;

// nur Dummy -> wenn nötig -> selber implementieren
function GetCharacterPlacementW(DC: HDC; p2: PWideChar; p3, p4: Integer;
  var p5: TGCPResultsW; p6: DWORD): DWORD;

function GetBkColor(dc: HDC): COLORREF;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'GetBkColor';
{$endif}

function GetDeviceCaps(dc: HDC; index: Integer): Integer;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'GetDeviceCaps';
{$endif}

function GetDIBits(
  dc: HDC;
  hbm: HBITMAP;
  Start,cLines: UINT;
  lpvBits: Pointer;
  lpmi: LPBITMAPINFO;
  usage: UINT
  ): Integer;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'GetDIBits';
{$endif}

function GetObject(h: HANDLE; BufSize: Integer; Buf: Pointer): Integer;
   {$ifdef HX_DOS}
    stdcall; external gdidll name 'GetObjectA';
   {$endif}

function GetPixel(dc: HDC; x,y: Integer): COLORREF;
   {$ifdef HX_DOS}
    stdcall; external gdidll name 'GetPixel';
   {$endif}

function GetRegionData(rgn: HRGN; Count: DWORD; rgnData: LPRGNDATA): DWORD;
   {$ifdef HX_DOS}
    stdcall; external gdidll name 'GetRegionData';
   {$endif}

function GetTextColor(dc: HDC): COLORREF;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'GetTextColor';
{$endif}

function GetTextExtentPoint32A(
  dc: HDC;
  lpString: LPCSTR;
  strlen: Integer;
  var psizl: SIZE
  ): BOOL;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'GetTextExtentPoint32A';
{$endif}

function GetTextExtentPoint32W(
  dc: HDC;
  lpString: LPCWSTR;
  strlen: Integer;
  var psizl: SIZE
  ): BOOL;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'GetTextExtentPoint32W';
{$endif}

function GetTextExtentPointA(
  dc: HDC;
  lpString: LPCSTR;
  strlen: Integer;
  var psizl: SIZE
  ): BOOL;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'GetTextExtentPointA';
{$endif}

function GetTextExtentPointW(
  dc: HDC;
  lpString: LPCWSTR;
  strlen: Integer;
  var psizl: SIZE
  ): BOOL;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'GetTextExtentPointW';
{$endif}

function GetTextFaceA(dc: HDC; buflen: Integer; lpName: LPSTR): Integer;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'GetTextFaceA';
{$endif}

function GetTextFaceW(dc: HDC; buflen: Integer; lpName: LPWSTR): Integer;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'GetTextFaceW';
{$endif}

function GetTextMetrics(DC: HDC; var TM: TTextMetric): Bool;
  {$ifdef HX_DOS}
   stdcall; external gdidll name 'GetTextMetricsA';
  {$endif}

 function MaskBlt(
   dc: HDC;
   X, Y, Width, Height: Integer;
   SrcDC: HDC; XSrc, YSrc: Integer;
   hbmMask: HBITMAP;
   Xmask: Integer;
   Ymask: Integer;
   Rop: DWORD
 ): BOOL;

//Dummy oder selber implementieren
function GetROP2(dc: HDC): Integer;

function Pie(dc: HDC; Left,Top,Right,Bottom,xr1,yr1,xr2,yr2: Integer): BOOL;

function Polygon(dc: HDC; Points: PPoint; cpt: Integer): BOOL;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'Polygon';
{$endif}

function PolyLine(dc: HDC; Points: PPoint; cpt: Integer): BOOL;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'Polyline';
{$endif}

function Rectangle(DC: HDC; X1, Y1, X2, Y2: Integer): Boolean;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'Rectangle';
{$endif}

function SelectClipRgn(dc: HDC; rgn: HRGN): Integer;

function SelectObject(dc: HDC; gdi: HGDIOBJ): HGDIOBJ;
   {$ifdef HX_DOS}
    stdcall; external gdidll name 'SelectObject';
   {$endif}

function LineTo(dc: HDC; x,y: Integer): BOOL;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'LineTo';
{$endif}

function MoveToEx(dc: HDC; x,y: Integer; Oldpoint: PPoint): BOOL;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'MoveToEx';
{$endif}


function SetArcDirection(dc: HDC; dir: Integer): Integer;

function SetBkColor(dc: HDC; color: COLORREF): COLORREF;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'SetBkColor';
{$endif}

function SetBkMode(dc: HDC; mode: Integer): Integer;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'SetBkMode';
{$endif}

function SetDIBits(
  dc: HDC;
  dbm: HBITMAP;
  Start,cLines: UINT;
  lpBits: Pointer;
  lpBmi: BITMAPINFO;
  ColorUse: UINT
  ): Integer;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'SetDIBits';
{$endif}

function SetDIBitsToDevice(
     dc        : HDC;
     xDest     : integer;
     yDest     : integer;
     w         : DWORD;
     h         : DWORD;
     xSrc      : integer;
     ySrc      : integer;
     StartScan : UINT;
     cLines    : UINT;
  const lpvBits: LPVOID;
  const lpbmi  : BITMAPINFO;
     ColorUse  : UINT
  ): Integer;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'SetDIBitsToDevice';
{$endif}

function SetMapMode(dc: HDC; imode: Integer): Integer;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'SetMapMode';
{$endif}

function SetPixel(dc: HDC; x,y: Integer; Color: COLORREF): COLORREF;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'SetPixel';
{$endif}

function SetROP2(dc: HDC; rop2: Integer): Integer;

function SetTextColor(dc: HDC; Color: COLORREF): COLORREF;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'SetTextColor';
{$endif}

function SetTextAlign(dc: HDC; align: UINT): UINT;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'SetTextAlign';
{$endif}

function SetViewPortExtEx(DC: HDC; XExt,YExt: Integer; OldSize: PSize): BOOL;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'SetViewportExtEx';
{$endif}

function SetViewportOrgEx(dc: HDC; NewX,NewY: Integer; OldSize: PSize): BOOL;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'SetViewportOrgEx';
{$endif}

function SetWindowExtEx(DC: HDC; XExt,YExt: Integer; OldSize: PSize): BOOL;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'SetWindowExtEx';
{$endif}

function SetWindowOrgEx(dc: HDC; NewX,NewY: Integer; OldSize: PSize): BOOL;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'SetWindowOrgEx';
{$endif}

function TextOutA(dc: HDC; x,y: Integer; Str: LPCSTR; count: Integer): BOOL;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'TextOutA';
{$endif}

function TextOutW(dc: HDC; x,y: Integer; Str: LPCWSTR; count: Integer): BOOL;
{$ifdef HX_DOS}
 stdcall; external gdidll name 'TextOutW';
{$endif}

function TextOut(DC: HDC; X,Y : Integer; Str : Pchar; Count: Integer) : Bool;


implementation

{$ifndef HX_DOS}

function BitBlt(DestDC: HDC; X, Y, Width, Height: Integer; SrcDC: HDC; XSrc, YSrc: Integer; Rop: DWORD): Boolean;
begin

end;

function CombineRgn(hrgnDst,hrgnSrc1,hrgnSrc2: HRGN; imode: Integer): Integer;
begin

end;

function CreateBitmap(Width, Height: Integer; Planes, BitCount: Longint; BitmapBits: Pointer): HBITMAP;
begin

end;

function CreateCompatibleBitmap(DC: HDC; Width, Height: Integer): HBITMAP;
begin

end;

function CreateCompatibleDC(DC: HDC): HDC;
begin

end;

function CreateDIBSection(
  dc: HDC;
  pbmi: BITMAPINFO;
  usage: UINT;
  ppvbits: Pointer;
  hSection: HANDLE;
  offset: DWORD
  ): HBITMAP;
begin

end;

function CreateFontA(
  cHeight        : integer;
  cWidth         : integer;
  cEscapement    : integer;
  cOrientation   : integer;
  cWeight        : integer;
  bItalic        : DWORD;
  bUnderline     : DWORD;
  bStrikeOut     : DWORD;
  iCharSet       : DWORD;
  iOutPrecision  : DWORD;
  iClipPrecision : DWORD;
  iQuality       : DWORD;
  iPitchAndFamily: DWORD;
  pszFaceName    : LPCSTR
): HFONT;
begin

end;

function CreateFontW(
  cHeight        : integer;
  cWidth         : integer;
  cEscapement    : integer;
  cOrientation   : integer;
  cWeight        : integer;
  bItalic        : DWORD;
  bUnderline     : DWORD;
  bStrikeOut     : DWORD;
  iCharSet       : DWORD;
  iOutPrecision  : DWORD;
  iClipPrecision : DWORD;
  iQuality       : DWORD;
  iPitchAndFamily: DWORD;
  pszFaceName    : LPCWSTR
): HFONT;
begin

end;

function CreateFontIndirectA(lplf: PLOGFONTA): HFONT;
begin

end;

function CreateFontIndirectW(lplf: PLOGFONTW): HFONT;
begin

end;

function CreatePalette(pal: LOGPALETTE): HPALETTE;
begin

end;

function CreateSolidBrush(Color: COLORREF): HBRUSH;
begin

end;

function CreatePatternBrush(hbm: HBITMAP): HBRUSH;
begin

end;

function CreatePen(iStyle,cWidth: Integer; color: COLORREF): HPEN;
begin

end;

function CreateRectRgn(x1,y1,x2,y2: Integer): HRGN;
begin

end;

function CreateRectRgnIndirect(rect: LPRECT): HRGN;
begin

end;

function DeleteDC(hDC: HDC): Boolean;
begin

end;

function DeleteObject(GDIObject: HGDIOBJ): Boolean;
begin

end;

function EnumFontFamilies(
  dc        : HDC;
  lpLogfont : LPCSTR;
  lpProc    : FONTENUMPROCA;
  lParam    : LPARAM
  ): Integer;
begin

end;

function EnumFontFamiliesA(
  dc        : HDC;
  lpLogfont : LPCSTR;
  lpProc    : FONTENUMPROCA;
  lParam    : LPARAM
  ): Integer;
begin

end;

function EnumFontFamiliesEx(
  dc        : HDC;
  lpLogfont : LPLOGFONTA;
  lpProc    : FONTENUMPROCA;
  lParam    : LPARAM;
  dwFlags   : DWORD
  ): Integer;
begin

end;

function EnumFontFamiliesExA(
  dc        : HDC;
  lpLogfont : LPLOGFONTA;
  lpProc    : FONTENUMPROCA;
  lParam    : LPARAM;
  dwFlags   : DWORD
  ): Integer;
begin

end;

function ExtCreatePen(
  iPenStyle: DWORD;
  cWidth: DWORD;
  var plbrush: LOGBRUSH;
  cStyle : DWORD;
  const pstyle: DWORD_PTR
  ): HPEN;
begin

end;

function ExtTextOutA(
  dc: HDC;
  x: integer;
  y: integer;
  options     : UINT;
  const lprect: PRECT;
  lpString    : LPCSTR;
  c: UINT;
  const lpDx  : INT_PTR
  ): BOOL;
begin

end;

function ExtTextOutW(
  dc: HDC;
  x: integer;
  y: integer;
  options     : UINT;
  const lprect: PRECT;
  lpwString   : LPCWSTR;
  c: UINT;
  const lpDx  : INT_PTR
  ): BOOL;
begin

end;

function GetBkColor(dc: HDC): COLORREF;
begin

end;

function GetDeviceCaps(dc: HDC; index: Integer): Integer;
begin

end;

function GetDIBits(
  dc: HDC;
  hbm: HBITMAP;
  Start,cLines: UINT;
  lpvBits: Pointer;
  lpmi: LPBITMAPINFO;
  usage: UINT
  ): Integer;
begin

end;

function GetObject(h: HANDLE; BufSize: Integer; Buf: Pointer): Integer;
begin

end;

function GetPixel(dc: HDC; x,y: Integer): COLORREF;
begin

end;

function GetRegionData(rgn: HRGN; Count: DWORD; rgnData: LPRGNDATA): DWORD;
begin

end;

function GetTextColor(dc: HDC): COLORREF;
begin

end;

function GetTextExtentPoint32A(
  dc: HDC;
  lpString: LPCSTR;
  strlen: Integer;
  var psizl: SIZE
  ): BOOL;
begin

end;

function GetTextExtentPoint32W(
  dc: HDC;
  lpString: LPCWSTR;
  strlen: Integer;
  var psizl: SIZE
  ): BOOL;
begin

end;

function GetTextExtentPointA(
  dc: HDC;
  lpString: LPCSTR;
  strlen: Integer;
  var psizl: SIZE
  ): BOOL;
begin

end;

function GetTextExtentPointW(
  dc: HDC;
  lpString: LPCWSTR;
  strlen: Integer;
  var psizl: SIZE
  ): BOOL;
begin

end;

function GetTextFaceA(dc: HDC; buflen: Integer; lpName: LPSTR): Integer;
begin

end;

function GetTextFaceW(dc: HDC; buflen: Integer; lpName: LPWSTR): Integer;
begin

end;

function GetTextMetrics(DC: HDC; var TM: TTextMetric): Bool;
begin

end;

function LineTo(dc: HDC; x,y: Integer): BOOL;
begin

end;

function MoveToEx(dc: HDC; x,y: Integer; Oldpoint: PPoint): BOOL;
begin

end;

function SelectObject(dc: HDC; gdi: HGDIOBJ): HGDIOBJ;
begin

end;


function Polygon(dc: HDC; Points: PPoint; cpt: Integer): BOOL;
begin

end;

function PolyLine(dc: HDC; Points: PPoint; cpt: Integer): BOOL;
begin

end;

function Rectangle(DC: HDC; X1, Y1, X2, Y2: Integer): Boolean;
begin

end;

function SetBkColor(dc: HDC; color: COLORREF): COLORREF;
begin

end;

function SetBkMode(dc: HDC; mode: Integer): Integer;
begin

end;

function SetDIBits(
  dc: HDC;
  dbm: HBITMAP;
  Start,cLines: UINT;
  lpBits: Pointer;
  lpBmi: BITMAPINFO;
  ColorUse: UINT
  ): Integer;
begin

end;

function SetDIBitsToDevice(
     dc        : HDC;
     xDest     : integer;
     yDest     : integer;
     w         : DWORD;
     h         : DWORD;
     xSrc      : integer;
     ySrc      : integer;
     StartScan : UINT;
     cLines    : UINT;
  const lpvBits: LPVOID;
  const lpbmi  : BITMAPINFO;
     ColorUse  : UINT
  ): Integer;
begin

end;

function SetMapMode(dc: HDC; imode: Integer): Integer;
begin

end;

function SetPixel(dc: HDC; x,y: Integer; Color: COLORREF): COLORREF;
begin

end;

function SetTextAlign(dc: HDC; align: UINT): UINT;
begin

end;

function SetTextColor(dc: HDC; Color: COLORREF): COLORREF;
begin

end;

function SetViewPortExtEx(DC: HDC; XExt,YExt: Integer; OldSize: PSize): BOOL;
begin

end;

function SetViewportOrgEx(dc: HDC; NewX,NewY: Integer; OldSize: PSize): BOOL;
begin

end;

function SetWindowExtEx(DC: HDC; XExt,YExt: Integer; OldSize: PSize): BOOL;
begin

end;

function SetWindowOrgEx(dc: HDC; NewX,NewY: Integer; OldSize: PSize): BOOL;
begin

end;

function TextOutA(dc: HDC; x,y: Integer; Str: LPCSTR; count: Integer): BOOL;
begin

end;

function TextOutW(dc: HDC; x,y: Integer; Str: LPCWSTR; count: Integer): BOOL;
begin

end;

{$endif}

var
  ARC_DIRECTION: Integer = AD_COUNTERCLOCKWISE;

function Arc(dc: HDC; x1,y1,x2,y2,x3,y3,x4,y4: Integer): BOOL;
begin

end;

function GdiFlush: BOOL;
begin

end;

function GetArcDirection(dc: HDC): Integer;
begin
  Result := ARC_DIRECTION;
end;

function GetCharacterPlacementW(DC: HDC; p2: PWideChar; p3, p4: Integer;
  var p5: TGCPResultsw; p6: DWORD): DWORD;
begin

end;

function GetROP2(dc: HDC): Integer;
begin
  Result := 0;
end;

function MaskBlt(
  dc: HDC;
  X, Y, Width, Height: Integer;
  SrcDC: HDC; XSrc, YSrc: Integer;
  hbmMask: HBITMAP;
  Xmask: Integer;
  Ymask: Integer;
  Rop: DWORD
): BOOL;
begin

  Result := BitBlt(dc,X,Y,Width,Height,SrcDC,XSrc,YSrc,Rop);
end;

function Pie(dc: HDC; Left,Top,Right,Bottom,xr1,yr1,xr2,yr2: Integer): BOOL;
begin

end;

function SelectClipRgn(dc: HDC; rgn: HRGN): Integer;
begin

end;

function SetArcDirection(dc: HDC; dir: Integer): Integer;
begin
  Result := ARC_DIRECTION;
  ARC_DIRECTION := dir;
end;

function SetROP2(dc: HDC; rop2: Integer): Integer;
begin
  Result := 0;
  case rop2 of
   R2_BLACK:;
   {Pixel is always 0.}
   R2_COPYPEN:;
   {Pixel is the pen color.}
   R2_MASKNOTPEN:;
   {Pixel is a combination of the colors common to both the screen and the inverse of the pen.}
   R2_MASKPEN:;
   {Pixel is a combination of the colors common to both the pen and the screen.}
   R2_MASKPENNOT:;
   {Pixel is a combination of the colors common to both the pen and the inverse of the screen.}
   R2_MERGENOTPEN:;
   {Pixel is a combination of the screen color and the inverse of the pen color.}
   R2_MERGEPEN:;
   {Pixel is a combination of the pen color and the screen color.}
   R2_MERGEPENNOT:;
   {Pixel is a combination of the pen color and the inverse of the screen color.}
   R2_NOP:;
   {Pixel remains unchanged.}
   R2_NOT:;
   {Pixel is the inverse of the screen color.}
   R2_NOTCOPYPEN:;
   {Pixel is the inverse of the pen color.}
   R2_NOTMASKPEN:;
   {Pixel is the inverse of the R2_MASKPEN color.}
   R2_NOTMERGEPEN:;
   {Pixel is the inverse of the R2_MERGEPEN color.}
   R2_NOTXORPEN:;
   {Pixel is the inverse of the R2_XORPEN color.}
   R2_WHITE:;
   {Pixel is always 1.}
   R2_XORPEN:;
   {Pixel is a combination of the colors in the pen and in the screen, but not in both.}
  end;
end;

function TextOut(DC: HDC; X,Y : Integer; Str : Pchar; Count: Integer) : Bool;
begin
  Result := TextOutA(dc,X,Y,LPCSTR(Str),Count);
end;

end.

