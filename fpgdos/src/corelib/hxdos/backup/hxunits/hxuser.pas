unit hxuser;

{$mode objfpc}{$H+}

interface

{$define HX_DOS}

uses
  Classes, SysUtils, qtwinapi;

//const
//  userdll = {$ifdef link_dynamic}'c:\Users\Konta\mseide\lib\msedos\hxdos\duser32.dll'{$else}'c:\programs\fpc\fpgdos\src\lib\i386go32\DUSER32S.LIB'{$endif};

{$Linklib DUSER32S.LIB}

function AdjustWindowRect(
 var lpRect : RECT;
     dwStyle: DWORD;
     bMenu  : BOOL
    ): BOOL;
  {$ifdef HX_DOS}
  stdcall; external name 'AdjustWindowRect';
  {$endif}

function AdjustWindowRectEx(
 var lpRect   : RECT;
     dwStyle  : DWORD;
     bMenu    : BOOL;
    dwExStyle: DWORD
    ): BOOL;

//momentan Dummy - ALternative suchen!
function AttachThreadInput(iAttach,iAttachTo:DWORD; fAttach: Boolean): Boolean;

function BeginPaint(Handle: hWnd; Var PS : TPaintStruct) : hdc;
  {$ifdef HX_DOS}
  stdcall; external name 'BeginPaint';
  {$endif}

function BringWindowToTop(wnd: HWND): BOOL;
  {$ifdef HX_DOS}
  stdcall; external name 'BringWindowToTop';
  {$endif}

function CallNextHookEx(
    hhk: HHOOK;
    nCode: Integer;
    w: WPARAM;
    l: LPARAM
    ): LRESULT;

function ClientToScreen(Handle: HWND; P: PPoint) : BOOL;
  {$ifdef HX_DOS}
  stdcall; external name 'ClientToScreen';
  {$endif}

function CloseClipboard: BOOL;
  {$ifdef HX_DOS}
  stdcall; external name 'CloseClipboard';
  {$endif}

function CreateCursor(
  hInst: HINSTANCE;
  xHotSpot,yHotSpot: Integer;
  nWidth,nHeight: Integer;
  pvANDPlane: Pointer;
  pvXORPlane: Pointer
  ): HCURSOR;
  {$ifdef HX_DOS}
  stdcall; external name 'CreateCursor';
  {$endif}

function CreateIcon(
  hInst: HINSTANCE;
  xHotSpot,yHotSpot: Integer;
  nWidth,nHeight: Integer;
  pvANDPlane: Pointer;
  pvXORPlane: Pointer
  ): HICON;
  {$ifdef HX_DOS}
  stdcall; external name 'CreateIcon';
  {$endif}

function CreateIconIndirectD(iconinfo: PICONINFO): HICON;
{$ifdef HX_DOS}
stdcall; external name 'CreateIconIndirect';
{$endif}

function CreateIconIndirect(iconinfo: PICONINFO): HICON;

function CreateMenu: HMENU;
{$ifdef HX_DOS}
stdcall; external name 'CreateMenu';
{$endif}

function CreatePopupMenu: HMENU;
{$ifdef HX_DOS}
stdcall; external name 'CreatePopupMenu';
{$endif}

function CreateWindow(lpClassName: LPCSTR;
    			lpWindowName: LPCSTR; dwStyle: DWORD; X, Y: int;
			    nWidth, nHeight: int; hwndParent: HWND; Menu: HMENU;
			    Instance: HINSTANCE; lpParam: Pointer): HWND;

function CreateWindowEx(dwExStyle: DWORD;
                lpClassName: LPCSTR;
    			lpWindowName: LPCSTR; dwStyle: DWORD; X, Y: int;
			    nWidth, nHeight: int; hwndParent: HWND; Menu: HMENU;
			    Instance: HINSTANCE; lpParam: Pointer): HWND;
{$ifdef HX_DOS}
stdcall; external name 'CreateWindowExA';
{$endif}

function DefWindowProc(wnd: HWND; msg: UINT; w: WPARAM; l: LPARAM): LRESULT;
{$ifdef HX_DOS}
stdcall; external name 'DefWindowProcA';
{$endif}

function DefWindowProcA(wnd: HWND; msg: UINT; w: WPARAM; l: LPARAM): LRESULT;
{$ifdef HX_DOS}
stdcall; external name 'DefWindowProcA';
{$endif}

function DefWindowProcW(wnd: HWND; msg: UINT; w: WPARAM; l: LPARAM): LRESULT;
{$ifdef HX_DOS}
stdcall; external name 'DefWindowProcA';
{$endif}

function DestroyIconD(Icon: HICON): BOOL;
  {$ifdef HX_DOS}
  stdcall; external name 'DestroyIcon';
  {$endif}

function DeleteMenu(menu: HMENU; uPosition,uFlags: UINT): BOOL;
  {$ifdef HX_DOS}
  stdcall; external name 'DeleteMenu';
  {$endif}

function DestroyMenu(menu: HMENU): BOOL;
  {$ifdef HX_DOS}
  stdcall; external name 'DestroyMenu';
  {$endif}

function DestroyIcon(icon: HICON): Boolean;

function DestroyWindow(wnd: HWND): BOOL;
  {$ifdef HX_DOS}
  stdcall; external name 'DestroyWindow';
  {$endif}

function DispatchMessage(Message: PMsg): LResult;
  {$ifdef HX_DOS}
  stdcall; external name 'DispatchMessageA';
  {$endif}

function DispatchMessageA(Message: PMsg): LResult;
  {$ifdef HX_DOS}
  stdcall; external name 'DispatchMessageA';
  {$endif}

function DispatchMessageW(Message: PMsg): LResult;
  {$ifdef HX_DOS}
  stdcall; external name 'DispatchMessageW';
  {$endif}

function DrawFocusRect(DC: HDC; const Rect: TRect): boolean;

