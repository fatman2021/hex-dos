{
  todo

  im Implementation Teil statt {$ifdef HX_DOS}  ->  {$ifndef HX_DOS} !
}

unit hxkernel;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, syncobjs, qtwinapi;

const
  kerneldll = {$ifdef link_dynamic}'c:\Users\Konta\mseide\lib\msedos\hxdos\dkrnl32.dll'{$else}'c:\lazarus\fpgui-1.4.1\src\lib\i386go32\DKRNL32S.LIB'{$endif};
  userdll = {$ifdef link_dynamic}'c:\Users\Konta\mseide\lib\msedos\hxdos\duser32.dll'{$else}'c:\lazarus\fpgui-1.4.1\src\lib\i386go32\DUSER32S.LIB'{$endif};

{$define HX_DOS}

type
  tagPROCESSENTRY32 = record
    dwSize             : DWORD;
    cntUsage           : DWORD;
    th32ProcessID      : DWORD;
    th32DefaultHeapID  : ULONG_PTR;
    th32ModuleID       : DWORD;
    cntThreads         : DWORD;
    th32ParentProcessID: DWORD;
    pcPriClassBase     : LONG;
    dwFlags            : DWORD;
    szExeFile          : array[0..MAX_PATH] of CHAR;
  end;
  PROCESSENTRY32 = tagPROCESSENTRY32;
  PPROCESSENTRY32 = ^PROCESSENTRY32;


function CloseHandle(hObject: HANDLE): Boolean;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'CloseHandle';
  {$endif}

function CopyFileA(
   lpExistingFileName : LPCSTR;
   lpNewFileName      : LPCSTR;
   bFailIfExists      : BOOL
   ): BOOL;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'CopyFileA';
  {$endif}

function CopyFileW(
   lpExistingFileName : LPCWSTR;
   lpNewFileName      : LPCWSTR;
   bFailIfExists      : BOOL
   ): BOOL;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'CopyFileW';
  {$endif}

function CreateDirectoryA(
  lpPathName          : LPCSTR;
  lpSecurityAttributes: LPSECURITY_ATTRIBUTES
  ): BOOL;
{$ifdef HX_DOS}
stdcall; external kerneldll name 'CreateDirectoryA';
{$endif}

function CreateDirectoryW(
  lpPathName          : LPCWSTR;
  lpSecurityAttributes: LPSECURITY_ATTRIBUTES
  ): BOOL;
{$ifdef HX_DOS}
stdcall; external kerneldll name 'CreateDirectoryW';
{$endif}

function CreateDirectoryExA(
  lpTemplateDirectory : LPCSTR;
  lpPathName          : LPCSTR;
  lpSecurityAttributes: LPSECURITY_ATTRIBUTES
  ): BOOL;
{$ifdef HX_DOS}
stdcall; external kerneldll name 'CreateDirectoryExA';
{$endif}

function CreateDirectoryExW(
  lpTemplateDirectory : LPCWSTR;
  lpPathName          : LPCWSTR;
  lpSecurityAttributes: LPSECURITY_ATTRIBUTES
  ): BOOL;
{$ifdef HX_DOS}
stdcall; external kerneldll name 'CreateDirectoryExW';
{$endif}

function CreateFileA(
   lpFileName           : LPCSTR;
   dwDesiredAccess      : DWORD;
   dwShareMode          : DWORD;
   lpSecurityAttributes : LPSECURITY_ATTRIBUTES;
   dwCreationDisposition: DWORD;
   dwFlagsAndAttributes : DWORD;
   hTemplateFile        : HANDLE
   ): HANDLE;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'CreateFileA';
  {$endif}

function CreateFileW(
   lpFileName           : LPCWSTR;
   dwDesiredAccess      : DWORD;
   dwShareMode          : DWORD;
   lpSecurityAttributes : LPSECURITY_ATTRIBUTES;
   dwCreationDisposition: DWORD;
   dwFlagsAndAttributes : DWORD;
   hTemplateFile        : HANDLE
   ): HANDLE;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'CreateFileW';
  {$endif}

function CreateMutexA(
  lpMutexAttributes : LPSECURITY_ATTRIBUTES;
  bInitialOwner     : BOOL;
  lpName            : LPCSTR
  ): HANDLE;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'CreateMutexA';
  {$endif}

function CreateMutexW(
  lpMutexAttributes : LPSECURITY_ATTRIBUTES;
  bInitialOwner     : BOOL;
  lpName            : LPCWSTR
): HANDLE;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'CreateMutexW';
  {$endif}

function CreatePipe(
  hReadPipe        : PHANDLE;
  hWritePipe       : PHANDLE;
  lpPipeAttributes : LPSECURITY_ATTRIBUTES;
  nSize            : DWORD
  ): BOOL;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'CreatePipe';
  {$endif}

function CreateProcessA(
  lpApplicationName   : LPCSTR;
  lpCommandLine       : LPSTR;
  lpProcessAttributes : LPSECURITY_ATTRIBUTES;
  lpThreadAttributes  : LPSECURITY_ATTRIBUTES;
  bInheritHandles     : BOOL;
  dwCreationFlags     : DWORD;
  lpEnvironment       : Pointer;
  lpCurrentDirectory  : LPCSTR;
  StartupInfo         : PSTARTUPINFO;
  ProcessInformation  : LPPROCESS_INFORMATION 
): BOOL;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'CreateProcessA';
  {$endif}

function CreateProcessW(
  lpApplicationName   : LPCWSTR;
  lpCommandLine       : LPWSTR;
  lpProcessAttributes : LPSECURITY_ATTRIBUTES;
  lpThreadAttributes  : LPSECURITY_ATTRIBUTES;
  bInheritHandles     : BOOL;
  dwCreationFlags     : DWORD;
  lpEnvironment       : Pointer;
  lpCurrentDirectory  : LPCWSTR;
  StartupInfo         : PSTARTUPINFO;
  ProcessInformation  : LPPROCESS_INFORMATION 
): BOOL;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'CreateProcessW';
  {$endif}

function CreateSemaphoreA(
  lpSemaphoreAttributes : LPSECURITY_ATTRIBUTES;
  lInitialCount         : LONG;
  lMaximumCount         : LONG;
  lpName                : LPCSTR
): HANDLE;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'CreateSemaphoreA';
  {$endif}

