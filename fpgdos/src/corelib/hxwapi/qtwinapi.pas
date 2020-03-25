unit qtwinapi;

interface
{.$I windefs.inc}
{$I gdefines.inc}
{$I osdefs.inc}
{$define HX_DOS}
uses
  Classes,
  Sysutils,
  Contnrs,
  fpcolnum,
  {Graphtype,}
  lcltype,   //für msdos Plattform übersetzbar, da keine Assemblerteile
  doskeybd,
  {Types,}
  {$IFNDEF HX_DOS}
   {$ifdef windows}
    {Winmouse,}
    WinCrt,
    WinGraph,
   {$else}
    Crt,
    Graph,
   {$endif}
    dosmouse;
  {$ELSE}
  hxvesa32;
  {$ENDIF}

type
  //TBevelCut = (bvNone, bvLowered, bvRaised, bvSpace);
  HINSTANCE = Longword;
  int = integer;
  TCastRec = record
    case DWORD of
     0: (dw: DWORD);
     1: (dl: Longint);
     2: (dc: Longword);
     3: (ww: word);
     4: (wi: smallint);
     5: (wb: byte);
     6: (ws: shortint);
  end;

var
  Cast: TCastRec;
  InGraphMode: Boolean = false;
  NULL_RECT: TRect;

{$ifdef microwindows}
  {$LINK images}
  {$LINK mwin}
  {$LINK nano-X}
{$endif}

{$ifdef read_implementation}
{$undef read_implementation}
{$endif}
{$define read_interface}
{$i gdi_base.inc}
{$i gdi_defines.inc}
{.$i gdi_base.inc}
{$i gdi_Struct.inc}
{.$define messagesunit}
{$i gdi_msg.inc}
{$I predefinedcolors.inc}

CONST
  //AD_COUNTERCLOCKWISE     = 1;
  //AD_CLOCKWISE            = 2;
  //DIFFERENCE              = 11;
  AdjustedDirection : integer = AD_COUNTERCLOCKWISE;
  ROP4                    = $0000AACC;
  DSTERASE                = $00220326;
  DSTCOPY                 = $00AA0029;
  IDC_CLOSE               = $7FFFFFFF;
  IDC_MINIMIZE            = $7FFFFFFE;
  IDC_MAXIMIZE            = $7FFFFFFD;
  IDC_SYSMENU             = $7FFFFFFC;

  HEIGHT_TITLEBAR         = 24;
  HEIGHT_TITLEBARBUTTONS  = 20;
  WIDTH_TITLEBARBUTTONS   = 20;
  HEIGHT_BUTTONS          = 20;
  WIDTH_BUTTONS           = 100;

  GDI_PALETTE             = $70;
  GDI_BITMAP              = $72;
  GDI_DIB                 = $73;
  GDI_PEN                 = $74;
  GDI_EXTPEN              = $75;
  GDI_BRUSH               = $78;
  GDI_FONT                = $60;
  GDI_REGION              = $61;
  GDI_CARET               = $62;

  UpRect                  = $7FFFFF00;
  DnRect                  = $7FFFFF01;
  LeftRect                = $7FFFFF02;
  RightRect               = $7FFFFF04;
  ellipticrgn             = $7FFF00FF;
  roundrectrgn            = $7FFF01FF;
  rectrgn                 = $7FFF02FF;
  polyrgn                 = $7FFF04FF;
  polypolyrgn             = $7FFF08FF;

{
type
  TOSVERSIONINFO = record
    dwOSVersionInfoSize: DWORD;
    dwMajorVersion: DWORD;
    dwMinorVersion: DWORD;
    dwBuildNumber: DWORD;
    dwPlatformId: DWORD;
    szCSDVersion: array[0..127] of Char;
  end;
  OSVERSIONINFO = TOSVERSIONINFO;
}

type
  PPixel = ^TPixel;
  TPixel = record
    Color: word;
    Visible: boolean;
    pMode: word;
  end;

  PRegionRec = ^TRegionRec;
  TRegionRec = record
    RectRegion: TRect;
    RectVisible: Boolean;  //Rechteck sichtbar oder nicht
    RectBuffer: array of TPixel;
  end;

  { TRegions }

  TRegions = class(TList)
  private
    function GetRegion(Index: Integer): TRegionRec;
    procedure SetRegion(Index: Integer; AValue: TRegionRec);
  public
    destructor Destroy; override;
    property Region[Index: Integer]: TRegionRec read GetRegion write SetRegion;
  end;

  PRegion = ^TRegion;
  TRegion = record
    Regions: TRegions;
    RgnType: Longint; //NULLREGION, SIMPLEREGION, COMPLEXREGION, ERROR
    flags: Longint;   //UpRect, DnRect, LeftRect, RightRect, ellipticrgn,roundrectrgn,rectrgn,polyrgn,polypolyrgn
    mode: Longint;
  end;

  PGDIObject = ^TGDIObject;
  TGDIObject = record
    gdiobj: HGDIOBJ;
    gdiknd: Integer;
    case integer of
     0: (palette: word);
     1: (bmp: BITMAP);
     2: (dib: DIBSECTION);
     3: (pen: LOGPEN);
     4: (extpen: EXTLOGPEN);
     5: (brush: LOGBRUSH);
     6: (font: LOGFONT);
     7: (rgn: PRegion);
  end;

  TGDIObjectItem = class(TObject)
  private
    FGDIObject: TGDIObject;
    function GetGDIkind: Integer;
    procedure SetGDIkind(Value: Integer);
    function GetGdiHandle: HGDIOBJ;
    procedure SetGdiHandle(Value: HGDIOBJ);
    function GetGdiObject: TGdiObject;
    procedure SetGdiObject(Value: TGDIObject);
  public
    constructor Create;
    destructor Destroy; override;

    property kind: Integer read GetGDIkind write SetGDIkind;
    property Handle: HGDIOBJ read GetGdiHandle write SetGdiHandle;
    property Obj: TGDIObject read GetGDIObject write SetGDIObject;
  end;

  TGDIObjects = class(TList)
    function GetGDIObjectItem(Index: Integer): TGDIObjectItem;     // drawtool.gdi[5].obj.font
    property Gdi[Index: Integer]: TGDIObjectItem read GetGDIObjectItem;
  end;

  PHeaderDeviceContext = ^THeaderDeviceContext; //HDC
  THeaderDeviceContext = record
    dc: HDC;             //Adresse Gerätekontext
    wnd: HWND;           //Adresse Fenterhandle
    gdi: TGDIObject;     //Daten GDI-Objekt  (Font, Bitmap, Pen, ... )
    Color: COLORREF;     //Hintergrundfarbe Gerätekontext
    PenMode: Integer;    //Drawmode (pmCopy, pmXor, pmOr, ...
    ClientArea: TRect;   // immer der komplette Clientbereich des Fensters
    ClientBuffer: array of TPixel; //gespeicherte Clientpixel
    Region: TRegion;     //Region im Clientbereich
    XPos,YPos: Integer;  //aktuelle Cursorposition im Clientbereich
    Redraw: Boolean;     //wenn true, dann neu zeichnen
  end;
  TPen = record
  end;
  TBrush = record
  end;
  TCursor = record
  end;
  {
  THookListItem = class(TObject)
    f_msg: TMsg;
    f_hook: Integer;
    f_wpar: WPARAM;
    f_lpar: LPARAM;
    f_hookproc: Pointer;
    constructor create(aMsg: TMsg; hooktype:Integer; w: WPARAM; l: LPARAM);
    destructor Destroy; override;
    property msg: TMsg read GetMsg;
    property hooktype: Integer read f_hook;
    property wpar: WPARAM read f_wpar write f_wpar;
    property lpar: LPARAM read f_lpar write f_lpar;
    property hookproc: Pointer read f_hookproc;
  end;

  THookList = class(TList)
  private
    function GetHook(Index: Integer): THooklistItem;
  public
    property Hook[Index: Integer]: THookListItem read GetHook;
  end;
  }