function EmptyClipboard: BOOL;
  {$ifdef HX_DOS}
  stdcall; external name 'EmptyClipboard';
  {$endif}

function EndPaint(Handle: hwnd; var PS: TPaintStruct): Integer;
  {$ifdef HX_DOS}
  stdcall; external name 'EndPaint';
  {$endif}

function EnumWindows(lpEnumFunc: WNDENUMPROC; l: LPARAM): BOOL;
  {$ifdef HX_DOS}
  stdcall; external name 'EnumWindows';
  {$endif}

function EnumChildWindows(wndParent:HWND; lpEnumFunc:WNDENUMPROC; l:LPARAM): BOOL;
  {$ifdef HX_DOS}
  stdcall; external name 'EnumChildWindows';
  {$endif}

function EnumThreadWindows(dwThreadId: DWORD; lpfn:WNDENUMPROC; l:LPARAM): BOOL;
  {$ifdef HX_DOS}
  stdcall; external name 'EnumThreadWindows';
  {$endif}

function FillRect(dc: HDC; const rect: TRect; hbr: HBRUSH): Integer;
  {$ifdef HX_DOS}
  stdcall; external name 'FillRect';
  {$endif}

function FindWindowA(lpClassName: LPCSTR; lpWindowName: LPCSTR): HWND;
  {$ifdef HX_DOS}
  stdcall; external name 'FindWindowA';
  {$endif}

function FindWindowExA(
  hWndParent    : HWND;
  hWndChildAfter: HWND;
  lpszClass     : LPCSTR;
  lpszWindow    : LPCSTR
  ): HWND;
  {$ifdef HX_DOS}
  stdcall; external name 'FindWindowExA';
  {$endif}

function GetActiveWindow: HWND;
  {$ifdef HX_DOS}
  stdcall; external name 'GetActiveWindow';
  {$endif}

function FrameRect(DC: HDC; const ARect: TRect; hBr: HBRUSH): Integer;

function GetCapture: HWND;

function GetClassInfoA(
  Instance    : HINSTANCE;
  lpClassName : LPCSTR;
  lpWndClass  : LPWNDCLASS
  ): BOOL;
  {$ifdef HX_DOS}
  stdcall; external name 'GetClassInfoA';
  {$endif}

function GetClassInfoW(
  Instance    : HINSTANCE;
  lpClassName : LPCWSTR;
  lpWndClass  : LPWNDCLASSW
): BOOL;
  {$ifdef HX_DOS}
  stdcall; external name 'GetClassInfoW';
  {$endif}

function GetClassInfoExA(
  Instance : HINSTANCE;
  lpszClass: LPCSTR;
  lpwcx    : LPWNDCLASSEX
  ): BOOL;
  {$ifdef HX_DOS}
  stdcall; external name 'GetClassInfoExA';
  {$endif}

function GetClassInfoExW(
  Instance : HINSTANCE;
  lpszClass: LPCWSTR;
  lpwcx    : LPWNDCLASSEXW
): BOOL;
  {$ifdef HX_DOS}
  stdcall; external name 'GetClassInfoExW';
  {$endif}

function GetClassLongA(wnd: HWND; Index: Integer): DWORD;
  {$ifdef HX_DOS}
  stdcall; external name 'GetClassLongA';
  {$endif}

function GetClassLongW(wnd: HWND; Index: Integer): DWORD;
  {$ifdef HX_DOS}
  stdcall; external name 'GetClassLongW';
  {$endif}

function GetClassNameA(wnd: HWND; lpClassName: LPSTR; nMaxCount: Integer): Integer;
  {$ifdef HX_DOS}
  stdcall; external name 'GetClassNameA';
  {$endif}

function GetClassNameW(wnd: HWND; lpClassName: LPWSTR; nMaxCount: Integer): Integer;
  {$ifdef HX_DOS}
  stdcall; external name 'GetClassNameW';
  {$endif}

function GetClientRect(handle : HWND; var ARect : TRect) : Boolean;
  {$ifdef HX_DOS}
  stdcall; external name 'GetClientRect';
  {$endif}

function GetCursorPos(var lpPoint: TPoint ): Boolean;
  {$ifdef HX_DOS}
  stdcall; external name 'GetCursorPos';
  {$endif}

function GetClipboardFormatNameA(
   format         : UINT;
   lpszFormatName : LPSTR;
   cchMaxCount    : Integer
   ): Integer;
  {$ifdef HX_DOS}
  stdcall; external name 'GetClipboardFormatNameA';
  {$endif}

function GetClipboardFormatNameW(
   format         : UINT;
   lpszFormatName : PWideChar;
   cchMaxCount    : Integer
   ): Integer;

function GetClipboardOwner: HWND;
  {$ifdef HX_DOS}
  stdcall; external name 'GetClipboardOwner';
  {$endif}

function GetDC(wnd: HWND): HDC;
  {$ifdef HX_DOS}
  stdcall; external name 'GetDC';
  {$endif}

function GetDesktopWindow: HWND;

function GetFocus: HWND;
  {$ifdef HX_DOS}
  stdcall; external name 'GetFocus';
  {$endif}

function GetKeyState(nVirtKey: Integer): Longint;
  {$ifdef HX_DOS}
  stdcall; external name 'GetKeyState';
  {$endif}

function GetKeyboardState(lpKeystate: PByte): BOOL;
  {$ifdef HX_DOS}
  stdcall; external name 'GetKeyboardState';
  {$endif}


function  GetMessage(var Msg: TMsg; wnd: HWND; wMsgFilterMin,wMsgFilterMax: UINT): Boolean;
  {$ifdef HX_DOS}
  stdcall; external name 'GetMessageA';
  {$endif}

function GetSystemMetrics(nIndex: Integer): Integer;
  {$ifdef HX_DOS}
  stdcall; external name 'GetSystemMetrics';
  {$endif}