function CreateSemaphoreW(
  lpSemaphoreAttributes : LPSECURITY_ATTRIBUTES;
  lInitialCount         : LONG;
  lMaximumCount         : LONG;
  lpName                : LPCWSTR
  ): HANDLE;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'CreateSemaphoreW';
  {$endif}

function CreateThread(
   lpThreadAttributes: LPSECURITY_ATTRIBUTES;
   dwStackSize       : SIZE_T;
   lpStartAddress    : LPTHREAD_START_ROUTINE;
   lpParameter       : {__drv_aliasesMem} LPVOID;
   dwCreationFlags   : DWORD;
   lpThreadId        : LPDWORD
   ): HANDLE;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'CreateThread';
  {$endif}

function CreateToolhelp32Snapshot(dFlags: DWORD; th32ProcessID
: DWORD): HANDLE;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'CreateToolhelp32Snapshot';
  {$endif}

function CompareStringA(
  Locale: LCID;
  dwCmpFlags: DWORD;
  lpString1: {_In_NLS_string_(cchCount1)}PChar;
  cchCount1: integer;
  lpString2: {_In_NLS_string_(cchCount2)}PChar;
  cchCount2: integer
): Integer;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'CompareStringA';
  {$endif}

function CompareStringW(
  Locale: LCID;
  dwCmpFlags: DWORD;
  lpString1: {_In_NLS_string_(cchCount1)}PWideChar;
  cchCount1: integer;
  lpString2: {_In_NLS_string_(cchCount2)}PWideChar;
  cchCount2: integer
): Integer;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'CompareStringW';
  {$endif}


procedure DeleteCriticalSection(CriticalSection: LPCRITICAL_SECTION{TCriticalSection});
  {$ifdef HX_DOS}
   stdcall; external kerneldll name 'DeleteCriticalSection';
  {$endif}

procedure InitializeCriticalSection(
   pCriticalSection: LPCRITICAL_SECTION
);
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'InitializeCriticalSection';
  {$endif}

function InitializeCriticalSectionEx(
  var CriticalSection: TCriticalSection;
  dwSpinCount: DWORD;
  flags: DWORD
): Boolean;

procedure EnterCriticalSection(CriticalSection: TCriticalSection);
{$ifdef HX_DOS}
stdcall; external kerneldll name 'EnterCriticalSection';
{$endif}

function PostThreadMessage(
  IdThread: DWORD;
  msg: UINT;
  w: WPARAM;
  l: LPARAM
): Boolean;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'EnterCriticlaSection';
  {$endif}

function FindClose(hFindFile: HANDLE): BOOL;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'FindClose';
  {$endif}

function FindFirstFileA(
  lpFileName     : LPCSTR;
  lpFindFileData : LPWIN32_FIND_DATA
  ): HANDLE;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'FindFirstFileA';
  {$endif}
function FindFirstFileW(
  lpFileName     : LPCWSTR;
  lpFindFileData : LPWIN32_FIND_DATAW
  ): HANDLE;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'FindFirstFileW';
  {$endif}
function FindNextFileA(
  hFindFile: HANDLE;
  lpFindFileData : LPWIN32_FIND_DATA
  ): BOOL;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'FindNextFileA';
  {$endif}
function FindNextFileW(
  hFindFile: HANDLE;
  lpFindFileData : LPWIN32_FIND_DATAW
  ): BOOL;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'FindNextFileW';
  {$endif}

function FlushFileBuffers(hFile: HANDLE): BOOL;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'FlushFileBuffers';
  {$endif}

function FreeEnvironmentStrings(penv: LPCH): Boolean;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'FreeEnvironmentStringsA';
  {$endif}
function FreeEnvironmentStringsA(penv: LPCH): Boolean;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'FreeEnvironmentStringsA';
  {$endif}

function FreeEnvironmentStringsW(penv: LPWCH): Boolean;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'FreeEnvironmentStringsW';
  {$endif}

function FreeLibrary(hLibModule: HMODULE): BOOL;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'FreeLibrary';
  {$endif}

function FreeResource(hResDate: HGLOBAL): BOOL;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'FreeResource';
  {$endif}

function GetClipboardFormatNameW(
  format: UINT;
  lpszFormatName: LPWSTR;
  cchMaxCount: Integer
): Integer;
  {$ifdef HX_DOS}
  stdcall; external 'c:\Users\Konta\mseide\lib\msedos\hxdos\duser32.dll' name 'GetClipboardFormatNameA';
  {$endif}

function GetCurrentDirectoryA(
  nBufferLength: DWORD;
  lpBuffer     : LPSTR
  ): DWORD;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GetCurrentDirectoryA';
  {$endif}

function GetCurrentDirectoryW(
  nBufferLength: DWORD;
  lpBuffer     : LPWSTR
  ): DWORD;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GetCurrentDirectoryW';
  {$endif}

function GetExitCodeProcess(hProcess: HANDLE; lpExitCode: LPDWORD): Boolean;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GetExitCodeProcess';
  {$endif}

function GetExitCodeThread(hThread: HANDLE; lpExitCode: LPDWORD): Boolean;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GetExitCodeThread';
  {$endif}

function GetFileInformationByHandle(hFile: THandle;
                    var lpFileInformation: By_Handle_File_Information): Boolean;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GetFileInformationByHandle';
  {$endif}

function GetFileAttributesA(lpFileName: LPCSTR): DWORD;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GetFileAttributesA';
  {$endif}

function GetFileAttributesW(lpFileName: LPCWSTR): DWORD;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GetFileAttributesW';
  {$endif}

function GetFileAttributes(lpFileName: LPCSTR): DWORD;

function GetFileAttributesExA(
   lpFileName       : LPCSTR;
   fInfoLevelId     : GET_FILEEX_INFO_LEVELS;
   lpFileInformation: Pointer
   ): BOOL;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GetFileAttributesExA';
  {$endif}

function GetFileAttributesExW(
   lpFileName       : LPCWSTR;
   fInfoLevelId     : GET_FILEEX_INFO_LEVELS;
   lpFileInformation: Pointer
   ): BOOL;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GetFileAttributesExW';
  {$endif}

function GetFileSize(
   hFile            : HANDLE;
   lpFileSizeHigh   : LPDWORD
   ): DWORD;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GetFileSize';
  {$endif}

function GetFileSizeEx(
   hFile            : HANDLE;
   lpFileSize       : PLARGE_INTEGER
   ): BOOL;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GetFileSizeEx';
  {$endif}

