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
  stdcall; external name '_AdjustWindowRect@12';
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
  stdcall; external name '_BeginPaint@8';
  {$endif}

function BringWindowToTop(wnd: HWND): BOOL;
  {$ifdef HX_DOS}
  stdcall; external name '_BringWindowToTop@4';
  {$endif}

function CallNextHookEx(
    hhk: HHOOK;
    nCode: Integer;
    w: WPARAM;
    l: LPARAM
    ): LRESULT;

function ClientToScreen(Handle: HWND; P: PPoint) : BOOL;
  {$ifdef HX_DOS}
  stdcall; external name '_ClientToScreen@8';
  {$endif}

function CloseClipboard: BOOL;
  {$ifdef HX_DOS}
  stdcall; external name '_CloseClipboard@0';
  {$endif}

function CreateCursor(
  hInst: HINSTANCE;
  xHotSpot,yHotSpot: Integer;
  nWidth,nHeight: Integer;
  pvANDPlane: Pointer;
  pvXORPlane: Pointer
  ): HCURSOR;
  {$ifdef HX_DOS}
  stdcall; external name '_CreateCursor@28';
  {$endif}

function CreateIcon(
  hInst: HINSTANCE;
  xHotSpot,yHotSpot: Integer;
  nWidth,nHeight: Integer;
  pvANDPlane: Pointer;
  pvXORPlane: Pointer
  ): HICON;
  {$ifdef HX_DOS}
  stdcall; external name '_CreateIcon@28';
  {$endif}

function CreateIconIndirectD(iconinfo: PICONINFO): HICON;
{$ifdef HX_DOS}
stdcall; external name '_CreateIconIndirect@4';
{$endif}

function CreateIconIndirect(iconinfo: PICONINFO): HICON;

function CreateMenu: HMENU;
{$ifdef HX_DOS}
stdcall; external name '_CreateMenu@0';
{$endif}

function CreatePopupMenu: HMENU;
{$ifdef HX_DOS}
stdcall; external name '_CreatePopupMenu@0';
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
stdcall; external name '_CreateWindowExA@48';
{$endif}

function DefWindowProc(wnd: HWND; msg: UINT; w: WPARAM; l: LPARAM): LRESULT;
{$ifdef HX_DOS}
stdcall; external name '_DefWindowProcA@16';
{$endif}

function DefWindowProcA(wnd: HWND; msg: UINT; w: WPARAM; l: LPARAM): LRESULT;
{$ifdef HX_DOS}
stdcall; external name '_DefWindowProcA@16';
{$endif}

function DefWindowProcW(wnd: HWND; msg: UINT; w: WPARAM; l: LPARAM): LRESULT;
{$ifdef HX_DOS}
stdcall; external name '_DefWindowProcW@16';
{$endif}

function DestroyIconD(Icon: HICON): BOOL;
  {$ifdef HX_DOS}
  stdcall; external name '_DestroyIcon@4';
  {$endif}

function DeleteMenu(menu: HMENU; uPosition,uFlags: UINT): BOOL;
  {$ifdef HX_DOS}
  stdcall; external name '_DeleteMenu@12';
  {$endif}

function DestroyMenu(menu: HMENU): BOOL;
  {$ifdef HX_DOS}
  stdcall; external name '_DestroyMenu@4';
  {$endif}

function DestroyIcon(icon: HICON): Boolean;

function DestroyWindow(wnd: HWND): BOOL;
  {$ifdef HX_DOS}
  stdcall; external name '_DestroyWindow@4';
  {$endif}

function DispatchMessage(Message: PMsg): LResult;
  {$ifdef HX_DOS}
  stdcall; external name '_DispatchMessageA@4';
  {$endif}

function DispatchMessageA(Message: PMsg): LResult;
  {$ifdef HX_DOS}
  stdcall; external name '_DispatchMessageA@4';
  {$endif}

function DispatchMessageW(Message: PMsg): LResult;
  {$ifdef HX_DOS}
  stdcall; external name '_DispatchMessageW@4';
  {$endif}

function DrawFocusRect(DC: HDC; const Rect: TRect): boolean;

function EmptyClipboard: BOOL;
  {$ifdef HX_DOS}
  stdcall; external name '_EmptyClipboard@0';
  {$endif}