function GetWindowLong(wnd: HWND; nIndex: Integer): Longint;
  {$ifdef HX_DOS}
   stdcall; external name 'GetWindowLongA';
  {$endif}

function GetWindowLongPtr(wnd: HWND; nIndex: Integer): PLongint;

function GetWindowPlacement(wnd: HWND; var lpwndpl
: WINDOWPLACEMENT): BOOL;
  {$ifdef HX_DOS}
   stdcall; external name 'GetWindowPlacement';
  {$endif}

function GetWindowRect(Handle: hwnd; var ARect: TRect): BOOL;
  {$ifdef HX_DOS}
   stdcall; external name 'GetWindowRect';
  {$endif}

function GetWindowThreadProcessId(wnd: HWND; lpdwProcessId: LPDWORD): DWORD;
  {$ifdef HX_DOS}
   stdcall; external name 'GetWindowThreadProcessId';
  {$endif}

function InvalidateRect(wnd: HWND; lpr: LPRECT; bErase: BOOL): BOOL;
  {$ifdef HX_DOS}
   stdcall; external name 'InvalidateRect';
  {$endif}

function IsClipBoardFormatAvailable(format: UINT): Boolean;
  {$ifdef HX_DOS}
   stdcall; external name 'IsClipboardFormatAvailable';
  {$endif}

//laut Doku enthalten aber in duser32.txt nicht aufgeführt
//im Zweifelsfall eigene Implementation
function IsWindowVisible(wnd: HWND): Boolean;
  {$ifdef HX_DOS}
   stdcall; external name 'IsWindowVisible';
  {$endif}

function KillTimer(h: HWND; uIDEvent: UINT_PTR): Boolean;
  {$ifdef HX_DOS}
   stdcall; external name 'KillTimer';
  {$endif}

function LoadBitmapA(Instance: HINSTANCE; lpBitmapName: LPCSTR): HBITMAP;
  {$ifdef HX_DOS}
  stdcall; external name 'LoadBitmapA';
  {$endif}

function LoadCursor(Instance: HINSTANCE; lpCursorName
: LPCSTR): HCURSOR;
  {$ifdef HX_DOS}
  stdcall; external name 'LoadCursorA';
  {$endif}

function LoadCursorA(Instance: HINSTANCE; lpCursorName
  : LPCSTR): HCURSOR;
  {$ifdef HX_DOS}
  stdcall; external name 'LoadCursorA';
  {$endif}

function LoadCursorW(Instance: HINSTANCE; lpCursorName
  : LPCWSTR): HCURSOR;
    {$ifdef HX_DOS}
    stdcall; external name 'LoadCursorW';
    {$endif}

function LoadIconA(Instance: HINSTANCE; IconName: LPCSTR): HICON;
  {$ifdef HX_DOS}
  stdcall; external name 'LoadIconA';
  {$endif}

function LoadImageA(
   hInst  : HINSTANCE;
   name   : LPCSTR;
   imgtype: UINT;
   cx     : integer;
   cy     : integer;
   fuLoad : UINT): HANDLE;
  {$ifdef HX_DOS}
  stdcall; external name 'LoadImageA';
  {$endif}

function MapVirtualKeyA(ucode,uMapType: UINT): UINT;
  {$ifdef HX_DOS}
  stdcall; external name 'MapVirtualKeyA';
  {$endif}

function MapVirtualKeyExA(ucode,uMapType: UINT; dwHkl: HKL): UINT;
  {$ifdef HX_DOS}
  stdcall; external name 'MapVirtualKeyExA';
  {$endif}

function MapVirtualKey(ucode,uMapType: UINT): UINT;

function MapVirtualKeyEx(ucode,uMapType: UINT; dwHkl: HKL): UINT;

function MoveWindow(wnd:HWND; x,y,nWidth,hHeight:Integer; bRepaint:BOOL): BOOL;
  {$ifdef HX_DOS}
  stdcall; external name 'MoveWindow';
  {$endif}

function MsgWaitForMultipleObjects(
  nCount: DWORD;
  pHandles: PHandle;
  fWaitAll: BOOL;
  dwMilliseconds: DWORD;
  dwWakeMask: DWORD
): DWORD;
  {$ifdef HX_DOS}
  stdcall; external name 'MsgWaitForMultipleObjects';
  {$endif}

function MessageBeep(uType: UINT): Boolean;
  {$ifdef HX_DOS}
  stdcall; external name 'MessageBeep';
  {$endif}

function OemToCharA(pSrc: LPCSTR; pDst: LPSTR): BOOL;
{$ifdef HX_DOS}
stdcall; external name 'OemToCharA';
{$endif}

function OemToCharBuffA(lpszSrc:LPCSTR; lpszDst:LPSTR; cchDstLength:DWORD):BOOL;
{$ifdef HX_DOS}
stdcall; external name 'OemToCharBuffA';
{$endif}

function OemToCharBuffW(lpszSrc:LPCSTR; lpszDst:LPSTR; cchDstLength:DWORD):BOOL;
{$ifdef HX_DOS}
stdcall; external name 'OemToCharBuffW';
{$endif}

function OemToCharW(pSrc: LPCSTR; pDst: LPSTR): BOOL;
{$ifdef HX_DOS}
stdcall; external name 'OemToCharW';
{$endif}

function OpenClipboard(hWndNewOwner: HWND): BOOL;
{$ifdef HX_DOS}
stdcall; external name 'OpenClipboard';
{$endif}

function PeekMessage(var Msg: TMsg; wnd: HWND; wMsgFilterMin,wMsgFilterMax,wRemoveMsg
: UINT): Boolean;
  {$ifdef HX_DOS}
  stdcall; external name 'PeekMessageA';
  {$endif}

function PeekMessageA(var Msg: TMsg; wnd: HWND; wMsgFilterMin,wMsgFilterMax,wRemoveMsg
  : UINT): Boolean;
  {$ifdef HX_DOS}
  stdcall; external name 'PeekMessageA';
  {$endif}