{ TMsgQueue }

 PMsgRec = ^TMsgRec;
 TMsgRec = record
     hwnd : HWND;
     message : UINT;
     wParam : WPARAM;
     lParam : LPARAM;
     time : DWORD;
     pt : POINT;
  end;

 //Messageliste
  TMsgList = array[0..255] of TMsg;
 //Message-Queue
  TMsgQueue = class(TPersistent)
  private
    FCount: Integer;
    fMsg: TMsg;
    fMessage: TMsgList;
    function GetMsg(Index: Integer): TMsg;
  public
    constructor Create;
    procedure Clear;
    procedure Delete(Index: Integer);
    function Add(aMsg: TMsg): Integer;
    function FindMessage(msg: UINT): Integer;
    function HasMessage(var msg): Boolean;
    property Count: Integer read FCount write FCount;
    property messages[Index: Integer]: TMsg read GetMsg;
  end;

  //Das jeweilige Fenster
  PWindowHandle = ^TWindowHandle;
  TWindowHandle = class(TObject)
    Fwclass: TWndClassEx;
    FlpClassName: LPCSTR;
    FdwExStyle: DWORD;
    FlpWindowName: LPCSTR;
    FdwStyle: DWORD;
    FX: integer;
    FY: integer;
    FnWidth: integer;
    FnHeight: integer;
    FhwndParent: HWND;
    FMenu: HMENU;
    FInstance: HINSTANCE;
    FlpParam: Pointer;

    Fwtitle: TWindowHandle;
    Fwclose: TWindowHandle;
    Fwmin: TWindowHandle;
    Fwmax: TWindowHandle;
    Fwsys: TWindowHandle;
    Fwsize: TWindowHandle;

    Fcontext: PHeaderDeviceContext;

    Fparent: TWindowHandle;
    Fnext: TWindowHandle;
    Fsubwin: TWindowHandle;

    FClassIndex: Integer;

    FActive: Boolean;
    FCaret: Boolean;
    FEnabled: Boolean;
    FFocused: Boolean;
    FIconic: Boolean;
    FVisible: Boolean;
    FZoomed: Boolean;

    FBckgndErase: Boolean;

    FWindowText: String;
    FWindowData: TStringList;
    FWindowProp: TStringList;

    constructor Create(
       dwExStyle: DWORD;
       lpClassName: LPCSTR;
       lpWindowName: LPCSTR; dwStyle: DWORD; X, Y: int;
       nWidth,
       nHeight: int;
       hwndParent: HWND;
       Menu: HMENU;
       Instance: HINSTANCE;
       lpParam: Pointer
       );
    destructor Destroy; override;

    property ClassName: LPCSTR read FlpClassName;
    property wclass: TWndClassEx read FWClass write FWClass;
    property dwExStyle: DWORD read FdwExStyle write FdwExStyle;
    property lpWindowName: LPCSTR read FlpWindowName write FlpWindowName;
    property dwStyle: DWORD read FdwStyle write FdwStyle;
    property X: integer read FX write FX;
    property Y: integer read FY write FY;
    property nWidth: integer read FnWidth write FnWidth;
    property nHeight: integer read FnHeight write FnHeight;
    property hwndParent: HWND read FhwndParent write FhwndParent;
    property Menu: HMENU read FMenu write FMenu;
    property Instance: HINSTANCE read FInstance write FInstance;
    property lpParam: Pointer read FlpParam write FlpParam;

    property wtitle: TWindowHandle read Fwtitle write Fwtitle;
    property wclose: TWindowHandle read Fwclose write Fwclose;
    property wmin: TWindowHandle read Fwmin write Fwmin;
    property wmax: TWindowHandle read Fwmax write Fwmax;
    property wsys: TWindowHandle read Fwsys write Fwsys;
    property wsize: TWindowHandle read Fwsize write Fwsize;

    property context: PHeaderDeviceContext read FContext write FContext;

    property ClassIndex: Integer read FClassIndex write FClassIndex;

    property parent: TWindowHandle read Fparent write Fparent;
    property next: TWindowHandle read Fnext write Fnext;
    property subwin: TWindowHandle read Fsubwin write Fsubwin;

    property Active: Boolean read FActive write FActive;
    property Caret: Boolean read FCaret write FCaret;
    property Enabled: Boolean read FEnabled write FEnabled;
    property Focused: Boolean read FFOcused write FFOcused;
    property Iconic: Boolean read FIconic write FIconic;
    property Visible: Boolean read FVisible write FVisible;
    property Zoomed: Boolean read FZoomed write FZoomed;

    property BckgndErase: Boolean read FBckgndErase write FBckgndErase;

    property WindowText: String read FWindowText write FWindowText;
    property WindowData: TStringList read FWindowData write FWindowData;
    property WindowProp: TStringList read FWindowProp write FWindowProp;
  end;

  //Liste der im System/Programm vorhandenen Fenster
  TWindowList = class(TObjectList)
  private

  public
    function Add(wnd: TWindowHandle): Integer;
    procedure CallWndProcs(wnd: HWND; msg: UINT; w: WPARAM; l: LPARAM);
    function Window(Index: Integer): TWindowHandle;
  end;

  //WindowTree (momentan nicht verwendet) Andere Struktur der im System/Programm
  //vorhandenen Fenster
  TWindowTree = class(TObject)
  private
    fRootWin: TWindowHandle;  //Root pointer (to first in the List)
    fNextWin: TWindowHandle;
    fPrevWin: TWindowHandle;
    fCurrent: TWindowHandle;
    fLevel: Integer;          //current node depth
    fSubnodes: TList;         //varable count of subnodes
    function GetNodes(Index: Integer): TWindowHandle;
    function GetParent: TWindowHandle;
    function GetWindow(Index: Integer): TWindowHandle;
  public
    constructor Create;
    destructor Destroy; override;
    property Level: Integer read fLevel;  //Depth of windows tree
    property Handle: TWindowHandle read fCurrent;
    property Nodes[Index: Integer]: TWindowHandle read GetNodes;
    property Parent: TWindowHandle read GetParent;
    property Root: TWindowHandle read fRootWin;
    property Window[Index: Integer]: TWindowHandle read GetWindow;
  end;

 //Hier werden die einzelnen Fensterklassen registriert
  TWindowClasses = array of TWndClassEx;
  TWndClassRec = class(TObject)
  private
    FWndClassEx: TWndClassEx;
  public
    constructor Create(wc: TWndClassEx);
    property WndClassEx: TWndClassEx read FWndClassEx write FWndClassEx;
  end;

  TWindowClassEx = class(TObject)
  private
    FCount: Integer;
    FCapacity: Integer;
    FWndClasses: TWindowClasses;
    procedure SetCapacity(value: Integer);
    function GetWndClassEx(Index: Integer): TWndClassEx;
    procedure SetWndClassEx(Index: Integer; value: TWndClassEx);
  public
    constructor Create;
    function Add(wndc: TWndClassEx): Integer; overload;
    function Add(wndr: TWndClassRec): Integer; overload;
    function Find(Item: String; var wc: TWndClassEx): Boolean;
    property Capacity: Integer read FCapacity write SetCapacity;
    property Count: Integer read FCount;
    property WndClassEx[Index: Integer]: TWndClassEx read GetWndClassEx write SetWndClassEx;
  end;

  TKeyboardTable = array[0..2] of Cardinal;

  TWindowPropData = class(TObject)
  private
    FData: Pointer;
    FSize: Integer;
  public
    constructor Create(Data: Pointer; Size: Integer);
    destructor Destroy; override;
    property Data: Pointer read FData write FData;
    property Size: Integer read FSize write FSize;
  end;

  PNamedFont = ^TNamedFont;
  TNamedFont = class(TObject)
  private
    FFontName: String;
    FFont: PLogFont;
  public
    constructor Create(Fontname: String; Font: TLogFont);
    destructor Destroy; override;
    property fontname: String read FFontName;
    property Font: PLogFont read FFont;
  end;

  TNamedFonts = class(TList)
  private
    function GetFonts(Index: Integer): PNamedFont;
  public
    property Fonts[Index: Integer]: PNamedFont read GetFonts;
  end;

//TWindowProc = procedure(wnd: HWND; msg: UINT; w: WPARAM; l: LPARAM; out r: LRESULT = 0);

{$ifndef HX_DOS}
function DefWndProc(wnd: HWND; msg: UINT; w: WPARAM; l: LPARAM): LResult;
function DefWindowProc(wnd: HWND; msg: UINT; w: WPARAM; l: LPARAM): LResult;
function DefWindowProcA(wnd: HWND; msg: UINT; w: WPARAM; l: LPARAM): LResult;
function DefWindowProcW(wnd: HWND; msg: UINT; w: WPARAM; l: LPARAM): LResult;
function DispatchMessage(Message: TMsg): LResult;
function TranslateMessage(Message: TMsg): Boolean;
{$endif}
function DispatchMsg(Message: TMsg): LResult;

procedure FillBuffer(var Buf: array of TPixel; Color: word; Visible: Boolean; Exclude: TRect);

const
  KeyCodeScan = 0; //KeyChr <-> Scancode Paar
  KeyVirtCode = 1; //Virtual - Code (Siehe Windows)
  KeyboardNum = 2; //Keycode von GetKeyEventCode() Funktion der Unit Keyboard
  {
  KeyboardTable : TKeyboardTable = (
     $30,VK_0,2864,  // 0
     $31,VK_1, 561,  // 1
     $32,VK_2, 818,  // 2
     $33,VK_3,1075,  // 3
     $34,VK_4,1332,  // 4
     $35,VK_5,1589,  // 5
     $36,VK_6,1846,  // 6
     $37,VK_7,2103,  // 7
     $38,VK_8,2360,  // 8
     $39,VK_9,2617,  // 9

     $00, VK_F1,65281, //F1
     $00, VK_F2,65282, //F2
     $00, VK_F3,65283, //F3
     $00, VK_F4,65284, //F4
     $00, VK_F5,65285, //F5
     $00, VK_F6,65286, //F6
     $00, VK_F7,65287, //F7
     $00, VK_F8,65288, //F8
     $00, VK_F9,65289, //F9
     $00,VK_F10,65290, //F10
     $00,VK_F11,65291, //F11
     $00,VK_F12,65292, //F12

  );
  }