function EndPaint(Handle: hwnd; var PS: TPaintStruct): Integer;
  {$ifdef HX_DOS}
  stdcall; external name '_EndPaint@8';
  {$endif}

function EnumWindows(lpEnumFunc: WNDENUMPROC; l: LPARAM): BOOL;
  {$ifdef HX_DOS}
  stdcall; external name '_EnumWindows@8';
  {$endif}

function EnumChildWindows(wndParent:HWND; lpEnumFunc:WNDENUMPROC; l:LPARAM): BOOL;
  {$ifdef HX_DOS}
  stdcall; external name '_EnumChildWindows@12';
  {$endif}

function EnumThreadWindows(dwThreadId: DWORD; lpfn:WNDENUMPROC; l:LPARAM): BOOL;
  {$ifdef HX_DOS}
  stdcall; external name '_EnumThreadWindows@12';
  {$endif}

function FillRect(dc: HDC; const rect: TRect; hbr: HBRUSH): Integer;
  {$ifdef HX_DOS}
  stdcall; external name '_FillRect@12';
  {$endif}

function FindWindowA(lpClassName: LPCSTR; lpWindowName: LPCSTR): HWND;
  {$ifdef HX_DOS}
  stdcall; external name '_FindWindowA@8';
  {$endif}

function FindWindowExA(
  hWndParent    : HWND;
  hWndChildAfter: HWND;
  lpszClass     : LPCSTR;
  lpszWindow    : LPCSTR
  ): HWND;
  {$ifdef HX_DOS}
  stdcall; external name '_FindWindowExA@16';
  {$endif}

function GetActiveWindow: HWND;
  {$ifdef HX_DOS}
  stdcall; external name '_GetActiveWindow@0';
  {$endif}
  
  
function FrameRect(DC: HDC; const ARect: TRect; hBr: HBRUSH): Integer;

function GetCapture: HWND;

function GetClassInfoA(
  Instance    : HINSTANCE;
  lpClassName : LPCSTR;
  lpWndClass  : LPWNDCLASS
  ): BOOL;
  {$ifdef HX_DOS}
  stdcall; external name '_GetClassInfoA@12';
  {$endif}

function GetClassInfoW(
  Instance    : HINSTANCE;
  lpClassName : LPCWSTR;
  lpWndClass  : LPWNDCLASSW
): BOOL;
  {$ifdef HX_DOS}
  stdcall; external name '_GetClassInfoW@12';
  {$endif}

function GetClassInfoExA(
  Instance : HINSTANCE;
  lpszClass: LPCSTR;
  lpwcx    : LPWNDCLASSEX
  ): BOOL;
  {$ifdef HX_DOS}
  stdcall; external name '_GetClassInfoExA@12';
  {$endif}

function GetClassInfoExW(
  Instance : HINSTANCE;
  lpszClass: LPCWSTR;
  lpwcx    : LPWNDCLASSEXW
): BOOL;
  {$ifdef HX_DOS}
  stdcall; external name '_GetClassInfoExW@12';
  {$endif}

function GetClassLongA(wnd: HWND; Index: Integer): DWORD;
  {$ifdef HX_DOS}
  stdcall; external name '_GetClassLongA@8';
  {$endif}

function GetClassLongW(wnd: HWND; Index: Integer): DWORD;
  {$ifdef HX_DOS}
  stdcall; external name '_GetClassLongW@8';
  {$endif}

function GetClassNameA(wnd: HWND; lpClassName: LPSTR; nMaxCount: Integer): Integer;
  {$ifdef HX_DOS}
  stdcall; external name '_GetClassNameA@12';
  {$endif}

function GetClassNameW(wnd: HWND; lpClassName: LPWSTR; nMaxCount: Integer): Integer;
  {$ifdef HX_DOS}
  stdcall; external name '_GetClassNameW@12';
  {$endif}

function GetClientRect(handle : HWND; var ARect : TRect) : Boolean;
  {$ifdef HX_DOS}
  stdcall; external name '_GetClientRect@8';
  {$endif}

function GetCursorPos(var lpPoint: TPoint ): Boolean;
  {$ifdef HX_DOS}
  stdcall; external name '_GetCursorPos@4';
  {$endif}