function PeekMessageW(var Msg: TMsg; wnd: HWND; wMsgFilterMin,wMsgFilterMax,wRemoveMsg
  : UINT): Boolean;
  {$ifdef HX_DOS}
  stdcall; external name 'PeekMessageA';
  {$endif}

function PostMessage(HandleWnd: HWND; Msg: Cardinal; w: WParam; l: LParam): Boolean;
  {$ifdef HX_DOS}
  stdcall; external name 'PostMessageA';
  {$endif}

function PostMessageA(HandleWnd: HWND; Msg: Cardinal; w: WParam; l: LParam): Boolean;
  {$ifdef HX_DOS}
  stdcall; external name 'PostMessageA';
  {$endif}

function PostMessageW(HandleWnd: HWND; Msg: Cardinal; w: WParam; l: LParam): Boolean;
  {$ifdef HX_DOS}
  stdcall; external name 'PostMessageA';
  {$endif}

function PostThreadMessageW(idThread: DWORD; Msg: UINT; w: WPARAM; l: LPARAM): Boolean;
  {$ifdef HX_DOS}
  stdcall; external name 'PostThreadMessageA';
  {$endif}

procedure PostQuitMessage(nExitCode: Integer);
  {$ifdef HX_DOS}
  stdcall; external name 'PostQuitMessage';
  {$endif}

function ReleaseCapture : Boolean;  //In HXDOS nicht vorhanden, selber implementieren!

function ReleaseDC(Wnd: HWND; DC: HDC): Integer;
  {$ifdef HX_DOS}
  stdcall; external name 'ReleaseDC';
  {$endif}

function Registerclass(var lpWndClass: TWndClass): Word;
function RegisterclassEx(var lpwcx: TWndClassEx): Word;

function RegisterClassA(var lpWndClass: TWndClass): Word;
{$ifdef HX_DOS}
stdcall; external name 'RegisterClassA';
{$endif}

function RegisterClassW(var lpWndClass: TWndClass): Word;
{$ifdef HX_DOS}
stdcall; external name 'RegisterClassW';
{$endif}

function RegisterClassExA(var lpwcx: TWndClassEx): Word;
{$ifdef HX_DOS}
stdcall; external name 'RegisterClassExA';
{$endif}

function RegisterClassExW(var lpwcx: TWndClassEx): Word;
{$ifdef HX_DOS}
stdcall; external name 'RegisterClassExW';
{$endif}

function RegisterClipBoardFormatA(
   lpszFormat         : LPCSTR
): UINT;
  {$ifdef HX_DOS}
  stdcall; external name 'RegisterClipBoardFormatA';
  {$endif}

function RegisterClipBoardFormatNameA(
   format         : UINT;
   lpszFormatName : LPSTR;
   cchMaxCount    : Integer
): Integer;

function GetClipboardData(uFormat: UINT): HANDLE;
  {$ifdef HX_DOS}
  stdcall; external name 'GetClipboardData';
  {$endif}

function PtInRect(lprc: TRect; point: TPoint): BOOL;
{$ifdef HX_DOS}
stdcall; external name 'PtInRect';
{$endif}

function ScreenToClient(Handle : HWND; P : PPoint) : BOOL;
  {$ifdef HX_DOS}
  stdcall; external name 'ScreenToClient';
  {$endif}

function SendMessage(HandleWnd: HWND; Msg: Cardinal; w: WParam; l: LParam): LResult;
  {$ifdef HX_DOS}
  stdcall; external name 'SendMessageA';
  {$endif}

function SetActiveWindow(wnd: HWND): HWND;
  {$ifdef HX_DOS}
  stdcall; external name 'SetActiveWindow';
  {$endif}

//zunächst Dummy. In DUser32 gar nicht enthalten, daher später eigene Implementierung finden
function SetLayeredWindowAttributes(
    wnd: HWND;
    crKey: COLORREF;
    bAlpha: BYTE;
    dwFlags: DWORD
  ): BOOL;

function SetTimer(h: HWND; nIDEvent: UINT_PTR; uElapse: UINT; lpTimerFunc: TIMERPROC): UINT_PTR;
  {$ifdef HX_DOS}
  stdcall; external name 'SetTimer';
  {$endif}

function SetWindowsHookExA(
    idHook: Integer;
    lpfn  : HOOKPROC;
    hmod  : HINSTANCE;
    dwThreadId: DWORD
    ): HHOOK;

function SetWindowTextA(wnd: HWND; lpString: LPCSTR): Boolean;
  {$ifdef HX_DOS}
  stdcall; external name 'SetWindowTextA';
  {$endif}

function SetWindowTextW(wnd: HWND; lpString: LPCWSTR): Boolean;
  {$ifdef HX_DOS}
  stdcall; external name 'SetWindowTextW';
  {$endif}

function SetCursor(hCur: HCURSOR): HCURSOR;
  {$ifdef HX_DOS}
  stdcall; external name 'SetCursor';
  {$endif}

function TranslateMessage(Message: PMsg): Boolean;
  {$ifdef HX_DOS}
  stdcall; external name 'TranslateMessage';
  {$endif}

function Shell_NotifyIconA(dwMessage: DWORD; lpData: PNotifyIconDataA): BOOL;

function Shell_NotifyIconW(dwMessage: DWORD; lpData: PNotifyIconDataW): BOOL;

function ScrollWindow(Wnd: HWND; dx, dy: Integer; lpRect,lpClipRect: PRect): BOOL;
  {$ifdef HX_DOS}
   stdcall; external name 'ScrollWindow';
  {$endif}

function ScrollWindowEx(Wnd: HWND; dx, dy: Integer;
  prcScroll, prcClip: PRect;
   hrgnUpdate: HRGN; prcUpdate: PRect; flags: UINT): BOOL;