var
  defwndproccalled: Boolean = false;
  DeltaX: Integer;
  DeltaY: Integer;
  StartX: Integer = -1;
  StartY: Integer = -1;
  Shift_State: Classes.TShiftState;
  GlobalAtom: TStringlist;
  //mouse_Event: {$ifdef windows}WinMouse.MouseEventType{$else}TMouseEvent{$endif};
  gdiobjects: TGDIObjects;
  {$ifndef HX_DOS}
  mouse_Event: TMouseEvent;
  {$ENDIF}
  msgQueue: TMsgQueue;

  namedfonts: TNamedFonts;
  fonts: Tlist;
  bitmaps: Tlist;
  pens: TList;
  brushes: TList;

  WindowClass: TWindowClassEx;
  WindowMain,WindowRoot,WindowDesktop: TWindowHandle;
  WindowPtr: TWindowHandle;
  WindowSave: TWindowHandle;

  WindowM,                 //MainWindow
  WindowT,                 //Temp Window
  WindowR,                 //RootWindow
  WindowD,                 //Desktop
  WindowC: TWindowHandle;  //CurrentWindow

  WindowList: TWindowList;
  WindowIndex: Integer;
  KeyWasPressed: Boolean = false;
  Startup: TStartupInfo;
  Instance: Longint = $100;
  IsStarted: Boolean;

  __message__: TMsg;

  function _equ_msg_(Msg: TMsg): boolean;
  function _push_message_(_msg: TMsg): TMsg;
  function _pop_message_: TMsg;

{$ifndef HX_DOS}
procedure PrintLnStr(line: String);
procedure PrintLnInt(value: Integer);
{$endif}
function ToSmallint(I: Longint): smallint;
{$ifndef HX_DOS}
function RegisterDesktopClassEx: word;
function RegisterTitleBarClassEx: word;
function RegisterButtonClassEx: word;
function RegisterEditBoxClassEx: word;
function RegisterListboxClassEx: word;
{$endif}
{$ifndef HX_DOS}
{$i qtwapih.inc} {(qt)(w)in (api) (h)eader}
{$endif}
implementation
{$ifdef HX_DOS}
uses
  hxuser;
{$endif}

{
uses
  mwindefs, wmacros, winfont, wingdi, gfx_wnd;
}
{$undef read_interface}
{$define read_implementation}
{$i gdi_base.inc}
{$i gdi_defines.inc}
{$i gdi_Struct.inc}
{$ifndef HX_DOS}
{$i qtwapii.inc}  {(qt)(w)in (api)(i)mplementation}
{$endif}
{$ifndef HX_DOS}
procedure PrintLnStr(line: String);
var SaveX: smallint;
begin
  if InGraphMode then
  begin
    SaveX := GetX;
    OutText('                                                 ');
    MoveTo(SaveX, GetY);
    OutText('   '+line);
    MoveTo(SaveX, GetY + 20);
    if GetY > GetMaxY-20 then MoveTo(SaveX,20);
  end
  else writeln(line);
end;

procedure PrintLnInt(value: Integer);
var SaveX: smallint;
begin
  if InGraphMode then
  begin
    SaveX := GetX;
    OutText('                                                 ');
    MoveTo(SaveX, GetY);
    OutText('   '+IntToStr(value));
    MoveTo(SaveX, GetY + 20);
    if GetY > GetMaxY-20 then MoveTo(SaveX,20);
  end
  else writeln(value);
end;
{$endif}

function ToSmallint(I: Longint): smallint;
begin
  Cast.dl := I;
  Result  := Cast.wi;
end;

function ev_mouse_(wnd: HWND; m: UINT; btn: word; x,y: word): TMsg;
var msg: TMsg;
begin
  msg.hwnd    := wnd;
  msg.message := m;
  msg.wParam  := btn;
  msg.lParam  := (y shl 16) + x;
  msg.pt.x    := x;
  msg.pt.y    := y;
  Result      := msg;
end;

{$ifndef HX_DOS}
function Poll_mouse_Ev(var Msg: TMsg; wnd: HWND; wMsgFilterMin,wMsgFilterMax: UINT): Boolean;
begin
  if PollmouseEvent(mouse_Event) then GetmouseEvent(mouse_Event);
  case Mouse_Event.Action of
   mouseActionDown:
    begin
      case mouse_Event.buttons of
       mouseLeftButton:
         begin
           msg := ev_mouse_(wnd,WM_LBUTTONDOWN,mouse_Event.Buttons,GetmouseX,GetmouseY);
         end;
       mouseMiddleButton:
         begin
           msg := ev_mouse_(wnd,WM_MBUTTONDOWN,mouse_Event.Buttons,GetmouseX,GetmouseY);
         end;
       mouseRightButton:
         begin
           msg := ev_mouse_(wnd,WM_RBUTTONDOWN,mouse_Event.Buttons,GetmouseX,GetmouseY);
         end;
      end;
    end;

   mouseActionMove:
    begin
      case mouse_Event.buttons of
       mouseLeftButton:
         begin
           msg := ev_mouse_(wnd,WM_mouseMOVE,mouse_Event.Buttons,GetmouseX,GetmouseY);
         end;
       mouseMiddleButton:
         begin
           msg := ev_mouse_(wnd,WM_mouseMOVE,mouse_Event.Buttons,GetmouseX,GetmouseY);
         end;
       mouseRightButton:
         begin
           msg := ev_mouse_(wnd,WM_mouseMOVE,mouse_Event.Buttons,GetmouseX,GetmouseY);
         end;
      end;
    end;

   mouseActionUp:
    begin
      case mouse_Event.buttons of
       mouseLeftButton:
         begin
           msg := ev_mouse_(wnd,WM_LBUTTONUP,mouse_Event.Buttons,GetmouseX,GetmouseY);
         end;
       mouseMiddleButton:
         begin
           msg := ev_mouse_(wnd,WM_MBUTTONUP,mouse_Event.Buttons,GetmouseX,GetmouseY);
         end;
       mouseRightButton:
         begin
           msg := ev_mouse_(wnd,WM_RBUTTONUP,mouse_Event.Buttons,GetmouseX,GetmouseY);
         end;
      end;
    end;
  end;
end;

function ButtonProc(wnd: HWND; msg: UINT; w: WPARAM; l: LPARAM): LResult; stdcall;
var m: TMsg;
begin
  case msg of
   WM_KEYDOWN:
     begin
       m.hwnd:=wnd;
       m.message:=WM_COMMAND;
       m.wParam:=TWindowHandle(wnd).Menu;
       m.lParam:=l;
       m.time:=CurrentTime;
       PostMsg(m);
     end;
   WM_LBUTTONDOWN:
     begin
       m.hwnd:=wnd;
       m.message:=WM_COMMAND;
       m.wParam:=TWindowHandle(wnd).Menu;
       m.lParam:=l;
       m.time:=CurrentTime;
       PostMsg(m);
     end;
  end;
  Result := DefWndProc(wnd,msg,w,l);
end;

function DesktopProc(wnd: HWND; msg: UINT; w: WPARAM; l: LPARAM): LResult; stdcall;
var
  Desktop: TWindowHandle;
begin
  Desktop:=TWindowHandle(wnd);
  case msg of
   WM_MOUSEMOVE:
     begin

     end;
   WM_RBUTTONDOWN:
     begin

     end;
   WM_KEYDOWN:
     begin

     end
   else
     Result := DefWndProc(wnd,msg,w,l);
  end;
end;

function EditBoxProc(wnd: HWND; msg: UINT; w: WPARAM; l: LPARAM): LResult; stdcall;
const can_undo: Boolean = false;
var
  Buffer: PChar;
  StrLine: String;
