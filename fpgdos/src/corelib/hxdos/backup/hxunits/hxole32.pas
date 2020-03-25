unit hxole32;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, qtwinapi;

type
  tagSTGMEDIUM = record
    tymed: DWORD;
    pUnkForRelease: IUNKNOWN;
    case integer of
     0:(bitmap: HBITMAP);
     1:(MetaFilePict: HANDLE);
     2:(EnhMetaFile: HENHMETAFILE);
     3:(global: HGLOBAL);
     4:(lpszFileName: array[0..255] of Longint);
     5:(pstm: TFileStream);
     6:(pstg: TFileStream);
  end;
  STGMEDIUM = tagSTGMEDIUM;
  TStgMedium = STGMEDIUM;
  PStgMedium = ^TStgMedium;



{$define HX_DOS}

{$Linklib OLE32S.LIB}

function CLSIDFromString (lpsz: Variant; pclsid: LPCLSID): HRESULT;
{$ifdef HX_DOS}
 stdcall; external name 'CLSIDFromString';
{$endif}

function CoCreateInstance(
  rclsid      : CLSID;
  pUnkOuter   : PUNKNOWN;
  dwClsContext: DWORD;
  riid        : GUID;
  ppv         : Pointer
  ): HRESULT;
{$ifdef HX_DOS}
 stdcall; external name 'CoCreateInstance';
{$endif}

function CoGetClassObject(
  rclsid: CLSID;
  dwClsContext: DWORD;
  pvReserved  : LPVOID;
  riid        : GUID;
  ppv         : LPVOID
  ): HRESULT;
{$ifdef HX_DOS}
 stdcall; external name 'CoGetClassObject';
{$endif}

function CoGetMalloc(dwMemContext: DWORD; ppmAlloc: Pointer): HRESULT;
{$ifdef HX_DOS}
 stdcall; external name 'CoGetMalloc';
{$endif}

function CoTaskMemAlloc(cb: SIZE_T): LPVOID;
{$ifdef HX_DOS}
 stdcall; external name 'CoTaskMemAlloc';
{$endif}

procedure CoTaskMemFree(pv: LPVOID);
{$ifdef HX_DOS}
 stdcall; external name 'CoTaskMemFree';
{$endif}

function CoTaskMemRealloc(pv: LPVOID; cb: SIZE_T): LPVOID;
{$ifdef HX_DOS}
 stdcall; external name 'CoTaskMemRealloc';
{$endif}

function IIDFromString(lpsz: Variant; var piid: PGUID): HRESULT;
{$ifdef HX_DOS}
 stdcall; external name 'IIDFromString';
{$endif}

function StringFromGUID2(
  rguid : GUID;
  lpsz  : Variant;
  cchMax: integer
  ): Integer;
{$ifdef HX_DOS}
 stdcall; external name 'StringFromGUID2';
{$endif}


implementation

{$ifndef HX_DOS}
function CLSIDFromString (lpsz: Variant; pclsid: LPCLSID): HRESULT;
begin

end;

function CoCreateInstance(
  rclsid      : CLSID;
  pUnkOuter   : PUNKNOWN;
  dwClsContext: DWORD;
  riid        : GUID;
  ppv         : Pointer
  ): HRESULT;
begin

end;

function CoGetClassObject(
  rclsid: CLSID;
  dwClsContext: DWORD;
  pvReserved  : LPVOID;
  riid        : GUID;
  ppv         : LPVOID
  ): HRESULT;
begin

end;

function CoGetMalloc(dwMemContext: DWORD; ppmAlloc: Pointer): HRESULT;
begin

end;

function CoTaskMemAlloc(cb: SIZE_T): LPVOID;
begin

end;

procedure CoTaskMemFree(pv: LPVOID);
begin

end;

function CoTaskMemRealloc(pv: LPVOID; cb: SIZE_T): LPVOID;
begin

end;

function IIDFromString(lpsz: Variant; var piid: PGUID): HRESULT;
begin

end;

function StringFromGUID2(
  rguid : GUID;
  lpsz  : Variant;
  cchMax: integer
  ): Integer;
begin

end;
{$endif}


end.