function GetFileTime(
   hFile           : HANDLE;
   lpCreationTime  : LPFILETIME;
   lpLastAccessTime: LPFILETIME;
   lpLastWriteTime : LPFILETIME): BOOL;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GetFileTime';
  {$endif}

function GetFileType(hFile: HANDLE): DWORD;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GetFileType';
  {$endif}

function GetFullPathNameA(
   lpFileName   : LPCSTR;
   nBufferLength: DWORD;
   lpBuffer     : LPSTR;
  var lpFilePart: LPSTR
   ): DWORD;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GetFullPathNameA';
  {$endif}

function GetFullPathNameW(
   lpFileName   :LPCWSTR;
   nBufferLength: DWORD;
   lpBuffer     : LPWSTR;
  var lpFilePart: LPWSTR
   ): DWORD;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GetFullPathNameW';
  {$endif}


function GetLastError: DWORD;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GetLastError';
  {$endif}

  //dummy
function GetProcessId(Process: HANDLE): DWORD;
  {$ifdef HX_DOS}
  //stdcall; external kerneldll name '';
  {$endif}

function GetCurrentProcess: HANDLE;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GetCurrentProcess';
  {$endif}

function GetCurrentProcessId: DWORD;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GetCurrentProcessId';
  {$endif}

function GetCurrentThread: HANDLE;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GetCurrentThread';
  {$endif}

function GetCurrentThreadId: DWORD;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GetCurrentThreadId';
  {$endif}

function GetDiskFreeSpaceA(
  lpRootPathName: LPCSTR;
  lpSectorsPerCluster    : LPDWORD;
  lpBytesPerSector       : LPDWORD;
  lpNumberOfFreeClusters : LPDWORD;
  lpTotalNumberOfClusters: LPDWORD
   ): BOOL;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GetDiskFreeSpaceA';
  {$endif}

function GetDiskFreeSpaceW(
  lpRootPathName: LPCWSTR;
  lpSectorsPerCluster    : LPDWORD;
  lpBytesPerSector       : LPDWORD;
  lpNumberOfFreeClusters : LPDWORD;
  lpTotalNumberOfClusters: LPDWORD
  ): BOOL;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GetDiskFreeSpaceW';
  {$endif}

function GetDiskFreeSpaceExA(
  lpDirectoryName             : LPCSTR;
  lpFreeBytesAvailableToCaller: PULARGE_INTEGER;
  lpTotalNumberOfBytes        : PULARGE_INTEGER;
  lpTotalNumberOfFreeBytes    : PULARGE_INTEGER
  ): BOOL;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GetDiskFreeSpaceExA';
  {$endif}

function GetDiskFreeSpaceExW(
  lpDirectoryName             : LPCWSTR;
  lpFreeBytesAvailableToCaller: PULARGE_INTEGER;
  lpTotalNumberOfBytes        : PULARGE_INTEGER;
  lpTotalNumberOfFreeBytes    : PULARGE_INTEGER
  ): BOOL;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GetDiskFreeSpaceExW';
  {$endif}

function GetDriveTypeA(lpRootPathName: LPCSTR): UINT;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GetDriveTypeA';
  {$endif}

function GetDriveTypeW(lpRootPathName: LPCWSTR): UINT;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GetDriveTypeW';
  {$endif}

function GetEnvironmentStrings: LPCH;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GetEnvironmentStrings';
  {$endif}
function GetEnvironmentStringsA: LPCH;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GetEnvironmentStringsA';
  {$endif}

function GetEnvironmentStringsW: LPWCH;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GetEnvironmentStringsW';
  {$endif}

function GetEnvironmentVariableA(lpName:LPCTSTR; lpBuf:LPTSTR; nSize:DWORD):DWORD;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GetEnvironmentVariableA';
  {$endif}

function GetEnvironmentVariableW(lpName:LPCTSTR; lpBuf:LPTSTR; nSize:DWORD):DWORD;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GetEnvironmentVariableW';
  {$endif}

function GetExitCodeProcess(hProcess: HANDLE; lpExitCode: ULONG_PTR): BOOL;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GetExitCodeProcess';
  {$endif}
(*
function GetExitCodeThread(hThread: HANDLE; lpExitCode: LPDWORD): Boolean;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GetExitCodeThread';
  {$endif}
*)
function GetModuleFileName(
   Module: HMODULE;
   lpFileName: LPSTR;
   nSize: DWORD
): DWORD;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GetModuleFileNameA';
  {$endif}