function GetClipboardFormatNameA(
   format         : UINT;
   lpszFormatName : LPSTR;
   cchMaxCount    : Integer
   ): Integer;
  {$ifdef HX_DOS}
  stdcall; external name '_GetClipboardFormatNameA@12';
  {$endif}

function GetClipboardFormatNameW(
   format         : UINT;
   lpszFormatName : PWideChar;
   cchMaxCount    : Integer
   ): Integer;

function GetClipboardOwner: HWND;
  {$ifdef HX_DOS}
  stdcall; external name '_GetClipboardOwner@0';
  {$endif}

function GetDC(wnd: HWND): HDC;
  {$ifdef HX_DOS}
  stdcall; external name '_GetDC@4';
  {$endif}

function GetDesktopWindow: HWND;

function GetFocus: HWND;
  {$ifdef HX_DOS}
  stdcall; external name '_GetFocus@0';
  {$endif}

function GetKeyState(nVirtKey: Integer): Longint;
  {$ifdef HX_DOS}
  stdcall; external name '_GetKeyState@4';
  {$endif}

function GetKeyboardState(lpKeystate: PByte): BOOL;
  {$ifdef HX_DOS}
  stdcall; external name '_GetKeyboardState@4';
  {$endif}


function  GetMessage(var Msg: TMsg; wnd: HWND; wMsgFilterMin,wMsgFilterMax: UINT): Boolean;
  {$ifdef HX_DOS}
  stdcall; external name '_GetMessageA@16';
  {$endif}

function GetSystemMetrics(nIndex: Integer): Integer;
  {$ifdef HX_DOS}
  stdcall; external name '_GetSystemMetrics@4';
  {$endif}

function GetWindowLong(wnd: HWND; nIndex: Integer): Longint;
  {$ifdef HX_DOS}
   stdcall; external name '_GetWindowLongA@8';
  {$endif}

function GetWindowLongPtr(wnd: HWND; nIndex: Integer): PLongint;

function GetWindowPlacement(wnd: HWND; var lpwndpl
: WINDOWPLACEMENT): BOOL;
  {$ifdef HX_DOS}
   stdcall; external name '_GetWindowPlacement@8';
  {$endif}

function GetWindowRect(Handle: hwnd; var ARect: TRect): BOOL;
  {$ifdef HX_DOS}
   stdcall; external name '_GetWindowRect@8';
  {$endif}

function GetWindowThreadProcessId(wnd: HWND; lpdwProcessId: LPDWORD): DWORD;
  {$ifdef HX_DOS}
   stdcall; external name '_GetWindowThreadProcessId@8';
  {$endif}

function InvalidateRect(wnd: HWND; lpr: LPRECT; bErase: BOOL): BOOL;
  {$ifdef HX_DOS}
   stdcall; external name '_InvalidateRect@12';
  {$endif}

function IsClipBoardFormatAvailable(format: UINT): Boolean;
  {$ifdef HX_DOS}
   stdcall; external name '_IsClipboardFormatAvailable@4';
  {$endif}

//laut Doku enthalten aber in duser32.txt nicht aufgeführt
//im Zweifelsfall eigene Implementation
function IsWindowVisible(wnd: HWND): Boolean;
  {$ifdef HX_DOS}
   stdcall; external name '_IsWindowVisible@4';
  {$endif}

function KillTimer(h: HWND; uIDEvent: UINT_PTR): Boolean;
  {$ifdef HX_DOS}
   stdcall; external name '_KillTimer@8';
  {$endif}

function LoadBitmapA(Instance: HINSTANCE; lpBitmapName: LPCSTR): HBITMAP;
  {$ifdef HX_DOS}
  stdcall; external name '_LoadBitmapA@8';
  {$endif}

function LoadCursor(Instance: HINSTANCE; lpCursorName
: LPCSTR): HCURSOR;
  {$ifdef HX_DOS}
  stdcall; external name '_LoadCursorA@8';
  {$endif}

function LoadCursorA(Instance: HINSTANCE; lpCursorName
  : LPCSTR): HCURSOR;
  {$ifdef HX_DOS}
  stdcall; external name '_LoadCursorA@8';
  {$endif}