function SetCapture(AHandle: HWND): HWND; //In HXDOS nicht vorhanden, selber implementieren!

function SetClipboardData(uFormat: UINT; hmem: HANDLE = 0): HANDLE;
  {$ifdef HX_DOS}
   external name 'SetClipboardData';
  {$endif}

function SetCursorPos(x,y: Integer): Boolean;
  {$ifdef HX_DOS}
   external name 'SetCursorPos';
  {$endif}

function SetFocus(Wnd: HWND): HWND;
  {$ifdef HX_DOS}
   external name 'SetFocus';
  {$endif}

function SetForegroundWindow(Wnd: HWND): boolean;


function SetWindowLong(wnd: HWND; nIndex: Integer; dwNewLong: Longint): Longint;
  {$ifdef HX_DOS}
   external name 'SetWindowLongA';
  {$endif}

function SetWindowLongPtr(wnd: HWND; nIndex: Integer; dwNewLong: PLongint): PLongint;

function SetWindowPos(wnd,wndInsertAfter:HWND; x,y,cx,cy:Integer; uFlags: DWORD): Boolean;
  {$ifdef HX_DOS}
   external name 'SetWindowPos';
  {$endif}

function ShowWindow(hWnd: HWND; nCmdShow: Integer): Boolean;
  {$ifdef HX_DOS}
   external name 'ShowWindow';
  {$endif}

function SystemParametersInfo(
  uiAction : UINT;
  uiParam  : UINT;
  pvParam  : Pointer;
  fWinIni  : UINT
  ): BOOL;

function SystemParametersInfoA(
  uiAction : UINT;
  uiParam  : UINT;
  pvParam  : Pointer;
  fWinIni  : UINT
  ): BOOL;

function SystemParametersInfoW(
  uiAction : UINT;
  uiParam  : UINT;
  pvParam  : Pointer;
  fWinIni  : UINT
  ): BOOL;

function UnhookWindowsHookEx(hhk: HHOOK): BOOL;

function UnRegisterClass(lpClassName: LPCSTR; Instance: HINSTANCE): Boolean;
  {$ifdef HX_DOS}
  stdcall; external name 'UnRegisterClassA';
  {$endif}
function UnRegisterClassA(lpClassName: LPCSTR; Instance: HINSTANCE): Boolean;
  {$ifdef HX_DOS}
  stdcall; external name 'UnRegisterClassA';
  {$endif}

function UpdateWindow(Wnd: HWND): BOOL;
  {$ifdef HX_DOS}
   external name 'UpdateWindow';
  {$endif}

function WindowFromPoint(Point: TPoint): HWND;
  {$ifdef HX_DOS}
   external name 'WindowFromPoint';
  {$endif}

implementation

uses hxgdi;

function AdjustWindowRectEx(
 var  lpRect   : RECT;
      dwStyle  : DWORD;
      bMenu    : BOOL;
      dwExStyle: DWORD
    ): BOOL;
var
  wnd: HWND;
begin
  wnd := dwExStyle; //workaround to find window with spcified EX_Style
  dwExStyle := GetWindowLong(wnd, GWL_EXSTYLE);
  Result := AdjustWindowRect(lpRect,dwStyle,bMenu);
end;

function AttachThreadInput(iAttach,iAttachTo:DWORD; fAttach: Boolean): Boolean;
begin

end;

{$ifndef HX_DOS}
function CreateIcon(
  hInst: HINSTANCE;
  xHotSpot,yHotSpot: Integer;
  nWidth,nHeight: Integer;
  pvANDPlane: Pointer;
  pvXORPlane: Pointer
  ): HICON;
var
  iconinfo: PIconInfo;
begin

end;
{$endif}

function CreateIconIndirect(iconinfo: PICONINFO): HICON;
begin

  //{$ifdef HX_DOS}CreateIconIndirectD(iconinfo);{$endif}
end;

function DestroyIcon(icon: HICON): Boolean;
var res: Boolean;
begin
  //Dispose(PIconInfo(icon));
  //Result := PIconInfo(icon) = nil;
  {$ifdef HX_DOS}Res := DestroyIconD(icon){$endif}
end;

function Shell_NotifyIconA(dwMessage: DWORD; lpData: PNotifyIconDataA): BOOL;
begin
  PostMessage(0,dwMessage,WPARAM(lpData),0);
end;

function Shell_NotifyIconW(dwMessage: DWORD; lpData: PNotifyIconDataW): BOOL;
begin
  PostMessage(0,dwMessage,WPARAM(lpData),0);
end;

{$ifndef HX_DOS}
function AdjustWindowRect(
 var lpRect : RECT;
     dwStyle: DWORD;
     bMenu  : BOOL
    ): BOOL;
begin

end;

function BeginPaint(Handle: hWnd; Var PS : TPaintStruct) : hdc;
begin

end;

function BringWindowToTop(wnd: HWND): BOOL;
begin

end;

function ClientToScreen(Handle: HWND; P: PPoint) : BOOL;
begin

end;

function CloseClipboard: BOOL;
begin

end;

function CreateCursor(
  hInst: HINSTANCE;
  xHotSpot,yHotSpot: Integer;
  nWidth,nHeight: Integer;
  pvANDPlane: Pointer;
  pvXORPlane: Pointer
  ): HCURSOR;
begin

end;

function CreateIconIndirectD(iconinfo: PICONINFO): HICON;
begin

end;

function CreateMenu: HMENU;
begin

end;

function CreatePopupMenu: HMENU;
begin

end;

function CreateWindowEx(dwExStyle: DWORD;
                lpClassName: LPCSTR;
    			lpWindowName: LPCSTR; dwStyle: DWORD; X, Y: int;
			    nWidth, nHeight: int; hwndParent: HWND; Menu: HMENU;
			    Instance: HINSTANCE; lpParam: Pointer): HWND;
begin

end;

function DefWindowProc(wnd: HWND; msg: UINT; w: WPARAM; l: LPARAM): LRESULT;
begin

