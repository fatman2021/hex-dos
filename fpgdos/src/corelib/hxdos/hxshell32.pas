unit hxshell32;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, qtwinapi;

const
  shell32 = 'c:\Users\Konta\mseide\lib\msedos\hxdos\shell32.dll';



type
  PCZZSTR = PChar;
  _SHFILEOPSTRUCTA = record
    hwnd       : HWND;
    wFunc      : UINT;
    pFrom      : PCZZSTR;
    pTo        : PCZZSTR;
    fFlags     : FILEOP_FLAGS;
    fAnyOperationsAborted: BOOL;
    hNameMappings        : LPVOID;
    lpszProgressTitle    : PCSTR;
  end;
  SHFILEOPSTRUCTA = _SHFILEOPSTRUCTA;
  LPSHFILEOPSTRUCTA = ^SHFILEOPSTRUCTA;

function ShellExecuteA(
  wnd: HWND;
  lpOperation : LPCSTR;
  lpFile      : LPCSTR;
  lpParameters: LPCSTR;
  lpDirectory : LPCSTR;
  nShowCmd    : Integer
  ): HINSTANCE;
{$ifdef HX_DOS}
stdcall; external shell32 name 'ShellExecuteA';
{$endif}

function SHCreateDirectoryExW(
  wnd: HWND;
  pszPath: LPCWSTR;
  var psa : SECURITY_ATTRIBUTES
  ): Integer;
{$ifdef HX_DOS}
stdcall; external shell32 name 'SHCreateDirectoryExW';
{$endif}

function SHFileOperationA(lpFileOp: LPSHFILEOPSTRUCTA): Integer;
{$ifdef HX_DOS}
stdcall; external shell32 name 'SHFileOperationA';
{$endif}

implementation

{$ifndef HX_DOS}

uses hxkernel;

function ShellExecuteA(
  wnd: HWND;
  lpOperation : LPCSTR;
  lpFile      : LPCSTR;
  lpParameters: LPCSTR;
  lpDirectory : LPCSTR;
  nShowCmd    : Integer
  ): HINSTANCE;
var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  SecurityAttr: TSecurityAttributes;
  PipeOutputRead: THandle;
  PipeOutputWrite: THandle;
  PipeErrorsRead: THandle;
  PipeErrorsWrite: THandle;
  Succeed: Boolean;
  Buffer: array [0..255] of Char;
  NumberOfBytesRead: DWORD;
  Stream: TMemoryStream;
  
begin
  FillChar(ProcessInfo, SizeOf(TProcessInformation), 0);

  //Initialisierung SecurityAttr

  FillChar(SecurityAttr, SizeOf(TSecurityAttributes), 0);

  SecurityAttr.nLength := SizeOf(SecurityAttr);
  SecurityAttr.bInheritHandle := true;
  SecurityAttr.lpSecurityDescriptor := nil;

  //Pipes erzeugen

  CreatePipe(PipeOutputRead, PipeOutputWrite, @SecurityAttr, 0);
  CreatePipe(PipeErrorsRead, PipeErrorsWrite, @SecurityAttr, 0);

  //Initialisierung StartupInfo

  FillChar(StartupInfo, SizeOf(TStartupInfo), 0);
  StartupInfo.cb:=SizeOf(StartupInfo);
  StartupInfo.hStdInput := 0;
  StartupInfo.hStdOutput := PipeOutputWrite;
  StartupInfo.hStdError := PipeErrorsWrite;
  StartupInfo.wShowWindow := sw_Hide;
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;

  if lpOperation = 'edit' then else
  if lpOperation = 'explore' then else
  if lpOperation = 'find' then else
  if lpOperation = 'open' then else
  if lpOperation = 'print' then else
  if lpOperation = NIL then
  begin 
    GetCurrentDirectoryA(255,Buffer);
    CreateProcessA(
      'command.com',
      lpDirectory + lpFile + lpParameters,
      nil,nil,
      true,
      0,
      nil,
      @Buffer,
      StartUpInfo,
      ProcessInfo
  );
  end;
end;

function SHCreateDirectoryExW(
  wnd: HWND;
  pszPath: LPCWSTR;
  var psa : SECURITY_ATTRIBUTES
  ): Integer;
begin
  CreateDirectoryA(pszPath,psa);
end;

function SHFileOperationA(lpFileOp: LPSHFILEOPSTRUCTA): Integer;
var
 FSrcHandle: THandle; 
 FDstHandle: THandle;
 DstFile,
 SrcFile: File;
 BytePos: Longint;
begin
  if lpFileOp <> NIL then
    case lpFileOp^.wFunc of
      FO_COPY:
        begin
          AssignFile(SrcFile,String(lpFileOp^.pFrom));
          AssignFile(DstFile,String(lpFileOp^.pTo));
          FSrcHandle := FileOpen(lpFileOp^.pFrom,ofReadWrite);
          FDstHandle := FileCreate(lpFileOp^.pTo);
          For BytePos := 0 to FileSize(SrcFile) do
          begin
            FileRead(FSrcHandle,Buffer,1);
            FileWrite(FDstHandle,Buffer,1);
          end;
        end;
      FO_DELETE:
        begin
          DeleteFile(lpFileOp^.pFrom);
        end;
      FO_MOVE:
        begin
          AssignFile(SrcFile,String(lpFileOp^.pFrom));
          AssignFile(DstFile,String(lpFileOp^.pTo));
          FSrcHandle := FileOpen(lpFileOp^.pFrom,ofReadWrite);
          FDstHandle := FileCreate(lpFileOp^.pTo);
          For BytePos := 0 to FileSize(SrcFile) do
          begin
            FileRead(FSrcHandle,Buffer,1);
            FileWrite(FDstHandle,Buffer,1);
          end;
          DeleteFile(lpFileOp^.pFrom);
        end;
      FO_RENAME:
        begin
          RenameFile(lpFileOp^.pFrom,lpFileOp^.pTo);
        end;
    end;
end;

{$endif}

end.

