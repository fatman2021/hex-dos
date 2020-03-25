{
  UNIT DDAV32   interface unit for DADV32.LIB and DADV32S.lib

  This unit contains all functions of this lib, which are not only dummies

}
unit hxdadv32;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, qtwinapi;

{$define HX_DOS}

{$ifdef windows}
const dadv32lib = 'DADV32S.LIB';
{$endif}
{$ifdef GO32V2}
{$Linklib DADV32S.LIB}
{$endif}

type
  LSTATUS = Longint;

function GetUserNameA (lpBuffer: LPSTR; pcbBuffer: LPDWORD): BOOL;
{$ifdef HX_DOS}
stdcall; external {$ifdef windows}dadv32lib{$endif} name '_GetUserNameA@8';
{$endif}

function GetUserNameW (lpBuffer: LPWSTR; pcbBuffer: LPDWORD): BOOL;
{$ifdef HX_DOS}
stdcall; external {$ifdef windows}dadv32lib{$endif} name '_GetUserNameW@8';
{$endif}

function RegCloseKey(key: HKEY): LSTATUS;
{$ifdef HX_DOS}
stdcall; external {$ifdef windows}dadv32lib{$endif} name '_RegCloseKey@4';
{$endif}

function RegCreateKeyA(key: HKEY; lpSubKey: LPCSTR; phkResult: PHKEY): LSTATUS;
{$ifdef HX_DOS}
stdcall; external {$ifdef windows}dadv32lib{$endif} name '_RegCreateKeyA@12';
{$endif}

function RegCreateKeyExA(
      Key                 : HKEY;
      lpSubKey            : LPCSTR;
      Reserved            : DWORD;
      lpClass             : LPSTR;
      dwOptions           : DWORD;
      samDesired          : REGSAM;
const lpSecurityAttributes: LPSECURITY_ATTRIBUTES;
      phkResult           : PHKEY;
      lpdwDisposition     : LPDWORD
): LSTATUS;
{$ifdef HX_DOS}
stdcall; external {$ifdef windows}dadv32lib{$endif} name '_RegCreateKeyExA@36';
{$endif}

function RegCreateKeyExW(
      Key                : HKEY;
      lpSubKey            : LPCWSTR;
      Reserved            : DWORD;
      lpClass             : LPWSTR;
      dwOptions           : DWORD;
      samDesired          : REGSAM;
const lpSecurityAttributes: LPSECURITY_ATTRIBUTES;
      phkResult           : PHKEY;
      lpdwDisposition     : LPDWORD
      ): LSTATUS;
{$ifdef HX_DOS}
stdcall; external {$ifdef windows}dadv32lib{$endif} name '_RegCreateKeyExW@36';
{$endif}

function RegCreateKeyW(key: HKEY; lpSubKey: LPCWSTR; phkResult: PHKEY): LSTATUS;
{$ifdef HX_DOS}
stdcall; external {$ifdef windows}dadv32lib{$endif} name '_RegCreateKeyW@12';
{$endif}

function RegDeleteKeyA(key: HKEY; hSubKey: LPCSTR): LSTATUS;
{$ifdef HX_DOS}
stdcall; external {$ifdef windows}dadv32lib{$endif} name '_RegDeleteKeyA@8';
{$endif}

function RegDeleteKeyW(key: HKEY; hSubKey: LPCWSTR): LSTATUS;
{$ifdef HX_DOS}
stdcall; external {$ifdef windows}dadv32lib{$endif} name '_RegDeleteKeyW@8';
{$endif}

function RegDeleteValueA (key: HKEY; lpValueName: LPCSTR): LSTATUS;
{$ifdef HX_DOS}
stdcall; external {$ifdef windows}dadv32lib{$endif} name '_RegDeleteValueA@8';
{$endif}

function RegDeleteValueW (key: HKEY; lpValueName: LPCWSTR): LSTATUS;
{$ifdef HX_DOS}
stdcall; external {$ifdef windows}dadv32lib{$endif} name '_RegDeleteValueW@8';
{$endif}

function RegEnumKeyA(
  Key    : HKEY;
  dwIndex: DWORD;
  lpName : LPSTR;
  cchName: DWORD
  ): LSTATUS;
{$ifdef HX_DOS}
stdcall; external {$ifdef windows}dadv32lib{$endif} name '_RegEnumKeyA@16';
{$endif}

function RegEnumKeyExA(
  Key        : HKEY;
  dwIndex    : DWORD;
  lpName     : LPSTR;
  lpcchName  : LPDWORD;
  lpReserved : LPDWORD;
  lpClass    : LPSTR;
  lpcchClass : LPDWORD;
  lpftLastWriteTime: PFILETIME
): LSTATUS;
{$ifdef HX_DOS}
stdcall; external {$ifdef windows}dadv32lib{$endif} name '_RegEnumKeyExA@32';
{$endif}

function RegEnumKeyExW(
  Key        : HKEY;
  dwIndex    : DWORD;
  lpName     : LPWSTR;
  lpcchName  : LPDWORD;
  lpReserved : LPDWORD;
  lpClass    : LPWSTR;
  lpcchClass : LPDWORD;
  lpftLastWriteTime: PFILETIME
): LSTATUS;
{$ifdef HX_DOS}
stdcall; external {$ifdef windows}dadv32lib{$endif} name '_RegEnumKeyExW@32';
{$endif}