function GetModuleFileNameA(
   Module: HMODULE;
   lpFileName: LPSTR;
   nSize: DWORD
): DWORD;
 {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GetModuleFileNameA';
 {$endif}

function GetStdHandle(nStdHandle: DWORD): HANDLE;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GetStdHandle';
  {$endif}

Procedure GetSystemTimeAsFileTime(lpSystemTimeAsFileTime: LPFILETIME);
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GetSystemTimeAsFileTime';
  {$endif}

function GetTimeZoneInformation(lpTimeZoneInformation: LPTIME_ZONE_INFORMATION): DWORD;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GetTimeZoneInformation';
  {$endif}

function GetTempFileNameA(
  lpPathName    : LPCSTR;
  lpPrefixString: LPCSTR;
  uUnique       : UINT;
  lpTempFileName: LPSTR
  ): UINT;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GetTempFileNameA';
  {$endif}

function GetTempFileNameW(
  lpPathName    : LPCWSTR;
  lpPrefixString: LPCWSTR;
  uUnique       : UINT;
  lpTempFileName: LPWSTR
  ): UINT;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GetTempFileNameW';
  {$endif}

function GetTempPathA(nBufferLength: DWORD; lpBuffer: LPSTR): DWORD;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GetTempPathA';
  {$endif}

function GetTempPathW(nBufferLength: DWORD; lpBuffer: LPWSTR): DWORD;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GetTempPathW';
  {$endif}

function GetLongPathNameA(
  lpszShortPath: LPCSTR;
  lpszLongPath : LPSTR;
  cchBuffer    : DWORD
): DWORD;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GetLongPathNameA';
  {$endif}

function GetLongPathNameW(
  lpszShortPath: LPCWSTR;
  lpszLongPath : LPWSTR;
  cchBuffer    : DWORD
): DWORD;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GetLongPathNameW';
  {$endif}

function GetUserNameA(
   lpBuffer : LPSTR;
   pcbBuffer: LPDWORD
   ): BOOL;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GetUserNameA';
  {$endif}

function GetUserNameW(
   lpBuffer : LPWSTR;
   pcbBuffer: LPDWORD
   ): BOOL;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GetUserNameW';
  {$endif}

function GetVersion: DWORD;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GetVersion';
  {$endif}

function GetVersionExA(lpVersionInformation: LPOSVERSIONINFOA): BOOL;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GetVersionExA';
  {$endif}

function GlobalAlloc(uFlags: UINT; dwBytes: SIZE_T): HGLOBAL;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GlobalAlloc';
  {$endif}
function GlobalLock(hmem: HGLOBAL): Pointer;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GlobalLock';
  {$endif}
function GlobalUnlock(hmem: HGLOBAL): Boolean;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GlobalUnlock';
  {$endif}

function GlobalFree(hmem: HGLOBAL): HGLOBAL;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'GlobalFree';
  {$endif}

function InterlockedCompareExchange(
   var Destination: Longint;
     ExChange: Longint;
     Comparand: Longint
): Longint;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'InterlockedCompareExchange';
  {$endif}

function InterlockedDecrement(var Addend: Longint): LOngint;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'InterlockedDecrement';
  {$endif}

function InterlockedExchange(var Target: Longint; Value: Longint): Longint;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'InterlockedExchange';
  {$endif}

function InterlockedIncrement(var Addend: Longint): Longint;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'InterlockedIncrement';
  {$endif}

procedure LeaveCriticalSection(pCriticalSection: LPCRITICAL_SECTION);
  {$ifdef HX_DOS}
   stdcall; external kerneldll name 'LeaveCriticalSection';
  {$endif}

function LoadLibraryA(lpLibFileName: LPCSTR): HMODULE;
  {$ifdef HX_DOS}
   stdcall; external kerneldll name 'LoadLibraryA';
  {$endif}

function LoadLibraryW(lpLibFileName: LPCWSTR): HMODULE;
  {$ifdef HX_DOS}
   stdcall; external kerneldll name 'LoadLibraryW';
  {$endif}

function LoadLibraryExA(
   lpLibFileName: LPCSTR;
   hFile        : HANDLE;
   dwFlags      : DWORD
   ): HMODULE;
  {$ifdef HX_DOS}
   stdcall; external kerneldll name 'LoadLibraryExA';
  {$endif}

function LoadLibraryExW(
   lpLibFileName: LPCWSTR;
   hFile        : HANDLE;
   dwFlags      : DWORD
   ): HMODULE;
  {$ifdef HX_DOS}
   stdcall; external kerneldll name 'LoadLibraryExW';
  {$endif}

function LoadResource(module: HMODULE; ResInfo: HRSRC): HGLOBAL;
  {$ifdef HX_DOS}
   stdcall; external kerneldll name 'LoadResource';
  {$endif}

function LocalAlloc(uFlags: UINT; ubytes: Size_t): HLOCAL;
  {$ifdef HX_DOS}
   stdcall; external kerneldll name 'LocalAlloc';
  {$endif}

function LocalFree(hmem: HLOCAL): HLOCAL;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'LocalFree';
  {$endif}

function MoveFileA(
   lpExistingFileName : LPCSTR;
   lpNewFileName      : LPCSTR
   ): BOOL;
{$ifdef HX_DOS}
stdcall; external kerneldll name 'MoveFileA';
{$endif}

function MoveFileExA(
   lpExistingFileName : LPCSTR;
   lpNewFileName      : LPCSTR;
   dwFlags            : DWORD
   ): BOOL;
{$ifdef HX_DOS}
stdcall; external kerneldll name 'MoveFileExA';
{$endif}

function MoveFileExW(
   lpExistingFileName : LPCWSTR;
   lpNewFileName      : LPCWSTR;
   dwFlags            : DWORD
   ): BOOL;
{$ifdef HX_DOS}
stdcall; external kerneldll name 'MoveFileExW';
{$endif}

function MoveFileW(
   lpExistingFileName : LPCWSTR;
   lpNewFileName      : LPCWSTR
   ): BOOL;
{$ifdef HX_DOS}
stdcall; external kerneldll name 'MoveFileW';
{$endif}


// in dieser Unit implementieren -> Dummy
function MonitorFromWindow(wnd: HWND; dwFlags: DWORD): HMONITOR;

function Process32First(hSnapshot: thandle; lppe: PPROCESSENTRY32): Boolean;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'Process32First';
  {$endif}
// in dll vorhanden, aber Dummy
function Process32Next(hSnapshot: thandle; lppe: PPROCESSENTRY32): Boolean;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'Process32First'; //weil Process32Next -> dummy
  {$endif}

function ReadFile(
  hFile                : HANDLE;
  lpBuffer             : LPVOID;
  nNumberOfBytesToRead : DWORD;
  lpNumberOfBytesRead  : LPDWORD;
  lpOverlapped         : LPOVERLAPPED
): BOOL;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'ReadFile';
  {$endif}

function RemoveDirectoryA(lpPathName: LPCSTR): BOOL;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'RemoveDirectoryA';
  {$endif}

function RemoveDirectoryW(lpPathName: LPCWSTR): BOOL;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'RemoveDirectoryW';
  {$endif}

function SetCurrentDirectory(lpPathName: LPCTSTR): BOOL;

function SetCurrentDirectoryA(lpPathName: LPCSTR): BOOL;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'SetCurrentDirectoryA';
  {$endif}

function SetCurrentDirectoryW(lpPathName: LPCWSTR): BOOL;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'SetCurrentDirectoryW';
  {$endif}

function SetEnvironmentVariableA(lpName,lpValue: PChar): BOOL;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'SetEnvironmentVariableA';
  {$endif}

function SetEnvironmentVariableW(lpName,lpValue: PWideChar): BOOL;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'SetEnvironmentVariableW';
  {$endif}

function SetFileAttributesA(
  lpFileName      : LPCSTR;
  dwFileAttributes: DWORD
  ): BOOL;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'SetFileAttributesA';
  {$endif}

function SetFileAttributesW(
  lpFileName      : LPCWSTR;
  dwFileAttributes: DWORD
  ): BOOL;
  {$ifdef HX_DOS}
   stdcall; external kerneldll name 'SetFileAttributesW';
  {$endif}

function SetFilePointer(
  hFile               : HANDLE;
  lDistanceToMove     : LONG;
  lpDistanceToMoveHigh: PLONG;
  dwMoveMethod        : DWORD
  ): DWORD;
  {$ifdef HX_DOS}
   stdcall; external kerneldll name 'SetFilePointer';
  {$endif}

function SetFilePointerEx(
  hFile           : HANDLE;
  liDistanceToMove: LARGE_INTEGER;
  lpNewFilePointer: PLARGE_INTEGER;
  dwMoveMethod    : DWORD
  ): BOOL;
  {$ifdef HX_DOS}
   stdcall; external kerneldll name 'SetFilePointerEx';
  {$endif}

function SetFileTime(
  hFile               : HANDLE;
  var lpCreationTime  :FILETIME;
  var lpLastAccessTime:FILETIME;
  var lpLastWriteTime : FILETIME
  ): BOOL;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'SetFileTime';
  {$endif}

function TerminateProcess(hProcess: HANDLE; uExitCode: UINT): Boolean;

function TerminateThread(hThread: HANDLE; dwExitCode: UINT): Boolean;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'TerminateThread';
  {$endif}

function TryEnterCriticalSection(CriticalSection: TCriticalSection): BOOL;

function WaitForMultipleObjects(
  nCount: DWORD;
  lpHandles: array of Handle; //Original *lphandles: Handle  -> in msegui Implementation nachschauen
  bWaitAll: Boolean;
  dwMilliseconds: DWORD
): DWORD;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'WaitForMultipleObjects';
  {$endif}
function WaitForMultipleObjectsEx(
  nCount: DWORD;
  lpHandles: array of Handle; //Original *lphandles: Handle  -> in msegui Implementation nachschauen
  bWaitAll: Boolean;
  dwMilliseconds: DWORD;
  bAlertable: Boolean
): DWORD;
{$ifdef HX_DOS}
    stdcall; external kerneldll name 'WaitForMultipleObjectsA';
{$endif}
function WaitForSingleObject(
  hHandle: HANDLE;
  dwMilliseconds: DWORD
  ): DWORD;
{$ifdef HX_DOS}
    stdcall; external kerneldll name 'WaitForSingleObject';
{$endif}

function WriteFile(
   hFile                  : HANDLE;
   lpBuffer               : LPCVOID;
   nNumberOfBytesToWrite  : DWORD;
   lpNumberOfBytesWritten : LPDWORD;
   lpOverlapped           : LPOVERLAPPED
): BOOL;
  {$ifdef HX_DOS}
  stdcall; external kerneldll name 'WriteFile';
  {$endif}

implementation

{$ifndef HX_DOS}
function CloseHandle(hObject: HANDLE): Boolean;
begin

end;
function CopyFileA(
   lpExistingFileName : LPCSTR;
   lpNewFileName      : LPCSTR;
   bFailIfExists      : BOOL
   ): BOOL;
begin

end;

function CopyFileW(
   lpExistingFileName : LPCWSTR;
   lpNewFileName      : LPCWSTR;
   bFailIfExists      : BOOL
   ): BOOL;
begin

end;

function CreateDirectoryA(
  lpPathName          : LPCSTR;
  lpSecurityAttributes: LPSECURITY_ATTRIBUTES
  ): BOOL;
begin

end;

function CreateDirectoryW(
  lpPathName          : LPCWSTR;
  lpSecurityAttributes: LPSECURITY_ATTRIBUTES
  ): BOOL;
begin

end;

function CreateDirectoryExA(
  lpTemplateDirectory : LPCSTR;
  lpPathName          : LPCSTR;
  lpSecurityAttributes: LPSECURITY_ATTRIBUTES
  ): BOOL;
begin

end;

function CreateDirectoryExW(
  lpTemplateDirectory : LPCWSTR;
  lpPathName          : LPCWSTR;
  lpSecurityAttributes: LPSECURITY_ATTRIBUTES
  ): BOOL;
begin

end;

function CreateFileA(
   lpFileName           : LPCSTR;
   dwDesiredAccess      : DWORD;
   dwShareMode          : DWORD;
   lpSecurityAttributes : LPSECURITY_ATTRIBUTES;
   dwCreationDisposition: DWORD;
   dwFlagsAndAttributes : DWORD;
   hTemplateFile        : HANDLE
   ): HANDLE;
begin

end;

function CreateFileW(
   lpFileName           : LPCWSTR;
   dwDesiredAccess      : DWORD;
   dwShareMode          : DWORD;
   lpSecurityAttributes : LPSECURITY_ATTRIBUTES;
   dwCreationDisposition: DWORD;
   dwFlagsAndAttributes : DWORD;
   hTemplateFile        : HANDLE
   ): HANDLE;
begin

end;

function CreateMutexA(
  lpMutexAttributes : LPSECURITY_ATTRIBUTES;
  bInitialOwner     : BOOL;
  lpName            : LPCSTR;
  ): HANDLE;
begin

end;

function CreateMutexW(
  lpMutexAttributes : LPSECURITY_ATTRIBUTES;
  bInitialOwner     : BOOL;
  lpName            : LPCWSTR;
): HANDLE;
begin

end;

function CreatePipe(
  hReadPipe        : PHANDLE;
  hWritePipe       : PHANDLE;
  lpPipeAttributes : LPSECURITY_ATTRIBUTES;
  nSize            : DWORD;
  ): BOOL;
begin

end;

function CreateProcessA(
  lpApplicationName   : LPCSTR;
  lpCommandLine       : LPSTR;
  lpProcessAttributes : LPSECURITY_ATTRIBUTES;
  lpThreadAttributes  : LPSECURITY_ATTRIBUTES;
  bInheritHandles     : BOOL;
  dwCreationFlags     : DWORD;
  lpEnvironment       : Pointer;
  lpCurrentDirectory  : LPCSTR;
  StartupInfo         : PSTARTUPINFO;
  ProcessInformation  : LPPROCESS_INFORMATION 
): BOOL;
begin

end;

function CreateProcessW(
  lpApplicationName   : LPCWSTR;
  lpCommandLine       : LPWSTR;
  lpProcessAttributes : LPSECURITY_ATTRIBUTES;
  lpThreadAttributes  : LPSECURITY_ATTRIBUTES;
  bInheritHandles     : BOOL;
  dwCreationFlags     : DWORD;
  lpEnvironment       : Pointer;
  lpCurrentDirectory  : LPCWSTR;
  StartupInfo         : PSTARTUPINFO;
  ProcessInformation  : LPPROCESS_INFORMATION 
): BOOL;
begin

end;

function CreateSemaphoreA(
  lpSemaphoreAttributes : LPSECURITY_ATTRIBUTES;
  lInitialCount         : LONG;
  lMaximumCount         : LONG;
  lpName                : LPCSTR
): HANDLE;
begin

end;

function CreateSemaphoreW(
  lpSemaphoreAttributes : LPSECURITY_ATTRIBUTES;
  lInitialCount         : LONG;
  lMaximumCount         : LONG;
  lpName                : LPCWSTR
  ): HANDLE;
begin

end;

function CreateThread(
   lpThreadAttributes: LPSECURITY_ATTRIBUTES;
   dwStackSize       : SIZE_T;
   lpStartAddress    : LPTHREAD_START_ROUTINE;
   lpParameter       : {__drv_aliasesMem} LPVOID;
   dwCreationFlags   : DWORD;
   lpThreadId        : LPDWORD
   ): HANDLE;
begin

end;

function CompareStringA(
  Locale: LCID;
  dwCmpFlags: DWORD;
  lpString1: {_In_NLS_string_(cchCount1)}PChar;
  cchCount1: integer;
  lpString2: {_In_NLS_string_(cchCount2)}PChar;
  cchCount2: integer
): Integer;
begin

end;

function CompareStringW(
  Locale: LCID;
  dwCmpFlags: DWORD;
  lpString1: {_In_NLS_string_(cchCount1)}PWideChar;
  cchCount1: integer;
  lpString2: {_In_NLS_string_(cchCount2)}PWideChar;
  cchCount2: integer
): Integer;
begin

end;

function CreateToolhelp32Snapshot(dFlags: DWORD; th32ProcessID
: DWORD): HANDLE;
begin

end;

procedure DeleteCriticalSection(CriticalSection: LPCRITICAL_SECTION{TCriticalSection});
begin

end;

procedure EnterCriticalSection(CriticalSection: TCriticalSection);
begin

end;

function FindClose(hFindFile: HANDLE): BOOL;
begin

end;

function FindFirstFileA(
  lpFileName     : LPCSTR;
  lpFindFileData : LPWIN32_FIND_DATA
  ): HANDLE;
begin

end;

function FindFirstFileW(
  lpFileName     : LPCWSTR;
  lpFindFileData : LPWIN32_FIND_DATAW
  ): HANDLE;
begin

end;

function FindNextFileA(
  hFindFile: HANDLE;
  lpFindFileData : LPWIN32_FIND_DATA
  ): BOOL;
begin

end;

function FindNextFileW(
  hFindFile: HANDLE;
  lpFindFileData : LPWIN32_FIND_DATAW
  ): BOOL;
begin

end;

function FlushFileBuffers(hFile: HANDLE): BOOL;
begin

end;

function FreeEnvironmentStrings(penv: LPCH): Boolean;
begin

end;

function FreeEnvironmentStringsA(penv: LPCH): Boolean;
begin
  Result := FreeEnvironmentStrings(penv);
end;

function FreeEnvironmentStringsW(penv: LPWCH): Boolean;
begin

end;

function FreeLibrary(hLibModule: HMODULE): BOOL;
begin

end;

function FreeResource(hResDate: HGLOBAL): BOOL;
begin

end;

function GetClipboardFormatNameW(
  format: UINT;
  lpszFormatName: LPWSTR;
  cchMaxCount: Integer
): Integer;
begin

end;

function GetExitCodeProcess(hProcess: HANDLE; lpExitCode: LPDWORD): Boolean;
begin

end;
function GetFileInformationByHandle(hFile: THandle;
                    var lpFileInformation: By_Handle_File_Information): Boolean;
begin

end;

function GetFileAttributesA(lpFileName: LPCSTR): DWORD;
begin

end;

function GetFileAttributesW(lpFileName: LPCWSTR): DWORD;
begin

end;

function GetFileAttributesExA(
   lpFileName       : LPCSTR;
   fInfoLevelId     : GET_FILEEX_INFO_LEVELS;
   lpFileInformation: Pointer
   ): BOOL;
begin

end;

function GetFileAttributesExW(
   lpFileName       : LPCWSTR;
   fInfoLevelId     : GET_FILEEX_INFO_LEVELS;
   lpFileInformation: Pointer
   ): BOOL;
begin

end;

function GetFileSize(
   hFile            : HANDLE;
   lpFileSizeHigh   : LPDWORD
   ): DWORD;
begin

end;

function GetFileSizeEx(
   hFile            : HANDLE;
   lpFileSize       : PLARGE_INTEGER
   ): BOOL;
begin

end;

function GetFileTime(
   hFile           : HANDLE;
   lpCreationTime  : LPFILETIME;
   lpLastAccessTime: LPFILETIME;
   lpLastWriteTime : LPFILETIME): BOOL;
begin

end;

function GetFileType(hFile: HANDLE): DWORD;
begin

end;

function GetFullPathNameA(
   lpFileName   :LPCSTR;
   nBufferLength: DWORD;
   lpBuffer     : LPSTR;
  var lpFilePart: LPSTR
   ): DWORD;
begin

end;

function GetFullPathNameW(
   lpFileName   :LPCWSTR;
   nBufferLength: DWORD;
   lpBuffer     : LPWSTR;
  var lpFilePart: LPWSTR
   ): DWORD;
begin

end;

function GetLastError: DWORD;
begin

end;

function GetVersion: DWORD;
begin

end;

function GetVersionExA(lpVersionInformation: LPOSVERSIONINFOA): BOOL;
begin

end;
{$endif}

function GetProcessId(Process: HANDLE): DWORD;
begin

end;

{$ifndef HX_DOS}
function GetCurrentDirectoryA(
  nBufferLength: DWORD;
  lpBuffer     : LPSTR
  ): DWORD;
begin

end;

function GetCurrentDirectoryW(
  nBufferLength: DWORD;
  lpBuffer     : LPWSTR
  ): DWORD;
begin

end;

function GetCurrentProcess: HANDLE;
begin

end;

function GetCurrentProcessId: DWORD;
begin

end;

function GetCurrentThread: HANDLE;
begin

end;

function GetCurrentThreadId: DWORD;
begin

end;

function GetEnvironmentStrings: LPCH;
begin

end;

function GetEnvironmentStringsA: LPCH;
begin

end;

function GetDiskFreeSpaceA(
  lpRootPathName: LPCSTR;
  lpSectorsPerCluster    : LPDWORD;
  lpBytesPerSector       : LPDWORD;
  lpNumberOfFreeClusters : LPDWORD;
  lpTotalNumberOfClusters: LPDWORD
   ): BOOL;
begin

end;

function GetDiskFreeSpaceW(
  lpRootPathName: LPCWSTR;
  lpSectorsPerCluster    : LPDWORD;
  lpBytesPerSector       : LPDWORD;
  lpNumberOfFreeClusters : LPDWORD;
  lpTotalNumberOfClusters: LPDWORD
  ): BOOL;
begin

end;

function GetDiskFreeSpaceExA(
  lpDirectoryName             : LPCSTR;
  lpFreeBytesAvailableToCaller: PULARGE_INTEGER;
  lpTotalNumberOfBytes        : PULARGE_INTEGER;
  lpTotalNumberOfFreeBytes    : PULARGE_INTEGER
  ): BOOL;
begin

end;

function GetDiskFreeSpaceExW(
  lpDirectoryName             : LPCWSTR;
  lpFreeBytesAvailableToCaller: PULARGE_INTEGER;
  lpTotalNumberOfBytes        : PULARGE_INTEGER;
  lpTotalNumberOfFreeBytes    : PULARGE_INTEGER
  ): BOOL;
begin

end;

function GetDriveTypeA(lpRootPathName: LPCSTR): UINT;
begin

end;

function GetDriveTypeW(lpRootPathName: LPCWSTR): UINT;
begin

end;

function GetEnvironmentStringsW: LPWCH;
begin

end;

function GetEnvironmentVariableA(lpName:LPCTSTR; lpBuf:LPTSTR; nSize:DWORD):DWORD;
begin

end;

function GetEnvironmentVariableW(lpName:LPCTSTR; lpBuf:LPTSTR; nSize:DWORD):DWORD;
begin

end;

function GetModuleFileName(
   Module: HMODULE;
   lpFileName: LPSTR;
   nSize: DWORD
): DWORD;
begin

end;

function GetExitCodeProcess(hProcess: HANDLE; lpExitCode: ULONG_PTR): BOOL;
begin

end;

function GetExitCodeThread(hThread: HANDLE; lpExitCode: LPDWORD): Boolean;
begin

end;

function GetLongPathNameA(
  lpszShortPath: LPCSTR;
  lpszLongPath : LPSTR;
  cchBuffer    : DWORD
): DWORD;
var
  lpStrg: LPSTR;
begin
  Result := GetFullPathNameA(lpszShortPath,cchBuffer,lpszLongPath,lpStrg);
end;

function GetLongPathNameW(
  lpszShortPath: LPCWSTR;
  lpszLongPath : LPWSTR;
  cchBuffer    : DWORD
): DWORD;
var
 lpwStrg: LPWSTR;
begin
  Result := GetFullPathNameW(lpszShortPath,cchBuffer,lpszLongPath,lpwStrg);
end;

function GetModuleFileNameA(
   Module: HMODULE;
   lpFileName: LPSTR;
   nSize: DWORD
): DWORD;
begin

end;

function GetStdHandle(nStdHandle: DWORD): HANDLE;
begin
  case nStdHandle of
   STD_INPUT_HANDLE :;
   STD_OUTPUT_HANDLE:;
   STD_ERROR_HANDLE :;
  end;
end;

Procedure GetSystemTimeAsFileTime(lpSystemTimeAsFileTime: LPFILETIME);
begin

end;

function GetTimeZoneInformation(lpTimeZoneInformation: LPTIME_ZONE_INFORMATION): DWORD;
begin

end;

function GetTempFileNameA(
  lpPathName    : LPCSTR;
  lpPrefixString: LPCSTR;
  uUnique       : UINT;
  lpTempFileName: LPSTR
): UINT;
begin

end;

function GetTempFileNameW(
  lpPathName    : LPCWSTR;
  lpPrefixString: LPCWSTR;
  uUnique       : UINT;
  lpTempFileName: LPWSTR
): UINT;
begin

end;

function GetTempPathA(nBufferLength: DWORD; lpBuffer: LPSTR): DWORD;
begin

end;

function GetTempPathW(nBufferLength: DWORD; lpBuffer: LPWSTR): DWORD;
begin

end;

function GetUserNameA(
   lpBuffer : LPSTR;
   pcbBuffer: LPDWORD
   ): BOOL;
begin

end;

function GetUserNameW(
   lpBuffer : LPWSTR;
   pcbBuffer: LPDWORD
   ): BOOL;
begin

end;

function GlobalAlloc(uFlags: UINT; dwBytes: SIZE_T): HGLOBAL;
begin

end;

function GlobalLock(hmem: HGLOBAL): Pointer;
begin

end;

function GlobalUnlock(hmem: HGLOBAL): Boolean;  //wenn uflags bei GlobalAlloc -> GMEM_FIXED -> kein Effekt, nur bei GMEM_MOVEABLE oä.
begin

end;

function GlobalFree(hmem: HGLOBAL): HGLOBAL;
begin

end;

procedure InitializeCriticalSection(
   pCriticalSection: LPCRITICAL_SECTION
);
begin

end;

function InterlockedCompareExchange(
   var Destination: Longint;
     ExChange: Longint;
     Comparand: Longint
): Longint;
begin

end;

function InterlockedDecrement(var Addend: Longint): LOngint;
begin

end;

function InterlockedExchange(var Target: Longint; Value: Longint): Longint;
begin

end;

function InterlockedIncrement(var Addend: Longint): Longint;
begin

end;

function LocalAlloc(uFlags: UINT; ubytes: Size_t): HLOCAL;
begin
  case uFlags of
   LMEM_FIXED:;
   LMEM_MOVEABLE:;
   LMEM_ZEROINIT:;
   LHND:;
  end;
end;

function LocalFree(hmem: HLOCAL): HLOCAL;
begin

end;

function InitializeCriticalSectionEx(
  var CriticalSection: TCriticalSection;  //in msegui nachschauen, wie dort omplementiert
  dwSpinCount: DWORD;
  flags: DWORD
): Boolean;
begin

end;

procedure LeaveCriticalSection(pCriticalSection: LPCRITICAL_SECTION);
begin

end;

function LoadLibraryA(lpLibFileName: LPCSTR): HMODULE;
begin

end;

function LoadLibraryW(lpLibFileName: LPCWSTR): HMODULE;
begin

end;

function LoadLibraryExA(
   lpLibFileName: LPCSTR;
   hFile        : HANDLE;
   dwFlags      : DWORD
   ): HMODULE;
begin

end;

function LoadLibraryExW(
   lpLibFileName: LPCWSTR;
   hFile        : HANDLE;
   dwFlags      : DWORD
   ): HMODULE;
begin

end;

function LoadResource(module: HMODULE; ResInfo: HRSRC): HGLOBAL;
begin

end;

function MoveFileA(
   lpExistingFileName : LPCSTR;
   lpNewFileName      : LPCSTR
   ): BOOL;
begin

end;

function MoveFileExA(
   lpExistingFileName : LPCSTR;
   lpNewFileName      : LPCSTR;
   dwFlags            : DWORD
   ): BOOL;
begin

end;

function MoveFileExW(
   lpExistingFileName : LPCWSTR;
   lpNewFileName      : LPCWSTR;
   dwFlags            : DWORD
   ): BOOL;
begin

end;

function MoveFileW(
   lpExistingFileName : LPCWSTR;
   lpNewFileName      : LPCWSTR
   ): BOOL;
begin

end;

{$endif}

function GetFileAttributes(lpFileName: LPCSTR): DWORD;
begin
  Result := GetFileAttributesA(lpFileName);
end;

function InitializeCriticalSectionEx(
  var CriticalSection: TCriticalSection;
  dwSpinCount: DWORD;
  flags: DWORD
): Boolean;
begin
  InitializeCriticalSection(@CriticalSection);
end;

function MonitorFromWindow(wnd: HWND; dwFlags: DWORD): HMONITOR;
begin
  Result := 0;
  {
  case dwFlags of
   MONITOR_DEFAULTTONEAREST: ; //Handle Monitor, der dem Fenster am nächsten ist (Größerer Teil des Fensters bei Überlappung)
   MONITOR_DEFAULTTONULL: Result := 0;
   MONITOR_DEFAULTTOPRIMARY: ; //Handle primärer Monitor
  end;
  }
end;

{$ifndef HX_DOS}
function PostThreadMessage(
  IdThread: DWORD;
  msg: UINT;
  w: WPARAM;
  l: LPARAM
): Boolean;
begin

end;

function PostThreadMessageA(
  IdThread: DWORD;
  msg: UINT;
  w: WPARAM;
  l: LPARAM
): Boolean;
begin
  Result := PostThreadMessage(IdThread, msg, w, l);
end;

function Process32First(hSnapshot: thandle; lppe: PPROCESSENTRY32): Boolean;
begin

end;
{$endif}
{
function Process32Next(hSnapshot: thandle; lppe: PPROCESSENTRY32): Boolean;
begin
  Result := Process32First(hSnapshot, lppe);
end;
}
{$ifndef HX_DOS}
function ReadFile(
  hFile                : HANDLE;
  lpBuffer             : LPVOID;
  nNumberOfBytesToRead : DWORD;
  lpNumberOfBytesRead  : LPDWORD;
  lpOverlapped         : LPOVERLAPPED
): BOOL;
begin

end;

function RemoveDirectoryA(lpPathName: LPCSTR): BOOL;
begin

end;

function RemoveDirectoryW(lpPathName: LPCWSTR): BOOL;
begin

end;

function SetCurrentDirectoryA(lpPathName: LPCSTR): BOOL;
begin

end;

function SetCurrentDirectoryW(lpPathName: LPCWSTR): BOOL;
begin

end;

function SetEnvironmentVariableA(lpName,lpValue: PChar): BOOL;
begin

end;

function SetEnvironmentVariableW(lpName,lpValue: PWideChar): BOOL;
begin

end;

function SetFileAttributesA(
  lpFileName      : LPCSTR;
  dwFileAttributes: DWORD
  ): BOOL;
begin

end;

function SetFileAttributesW(
  lpFileName      : LPCWSTR;
  dwFileAttributes: DWORD
  ): BOOL;
begin

end;

function SetFilePointer(
  hFile               : HANDLE;
  lDistanceToMove     : LONG;
  lpDistanceToMoveHigh: PLONG;
  dwMoveMethod        : DWORD
  ): DWORD;
begin

end;

function SetFilePointerEx(
  hFile           : HANDLE;
  liDistanceToMove: LARGE_INTEGER;
  lpNewFilePointer: PLARGE_INTEGER;
  dwMoveMethod    : DWORD
  ): BOOL;
begin

end;

function SetFileTime(
  hFile               : HANDLE;
  var lpCreationTime  :FILETIME;
  var lpLastAccessTime:FILETIME;
  var lpLastWriteTime : FILETIME
  ): BOOL;
begin

end;

function TerminateThread(hThread: HANDLE; dwExitCode: UINT): Boolean;
begin

end;

{$endif}

function SetCurrentDirectory(lpPathName: LPCSTR): BOOL;
begin
  Result := SetCurrentDirectoryA(LPCTSTR(lpPathName));
end;

function TerminateProcess(hProcess: HANDLE; uExitCode: UINT): Boolean;
begin
  //vorher mit der Anwendung verbundene TSR Prozesse beenden und entladen
  //Oder:
  //TerminateThread(hProcess,uExitCode);
  Halt(uExitCode);
  Result := true;
end;

function TryEnterCriticalSection(CriticalSection: TCriticalSection): BOOL;
begin
  Result := true;
  EnterCriticalSection(CriticalSection);
end;

{$ifndef HX_DOS}
function WaitForMultipleObjects(
  nCount: DWORD;
  lpHandles: array of Handle; //Original *lphandles: Handle
  bWaitAll: Boolean;
  dwMilliseconds: DWORD
): DWORD;
begin

end;

function WaitForMultipleObjectsEx(
  nCount: DWORD;
  lpHandles: array of Handle; //Original *lphandles: Handle
  bWaitAll: Boolean;
  dwMilliseconds: DWORD;
  bAlertable: Boolean
): DWORD;
begin

end;

function WaitForSingleObject(
  hHandle: HANDLE;
  dwMilliseconds: DWORD
  ): DWORD;
begin

end;

function WriteFile(
   hFile                  : HANDLE;
   lpBuffer               : LPCVOID;
   nNumberOfBytesToWrite  : DWORD;
   lpNumberOfBytesWritten : LPDWORD;
   lpOverlapped           : LPOVERLAPPED
): BOOL;
begin

end;
{$endif}

end.