end;

function DefWindowProcA(wnd: HWND; msg: UINT; w: WPARAM; l: LPARAM): LRESULT;
begin

end;

function DefWindowProcW(wnd: HWND; msg: UINT; w: WPARAM; l: LPARAM): LRESULT;
begin

end;

function DestroyIconD(icon: HICON): BOOL;
begin

end;

function DestroyMenu(menu: HMENU): BOOL;
begin

end;

function DeleteMenu(menu: HMENU; uPosition,uFlags: UINT): BOOL;
begin

end;

function DestroyWindow(wnd: HWND): BOOL;
begin

end;

function DispatchMessage(Message: PMsg): LResult;
begin

end;

function DispatchMessageA(Message: PMsg): LResult;
begin

end;

function DispatchMessageW(Message: PMsg): LResult;
begin

end;

function EmptyClipboard: BOOL;
begin

end;

function EndPaint(Handle: hwnd; var PS: TPaintStruct): Integer;
begin

end;

function EnumWindows(lpEnumFunc: WNDENUMPROC; l: LPARAM): BOOL;
begin

end;

function EnumChildWindows(wndParent:HWND; lpEnumFunc:WNDENUMPROC; l:LPARAM): BOOL;
begin

end;

function EnumThreadWindows(dwThreadId: DWORD; lpfn:WNDENUMPROC; l:LPARAM): BOOL;
begin

end;

function FillRect(dc: HDC; const rect: TRect; hbr: HBRUSH): Integer;
begin

end;

function FindWindowA(lpClassName: LPCSTR; lpWindowName: LPCSTR): HWND;
begin

end;

function FindWindowExA(
  hWndParent    : HWND;
  hWndChildAfter: HWND;
  lpszClass     : LPCSTR;
  lpszWindow    : LPCSTR
  ): HWND;
begin

end;

function GetActiveWindow: HWND;
begin

end;

function GetClassInfoA(
  Instance    : HINSTANCE;
  lpClassName : LPCSTR;
  lpWndClass  : LPWNDCLASSA
  ): BOOL;
begin

end;

function GetClassInfoW(
  Instance    : HINSTANCE;
  lpClassName : LPCWSTR;
  lpWndClass  : LPWNDCLASSW
): BOOL;
begin

end;

function GetClassInfoExA(
  Instance : HINSTANCE;
  lpszClass: LPCSTR;
  lpwcx    : LPWNDCLASSEXA
  ): BOOL;
begin

end;

function GetClassInfoExW(
  Instance : HINSTANCE;
  lpszClass: LPCWSTR;
  lpwcx    : LPWNDCLASSEXW
): BOOL;
begin

end;

function GetClassLongA(wnd: HWND; Index: Integer): DWORD;
begin

end;

function GetClassLongW(wnd: HWND; Index: Integer): DWORD;
begin

end;

function GetClassNameA(wnd: HWND; lpClassName: LPSTR; nMaxCount: Integer): Integer;
begin

end;

function GetClassNameW(wnd: HWND; lpClassName: LPWSTR; nMaxCount: Integer): Integer;
begin

end;

function GetClientRect(handle : HWND; var ARect : TRect) : Boolean;
begin

end;

function GetClipboardData(uFormat: UINT): HANDLE;
begin

end;

function GetClipboardFormatNameA(
   format         : UINT;
   lpszFormatName : LPSTR;
   cchMaxCount    : Integer
   ): Integer;
begin

end;

function GetClipboardOwner: HWND;
begin

end;

function GetCursorPos(var lpPoint: TPoint ): Boolean;
begin

end;

function GetDC(wnd: HWND): HDC;
begin

end;

function GetFocus: HWND;
begin

end;

function GetKeyState(nVirtKey: Integer): Longint;
begin

end;

function GetKeyboardState(lpKeystate: PByte): BOOL;
begin

end;

function GetMessage(var Msg: TMsg; wnd: HWND; wMsgFilterMin,wMsgFilterMax: UINT): Boolean;
begin

end;

function GetSystemMetrics(nIndex: Integer): Integer;
begin

end;

function GetWindowLong(wnd: HWND; nIndex: Integer): Longint;
begin

end;

function GetWindowPlacement(wnd: HWND; var lpwndpl: WINDOWPLACEMENT): BOOL;
begin

end;

function GetWindowRect(Handle: hwnd; var ARect: TRect): BOOL;
begin

end;

function GetWindowThreadProcessId(wnd: HWND; lpdwProcessId: LPDWORD): DWORD;
begin

end;

function InvalidateRect(wnd: HWND; lpr: LPRECT; bErase: BOOL): BOOL;
begin

end;

function IsClipBoardFormatAvailable(format: UINT): Boolean;
begin

end;

function IsWindowVisible(wnd: HWND): Boolean;
begin

end;

function KillTimer(h: HWND; uIDEvent: UINT_PTR): Boolean;
begin

end;

function LoadBitmapA(Instance: HINSTANCE; lpBitmapName: LPCSTR): HBITMAP;
begin

end;

function LoadCursor(Instance: HINSTANCE; lpCursorName
: LPCSTR): HCURSOR;
begin

end;

function LoadCursorA(Instance: HINSTANCE; lpCursorName
  : LPCSTR): HCURSOR;
begin

end;

function LoadCursorW(Instance: HINSTANCE; lpCursorName
  : LPCWSTR): HCURSOR;
begin

end;

function LoadIconA(Instance: HINSTANCE; IconName: LPCSTR): HICON;
begin

end;

function LoadImageA(
   hInst  : HINSTANCE;
   name   : LPCSTR;
   imgtype: UINT;
   cx     : integer;
   cy     : integer;
   fuLoad : UINT): HANDLE;
begin

end;

function MapVirtualKeyA(ucode,uMapType: UINT): UINT;
begin

end;