function LoadCursorW(Instance: HINSTANCE; lpCursorName
  : LPCWSTR): HCURSOR;
    {$ifdef HX_DOS}
    stdcall; external name '_LoadCursorW@8';
    {$endif}

function LoadIconA(Instance: HINSTANCE; IconName: LPCSTR): HICON;
  {$ifdef HX_DOS}
  stdcall; external name '_LoadIconA@8';
  {$endif}

function LoadImageA(
   hInst  : HINSTANCE;
   name   : LPCSTR;
   imgtype: UINT;
   cx     : integer;
   cy     : integer;
   fuLoad : UINT): HANDLE;
  {$ifdef HX_DOS}
  stdcall; external name '_LoadImageA@24';
  {$endif}

function MapVirtualKeyA(ucode,uMapType: UINT): UINT;
  {$ifdef HX_DOS}
  stdcall; external name '_MapVirtualKeyA@8';
  {$endif}

function MapVirtualKeyExA(ucode,uMapType: UINT; dwHkl: HKL): UINT;
  {$ifdef HX_DOS}
  stdcall; external name '_MapVirtualKeyExA@12';
  {$endif}

function MapVirtualKey(ucode,uMapType: UINT): UINT;

function MapVirtualKeyEx(ucode,uMapType: UINT; dwHkl: HKL): UINT;

function MoveWindow(wnd:HWND; x,y,nWidth,hHeight:Integer; bRepaint:BOOL): BOOL;
  {$ifdef HX_DOS}
  stdcall; external name '_MoveWindow@24';
  {$endif}

function MsgWaitForMultipleObjects(
  nCount: DWORD;
  pHandles: PHandle;
  fWaitAll: BOOL;
  dwMilliseconds: DWORD;
  dwWakeMask: DWORD
): DWORD;
  {$ifdef HX_DOS}
  stdcall; external name '_MsgWaitForMultipleObjects@20';
  {$endif}

function MessageBeep(uType: UINT): Boolean;
  {$ifdef HX_DOS}
  stdcall; external name '_MessageBeep@4';
  {$endif}

function OemToCharA(pSrc: LPCSTR; pDst: LPSTR): BOOL;
{$ifdef HX_DOS}
stdcall; external name '_OemToCharA@8';
{$endif}

function OemToCharBuffA(lpszSrc:LPCSTR; lpszDst:LPSTR; cchDstLength:DWORD):BOOL;
{$ifdef HX_DOS}
stdcall; external name '_OemToCharBuffA@12';
{$endif}

function OemToCharBuffW(lpszSrc:LPCSTR; lpszDst:LPSTR; cchDstLength:DWORD):BOOL;
{$ifdef HX_DOS}
stdcall; external name '_OemToCharBuffW@12';
{$endif}

function OemToCharW(pSrc: LPCSTR; pDst: LPSTR): BOOL;
{$ifdef HX_DOS}
stdcall; external name '_OemToCharW@8';
{$endif}

function OpenClipboard(hWndNewOwner: HWND): BOOL;
{$ifdef HX_DOS}
stdcall; external name '_OpenClipboard@4';
{$endif}

function PeekMessage(var Msg: TMsg; wnd: HWND; wMsgFilterMin,wMsgFilterMax,wRemoveMsg
: UINT): Boolean;
  {$ifdef HX_DOS}
  stdcall; external name '_PeekMessageA@20';
  {$endif}

function PeekMessageA(var Msg: TMsg; wnd: HWND; wMsgFilterMin,wMsgFilterMax,wRemoveMsg
  : UINT): Boolean;
  {$ifdef HX_DOS}
  stdcall; external name '_PeekMessageA@20';
  {$endif}

function PeekMessageW(var Msg: TMsg; wnd: HWND; wMsgFilterMin,wMsgFilterMax,wRemoveMsg
  : UINT): Boolean;
  {$ifdef HX_DOS}
  stdcall; external name '_PeekMessageA@20';
  {$endif}

function PostMessage(HandleWnd: HWND; Msg: Cardinal; w: WParam; l: LParam): Boolean;
  {$ifdef HX_DOS}
  stdcall; external name '_PostMessageA@16';
  {$endif}

