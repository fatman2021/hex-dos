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
stdcall; external {$ifdef windows}dadv32lib{$endif} name 'GetUserNameA';
{$endif}

function GetUserNameW (lpBuffer: LPWSTR; pcbBuffer: LPDWORD): BOOL;
{$ifdef HX_DOS}
stdcall; external {$ifdef windows}dadv32lib{$endif} name 'GetUserNameW';
{$endif}

function RegCloseKey(key: HKEY): LSTATUS;
{$ifdef HX_DOS}
stdcall; external {$ifdef windows}dadv32lib{$endif} name 'RegCloseKey';
{$endif}

function RegCreateKeyA(key: HKEY; lpSubKey: LPCSTR; phkResult: PHKEY): LSTATUS;
{$ifdef HX_DOS}
stdcall; external {$ifdef windows}dadv32lib{$endif} name 'RegCreateKeyA';
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
stdcall; external {$ifdef windows}dadv32lib{$endif} name 'RegCreateKeyExA';
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
stdcall; external {$ifdef windows}dadv32lib{$endif} name 'RegCreateKeyExW';
{$endif}

function RegCreateKeyW(key: HKEY; lpSubKey: LPCWSTR; phkResult: PHKEY): LSTATUS;
{$ifdef HX_DOS}
stdcall; external {$ifdef windows}dadv32lib{$endif} name 'RegCreateKeyW';
{$endif}

function RegDeleteKeyA(key: HKEY; hSubKey: LPCSTR): LSTATUS;
{$ifdef HX_DOS}
stdcall; external {$ifdef windows}dadv32lib{$endif} name 'RegDeleteKeyA';
{$endif}

function RegDeleteKeyW(key: HKEY; hSubKey: LPCWSTR): LSTATUS;
{$ifdef HX_DOS}
stdcall; external {$ifdef windows}dadv32lib{$endif} name 'RegDeleteKeyW';
{$endif}

function RegDeleteValueA (key: HKEY; lpValueName: LPCSTR): LSTATUS;
{$ifdef HX_DOS}
stdcall; external {$ifdef windows}dadv32lib{$endif} name 'RegDeleteValueA';
{$endif}

function RegDeleteValueW (key: HKEY; lpValueName: LPCWSTR): LSTATUS;
{$ifdef HX_DOS}
stdcall; external {$ifdef windows}dadv32lib{$endif} name 'RegDeleteValueW';
{$endif}

function RegEnumKeyA(
  Key    : HKEY;
  dwIndex: DWORD;
  lpName : LPSTR;
  cchName: DWORD
  ): LSTATUS;
{$ifdef HX_DOS}
stdcall; external {$ifdef windows}dadv32lib{$endif} name 'RegEnumKeyA';
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
stdcall; external {$ifdef windows}dadv32lib{$endif} name 'RegEnumKeyExA';
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
stdcall; external {$ifdef windows}dadv32lib{$endif} name 'RegEnumKeyExW';
{$endif}

function RegEnumKeyW(
  Key    : HKEY;
  dwIndex: DWORD;
  lpName : LPWSTR;
  cchName: DWORD
): LSTATUS;
{$ifdef HX_DOS}
stdcall; external {$ifdef windows}dadv32lib{$endif} name 'RegEnumKeyW';
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
stdcall; external {$ifdef windows}dadv32lib{$endif} name 'RegEnumValueA';
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
stdcall; external {$ifdef windows}dadv32lib{$endif} name 'RegEnumValueW';
{$endif}

function RegOpenKeyA(key: HKEY; lpSubKey: LPCSTR; phkResult: PHKEY): LSTATUS;
{$ifdef HX_DOS}
stdcall; external {$ifdef windows}dadv32lib{$endif} name 'RegOpenKeyA';
{$endif}

function RegOpenKeyExA(
  hKey      : HKEY;
  lpSubKey  : LPCSTR;
  ulOptions : DWORD;
  samDesired: REGSAM;
  phkResult : PHKEY
  ): LSTATUS;
{$ifdef HX_DOS}
stdcall; external {$ifdef windows}dadv32lib{$endif} name 'RegOpenKeyExA';
{$endif}

function RegOpenKeyExW(
  hKey      : HKEY;
  lpSubKey  : LPCWSTR;
  ulOptions : DWORD;
  samDesired: REGSAM;
  phkResult : PHKEY
): LSTATUS;
{$ifdef HX_DOS}
stdcall; external {$ifdef windows}dadv32lib{$endif} name 'RegOpenKeyExW';
{$endif}

function RegOpenKeyW(key: HKEY; lpSubKey: LPCWSTR; phkResult: PHKEY): LSTATUS;
{$ifdef HX_DOS}
stdcall; external {$ifdef windows}dadv32lib{$endif} name 'RegOpenKeyW';
{$endif}

function RegQueryValueA(
  Key     : HKEY;
  lpSubKey: LPCSTR;
  lpData  : LPSTR;
  lpcbData: PLONG
  ): LSTATUS;
{$ifdef HX_DOS}
stdcall; external {$ifdef windows}dadv32lib{$endif} name 'RegQueryValueA';
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
stdcall; external {$ifdef windows}dadv32lib{$endif} name 'RegQueryValueExA';
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
stdcall; external {$ifdef windows}dadv32lib{$endif} name 'RegQueryValueExW';
{$endif}

function RegQueryValueW(
  Key     : HKEY;
  lpSubKey: LPCWSTR;
  lpData  : LPWSTR;
  lpcbData: PLONG
): LSTATUS;
{$ifdef HX_DOS}
stdcall; external {$ifdef windows}dadv32lib{$endif} name 'RegQueryValueW';
{$endif}

function RegSetValueA(
  Key     : HKEY;
  lpSubKey: LPCSTR;
  dwType  : DWORD;
  lpData  : LPCSTR;
  cbData  : DWORD
): LSTATUS;
{$ifdef HX_DOS}
stdcall; external {$ifdef windows}dadv32lib{$endif} name 'RegSetValueA';
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
stdcall; external {$ifdef windows}dadv32lib{$endif} name 'RegSetValueExA';
{$endif}

function SystemFunction036(pbBuffer: Pointer; dwLen: ULONG): Boolean;
{$ifdef HX_DOS}
stdcall; external {$ifdef windows}dadv32lib{$endif} name 'SystemFunction036';
{$endif}


implementation

end.