function MapVirtualKeyExA(ucode,uMapType: UINT; dwHkl: HKL): UINT;
begin

end;

function MessageBeep(uType: UINT): Boolean;
begin

end;

function MoveWindow(wnd:HWND; x,y,nWidth,hHeight:Integer; bRepaint:BOOL): BOOL;
begin

end;

function OemToCharA(pSrc: LPCSTR; pDst: LPSTR): BOOL;
begin

end;

function OemToCharBuffA(lpszSrc:LPCSTR; lpszDst:LPSTR; cchDstLength:DWORD):BOOL;
begin

end;

function OemToCharBuffW(lpszSrc:LPCSTR; lpszDst:LPSTR; cchDstLength:DWORD):BOOL;
begin

end;

function OemToCharW(pSrc: LPCSTR; pDst: LPSTR): BOOL;
begin

end;

function OpenClipboard(hWndNewOwner: HWND): BOOL;
begin

end;

function MsgWaitForMultipleObjects(
  nCount: DWORD;
  pHandles: PHandle;
  fWaitAll: BOOL;
  dwMilliseconds: DWORD;
  dwWakeMask: DWORD
): DWORD;
begin

end;

function PeekMessage(var Msg: TMsg; wnd: HWND; wMsgFilterMin,wMsgFilterMax,wRemoveMsg
: UINT): Boolean;
begin

end;

function PeekMessageA(var Msg: TMsg; wnd: HWND; wMsgFilterMin,wMsgFilterMax,wRemoveMsg
: UINT): Boolean;
begin

end;

function PeekMessageW(var Msg: TMsg; wnd: HWND; wMsgFilterMin,wMsgFilterMax,wRemoveMsg
: UINT): Boolean;
begin

end;

function PostMessage(HandleWnd: HWND; Msg: Cardinal; w: WParam; l: LParam): Boolean;
begin

end;

function PostMessageA(HandleWnd: HWND; Msg: Cardinal; w: WParam; l: LParam): Boolean;
begin

end;

function PostMessageW(HandleWnd: HWND; Msg: Cardinal; w: WParam; l: LParam): Boolean;
begin

end;

function PostThreadMessage(idThread: DWORD; Msg: UINT; w: WPARAM; l: LPARAM): Boolean;
begin

end;

function PostThreadMessageW(idThread: DWORD; Msg: UINT; w: WPARAM; l: LPARAM): Boolean;
begin

end;

procedure PostQuitMessage(nExitCode: Integer);
begin

end;

function ReleaseDC(Wnd: HWND; DC: HDC): Integer;
begin

end;

function ScreenToClient(Handle : HWND; P : PPoint) : BOOL;
begin

end;

function SendMessage(HandleWnd: HWND; Msg: Cardinal; w: WParam; l: LParam): LResult;
begin

end;

function SetTimer(h: HWND; nIDEvent: UINT_PTR; uElapse: UINT; lpTimerFunc: TIMERPROC): UINT_PTR;
begin
  //Sleep(uElapse);
  if Assigned(lpTimerFunc) then lpTimerFunc(h, WM_TIMER, nIDEvent, GetTickCount);
  //PostMessage(h,WM_TIMER,Longint(nIDEvent),Longint(lpTimerFunc));
end;

function TranslateMessage(Message: PMsg): Boolean;
begin

end;

function PtInRect(lprc: TRect; point: TPoint): BOOL;
begin

end;

function RegisterClassA(var lpWndClass: PWndClass): Word;
begin

end;

function RegisterClassW(var lpWndClass: PWndClass): Word;
begin

end;

function RegisterClassExA(var lpwcx: PWndClassEx): Word;
begin

end;

function RegisterClassExW(var lpwcx: PWndClassEx): Word;
begin

end;

function RegisterClipBoardFormatA(
   lpszFormat         : LPCSTR
): UINT;
begin

end;

function ScrollWindow(Wnd: HWND; dx, dy: Integer; lpRect,lpClipRect: PRect): BOOL;
begin

end;
{$endif}


function CreateWindow(lpClassName: LPCSTR;
    			lpWindowName: LPCSTR; dwStyle: DWORD; X, Y: int;
			    nWidth, nHeight: int; hwndParent: HWND; Menu: HMENU;
			    Instance: HINSTANCE; lpParam: Pointer): HWND;
begin
  Result := CreateWindowEx(0,
                           lpClassName,
                           lpWindowName,
                           dwStyle,X,Y,
                           nWidth,nHeight,
                           hwndParent,
                           Menu,
                           Instance,
                           lpParam
                           );
end;

function GetCapture: HWND;
begin
  //GetFocus für Tastaturfokus, aber hier ist Mausfokus gemeint
end;

function GetClipboardFormatNameW(
   format         : UINT;
   lpszFormatName : PWideChar;
   cchMaxCount    : Integer
   ): Integer;
begin
  Result := GetClipboardFormatNameA(format,PChar(lpszFormatName),cchMaxCount);
end;

function ReleaseCapture : Boolean;  //In HXDOS nicht vorhanden, selber implementieren!
var r: TRect; p: TPoint;
begin
  {
  if GetWindowRect(AHandle,r) then
  if not PtInRect(r, p) then
  begin

    Result := true;
  end;
  }
end;

function RegisterClass(var lpWndClass: TWndClass): Word;
begin
  Result := RegisterClassA(lpwndClass);
end;

function RegisterClassEx(var lpwcx: TWndClassEx): Word;
begin
  Result := RegisterClassExA(lpwcx);
end;

function RegisterClipBoardFormatNameA(
   format         : UINT;
   lpszFormatName : LPSTR;
   cchMaxCount    : Integer
): Integer;
begin
  //mit Anweisungen in meswindnd verknüpfen
  //um zB. die vordefinierten Formate mit Formatnamen zu verbinden
  RegisterClipboardFormatA(lpszFormatName);
end;