begin
  can_undo := false;
  //if Length(WindowHandle(wnd).WindowText) = 0 then TWindowHandle(wnd)^.WindowText := ' ';
  //WindowHandle(wnd).WindowText := stralloc(strlen(TWindowHandle(wnd)^.WindowText)*2+1);
  case msg of
   WM_LBUTTONDOWN:
     begin
       SetFocus(wnd);
       //ShowCursor;
     end;
   WM_KEYDOWN:
     begin
       case w of
         8: ; //BackSp-Taste
         9: ; //Tab-Taste
        10: ; //Zeilenvorschub
        13: ; //Wagenrücklauf (nur DOS/Windows)
        32..126:
          begin
            //strcat(TWindowHandle(wnd).WindowText, PChar(StrPas(chr(w))));
            TWindowHandle(wnd).WindowText := TWindowHandle(wnd).WindowText + chr(w);
            Writeln(TWindowHandle(wnd).WindowText);
          end;
       127: ; //Entf-Taste
       end;
     end;
   EM_CANUNDO:
     begin

     end;
   EM_CHARFROMPOS:
     begin

     end;
   EM_EMPTYUNDOBUFFER:
     begin

     end;
   EM_FMTLINES:
     begin

     end;
   {
   EM_GETCUEBANNER:
     begin

     end;
   }
   EM_GETFIRSTVISIBLELINE:
     begin

     end;
   EM_GETHANDLE:
     begin

     end;
   {
   EM_GETHILITE:
     begin

     end;
   EM_GETIMESTATUS:
     begin

     end;
   }
   EM_GETLIMITTEXT:
     begin

     end;
   EM_GETLINE:
     begin

     end;
   EM_GETLINECOUNT:
     begin

     end;
   EM_GETMARGINS:
     begin

     end;
   EM_GETMODIFY:
     begin

     end;
   EM_GETPASSWORDCHAR:
     begin

     end;
   EM_GETRECT:
     begin

     end;
   EM_GETSEL:
     begin

     end;
   EM_GETTHUMB:
     begin

     end;
   EM_GETWORDBREAKPROC:
     begin

     end;
   {
   EM_HIDEBALLOONTIP:
     begin

     end;
   }
   EM_LIMITTEXT:
     begin

     end;
   EM_LINEFROMCHAR:
     begin

     end;
   EM_LINEINDEX:
     begin

     end;
   EM_LINELENGTH:
     begin

     end;
   EM_LINESCROLL:
     begin

     end;
   {
   EM_NOSETFOCUS:
     begin

     end;
   }
   EM_POSFROMCHAR:
     begin

     end;
   EM_REPLACESEL:
     begin

     end;
   EM_SCROLL:
     begin

     end;
   EM_SCROLLCARET:
     begin

     end;
   {
   EM_SETCUEBANNER:
     begin

     end;
   }
   EM_SETHANDLE:
     begin

     end;
   {
   EM_SETHILITE:
     begin

     end;
   EM_SETIMESTATUS:
     begin

     end;
   }
   EM_SETMARGINS:
     begin

     end;
   EM_SETMODIFY:
     begin

     end;
   EM_SETPASSWORDCHAR:
     begin

     end;
   EM_SETREADONLY:
     begin

     end;
   EM_SETRECT:
     begin

     end;
   EM_SETRECTNP:
     begin

     end;
   EM_SETSEL:
     begin

     end;
   EM_SETTABSTOPS:
     begin

     end;
   EM_SETWORDBREAKPROC:
     begin

     end;
   {
   EM_SHOWBALLOONTIP:
     begin

     end;
   EM_TAKEFOCUS:
     begin

     end;
   }
   EM_UNDO:
     begin

     end;
   WM_UNDO:
     begin

     end;
   WM_CLEAR:
     begin

     end;
   WM_COPY:
     begin

     end;
   WM_CUT:
     begin

     end;
   WM_PASTE:
     begin

     end;
  end;
  Result := DefWndProc(wnd,msg,w,l);
end;

function TitlebarProc(wnd: HWND; msg: UINT; w: WPARAM; l: LPARAM): LResult; stdcall;
var
  wdw: TWindowHandle;
  r: TRect;
  br: HBRUSH;
  wt: HWND;
  ps: TPaintStruct;
  dc: HDC;
begin
  wdw := TWindowHandle(wnd);
  if wdw <> nil then
  begin
   case msg of
    WM_LBUTTONDOWN:
     {$ifdef windows}
     if (GetmouseX >= wdw.X) and (GetmouseY >= wdw.Y) and
        (GetmouseX <= wdw.X+wdw.nWidth) and
        (GetmouseY <= wdw.Y+wdw.nHeight)
     then
     begin
       MoveTo(20,10);
       PrintLnStr('Linke Maustaste gedrückt');
     end;
     {$else}
     if (mouseWhereX >= wdw.X) and (MouseWhereY >= wdw.Y) and
        (mouseWhereX <= wdw.X+wdw.nWidth) and
        (mouseWhereY <= wdw.Y+wdw.nHeight)
     then
     begin
       MoveTo(20,10);
       PrintLnStr('Linke Maustaste gedrückt');
     end;
     {$endif}
    WM_RBUTTONDOWN:
     begin

     end;
    WM_mouseMOVE:
     begin

     end;
     (*
    WM_PAINT:
     begin
       if wdw.wtitle <> nil then
       begin
         wt := HWND(wdw.wtitle);
         dc := BeginPaint(wt, ps);
         GetClientRect(wt, r);
         br := CreateSolidBrush(DarkBlue);
         FillRect(dc,r,br);
         DeleteObject(br);
         EndPaint(wt, ps);
       end;
     end; { von WM_PAINT }
     *)
   end;
  end;
  Result := DefWndProc(wnd,msg,w,l);
end;

function ListBoxProc(wnd: HWND; msg: UINT; w: WPARAM; l: LPARAM): LResult; stdcall;
begin
  case msg of
   WM_LBUTTONDOWN:
     begin

     end;
   WM_mouseMOVE:
     begin

     end;
   WM_KEYDOWN:
     begin

     end;
  end;
  Result := DefWndProc(wnd,msg,w,l);
end;

function RegisterButtonClassEx(): word;
var Button: TWndClassEx;
begin
  Button.cbSize := SizeOf(TWndClassEx);
  Button.Style := CS_HREDRAW or CS_VREDRAW;
  Button.lpfnWndProc := @ButtonProc;
  Button.cbClsExtra  := 0;
  Button.cbWndExtra  := 0;
  Button.hbrBackground := COLOR_APPWORKSPACE;
  Button.lpszMenuName  := nil;
  Button.lpszClassName := 'BUTTON';
  Button.hIconSm       := 0;

  Result := RegisterClassEx(Button);
end;

function RegisterDesktopClassEx(): word;
var Desktop: TWndClassEx;
begin
  Desktop.cbSize := SizeOf(TWndClassEx);
  Desktop.Style := CS_HREDRAW or CS_VREDRAW;
  Desktop.lpfnWndProc := @DesktopProc;
  Desktop.cbClsExtra  := 0;
  Desktop.cbWndExtra  := 0;
  Desktop.hbrBackground := COLOR_APPWORKSPACE;
  Desktop.lpszMenuName  := nil;
  Desktop.lpszClassName := 'DESKTOP';
  Desktop.hIconSm       := 0;

  Result := RegisterClassEx(Desktop);
end;

function RegisterEditboxClassEx(): word;
var EditBox: TWndClassEx;
begin
  EditBox.cbSize :=SizeOf(TWndClassEx);
  EditBox.Style := CS_HREDRAW or CS_VREDRAW;
  EditBox.lpfnWndProc := @EditBoxProc;
  EditBox.cbClsExtra  := 0;
  EditBox.cbWndExtra  := 0;
  EditBox.hbrBackground := COLOR_APPWORKSPACE; //richtige Farbe (Weiß) noch ergänzen
  EditBox.lpszMenuName  := nil;
  EditBox.lpszClassName := 'EDIT';
  EditBox.hIconSm       := 0;

  Result := RegisterClassEx(EditBox);
end;

function RegisterTitleBarClassEx(): word;
var TitleBar: TWndClassEx;
begin
  TitleBar.cbSize :=SizeOf(TWndClassEx);
  TitleBar.Style := CS_HREDRAW or CS_VREDRAW;
  TitleBar.lpfnWndProc := @TitleBarProc;
  TitleBar.cbClsExtra := 0;
  TitleBar.cbWndExtra := 0;
  TitleBar.hbrBackground := COLOR_APPWORKSPACE;
  TitleBar.lpszMenuName := nil;
  TitleBar.lpszClassName := '__TITLE_BAR__';
  TitleBar.hIconSm := 0;
  Result := RegisterClassEx(TitleBar);
end;

function RegisterListBoxClassEx(): word;
var ListBox: TWndClassEx;
begin
  ListBox.cbSize :=SizeOf(TWndClassEx);
  ListBox.Style := CS_HREDRAW or CS_VREDRAW;
  ListBox.lpfnWndProc := @ListBoxProc;
  ListBox.cbClsExtra := 0;
  ListBox.cbWndExtra := 0;
  ListBox.hbrBackground := COLOR_APPWORKSPACE;
  ListBox.lpszMenuName := nil;
  ListBox.lpszClassName := 'LISTBOX';
  ListBox.hIconSm := 0;
  Result := RegisterClassEx(ListBox);
end;

function DefWndProc(wnd: HWND; msg: UINT; w: WPARAM; l: LPARAM): LResult;
var
  Index: Integer;
  window: TWindowHandle;
  brush : HBRUSH;
  cast  : TCastRec;
  xx,yy : smallint;
  ll,tt : smallint;
  rr,bb : smallint;
  rect  : TRect;
  x1,y1 : Longint;
  x2,y2 : Longint;
  ps: TPaintStruct;
  dc: HDC;
  wt: HWND;