function RegEnumKeyW(
  Key    : HKEY;
  dwIndex: DWORD;
  lpName : LPWSTR;
  cchName: DWORD
): LSTATUS;
{$ifdef HX_DOS}
stdcall; external {$ifdef windows}dadv32lib{$endif} name '_RegEnumKeyW@16';
{$endif}

function RegEnumValueA(
  Key           : HKEY;
  dwIndex       : DWORD;
  lpValueName   : LPSTR;
  lpcchValueName: LPDWORD;
  lpReserved    : LPDWORD;
  lpType        : LPDWORD;
  lpData        : LPBYTE;
  lpcbData      : LPDWORD
  ): LSTATUS;
{$ifdef HX_DOS}
stdcall; external {$ifdef windows}dadv32lib{$endif} name '_RegEnumValueA@32';
{$endif}

function RegEnumValueW(
  Key           : HKEY;
  dwIndex       : DWORD;
  lpValueName   : LPWSTR;
  lpcchValueName: LPDWORD;
  lpReserved    : LPDWORD;
  lpType        : LPDWORD;
  lpData        : LPBYTE;
  lpcbData      : LPDWORD
): LSTATUS;
{$ifdef HX_DOS}
stdcall; external {$ifdef windows}dadv32lib{$endif} name '_RegEnumValueW@32';
{$endif}

function RegOpenKeyA(key: HKEY; lpSubKey: LPCSTR; phkResult: PHKEY): LSTATUS;
{$ifdef HX_DOS}
stdcall; external {$ifdef windows}dadv32lib{$endif} name '_RegOpenKeyA@12';
{$endif}

function RegOpenKeyExA(
  hKey      : HKEY;
  lpSubKey  : LPCSTR;
  ulOptions : DWORD;
  samDesired: REGSAM;
  phkResult : PHKEY
  ): LSTATUS;
{$ifdef HX_DOS}
stdcall; external {$ifdef windows}dadv32lib{$endif} name '_RegOpenKeyExA@20';
{$endif}

function RegOpenKeyExW(
  hKey      : HKEY;
  lpSubKey  : LPCWSTR;
  ulOptions : DWORD;
  samDesired: REGSAM;
  phkResult : PHKEY
): LSTATUS;
{$ifdef HX_DOS}
stdcall; external {$ifdef windows}dadv32lib{$endif} name '_RegOpenKeyExW@20';
{$endif}

function RegOpenKeyW(key: HKEY; lpSubKey: LPCWSTR; phkResult: PHKEY): LSTATUS;
{$ifdef HX_DOS}
stdcall; external {$ifdef windows}dadv32lib{$endif} name '_RegOpenKeyW@12';
{$endif}

function RegQueryValueA(
  Key     : HKEY;
  lpSubKey: LPCSTR;
  lpData  : LPSTR;
  lpcbData: PLONG
  ): LSTATUS;
{$ifdef HX_DOS}
stdcall; external {$ifdef windows}dadv32lib{$endif} name '_RegQueryValueA@16';
{$endif}

function RegQueryValueExA(
  Key        : HKEY;
  lpValueName: LPCSTR;
  lpReserved : LPDWORD;
  lpType     : LPDWORD;
  lpData     : LPBYTE;
  lpcbData   : LPDWORD
): LSTATUS;
{$ifdef HX_DOS}
stdcall; external {$ifdef windows}dadv32lib{$endif} name '_RegQueryValueExA@24';
{$endif}

function RegQueryValueExW(
  Key        : HKEY;
  lpValueName: LPCWSTR;
  lpReserved : LPDWORD;
  lpType     : LPDWORD;
  lpData     : LPBYTE;
  lpcbData   : LPDWORD
): LSTATUS;
{$ifdef HX_DOS}
stdcall; external {$ifdef windows}dadv32lib{$endif} name '_RegQueryValueExW@24';
{$endif}

function RegQueryValueW(
  Key     : HKEY;
  lpSubKey: LPCWSTR;
  lpData  : LPWSTR;
  lpcbData: PLONG
): LSTATUS;
{$ifdef HX_DOS}
stdcall; external {$ifdef windows}dadv32lib{$endif} name '_RegQueryValueW@16';
{$endif}

function RegSetValueA(
  Key     : HKEY;
  lpSubKey: LPCSTR;
  dwType  : DWORD;
  lpData  : LPCSTR;
  cbData  : DWORD
): LSTATUS;
{$ifdef HX_DOS}
stdcall; external {$ifdef windows}dadv32lib{$endif} name '_RegSetValueA@20';
{$endif}

function RegSetValueExA(
      Key        : HKEY;
      lpValueName: LPCSTR;
      Reserved   : DWORD;
      dwType     : DWORD;
const lpData     : PBYTE;
      cbData     : DWORD
      ): LSTATUS;
{$ifdef HX_DOS}
stdcall; external {$ifdef windows}dadv32lib{$endif} name '_RegSetValueExA@24';
{$endif}

function SystemFunction036(pbBuffer: Pointer; dwLen: ULONG): Boolean;
{$ifdef HX_DOS}
stdcall; external {$ifdef windows}dadv32lib{$endif} name '_SystemFunction036@8';
{$endif}


implementation

end.