function SetCapture(AHandle: HWND): HWND; //In HXDOS nicht vorhanden, selber implementieren!
var r: TRect; p: TPoint;
begin
  if GetWindowRect(AHandle,r) then
  if PtInRect(r, p) then
  begin
    Result := SetFocus(AHandle);
  end;
end;

function ScrollWindowEx(Wnd: HWND; dx, dy: Integer;
  prcScroll, prcClip: PRect;
   hrgnUpdate: HRGN; prcUpdate: PRect; flags: UINT): BOOL;
begin
  case flags of
   SW_ERASE:
     begin

       ScrollWindow(Wnd,dx,dy,prcScroll,prcClip);
     end;
   SW_INVALIDATE:
     begin

       ScrollWindow(Wnd,dx,dy,prcScroll,prcClip);
     end;
   SW_SCROLLCHILDREN:
     begin

       ScrollWindow(Wnd,dx,dy,prcScroll,prcClip);
     end;
   {
   SW_SMOOTHSCROLL:
     begin

       ScrollWindow(Wnd,dx,dy,prcScroll,prcClip);
     end;
   }
  end;
  UpdateWindow(Wnd);
end;

{$ifndef HX_DOS}

function UpdateWindow(Wnd: HWND): BOOL;
begin

end;

function UnRegisterClass(lpClassName: LPCSTR; Instance: HINSTANCE): Boolean;
var
  idx: Integer;
  wdh: HWND;
  wnd: TWindowHandle;
begin
  idx := 0;
  while idx < WindowList.Count do
  begin
    wnd := WindowList.Window(idx);
    wnd.Instance := Instance;
    //Dispose(Pointer(wnd.Instance);
    if wnd.ClassName = lpClassName then
    begin
      WindowList.Remove(wnd);
      idx := WindowList.Count;
      Result := true;
    end;
    inc(idx);
  end;
end;

function SetClipboardData(uFormat: UINT; hmem: HANDLE = 0): HANDLE;
begin

end;

function SetCursorPos(x,y: Integer): Boolean;
begin

end;

function SetCursor(hCur: HCURSOR): HCURSOR;
begin

end;

function SetFocus(Wnd: HWND): HWND;
begin

end;
{$endif}

function MapVirtualKey(uCode,UMapType: UINT): UINT;
begin
  Result := MapVirtualKeyA(uCode,UMapType);
end;

function MapVirtualKeyEx(ucode,uMapType: UINT; dwHkl: HKL): UINT;
begin
  Result := MapVirtualKeyExA(ucode,uMapType,dwHkl);
end;

function SetForegroundWindow(Wnd: HWND): boolean;
begin
  {$ifdef HX_DOS}SetActiveWindow(Wnd);{$else}qtwinapi.SetForegroundWindow(Wnd);{$endif}
end;

{$ifndef HX_DOS}

function SetActiveWindow(wnd: HWND): HWND;
begin

end;

function SetWindowLong(wnd: HWND; nIndex: Integer; dwNewLong: Longint): Longint;
begin

end;

function SetWindowTextA(wnd: HWND; lpString: LPCSTR): Boolean;
begin

end;

function SetWindowTextW(wnd: HWND; lpString: LPCWSTR): Boolean;
begin

end;

function SetWindowPos(wnd,wndInsertAfter:HWND; x,y,cx,cy:Integer; uFlags: DWORD): Boolean;
begin

end;

function ShowWindow(hWnd: HWND; nCmdShow: Integer): Boolean;
begin

end;

function UnRegisterClassA(lpClassName: LPCSTR; Instance: HINSTANCE): Boolean;
begin
  Result := UnregisterClass(lpClassName, Instance);
end;

function WindowFromPoint(Point: TPoint): HWND;
begin

end;
{$endif}

function CallNextHookEx(
    hhk: HHOOK;
    nCode: Integer;
    w: WPARAM;
    l: LPARAM
    ): LRESULT;
begin

end;

function DrawFocusRect(DC: HDC; const Rect: TRect): boolean;
begin
  Result := Rectangle(DC,Rect.Left,Rect.Top,Rect.Right,Rect.Bottom);
end;

function FrameRect(DC: HDC; const ARect: TRect; hBr: HBRUSH): Integer;
begin
  if Rectangle(DC,ARect.Left,ARect.Top,ARect.Right,ARect.Bottom)
    then Result := 1;
end;

function GetWindowLongPtr(wnd: HWND; nIndex: Integer): PLongint;
var
  res: Longint;
begin
  res := GetWindowLong(wnd, nIndex);
  Result := @res;
end;

function GetDesktopWindow: HWND;
begin

end;

function SetLayeredWindowAttributes(
    wnd: HWND;
    crKey: COLORREF;
    bAlpha: BYTE;
    dwFlags: DWORD
  ): BOOL;
begin

end;

function SetWindowLongPtr(wnd: HWND; nIndex: Integer; dwNewLong: PLongint): PLongint;
var
  res: Longint;
begin
  res := SetWindowLong(wnd, nIndex, dwNewLong^);
  Result := @res;
end;

function SetWindowsHookExA(
    idHook: Integer;
    lpfn  : HOOKPROC;
    hmod  : HINSTANCE;
    dwThreadId: DWORD
    ): HHOOK;
begin

end;

function SystemParametersInfo(
  uiAction : UINT;
  uiParam  : UINT;
  pvParam  : Pointer;
  fWinIni  : UINT
  ): BOOL;
begin

end;

function SystemParametersInfoA(
  uiAction : UINT;
  uiParam  : UINT;
  pvParam  : Pointer;
  fWinIni  : UINT
  ): BOOL;
begin

end;

function SystemParametersInfoW(
  uiAction : UINT;
  uiParam  : UINT;
  pvParam  : Pointer;
  fWinIni  : UINT
  ): BOOL;
begin

end;

function UnhookWindowsHookEx(hhk: HHOOK): BOOL;
begin

end;

end.