begin
  Window := TWindowHandle(wnd);
  case msg of
   WM_ACTIVATE: Result := HandleWMActivate(wnd,w,l);
   //WM_ACTIVATEAPP: Result := HandleWMActivateApp(wnd,w,l);
   //WM_APPCOMMAND: Result := HandleWMAppCommand(wnd,w,l);
   WM_ASKCBFORMATNAME: ;
   WM_CANCELJOURNAL: ;
   WM_CANCELMODE: ;
   WM_CAPTURECHANGED: ;
   WM_CHANGECBCHAIN: ;
   WM_CHAR: ;
   WM_CHARTOITEM: ;
   WM_CHILDACTIVATE: ;
   WM_CHOOSEFONT_GETLOGFONT: ;
   WM_CHOOSEFONT_SETLOGFONT: ;
   WM_CHOOSEFONT_SETFLAGS: ;
   WM_CLEAR: ;
   WM_CLIPBOARDUPDATE: ;
   WM_CLOSE: ;
   WM_COMMAND: ;
   WM_COMPACTING: ;
   WM_COMPAREITEM: ;
   WM_CONTEXTMENU: ;
   WM_COPY: ;
   WM_COPYDATA: ;
   WM_CREATE: ;
   WM_CTLCOLORBTN: ;
   WM_CTLCOLORDLG: ;
   WM_CTLCOLOREDIT: ;
   WM_CTLCOLORLISTBOX: ;
   WM_CTLCOLORMSGBOX: ;
   WM_CTLCOLORSCROLLBAR: ;
   WM_CTLCOLORSTATIC: ;
   WM_CUT: ;
   WM_DEADCHAR: ;
   WM_DELETEITEM: ;
   WM_DESTROY: ;
   WM_DESTROYCLIPBOARD: ;
   WM_DEVICECHANGE: ;
   WM_DEVMODECHANGE: ;
   WM_DISPLAYCHANGE: ;
   WM_DRAWCLIPBOARD: ;
   WM_DRAWITEM: ;
   WM_DROPFILES: ;
   WM_ENABLE: ;
   WM_ENDSESSION: ;
   WM_ENTERIDLE: ;
   WM_ENTERMENULOOP: ;
   WM_ENTERSIZEMOVE: Result := HandleWMEnterSizeMove(wnd,w,l);
   WM_ERASEBKGND: ;
   WM_EXITMENULOOP: ;
   WM_EXITSIZEMOVE: Result := HandleWMExitSizeMove(wnd,w,l);
   WM_FONTCHANGE: ;
   WM_GESTURE: ;
   WM_GESTURENOTIFY: ;
   WM_GESTURECOMMAND: ;
   WM_GETACTIONTEXT: ;
   WM_GETDLGCODE: ;
   WM_GETFONT: ;
   WM_GETHOTKEY: ;
   WM_GETICON: ;
   WM_GETMINMAXINFO: Result := HandleWMWindowPosChanging(wnd,w,l);
   WM_GETTEXT: ;
   WM_GETTEXTLENGTH: ;
   WM_GETTITLEBARINFOEX: ;
   WM_HELP: ;
   WM_HOTKEY: ;
   WM_HSCROLL: ;
   WM_HSCROLLCLIPBOARD: ;
   WM_ICONERASEBKGND: ;
   WM_IME_CHAR: ;
   WM_IME_COMPOSITION: ;
   WM_IME_COMPOSITIONFULL: ;
   WM_IME_CONTROL: ;
   WM_IME_ENDCOMPOSITION: ;
   WM_IME_KEYDOWN: ;
   WM_IME_KEYUP: ;
   WM_IME_NOTIFY:  ;
   WM_IME_REQUEST: ;
   WM_IME_SELECT: ;
   WM_IME_SETCONTEXT: ;
   WM_IME_STARTCOMPOSITION: ;
   WM_INITDIALOG: ;
   WM_INITMENU: ;
   WM_INITMENUPOPUP: ;
   WM_INPUT: ;
   WM_INPUT_DEVICE_CHANGE: ;
   WM_INPUTLANGCHANGE: ;
   WM_INPUTLANGCHANGEREQUEST: ;
   WM_KEYDOWN: HandleWMKeyDown(wnd,w,l);
   WM_KEYUP: HandleWMKeyUp(wnd,w,l);
   WM_KILLFOCUS: ;
   WM_LBUTTONDBLCLK: Result := HandleWMLButtonDown(wnd, w, l);
   WM_LBUTTONDOWN: Result := HandleWMLButtonDown(wnd, w, l);
   WM_LBUTTONUP: Result := HandleWMLButtonUp(wnd, w, l);
   WM_MBUTTONDBLCLK: Result := HandleWMMButtonDown(wnd,w,l);
   WM_MBUTTONDOWN: Result := HandleWMMButtonDown(wnd,w,l);
   WM_MBUTTONUP: Result := HandleWMMButtonUp(wnd,w,l);
   WM_MDIACTIVATE: ;
   WM_MDICASCADE: ;
   WM_MDICREATE: ;
   WM_MDIDESTROY: ;
   WM_MDIGETACTIVE: ;
   WM_MDIICONARRANGE: ;
   WM_MDIMAXIMIZE: ;
   WM_MDINEXT: ;
   WM_MDIREFRESHMENU: ;
   WM_MDIRESTORE: ;
   WM_MDISETMENU: ;
   WM_MDITILE: ;
   WM_MEASURECONTROL: ;
   WM_MEASUREITEM: ;
   WM_MENUCHAR: ;
   WM_MENUCOMMAND: ;
   WM_MENUSELECT: ;
   WM_MENURBUTTONUP: ;
   WM_MENUDRAG : ;
   WM_MENUGETOBJECT: ;
   WM_mouseACTIVATE: Result := HandleWMMouseActivate(wnd,w,l);
   WM_mouseMOVE: Result := HandleWMMouseMove(wnd,w,l);
   WM_mouseWHEEL: ;
   WM_mouseHWHEEL: ;
   WM_mouseHOVER: ;
   WM_mouseLEAVE: ;
   WM_MOVE: ;
   WM_MOVING: ;
   WM_NCACTIVATE: ;
   WM_NCCALCSIZE: ;
   WM_NCCREATE: ;
   WM_NCDESTROY: ;
   WM_NCHITTEST: ;
   WM_NCLBUTTONDBLCLK: ;
   WM_NCLBUTTONDOWN: ;
   WM_NCLBUTTONUP: ;
   WM_NCMBUTTONDBLCLK: ;
   WM_NCMBUTTONDOWN: ;
   WM_NCMBUTTONUP: ;
   WM_NCmouseMOVE: ;
   WM_NCPAINT: ;
   WM_NCRBUTTONDBLCLK: ;
   WM_NCRBUTTONDOWN: ;
   WM_NCRBUTTONUP: ;
   WM_NCXBUTTONDOWN: ;
   WM_NCXBUTTONUP: ;
   WM_NCXBUTTONDBLCLK: ;
   WM_NCmouseHOVER: ;
   WM_NCmouseLEAVE: ;
   WM_NEXTDLGCTL: ;
   WM_NOTIFY: ;
   WM_NOTIFYFORMAT: ;
   WM_NULL: ;
   WM_PAINT:
     //if not defwndproccalled then
     if InGraphMode then
     begin
       //Result := HandleWMPaint(wnd,w,l);
       //window.wtitle.wclass.lpfnWndProc(wnd,WM_PAINT,w,l);
       cast.dl := Window.X; xx := cast.wi;
       cast.dl := Window.Y; yy := cast.wi;
       MoveTo(xx+30,yy+50);
       SetColor(Wingraph.Green);
       PrintLnStr('WM_PAINT gesendet!');
       { Window
       if window <> nil then
       begin
         dc := BeginPaint(wnd, ps);
         if window.wtitle <> nil then
         begin
           GetClientRect(HWND(window.wtitle),rect);
           brush := CreateSolidBrush(Wingraph.Green);
           FillRect(dc,rect,brush);
           DeleteObject(brush);
         end;
         EndPaint(wnd,ps);
       end;
       //TitleBar
       wt := HWND(window.wtitle);
       dc := BeginPaint(wt, ps);
       GetClientRect(wt, rect);
       brush := CreateSolidBrush(DarkBlue);
       FillRect(dc, rect, brush);
       DeleteObject(brush);
       EndPaint(wt, ps);
       }
     end
     else
     begin
       //defwndproccalled := false;
     end;
   WM_PAINTCLIPBOARD: ;
   WM_PAINTICON: ;
   WM_PALETTECHANGED: ;
   WM_PALETTEISCHANGING: ;
   WM_PARENTNOTIFY: ;
   WM_PASTE: ;
   WM_PENWINFIRST: ;
   WM_PENWINLAST: ;
   WM_POWER: ;
   WM_POWERBROADCAST: ;
   WM_PRINT: ;
   WM_PRINTCLIENT: ;
   WM_PSD_ENVSTAMPRECT: ;
   //WM_PSD_FULLPAGERECT: ;
   WM_PSD_GREEKTEXTRECT: ;
   WM_PSD_MARGINRECT: ;
   WM_PSD_MINMARGINRECT: ;
   WM_PSD_PAGESETUPDLG: ;
   WM_PSD_YAFULLPAGERECT: ;
   WM_QUERYDRAGICON: ;
   WM_QUERYENDSESSION: ;
   WM_QUERYNEWPALETTE: ;
   WM_QUERYOPEN: ;
   WM_QUEUESYNC: ;
   WM_QUIT: Result := HandleWMQuit(wnd,w,l);
   WM_RBUTTONDBLCLK: Result := HandleWMRButtonDown(wnd,w,l);
   WM_RBUTTONDOWN: Result := HandleWMRButtonDown(wnd,w,l);
   WM_RBUTTONUP: Result := HandleWMRButtonUp(wnd,w,l);
   WM_RENDERALLFORMATS: ;
   WM_RENDERFORMAT: ;
   WM_SETCURSOR: ;
   WM_SETFOCUS: ;
   WM_SETFONT: ;
   WM_SETHOTKEY: ;
   WM_SETICON: ;
   WM_SETREDRAW: ;
   WM_SETTEXT: ;
   WM_SETTINGCHANGE: ;
   WM_SHOWWINDOW: ;
   WM_SIZE: ;
   WM_SIZECLIPBOARD: ;
   WM_SIZING: ;
   WM_SPOOLERSTATUS: ;
   WM_STYLECHANGED: ;
   WM_STYLECHANGING: ;
   WM_SYSCHAR: ;
   WM_SYSCOLORCHANGE: ;
   WM_SYSCOMMAND: ;
   WM_SYSDEADCHAR: ;
   WM_SYSKEYDOWN: ;
   WM_SYSKEYUP: ;
   WM_TCARD: ;
   WM_THEMECHANGED: ;
   WM_TIMECHANGE: ;
   WM_TIMER: ;
   WM_UNDO: ;
   WM_UNICHAR: ;
   WM_UNINITMENUPOPUP: ;
   //WM_USER: ;
   WM_USERCHANGED: ;
   WM_VKEYTOITEM: ;
   WM_VSCROLL: ;
   WM_VSCROLLCLIPBOARD: ;
   WM_WINDOWPOSCHANGED: ;
   WM_WINDOWPOSCHANGING: Result := HandleWMWindowPosChanging(wnd,w,l);
   //WM_WININICHANGE: ;
  end;
  defwndproccalled := true;
  IsStarted := true;