function PostMessageA(HandleWnd: HWND; Msg: Cardinal; w: WParam; l: LParam): Boolean;
  {$ifdef HX_DOS}
  stdcall; external name '_PostMessageA@16';
  {$endif}

function PostMessageW(HandleWnd: HWND; Msg: Cardinal; w: WParam; l: LParam): Boolean;
  {$ifdef HX_DOS}
  stdcall; external name '_PostMessageA@16';
  {$endif}

function PostThreadMessage(idThread: DWORD; Msg: UINT; w: WPARAM; l: LPARAM): Boolean;

function PostThreadMessageW(idThread: DWORD; Msg: UINT; w: WPARAM; l: LPARAM): Boolean;
  {$ifdef HX_DOS}
  stdcall; external name '_PostThreadMessageA@16';
  {$endif}

procedure PostQuitMessage(nExitCode: Integer);
  {$ifdef HX_DOS}
  stdcall; external name '_PostQuitMessage@4';
  {$endif}

function ReleaseCapture : Boolean;  //In HXDOS nicht vorhanden, selber implementieren!

function ReleaseDC(Wnd: HWND; DC: HDC): Integer;
  {$ifdef HX_DOS}
  stdcall; external name '_ReleaseDC@8';
  {$endif}

function Registerclass(var lpWndClass: TWndClass): Word;
function RegisterclassEx(var lpwcx: TWndClassEx): Word;

function RegisterClassA(var lpWndClass: TWndClass): Word;
{$ifdef HX_DOS}
stdcall; external name '_RegisterClassA@4';
{$endif}

function RegisterClassW(var lpWndClass: TWndClass): Word;
{$ifdef HX_DOS}
stdcall; external name '_RegisterClassW@4';
{$endif}

function RegisterClassExA(var lpwcx: TWndClassEx): Word;
{$ifdef HX_DOS}
stdcall; external name '_RegisterClassExA@4';
{$endif}

function RegisterClassExW(var lpwcx: TWndClassEx): Word;
{$ifdef HX_DOS}
stdcall; external name '_RegisterClassExW@4';
{$endif}

function RegisterClipBoardFormatA(
   lpszFormat         : LPCSTR
): UINT;
  {$ifdef HX_DOS}
  stdcall; external name '_RegisterClipboardFormatA@4';
  {$endif}

function RegisterClipBoardFormatNameA(
   format         : UINT;
   lpszFormatName : LPSTR;
   cchMaxCount    : Integer
): Integer;

function GetClipboardData(uFormat: UINT): HANDLE;
  {$ifdef HX_DOS}
  stdcall; external name '_GetClipboardData@4';
  {$endif}

function PtInRect(lprc: TRect; point: TPoint): BOOL;
{$ifdef HX_DOS}
stdcall; external name '_PtInRect@12';
{$endif}

function ScreenToClient(Handle : HWND; P : PPoint) : BOOL;
  {$ifdef HX_DOS}
  stdcall; external name '_ScreenToClient@8';
  {$endif}

function SendMessage(HandleWnd: HWND; Msg: Cardinal; w: WParam; l: LParam): LResult;
  {$ifdef HX_DOS}
  stdcall; external name '_SendMessageA@16';
  {$endif}

function SetActiveWindow(wnd: HWND): HWND;
  {$ifdef HX_DOS}
  stdcall; external name '_SetActiveWindow@4';
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
  stdcall; external name '_SetTimer@16';
  {$endif}

function SetWindowsHookExA(
    idHook: Integer;
    lpfn  : HOOKPROC;
    hmod  : HINSTANCE;
    dwThreadId: DWORD
    ): HHOOK;

function SetWindowTextA(wnd: HWND; lpString: LPCSTR): Boolean;
  {$ifdef HX_DOS}
  stdcall; external name '_SetWindowTextA@8';
  {$endif}

function SetWindowTextW(wnd: HWND; lpString: LPCWSTR): Boolean;
  {$ifdef HX_DOS}
  stdcall; external name '_SetWindowTextW@8';
  {$endif}

function SetCursor(hCur: HCURSOR): HCURSOR;
  {$ifdef HX_DOS}
  stdcall; external name '_SetCursor@4';
  {$endif}