end;

function DefWindowProc(wnd: HWND; msg: UINT; w: WPARAM; l: LPARAM): LResult;
begin
  Result := DefWndProc(wnd, msg, w, l);
end;

function DefWindowProcA(wnd: HWND; msg: UINT; w: WPARAM; l: LPARAM): LResult;
begin
  Result := DefWndProc(wnd, msg, w, l);
end;

function DefWindowProcW(wnd: HWND; msg: UINT; w: WPARAM; l: LPARAM): LResult;
begin
  Result := DefWndProc(wnd, msg, w, l);
end;
{$endif}

function _equ_msg_(Msg: TMsg): boolean;
begin
  if (Msg.hwnd    = __message__.hwnd) and
     (Msg.message = __message__.message) and
     (Msg.wParam  = __message__.wParam) and
     (Msg.lParam  = __message__.lParam) and
     (Msg.pt.x    = __message__.pt.x) and
     (Msg.pt.y    = __message__.pt.y) and
     (Msg.time    = __message__.time) then Result := true else Result := false;
end;

function _push_message_(_msg: TMsg): TMsg;
begin
  __message__.hwnd    := _msg.hwnd;
  __message__.message := _msg.message;
  __message__.wParam  := _msg.wParam;
  __message__.lParam  := _msg.lParam;
  __message__.pt      := _msg.pt;
  __message__.time    := _msg.time;

  if _equ_msg_(__message__) then Result := _msg else writeln('Message nicht zugewiesen');
end;

function _pop_message_: TMsg;
begin
  Result := __message__;
end;

function GetAllMessages: LResult;
var msg: TMsgRec; m: TMsg;
begin
  repeat
    {$ifndef HX_DOS}
    PollMessage(m,0,0,0);
    {$endif}
    PostMessage(0,m.message,m.wParam,m.lParam);
    //DefWndProc(0,m.message,m.wParam,m.lParam);

  until m.message = WM_QUIT;
end;

{$ifndef HX_DOS}
function DispatchMessage(Message: TMsg): LResult;
var Index: Integer; WPtr: TWindowHandle;
begin
  Result := 0;
  Index := 0;
  if Message.hwnd = 0 then   //then call all windowprocs
  begin
    while Index < WindowList.Count do
    begin
      WPtr := WindowList.Window(Index);
      //if Assigned(WPtr) then
      if WPtr <> nil then
      begin
        if WPtr.wclass.lpfnWndProc <> nil then
        WPtr.wclass.lpfnWndProc(
           Message.hwnd,
           Message.message,
           Message.wParam,
           Message.lParam
        );
        //WPtr := WPtr.next;
      end;
      Inc(Index);
    end;
  end
  else
  begin
    Index := 0;
    while Index < WindowList.Count do
    begin
      if HWND(WindowList.Window(Index)) = Message.hwnd then
      begin
        WPtr := WindowList.Window(Index);
        //if Assigned(WPtr) then
        if WPtr <> nil then
        begin
          if WPtr.wclass.lpfnWndProc <> nil then
          WPtr.wclass.lpfnWndProc(
           Message.hwnd,
           Message.message,
           Message.wParam,
           Message.lParam
          );
          //WPtr := WPtr.next;
        end;
        Index := WindowList.Count;
      end;
      Inc(Index);
    end;
  end;
end;

function TranslateMessage(Message: TMsg): Boolean;
begin
  //Poll_dosmouse_Ev(Message, 0,0,0);

  Result := true;
end;
{$endif}

procedure FillBuffer(var Buf: array of TPixel; Color: word; Visible: Boolean; Exclude: TRect);
var I: Longint; x,y: Longint; ExcludeRgn: Boolean;
begin
  x := Exclude.Right-Exclude.Left;
  y := Exclude.Bottom-Exclude.Top;
  ExcludeRgn := (x > 0) or (y > 0);
  for I := Low(Buf) to High(Buf) do
  begin
    Buf[I].Color := Color;
    if ExcludeRgn then
    begin
      x := I mod (Exclude.Right-Exclude.Left);
      y := I div (Exclude.Right-Exclude.Left);
      if (x >= Exclude.Left) and (x <= Exclude.Right) and
         (y >= Exclude.Top) and (y <= Exclude.Bottom) then Buf[I].Visible := false;
    end else Buf[I].Visible := Visible;
  end;
end;

function DispatchMsg(Message: TMsg): LResult;
var WindowCount,MsgIndex: Integer;
begin
  //if Message.message = WM_QUIT then Halt else
  {$ifndef HX_DOS}
  case Message.message of
   WM_KEYDOWN: Result := HandleWMKeyDown(0,Message.wParam,Message.lParam);
   WM_KEYUP: Result := HandleWMKeyUp(0,Message.wParam,Message.lParam);
   WM_LBUTTONDOWN:
     begin
       //Println('WM_LBUTTONDOWN');
     end;
   WM_LBUTTONUP:
     begin
       //Println('WM_LBUTTONUP');
     end;
   WM_QUIT: Result := HandleWMQuit(WindowCount, Message.wParam, Message.lParam);
  end;

  if msgQueue.Count > 0 then
  begin
    MsgIndex := 0;
    while MsgIndex < msgQueue.Count do
    begin

      case msgQueue.messages[MsgIndex].message of
       WM_KEYDOWN: Result := HandleWMKeyDown(0,Message.wParam,Message.lParam);
       WM_KEYUP: Result := HandleWMKeyUp(0,Message.wParam,Message.lParam);
       WM_LBUTTONDOWN:
         begin
           writeln('WM_LBUTTONDOWN');
         end;
       WM_LBUTTONUP:
         begin
           writeln('WM_LBUTTONUP');
         end;
       WM_QUIT: Result := HandleWMQuit(WindowCount, Message.wParam, Message.lParam);
      end;

      Inc(MsgIndex);

    end;
  end;
  {$endif}
  IsStarted := true;
end;

{ TRegions }

function TRegions.GetRegion(Index: Integer): TRegionRec;
begin
  Result := PRegionRec(Items[Index])^;
end;

procedure TRegions.SetRegion(Index: Integer; AValue: TRegionRec);
begin
  PRegionRec(Items[Index])^ := AValue;
end;

destructor TRegions.Destroy;
var Index: Integer;
begin
  for Index := 0 to Count-1 do
    SetLength(PRegionRec(Items[Index])^.RectBuffer, 0);
  inherited Destroy;
end;

{ TMsgQueue }

function TMsgQueue.GetMsg(Index: Integer): TMsg;
var Rec: TMsgRec; RecPtr: PMsgRec; p: Pointer;
begin
  {
  if (Index >= 0) and (Index < Count) and (Count > 0) then
  begin
    p := Items[Index];
    RecPtr := PMsgRec(p);
    Result := RecPtr^;
  end
  else begin fillchar(Rec, sizeof(Rec), 0); Result := Rec; end;
  }
  Result := fMessage[Index mod 256];
end;

constructor TMsgQueue.Create;
begin
  inherited Create;
  FCount := 0;
end;

function TMsgQueue.Add(aMsg: TMsg): Integer;
var msgtemp: PMsgRec;
begin
  {
  New(msgtemp);
  msgtemp := PMsgRec(aMsg);
  Result := Inherited Add(msgtemp);
  }
  fMessage[FCount] := aMsg;
  Inc(FCount);
  if FCount > 255 then FCount := 0;
end;

function TMsgQueue.FindMessage(msg: UINT): Integer;
var index: Integer;
begin
  index := 0;
  Result := -1;
  while index < FCount do
  begin
    if GetMsg(index).message = msg then
    begin
      Result := index;
      index := Count-1;
    end;
    inc(index);
  end;
end;

function TMsgQueue.HasMessage(var msg): Boolean;
begin
  Result := FCount > 0;
  if Result then begin TMsg(msg) := GetMsg(0); {Delete(0);} end;
end;

procedure TMsgQueue.Clear;
begin
  fillChar(fMessage, sizeof(fMessage), 0);
end;

procedure TMsgQueue.Delete(Index: Integer);
var
  RecSize,RecCount: Integer;
begin
  RecSize := SizeOf(TMsg);
  RecCount := 256 - (Index mod 256);
  move(fMessage[succ(Index) mod 256], fMessage[Index mod 256], RecCount*RecSize);
end;

{ TGDIObjectItem }

function TGDIObjectItem.GetGDIkind: Integer;
begin
  Result := FGDIObject.gdiknd;
end;

procedure TGDIObjectItem.SetGDIkind(Value: Integer);
begin
  FGDIObject.gdiknd := Value;
end;

function TGDIObjectItem.GetGdiHandle: HGDIOBJ;
begin
  Result := FGDIObject.gdiobj;
end;

procedure TGDIObjectItem.SetGdiHandle(Value: HGDIOBJ);
begin
  FGDIObject.gdiobj := Value;
end;

function TGDIObjectItem.GetGdiObject: TGdiObject;
begin
  Result := FGDIObject;
end;

procedure TGDIObjectItem.SetGdiObject(Value: TGDIObject);
begin
  FGDIObject := Value;
end;

constructor TGDIObjectItem.Create;
begin
  inherited Create;
  New(FGDIObject.rgn);
end;

destructor TGDIObjectItem.Destroy;
begin
  if Assigned(FGDIObject.rgn) then
  begin
    FGDIObject.rgn^.Regions.free;
    FGDIObject.rgn^.Regions := NIL;
    Dispose(FGDIObject.rgn);
    FGDIObject.rgn := NIL;
  end;
  inherited Destroy;
end;

{ TGDIObjects }

function TGDIObjects.GetGDIObjectItem(Index: Integer): TGDIObjectItem;
begin
  Result := TGDIObjectItem(Items[Index]);
end;

{ TWindowClassEx }

constructor TWndClassRec.Create(wc: TWndClassEx);
begin
  inherited Create;
  FWndClassEx := wc;
end;


procedure TWindowClassEx.SetCapacity(value: Integer);
begin
  FCapacity := value;
  SetLength(FWndClasses,FCapacity);
end;

function TWindowClassEx.GetWndClassEx(Index: Integer): TWndClassEx;
begin
  if (Index>=0) and (Index<FCount) then Result := FWndClasses[Index];
end;

procedure TWindowClassEx.SetWndClassEx(Index: Integer; value: TWndClassEx);
begin
  if (Index>=0) and (Index<FCount) then FWndClasses[Index] := value;
end;

constructor TWindowClassEx.Create;
begin
  inherited Create;
  SetCapacity(10);
  FCount := 0;
  SetLength(FWndClasses,FCapacity);
end;

function TWindowClassEx.Add(wndc: TWndClassEx): Integer;
begin
  Inc(FCount);
  if FCapacity {div sizeof(TWndClassEx)} < FCount
     then SetCapacity(FCount);
  FWndClasses[FCount-1] := wndc;
  Result := FCount;
end;

function TWindowClassEx.Add(wndr: TWndClassRec): Integer;
begin
  Inc(FCount);
  if FCapacity {div sizeof(TWndClassEx)} < FCount
     then SetCapacity(FCount);
  FWndClasses[FCount-1] := wndr.WndClassEx;
  Result := FCount;
end;

function TWindowClassEx.Find(Item: String; var wc: TWndClassEx): Boolean;
var
  Index: Integer;
begin
  Result := false;
  Index := 0;
  while Index < self.Count do
  begin
    if FWndClasses[Index].lpszClassName = Item then
    begin
      wc := FWndClasses[Index];
      Index := self.Count;
      Result := true;
    end;
    Inc(Index);
  end;
end;

{ TWindowHandle }

constructor TWindowHandle.Create(
   dwExStyle: DWORD;
   lpClassName: LPCSTR;
   lpWindowName: LPCSTR; dwStyle: DWORD; X, Y: int;
   nWidth,
   nHeight: int;
   hwndParent: HWND;
   Menu: HMENU;
   Instance: HINSTANCE;
   lpParam: Pointer
);
var
  wc: TWndClassEx;
begin
  inherited Create;
  FdwExStyle    :=dwExStyle;
  FlpClassName  := lpClassName;
  FlpWindowName := lpWindowName;
  FdwStyle      := dwStyle;
  FX            := X;
  FY            := Y;
  FnWidth       := nWidth;
  FnHeight      := nHeight;
  FhwndParent   := hwndParent;
  FMenu         := Menu;
  FInstance     := Instance;
  FlpParam      := lpParam;
  New(Fcontext);//: PHeaderDeviceContext;
  FWindowData   := TStringList.Create;
  FWindowProp   := TStringList.Create;
  WindowText    := '';

  FActive       := true;
  FCaret        := false;
  FEnabled      := true;
  FFocused      := false;
  FIconic       := false;
  FVisible      := true;
  FZoomed       := false;

  FBckgndErase  := true;

  FParent       := TWindowHandle(FhwndParent);
  FNext         := NIL;

  if (dwStyle and WS_CAPTION) = WS_CAPTION then if Fwtitle = nil then
  begin
    Fwtitle       := TWindowHandle.Create(
      1,
      '__TITLE_BAR__',
      lpWindowName,
      WS_CHILD or WS_VISIBLE,
      X,
      Y,
      nWidth,
      y+HEIGHT_TITLEBAR,
      HWND(self),
      IDC_SYSMENU,
      Instance,
      nil
    );
    {
    if WindowClass.Find('__TITLE_BAR__', wc)
       then Fwclose.wclass := wc;
       }
    //WindowList.Add(Fwtitle);
  end;
  if Fwclose = nil then
  if Fwtitle <> nil then
  begin
    Fwclose := TWindowHandle.Create(
      5,
      'BUTTON',
      'X',
      WS_CHILD or WS_VISIBLE,
      Fwtitle.X+Fwtitle.nWidth-24, Fwtitle.Y + 2,
      WIDTH_TITLEBARBUTTONS,    //X+nWidth-4,
      HEIGHT_TITLEBARBUTTONS,
      HWND(Fwtitle),
      IDC_CLOSE,
      Instance,
      nil
    );
    if WindowClass.Find('__TITLE_BAR__', wc)
       then Fwclose.wclass := wc;
    //WindowList.Add(Fwtitle);
    if WindowClass.Find('BUTTON', wc)
       then Fwclose.wclass := wc;
    //WindowList.Add(FWClose);
  end;
  if (dwStyle and WS_MINIMIZEBOX) = WS_MINIMIZEBOX then
  if Fwmin = nil then
  if Fwtitle <> nil then
  begin
    Fwmin         := TWindowHandle.Create(
      3,
      'BUTTON',
      '_',
      WS_CHILD or WS_VISIBLE,
      Fwtitle.X+Fwtitle.nWidth-68, Fwtitle.Y + 2,
      WIDTH_TITLEBARBUTTONS,    //X+nWidth-4,
      HEIGHT_TITLEBARBUTTONS,
      HWND(Fwtitle),
      IDC_MINIMIZE,
      Instance,
      nil
    );
    if WindowClass.Find('BUTTON', wc)
       then Fwclose.wclass := wc;
    //WindowList.Add(Fwmin);
  end;
  if (dwStyle and WS_MAXIMIZEBOX) = WS_MAXIMIZEBOX then
  if Fwmax = nil then
  if Fwtitle <> nil then
  begin
    Fwmax         := TWindowHandle.Create(
      4,
      'BUTTON',
      '=',
      WS_CHILD or WS_VISIBLE,
      Fwtitle.X+Fwtitle.nWidth-46, Fwtitle.Y + 2,
      WIDTH_TITLEBARBUTTONS,    //X+nWidth-4,
      HEIGHT_TITLEBARBUTTONS,
      HWND(Fwtitle),
      IDC_MAXIMIZE,
      Instance,
      nil
    );
    if WindowClass.Find('BUTTON', wc)
       then Fwclose.wclass := wc;
    //WindowList.Add(Fwmax);
  end;
  if (dwStyle and WS_SYSMENU) = WS_SYSMENU then
  if Fwsys = nil then
  if Fwtitle <> nil then
  begin
    Fwsys         := TWindowHandle.Create(
      2,
      'BUTTON',
      '#',
      WS_CHILD or WS_VISIBLE,
      Fwtitle.X + 4, Fwtitle.Y + 2, WIDTH_TITLEBARBUTTONS, HEIGHT_TITLEBARBUTTONS,
      HWND(Fwtitle),
      IDC_SYSMENU,
      Instance,
      nil
    );
    if WindowClass.Find('BUTTON', wc)
       then Fwclose.wclass := wc;
    //WindowList.Add(Fwsys);
  end;
  if Fwsize = nil then
  if Fwtitle <> nil then
  begin
    Fwsize        := TWindowHandle.Create(
      6,
      'BUTTON',
      '>',
      WS_CHILD or WS_VISIBLE,
      X + nWidth - WIDTH_TITLEBARBUTTONS,
      Y + nHeight - HEIGHT_TITLEBARBUTTONS,
      WIDTH_TITLEBARBUTTONS,    //X+nWidth-4,
      HEIGHT_TITLEBARBUTTONS,
      HWND(self),
      $ff,
      Instance,
      nil
    );
    if WindowClass.Find('BUTTON', wc)
       then Fwclose.wclass := wc;
    //WindowList.Add(Fwsize);
  end;

  {
  Fparent       : TWindowHandle;
  Fnext         : TWindowHandle;
  Fsubwin       : TWindowHandle;
  }