function TranslateMessage(Message: PMsg): Boolean;
  {$ifdef HX_DOS}
  stdcall; external name '_TranslateMessage@4';
  {$endif}

function Shell_NotifyIconA(dwMessage: DWORD; lpData: PNotifyIconDataA): BOOL;

function Shell_NotifyIconW(dwMessage: DWORD; lpData: PNotifyIconDataW): BOOL;

function ScrollWindow(Wnd: HWND; dx, dy: Integer; lpRect,lpClipRect: PRect): BOOL;
  {$ifdef HX_DOS}
   stdcall; external name '_ScrollWindow@20';
  {$endif}

function ScrollWindowEx(Wnd: HWND; dx, dy: Integer;
  prcScroll, prcClip: PRect;
   hrgnUpdate: HRGN; prcUpdate: PRect; flags: UINT): BOOL;

function SetCapture(AHandle: HWND): HWND; //In HXDOS nicht vorhanden, selber implementieren!

function SetClipboardData(uFormat: UINT; hmem: HANDLE = 0): HANDLE;
  {$ifdef HX_DOS}
   external name '_SetClipboardData@8';
  {$endif}

function SetCursorPos(x,y: Integer): Boolean;
  {$ifdef HX_DOS}
   external name '_SetCursorPos@8';
  {$endif}

function SetFocus(Wnd: HWND): HWND;
  {$ifdef HX_DOS}
   external name '_SetFocus@4';
  {$endif}

function SetForegroundWindow(Wnd: HWND): boolean;


function SetWindowLong(wnd: HWND; nIndex: Integer; dwNewLong: Longint): Longint;
  {$ifdef HX_DOS}
   external name '_SetWindowLongA@12';
  {$endif}

function SetWindowLongPtr(wnd: HWND; nIndex: Integer; dwNewLong: PLongint): PLongint;

function SetWindowPos(wnd,wndInsertAfter:HWND; x,y,cx,cy:Integer; uFlags: DWORD): Boolean;
  {$ifdef HX_DOS}
   external name '_SetWindowPos@28';
  {$endif}

function ShowWindow(hWnd: HWND; nCmdShow: Integer): Boolean;
  {$ifdef HX_DOS}
   external name '_ShowWindow@8';
  {$endif}

function SystemParametersInfo(
  uiAction : UINT;
  uiParam  : UINT;
  pvParam  : Pointer;
  fWinIni  : UINT
  ): BOOL;
{$ifdef HX_DOS}
 stdcall; external name '_SystemParametersInfoA@16';
{$endif}  

function SystemParametersInfoA(
  uiAction : UINT;
  uiParam  : UINT;
  pvParam  : Pointer;
  fWinIni  : UINT
  ): BOOL;
{$ifdef HX_DOS}
 stdcall; external name '_SystemParametersInfoA@16';
{$endif}  

function SystemParametersInfoW(
  uiAction : UINT;
  uiParam  : UINT;
  pvParam  : Pointer;
  fWinIni  : UINT
  ): BOOL;
{$ifdef HX_DOS}
 stdcall; external name '_SystemParametersInfoW@16';
{$endif}  

function UnhookWindowsHookEx(hhk: HHOOK): BOOL;

function UnRegisterClass(lpClassName: LPCSTR; Instance: HINSTANCE): Boolean;
  {$ifdef HX_DOS}
  stdcall; external name '_UnregisterClassA@8';
  {$endif}
function UnRegisterClassA(lpClassName: LPCSTR; Instance: HINSTANCE): Boolean;
  {$ifdef HX_DOS}
  stdcall; external name '_UnRegisterClassA@8';
  {$endif}

function UpdateWindow(Wnd: HWND): BOOL;
  {$ifdef HX_DOS}
   external name '_UpdateWindow@4';
  {$endif}

function WindowFromPoint(Point: TPoint): HWND;
  {$ifdef HX_DOS}
   external name '_WindowFromPoint@8';
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

{$ifndef HX_DOS}
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
{$endif}

function UnhookWindowsHookEx(hhk: HHOOK): BOOL;
begin

end;

function PostThreadMessage(idThread: DWORD; Msg: UINT; w: WPARAM; l: LPARAM): Boolean;
begin
  Result := PostThreadMessageW(idThread, Msg, w, l);
end;

end.