end;

destructor TWindowHandle.Destroy;
begin
  FWindowProp.Free;
  FWindowData.Free;
  Dispose(FContext);
  inherited Destroy;
end;

{ TWindowList }

function TWindowList.Add(wnd: TWindowHandle): Integer;
begin
  Result := inherited Add(wnd);
end;

procedure TWindowList.CallWndProcs(wnd: HWND; msg: UINT; w: WPARAM; l: LPARAM);
var Index: Integer;
begin
  for Index := Count-1 downto 0 do
  begin
    if Assigned(TWindowHandle(Items[Index])) then
    if Assigned(TWindowHandle(Items[Index]).wclass.lpfnWndProc)
       then TWindowHandle(Items[Index]).wclass.lpfnWndProc(wnd,msg,w,l);
  end;
end;

function TWindowList.Window(Index: Integer): TWindowHandle;
begin
  Result := TWindowHandle(Items[Index]);
end;

{ TWindowTree }

function TWindowTree.GetNodes(Index: Integer): TWindowHandle;
begin
  Result := TWindowHandle(fSubnodes.Items[Index]);
end;

function TWindowTree.GetParent: TWindowHandle;
begin
  Result := fCurrent.Parent;
end;

function TWindowTree.GetWindow(Index: Integer): TWindowHandle;
begin

end;

constructor TWindowTree.Create;
begin
  inherited Create;
  fSubnodes := TList.Create;
  //fCurrent := ;
  //fSubnodes.Add(fCurrent);
end;

destructor TWindowTree.Destroy;
begin
  fSubnodes.Free;
  inherited Destroy;
end;

constructor TWindowPropData.Create(Data: Pointer; Size: Integer);
begin
  FData := Data;
  FSize := Size;
end;

destructor TWindowPropData.Destroy;
begin
  if FSize > 0 then freemem(FData,FSize) else freemem(FData);
  FData := NIL;
  inherited Destroy;
end;

constructor TNamedFont.Create(Fontname: String; Font: TLogFont);
begin
  inherited Create;
  FFontName := Fontname;
  New(FFont);
end;

destructor TNamedFont.Destroy;
begin
  Dispose(FFont);
  inherited Destroy;
end;

function TNamedFonts.GetFonts(Index: Integer): PNamedFont;
begin
  Result := PNamedFont(Items[Index]);
end;

procedure FreeWindowPtrs;
var Index: Integer;
begin
  {
  for Index := 0 to WindowList.Count-1 do
    if Assigned(WindowList.Window(Index)) then
    begin

      WindowList.Window(Index)^.WindowData.Free;
       WindowList.Window(Index)^.WindowProp.Free;
       if Assigned(WindowList.Window(Index)^.wmax) then Dispose(WindowList.Window(Index)^.wmax);
       if Assigned(WindowList.Window(Index)^.wmin) then Dispose(WindowList.Window(Index)^.wmin);
       if Assigned(WindowList.Window(Index)^.wsys) then Dispose(WindowList.Window(Index)^.wsys);
       if Assigned(WindowList.Window(Index)^.wclose) then Dispose(WindowList.Window(Index)^.wclose);
       if Assigned(WindowList.Window(Index)^.wtitle) then Dispose(WindowList.Window(Index)^.wtitle);
       if Assigned(WindowList.Window(Index)^.wsize) then Dispose(WindowList.Window(Index)^.wsize);
       if Assigned(WindowList.Window(Index)^.next) then Dispose(WindowList.Window(Index)^.next);
       if Assigned(WindowList.Window(Index)^.parent) then Dispose(WindowList.Window(Index)^.parent);
       if Assigned(WindowList.Window(Index)^.subwin) then Dispose(WindowList.Window(Index)^.subwin);
       if Assigned(WindowList.Window(Index)^.context) then
       begin
         SetLength(WindowList.Window(Index)^.context^.ClientBuffer, 0);
         Dispose(WindowList.Window(Index)^.context);
       end;
    end;
  }
  WindowList.Free;

end;

{$I hxvesa.inc}

var gd,gm: smallint; maxX,maxY: DWORD; tmp: word; {$ifdef HX_DOS}mInfo: TSVGAINFO;{$endif}

initialization
  //InitKeyboard;
  {$ifdef HX_DOS}
    VesaInit();
    VesaMouseInit();
    SetVesaMode(m640x480x24);
    {$UNDEF USE_GRAPH}
  {$ELSE}
  {$IFDEF USE_GRAPH}
    DetectGraph(gd,gm);
    InitGraph(gd,gm,'');
    InGraphMode := true;
    if GraphResult <> grOk then
    begin
      InGraphMode := false;
      writeln('Keine Grafikunterstützung! Sorry ... !');
      readln;
      Halt(1);
    end;
    {$ifndef windows}
    Initmouse;
    if Detectmouse <> 0 then
    begin
      Showmouse;
      PrintLnStr('Maus erkannt');
    end;

    tmp := GetmouseButtons;
    if tmp <> 0 then PrintLnStr('Maus erkannt');
    {$endif}
  {$ENDIF}
  {$ENDIF}
  GlobalAtom := TStringlist.Create;
  msgQueue := TMsgQueue.Create;
  WindowClass := TWindowClassEx.Create;
  WindowMain := NIL;
  //New(WindowRoot);
  WindowPtr := NIL;
  WindowList := TWindowList.Create;
  IsStarted := false;

  fillchar(Startup, SizeOf(Startup), 0);
  fillchar(NULL_RECT,sizeof(NULL_RECT),$00);
  Startup.cb := Sizeof(TStartupInfo);
  Startup.dwX := 20;
  Startup.dwY := 20;
  {$ifndef HX_DOS}
  cast.wi := GetMaxX - 20;
  Startup.dwXSize := cast.dw;
  cast.wi := GetMaxY - 20;
  Startup.dwYSize := cast.dw;
  {$else}

  Startup.dwXSize := 640;
  Startup.dwYSize := 480;
  {$endif}
  Startup.dwFlags := STARTF_USEPOSITION or
                     STARTF_USESIZE or
                     {STARTF_TITLEISAPPID or}
                     STARTF_USESHOWWINDOW; //or STARTF_RUNFULLSCREEN;

  //RegisterButtonClassEx();

  namedfonts := TNamedFonts.Create;
  fonts   := Tlist.Create;
  bitmaps := Tlist.Create;
  pens    := TList.Create;
  brushes := TList.Create;

  gdiobjects := TGDIObjects.Create;
  //WindowRoot := TWindowHandle(CreateWindowEx(0,'DESKTOP','DesktopWindow',0,0,0,GetMaxX,GetMaxY,0,0,0,nil));
  //WindowRoot := TWindowHandle.Create(0,'DESKTOP','DesktopWindow',0,0,0,GetMaxX,GetMaxY,0,0,0,nil);

finalization
  //DoneKeyboard;
  {$IFNDEF HX_DOS}
   {$ifndef windows}
     Donemouse;
   {$endif}
  {$ENDIF}
  WindowClass.Free;
  msgQueue.Free;
  WindowMain := NIL;
  WindowRoot := NIL;
  WindowPtr := NIL;
  FreeWindowPtrs;
  GlobalAtom.Free;

  brushes.Free;
  pens.Free;
  bitmaps.Free;
  fonts.Free;
  namedfonts.free;
  gdiobjects.Free;
  {$ifdef HX_DOS}
    VesaMouseExit();
    VesaExit();
  {$endif}
  {$ifdef USE_GRAPH}
    CloseGraph;
  {$endif}
  InGraphMode := false;

end.
