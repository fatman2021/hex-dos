unit doskeybd;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

{.$ifdef read_implementation}{.$undef read_implementation}{.$endif}
{.$define read_interface}

const
  KEY_LEFT_SHIFT = $01;
  KEY_LEFT_CTRL  = $02;
  KEY_LEFT_ALT   = $04;
  KEY_RGHT_SHIFT = $01;
  KEY_RGHT_CTRL  = $02;
  KEY_RGHT_ALT   = $04;

  VK_LBUTTON = 1;
  VK_RBUTTON = 2;
  VK_CANCEL = 3;
  VK_MBUTTON = 4;
  VK_BACK = 8;
  VK_TAB = 9;
  VK_CLEAR = 12;
  VK_RETURN = 13;
  VK_SHIFT = 16;
  VK_CONTROL = 17;
  VK_MENU = 18;
  VK_PAUSE = 19;
  VK_CAPITAL = 20;
  VK_ESCAPE = 27;
  VK_SPACE = 32;
  VK_PRIOR = 33;
  VK_NEXT = 34;
  VK_END = 35;
  VK_HOME = 36;
  VK_LEFT = 37;
  VK_UP = 38;
  VK_RIGHT = 39;
  VK_DOWN = 40;
  VK_SELECT = 41;
  VK_PRINT = 42;
  VK_EXECUTE = 43;
  VK_SNAPSHOT = 44;
  VK_INSERT = 45;
  VK_DELETE = 46;
  VK_HELP = 47;
  VK_0 = 48;
  VK_1 = 49;
  VK_2 = 50;
  VK_3 = 51;
  VK_4 = 52;
  VK_5 = 53;
  VK_6 = 54;
  VK_7 = 55;
  VK_8 = 56;
  VK_9 = 57;
  VK_A = 65;
  VK_B = 66;
  VK_C = 67;
  VK_D = 68;
  VK_E = 69;
  VK_F = 70;
  VK_G = 71;
  VK_H = 72;
  VK_I = 73;
  VK_J = 74;
  VK_K = 75;
  VK_L = 76;
  VK_M = 77;
  VK_N = 78;
  VK_O = 79;
  VK_P = 80;
  VK_Q = 81;
  VK_R = 82;
  VK_S = 83;
  VK_T = 84;
  VK_U = 85;
  VK_V = 86;
  VK_W = 87;
  VK_X = 88;
  VK_Y = 89;
  VK_Z = 90;
  VK_LWIN = 91;
  VK_RWIN = 92;
  VK_APPS = 93;
  VK_NUMPAD0 = 96;
  VK_NUMPAD1 = 97;
  VK_NUMPAD2 = 98;
  VK_NUMPAD3 = 99;
  VK_NUMPAD4 = 100;
  VK_NUMPAD5 = 101;
  VK_NUMPAD6 = 102;
  VK_NUMPAD7 = 103;
  VK_NUMPAD8 = 104;
  VK_NUMPAD9 = 105;
  VK_MULTIPLY = 106;
  VK_ADD = 107;
  VK_SEPARATOR = 108;
  VK_SUBTRACT = 109;
  VK_DECIMAL = 110;
  VK_DIVIDE = 111;
  VK_F1 = 112;
  VK_F2 = 113;
  VK_F3 = 114;
  VK_F4 = 115;
  VK_F5 = 116;
  VK_F6 = 117;
  VK_F7 = 118;
  VK_F8 = 119;
  VK_F9 = 120;
  VK_F10 = 121;
  VK_F11 = 122;
  VK_F12 = 123;
  VK_F13 = 124;
  VK_F14 = 125;
  VK_F15 = 126;
  VK_F16 = 127;
  VK_F17 = 128;
  VK_F18 = 129;
  VK_F19 = 130;
  VK_F20 = 131;
  VK_F21 = 132;
  VK_F22 = 133;
  VK_F23 = 134;
  VK_F24 = 135;
 { GetAsyncKeyState  }
  VK_NUMLOCK = 144;
  VK_SCROLL = 145;
  VK_LSHIFT = 160;
  VK_LCONTROL = 162;
  VK_LMENU = 164;
  VK_RSHIFT = 161;
  VK_RCONTROL = 163;
  VK_RMENU = 165;
 { ImmGetVirtualKey  }
  VK_PROCESSKEY = 229;

  keyBackSpace   =	 $08; // VK_BACK
  keyTab         =	 $09; // VK_TAB
  keyClear       =	 $0c; // VK_CLEAR
  keyReturn      =	 $0d; // VK_RETURN
  keyShift       =	 $10; // VK_SHIFT
  keyCtrl	 =	 $11; // VK_CONTROL
  keyAlt	 =	 $12; // VK_MENU
  keyPause	 =	 $13; // VK_PAUSE
  keyEscape	 =	 $1b; // VK_ESCAPE
  keyModeSwitch  =	 $1f; // VK_MODECHANGE
  keyPrior	 =	 $21; // VK_PRIOR
  keyNext	 =	 $22; // VK_NEXT
  keyEnd	 =	 $23; // VK_END
  keyHome	 =       $24; // VK_HOME
  keyLeft	 =	 $25; // VK_LEFT
  keyUp          =	 $26; // VK_UP
  keyRight	 =	 $27; // VK_RIGHT
  keyDown	 =	 $28; // VK_DOWN
  keySelect	 =	 $29; // VK_SELECT
  keyPrintScreen =	 $2a; // VK_PRINT
  keyExecute	 =	 $2b; // VK_EXECUTE
  keyPrintScrn   =	 $2c; // VK_SNAPSHOT
  keyInsert	 =       $2d; // VK_INSERT
  keyDelete	 =	 $2e; // VK_DELETE
  keyHelp	 =	 $2f; // VK_HELP
  keyP0		 =       $60; // VK_NUMPAD0
  keyP1		 =       $61; // VK_NUMPAD1
  keyP2		 =       $62; // VK_NUMPAD2
  keyP3		 =       $63; // VK_NUMPAD3
  keyP4		 =       $64; // VK_NUMPAD4
  keyP5		 =       $65; // VK_NUMPAD5
  keyP6		 =       $66; // VK_NUMPAD6
  keyP7		 =       $67; // VK_NUMPAD7
  keyP8		 =       $68; // VK_NUMPAD8
  keyP9		 =       $69; // VK_NUMPAD9
  keyPAsterisk	 =       $6a; // VK_MULTIPLY
  keyPPlus	 =       $6b; // VK_ADD
  keyPSeparator	 =       $6c; // VK_SEPARATOR
  keyPMinus	 =       $6d; // VK_SUBTRACT
  keyPDecimal	 =       $6e; // VK_DECIMAL
  keyPSlash	 =       $6f; // VK_DIVIDE
  keyF1		 =       $70; // VK_F1
  keyF2		 =       $71; // VK_F2
  keyF3		 =       $72; // VK_F3
  keyF4		 =       $73; // VK_F4
  keyF5		 =       $74; // VK_F5
  keyF6		 =       $75; // VK_F6
  keyF7		 =       $76; // VK_F7
  keyF8		 =       $77; // VK_F8
  keyF9		 =       $78; // VK_F9
  keyF10	 =       $79; // VK_F10
  keyF11	 =       $7a; // VK_F11
  keyF12	 =       $7b; // VK_F12
  keyF13	 =       $7c; // VK_F13
  keyF14	 =       $7d; // VK_F14
  keyF15	 =       $7e; // VK_F15
  keyF16	 =       $7f; // VK_F16
  keyF17	 =       $80; // VK_F17
  keyF18	 =       $81; // VK_F18
  keyF19	 =       $82; // VK_F19
  keyF20	 =       $83; // VK_F20
  keyF21	 =       $84; // VK_F21
  keyF22	 =       $85; // VK_F22
  keyF23	 =       $86; // VK_F23
  keyF24	 =       $87; // VK_F24
  keyNumLock	 =	 $90; // VK_NUMLOCK
  keyScroll	 =	 $91; // VK_SCROLL
  keyShiftL      =	 $a0; // VK_LSHIFT
  keyShiftR	 =	 $a1; // VK_RSHIFT
  keyCtrlL	 =	 $a2; // VK_LCONTROL
  keyCtrlR	 =	 $a3; // VK_RCONTROL
  keyDeadCircumflex =	 $dc; // VK_OEM_5
  keyDeadAcute	 =       $dd; // VK_OEM_6
  key_P5	 =       $e4; // VK_ICO_00
  KeyNIL         =       $ffff;

  kbAscii        =       $010F;
  kbFnKey        =       $010E;
  kbUnicode      =       $010D;
  kbPhys         =       $010C;
  kbReleased     =       $010B;

  {.$I gdikeys.inc}

type
  TKeyboardState = array[0..255] of byte;
  TKeyCode = record
    KeyChar: Char;
    KeyScan: Byte;
    KeyVirt: word;
    KeyShft: word; // Ctrl, Alt, Shift
    KeyLeft: byte; //   7   6   5   4   3   2   1   0
    KeyRght: byte; //   0   0   0   0   0 Ctrl Alt shift
  end;
  TKeyConv = record
    case Longint of
     0: (keychar: byte);
     1: (keyscan: word);
     2: (keycode: TKeycode);
     3: (keylong: Longint);
  end;
  TKeyEvent = record
    CharCode: byte;
    ScanCode: byte;
    VirtCode: word;
    ShiftState: TShiftState;
    ShiftDirection: byte;
  end;
  TKeyRec = record
    case word of
     0: (keycode: word);
     1: (keychar: array[0..1] of char);
  end;

var
  Keychars: array[0..255] of TKeyCode;
  Scankeys: array[0..255] of TKeyCode;

  function GetDosKeyCode: word;
  function GetKeyCode: word;
  function GetVirtKeyCode(Code: word; scan: Boolean): word;
  function GetVKeyOf(bioskey: word): TKeyEvent;
  function ShiftStateAsString(AShift: TShiftState): String;
  function PollKeyEvent: TKeyEvent;
  function GetKeyEventChar(ev: TKeyEvent): Char;
  function GetKeyEventCode(ev: TKeyEvent): Byte;
  function GetKeyEventFlags(ev: TKeyEvent): word;

implementation

{.$ifdef read_interface}{.$undef read_interface}{.$endif}
{.$define read_implementation}
{.$I gdikeys.inc}

procedure InitKeyChars;
begin
  fillchar(Keychars,sizeof(Keychars),$00);
  fillchar(Scankeys,sizeof(Scankeys),$00);

  Scankeys[59].KeyScan:=59;
  Scankeys[59].KeyVirt:=VK_F1;

  Scankeys[60].KeyScan:=60;
  Scankeys[60].KeyVirt:=VK_F2;

  Scankeys[61].KeyScan:=61;
  Scankeys[61].KeyVirt:=VK_F3;

  Scankeys[62].KeyScan:=62;
  Scankeys[62].KeyVirt:=VK_F4;

  Scankeys[63].KeyScan:=63;
  Scankeys[63].KeyVirt:=VK_F5;

  Scankeys[64].KeyScan:=64;
  Scankeys[64].KeyVirt:=VK_F6;

  Scankeys[65].KeyScan:=65;
  Scankeys[65].KeyVirt:=VK_F7;

  Scankeys[66].KeyScan:=66;
  Scankeys[66].KeyVirt:=VK_F8;

  Scankeys[67].KeyScan:=67;
  Scankeys[67].KeyVirt:=VK_F9;

  Scankeys[68].KeyScan:=68;
  Scankeys[68].KeyVirt:=VK_F10;

  Scankeys[71].KeyScan:=71;
  Scankeys[71].KeyVirt:=VK_HOME;

  Scankeys[72].KeyScan:=72;
  ScanKeys[72].KeyVirt:=VK_UP;

  Scankeys[73].KeyScan:=73;
  Scankeys[73].KeyVirt:=VK_PRIOR;

  Scankeys[75].KeyScan:=75;
  Scankeys[75].KeyVirt:=VK_LEFT;

  Scankeys[77].KeyScan:=77;
  Scankeys[77].KeyVirt:=VK_RIGHT;

  Scankeys[79].KeyScan:=79;
  Scankeys[79].KeyVirt:=VK_END;

  Scankeys[80].KeyScan:=80;
  Scankeys[80].KeyVirt:=VK_DOWN;

  Scankeys[81].KeyScan:=81;
  Scankeys[81].KeyVirt:=VK_NEXT;

  Scankeys[82].KeyScan:=82;
  Scankeys[82].KeyVirt:=VK_INSERT;

  Scankeys[83].KeyScan:=83;
  Scankeys[83].KeyVirt:=VK_DELETE;

  Scankeys[133].KeyScan:=133;
  Scankeys[133].KeyVirt:=VK_F11;

  Scankeys[134].KeyScan:=134;
  Scankeys[134].KeyVirt:=VK_F12;

  {000}
  Keychars[0].KeyChar := #0;
  Keychars[0].KeyScan := $00;
  KeyChars[0].KeyVirt := $00;
  {001}
  Keychars[1].KeyChar := #1;
  Keychars[1].KeyScan := $00;
  KeyChars[1].KeyVirt := 0;
  {002}
  Keychars[2].KeyChar := #2;
  Keychars[2].KeyScan := $00;
  KeyChars[2].KeyVirt := 0;
  {003}
  Keychars[3].KeyChar := #3;
  Keychars[3].KeyScan := $00;
  KeyChars[3].KeyVirt := 0;
  {004}
  Keychars[4].KeyChar := #4;
  Keychars[4].KeyScan := $00;
  KeyChars[4].KeyVirt := 0;
  {005}
  Keychars[5].KeyChar := #5;
  Keychars[5].KeyScan := $00;
  KeyChars[5].KeyVirt := $00;
  {006}
  Keychars[6].KeyChar := #6;
  Keychars[6].KeyScan := $00;
  KeyChars[6].KeyVirt := $00;
  {007}
  Keychars[7].KeyChar := #7;
  Keychars[7].KeyScan := $00;
  KeyChars[7].KeyVirt := $00;
  {008}
  Keychars[8].KeyChar := #8;
  Keychars[8].KeyScan := $0e;
  KeyChars[8].KeyVirt := VK_BACK;
  {009}
  Keychars[9].KeyChar := #9;
  Keychars[9].KeyScan := $0f;
  KeyChars[9].KeyVirt := VK_TAB;
  {010}
  Keychars[10].KeyChar := #10;
  Keychars[10].KeyScan := $00;
  KeyChars[10].KeyVirt := $00;
  {011}
  Keychars[11].KeyChar := #11;
  Keychars[11].KeyScan := $00;
  KeyChars[11].KeyVirt := $00;
  {012}
  Keychars[12].KeyChar := #12;
  Keychars[12].KeyScan := $00;
  KeyChars[12].KeyVirt := $00;
  {013}
  Keychars[13].KeyChar := #13;
  Keychars[13].KeyScan := $1C;
  KeyChars[13].KeyVirt := VK_RETURN;
  {014}
  Keychars[14].KeyChar := #14;
  Keychars[14].KeyScan := 0;
  KeyChars[14].KeyVirt := 0;
  {015}
  Keychars[15].KeyChar := #15;
  Keychars[15].KeyScan := 0;
  KeyChars[15].KeyVirt := 0;
  {016}
  Keychars[16].KeyChar := #16;
  Keychars[16].KeyScan := $00;
  KeyChars[16].KeyVirt := 00;
  {017}
  Keychars[17].KeyChar := #17;
  Keychars[17].KeyScan := $00;
  KeyChars[17].KeyVirt := 00;
  {018}
  Keychars[18].KeyChar := #18;
  Keychars[18].KeyScan := $00;
  KeyChars[18].KeyVirt := 00;
  {019}
  Keychars[19].KeyChar := #19;
  Keychars[19].KeyScan := $00;
  KeyChars[19].KeyVirt := 0;
  {020}
  Keychars[20].KeyChar := #20;
  Keychars[20].KeyScan := $00;
  KeyChars[20].KeyVirt := 0;

  Keychars[21].KeyChar := #21;
  Keychars[21].KeyScan := $00;
  KeyChars[21].KeyVirt := $00; //VK_KANA;

  Keychars[22].KeyChar := #22;
  Keychars[22].KeyScan := $00;
  KeyChars[22].KeyVirt := $00;

  Keychars[23].KeyChar := #23;
  Keychars[23].KeyScan := $00;
  KeyChars[23].KeyVirt := $00; //VK_JUNJA;

  Keychars[24].KeyChar := #24;
  Keychars[24].KeyScan := $00;
  KeyChars[24].KeyVirt := $00; //VK_FINAL;

  Keychars[25].KeyChar := #25;
  Keychars[25].KeyScan := $00;
  KeyChars[25].KeyVirt := $00; //VK_HANJA;

  Keychars[26].KeyChar := #26;
  Keychars[26].KeyScan := $00;
  KeyChars[26].KeyVirt := $00;

  Keychars[27].KeyChar := #27;
  Keychars[27].KeyScan := 1;
  KeyChars[27].KeyVirt := VK_ESCAPE;

  Keychars[28].KeyChar := #28;
  Keychars[28].KeyScan := $00;
  KeyChars[28].KeyVirt := $00; //VK_CONVERT;

  Keychars[29].KeyChar := #29;
  Keychars[29].KeyScan := 0;
  KeyChars[29].KeyVirt := $00; //VK_NONCONVERT;

  Keychars[30].KeyChar := #30;
  Keychars[30].KeyScan := $00;
  KeyChars[30].KeyVirt := $00; //VK_ACCEPT;

  Keychars[31].KeyChar := #31;
  Keychars[31].KeyScan := $00;
  KeyChars[31].KeyVirt := $00; //VK_MODECHANGE;

  Keychars[32].KeyChar := #32;
  Keychars[32].KeyScan := $39;
  KeyChars[32].KeyVirt := VK_SPACE;

  Keychars[33].KeyChar := #33;  {!}
  Keychars[33].KeyScan := $00;
  KeyChars[33].KeyVirt := KeyShiftR;

  Keychars[34].KeyChar := #34;  {"}
  Keychars[34].KeyScan := $00;
  KeyChars[34].KeyVirt := KeyShiftR;

  Keychars[35].KeyChar := #35;  {#}
  Keychars[35].KeyScan := $00;
  KeyChars[35].KeyVirt := 0;

  Keychars[36].KeyChar := #36;  { $ }
  Keychars[36].KeyScan := 0;
  KeyChars[36].KeyVirt := KeyShiftR;

  Keychars[37].KeyChar := #37;  {%}
  Keychars[37].KeyScan := 0;
  KeyChars[37].KeyVirt := KeyShiftR;

  Keychars[38].KeyChar := #38;  {&}
  Keychars[38].KeyScan := 0;
  KeyChars[38].KeyVirt := KeyShiftR;

  Keychars[39].KeyChar := #39;  {'}
  Keychars[39].KeyScan := 0;
  KeyChars[39].KeyVirt := KeyShiftR;

  Keychars[40].KeyChar := #40;  {(}
  Keychars[40].KeyScan := 0;
  KeyChars[40].KeyVirt := KeyShiftR;

  Keychars[41].KeyChar := #41;  {)}
  Keychars[41].KeyScan := 0;
  KeyChars[41].KeyVirt := KeyShiftR;

  Keychars[42].KeyChar := #42;  {*}
  Keychars[42].KeyScan := 0;
  KeyChars[42].KeyVirt := KeyShiftR;

  Keychars[43].KeyChar := #43;  {+}
  Keychars[43].KeyScan := 0;
  KeyChars[43].KeyVirt := VK_ADD;

  Keychars[44].KeyChar := #44;  {,}
  Keychars[44].KeyScan := 0;
  KeyChars[44].KeyVirt := 0;

  Keychars[45].KeyChar := #45;  {-}
  Keychars[45].KeyScan := 0;
  KeyChars[45].KeyVirt := VK_SUBTRACT;

  Keychars[46].KeyChar := #46;  {.}
  Keychars[46].KeyScan := 0;
  KeyChars[46].KeyVirt := 0;

  Keychars[47].KeyChar := #47;  {/}
  Keychars[47].KeyScan := 0;
  KeyChars[47].KeyVirt := KeyShiftR;

  Keychars[48].KeyChar := '0';
  Keychars[48].KeyScan := 0;
  KeyChars[48].KeyVirt := VK_0;

  Keychars[49].KeyChar := '1';
  Keychars[49].KeyScan := 0;
  KeyChars[49].KeyVirt := VK_1;

  Keychars[50].KeyChar := '2';
  Keychars[50].KeyScan := 0;
  KeyChars[50].KeyVirt := VK_2;

  Keychars[51].KeyChar := '3';
  Keychars[51].KeyScan := 0;
  KeyChars[51].KeyVirt := VK_3;

  Keychars[52].KeyChar := '4';
  Keychars[52].KeyScan := 0;
  KeyChars[52].KeyVirt := VK_4;

  Keychars[53].KeyChar := '5';
  Keychars[53].KeyScan := 0;
  KeyChars[53].KeyVirt := VK_5;

  Keychars[54].KeyChar := '6';
  Keychars[54].KeyScan := 0;
  KeyChars[54].KeyVirt := VK_6;

  Keychars[55].KeyChar := '7';
  Keychars[55].KeyScan := 0;
  KeyChars[55].KeyVirt := VK_7;

  Keychars[56].KeyChar := '8';
  Keychars[56].KeyScan := 0;
  KeyChars[56].KeyVirt := VK_8;

  Keychars[57].KeyChar := '9';
  Keychars[57].KeyScan := 0;
  KeyChars[57].KeyVirt := VK_9;

  Keychars[58].KeyChar := #58;
  Keychars[58].KeyScan := 0;
  KeyChars[58].KeyVirt := KeyShiftR;

  Keychars[59].KeyChar := #59;
  Keychars[59].KeyScan := 0;
  KeyChars[59].KeyVirt := KeyShiftR;

  Keychars[60].KeyChar := #60;
  Keychars[60].KeyScan := 0;
  KeyChars[60].KeyVirt := 0;

  Keychars[61].KeyChar := #61;
  Keychars[61].KeyScan := 0;
  KeyChars[61].KeyVirt := KeyShiftR;

  Keychars[62].KeyChar := #62;
  Keychars[62].KeyScan := 0;
  KeyChars[62].KeyVirt := KeyShiftR;

  Keychars[63].KeyChar := #63;
  Keychars[63].KeyScan := 0;
  KeyChars[63].KeyVirt := KeyShiftR;

  Keychars[64].KeyChar := #64;
  Keychars[64].KeyScan := 0;
  KeyChars[64].KeyVirt := KeyAlt;

  Keychars[65].KeyChar := #65;
  Keychars[65].KeyScan := 0;
  KeyChars[65].KeyVirt := VK_A;
  KeyChars[65].KeyShft := KeyShiftR;

  Keychars[66].KeyChar := #66;
  Keychars[66].KeyScan := 0;
  KeyChars[66].KeyVirt := VK_B;
  KeyChars[66].KeyShft := KeyShiftR;

  Keychars[67].KeyChar := #67;
  Keychars[67].KeyScan := 0;
  KeyChars[67].KeyVirt := VK_C;
  KeyChars[67].KeyShft := KeyShiftR;

  Keychars[68].KeyChar := #68;
  Keychars[68].KeyScan := 0;
  KeyChars[68].KeyVirt := VK_D;
  KeyChars[68].KeyShft := KeyShiftR;

  Keychars[69].KeyChar := #69;
  Keychars[69].KeyScan := 0;
  KeyChars[69].KeyVirt := VK_E;
  KeyChars[69].KeyShft := KeyShiftR;

  Keychars[70].KeyChar := #70;
  Keychars[70].KeyScan := 0;
  KeyChars[70].KeyVirt := VK_F;
  KeyChars[70].KeyShft := KeyShiftR;

  Keychars[71].KeyChar := #71;
  Keychars[71].KeyScan := 0;
  KeyChars[71].KeyVirt := VK_G;
  KeyChars[71].KeyShft := KeyShiftR;

  Keychars[72].KeyChar := #72;
  Keychars[72].KeyScan := 0;
  KeyChars[72].KeyVirt := VK_H;
  KeyChars[72].KeyShft := KeyShiftR;

  Keychars[73].KeyChar := #73;
  Keychars[73].KeyScan := 0;
  KeyChars[73].KeyVirt := VK_I;
  KeyChars[73].KeyShft := KeyShiftR;

  Keychars[74].KeyChar := #74;
  Keychars[74].KeyScan := 2;
  KeyChars[74].KeyVirt := VK_J;
  KeyChars[74].KeyShft := KeyShiftR;

  Keychars[75].KeyChar := #75;
  Keychars[75].KeyScan := 0;
  KeyChars[75].KeyVirt := VK_K;
  KeyChars[75].KeyShft := KeyShiftR;

  Keychars[76].KeyChar := #76;
  Keychars[76].KeyScan := 0;
  KeyChars[76].KeyVirt := VK_L;
  KeyChars[76].KeyShft := KeyShiftR;

  Keychars[77].KeyChar := #77;
  Keychars[77].KeyScan := 0;
  KeyChars[77].KeyVirt := VK_M;
  KeyChars[77].KeyShft := KeyShiftR;

  Keychars[78].KeyChar := #78;
  Keychars[78].KeyScan := 0;
  KeyChars[78].KeyVirt := VK_N;
  KeyChars[79].KeyShft := KeyShiftR;

  Keychars[79].KeyChar := #79;
  Keychars[79].KeyScan := 0;
  KeyChars[79].KeyVirt := VK_O;
  KeyChars[79].KeyShft := KeyShiftR;

  Keychars[80].KeyChar := #80;
  Keychars[80].KeyScan := 0;
  KeyChars[80].KeyVirt := VK_P;
  KeyChars[80].KeyShft := KeyShiftR;

  Keychars[81].KeyChar := #81;
  Keychars[81].KeyScan := 0;
  KeyChars[81].KeyVirt := VK_Q;
  KeyChars[81].KeyShft := KeyShiftR;

  Keychars[82].KeyChar := #82;
  Keychars[82].KeyScan := 0;
  KeyChars[82].KeyVirt := VK_R;
  KeyChars[82].KeyShft := KeyShiftR;

  Keychars[83].KeyChar := #83;
  Keychars[83].KeyScan := 0;
  KeyChars[83].KeyVirt := VK_S;
  KeyChars[83].KeyShft := KeyShiftR;

  Keychars[84].KeyChar := #84;
  Keychars[84].KeyScan := 0;
  KeyChars[84].KeyVirt := VK_T;
  KeyChars[84].KeyShft := KeyShiftR;

  Keychars[85].KeyChar := #85;
  Keychars[85].KeyScan := 0;
  KeyChars[85].KeyVirt := VK_U;
  KeyChars[85].KeyShft := KeyShiftR;

  Keychars[86].KeyChar := #86;
  Keychars[86].KeyScan := 0;
  KeyChars[86].KeyVirt := VK_V;
  KeyChars[86].KeyShft := KeyShiftR;

  Keychars[87].KeyChar := #87;
  Keychars[87].KeyScan := 0;
  KeyChars[87].KeyVirt := VK_W;
  KeyChars[87].KeyShft := KeyShiftR;

  Keychars[88].KeyChar := #88;
  Keychars[88].KeyScan := 0;
  KeyChars[88].KeyVirt := VK_X;
  KeyChars[88].KeyShft := KeyShiftR;

  Keychars[89].KeyChar := #89;
  Keychars[89].KeyScan := 0;
  KeyChars[89].KeyVirt := VK_Y;
  KeyChars[89].KeyShft := KeyShiftR;

  Keychars[90].KeyChar := #90;
  Keychars[90].KeyScan := 0;
  KeyChars[90].KeyVirt := VK_Z;
  KeyChars[90].KeyShft := KeyShiftR;

  Keychars[91].KeyChar := #91; {[}
  Keychars[91].KeyScan := 0;
  KeyChars[91].KeyVirt := 0;
  KeyChars[91].KeyShft := KeyAlt;

  Keychars[92].KeyChar := #92; {\}
  Keychars[92].KeyScan := 0;
  KeyChars[92].KeyVirt := KeyAlt;

  Keychars[93].KeyChar := #93; {]}
  Keychars[93].KeyScan := 0;
  KeyChars[93].KeyVirt := KeyAlt;

  Keychars[94].KeyChar := #94; {^}
  Keychars[94].KeyScan := 0;
  KeyChars[94].KeyVirt := 0;

  Keychars[95].KeyChar := #95; {_}
  Keychars[95].KeyScan := 0;
  KeyChars[95].KeyVirt := KeyShiftR;

  Keychars[96].KeyChar := #96;
  Keychars[96].KeyScan := 0;
  KeyChars[96].KeyVirt := 0;

  Keychars[97].KeyChar := #97;
  Keychars[97].KeyScan := 0;
  KeyChars[97].KeyVirt := VK_A;

  Keychars[98].KeyChar := #98;
  Keychars[98].KeyScan := 0;
  KeyChars[98].KeyVirt := VK_B;

  Keychars[99].KeyChar := #99;
  Keychars[99].KeyScan := 0;
  KeyChars[99].KeyVirt := VK_C;

  Keychars[100].KeyChar := #100;
  Keychars[100].KeyScan := 0;
  KeyChars[100].KeyVirt := VK_D;

  Keychars[101].KeyChar := #101;
  Keychars[101].KeyScan := 0;
  KeyChars[101].KeyVirt := VK_E;

  Keychars[102].KeyChar := #102;
  Keychars[102].KeyScan := 0;
  KeyChars[102].KeyVirt := VK_F;

  Keychars[103].KeyChar := #103;
  Keychars[103].KeyScan := 0;
  KeyChars[103].KeyVirt := VK_G;

  Keychars[104].KeyChar := #104;
  Keychars[104].KeyScan := 0;
  KeyChars[104].KeyVirt := VK_H;

  Keychars[105].KeyChar := #105;
  Keychars[105].KeyScan := 0;
  KeyChars[105].KeyVirt := VK_I;

  Keychars[106].KeyChar := #106;
  Keychars[106].KeyScan := 0;
  KeyChars[106].KeyVirt := VK_J;

  Keychars[107].KeyChar := #107;
  Keychars[107].KeyScan := 0;
  KeyChars[107].KeyVirt := VK_K;

  Keychars[108].KeyChar := #108;
  Keychars[108].KeyScan := 0;
  KeyChars[108].KeyVirt := VK_L;

  Keychars[109].KeyChar := #109;
  Keychars[109].KeyScan := 0;
  KeyChars[109].KeyVirt := VK_M;

  Keychars[110].KeyChar := #110;
  Keychars[110].KeyScan := 0;
  KeyChars[110].KeyVirt := VK_N;

  Keychars[111].KeyChar := #111;
  Keychars[111].KeyScan := 0;
  KeyChars[111].KeyVirt := VK_O;

  Keychars[112].KeyChar := #112;
  Keychars[112].KeyScan := 0;
  KeyChars[112].KeyVirt := VK_P;

  Keychars[113].KeyChar := #113;
  Keychars[113].KeyScan := 0;
  KeyChars[113].KeyVirt := VK_Q;

  Keychars[114].KeyChar := #114;
  Keychars[114].KeyScan := 0;
  KeyChars[114].KeyVirt := VK_R;

  Keychars[115].KeyChar := #115;
  Keychars[115].KeyScan := 0;
  KeyChars[115].KeyVirt := VK_S;

  Keychars[116].KeyChar := #116;
  Keychars[116].KeyScan := 0;
  KeyChars[116].KeyVirt := VK_T;

  Keychars[117].KeyChar := #117;
  Keychars[117].KeyScan := 0;
  KeyChars[117].KeyVirt := VK_U;

  Keychars[118].KeyChar := #118;
  Keychars[118].KeyScan := 0;
  KeyChars[118].KeyVirt := VK_V;

  Keychars[119].KeyChar := #119;
  Keychars[119].KeyScan := 0;
  KeyChars[119].KeyVirt := VK_W;

  Keychars[120].KeyChar := #120;
  Keychars[120].KeyScan := 0;
  KeyChars[120].KeyVirt := VK_X;

  Keychars[121].KeyChar := #121;
  Keychars[121].KeyScan := 0;
  KeyChars[121].KeyVirt := VK_Y;

  Keychars[122].KeyChar := #122;
  Keychars[122].KeyScan := 0;
  KeyChars[122].KeyVirt := VK_Z;

  Keychars[123].KeyChar := #123; (* { *)
  Keychars[123].KeyScan := 0;
  KeyChars[123].KeyVirt := KeyAlt;

  Keychars[124].KeyChar := #124; {|}
  Keychars[124].KeyScan := 0;
  KeyChars[124].KeyVirt := KeyAlt;

  Keychars[125].KeyChar := #125; (* } *)
  Keychars[125].KeyScan := 0;
  KeyChars[125].KeyVirt := KeyAlt;

  Keychars[126].KeyChar := #126; {~}
  Keychars[126].KeyScan := 0;
  KeyChars[126].KeyVirt := KeyAlt; //VK_MENU

  Keychars[127].KeyChar := #127;
  Keychars[127].KeyScan := 0;
  KeyChars[127].KeyVirt := 0;

end;

  function VirtKeyToKeycode(VirtKey: Byte): Word;
  const
    TranslTable: array[Byte] of Integer = (
      -1,			// $00
      -1,			// $01  VK_LBUTTON
      -1,			// $02  VK_RBUTTON
      -1,			// $03  VK_CANCEL
      -1,			// $04  VK_MBUTTON
      -1,			// $05  VK_XBUTTON1
      -1,			// $06  VK_XBUTTON2
      -1,			// $07
      keyBackSpace,	// $08  VK_BACK
      keyTab,		// $09  VK_TAB
      -1,			// $0a
      -1,			// $0b
      keyClear,		// $0c  VK_CLEAR
      keyReturn,		// $0d  VK_RETURN
      -1,			// $0e
      -1,			// $0f
      keyShift,		// $10  VK_SHIFT
      keyCtrl,		// $11  VK_CONTROL
      keyAlt,		// $12  VK_MENU
      keyPause,		// $13  VK_PAUSE
      -1,			// $14  VK_CAPITAL
      -1,			// $15  VK_KANA
      -1,			// $16
      -1,			// $17  VK_JUNJA
      -1,			// $18  VK_FINAL
      -1,			// $19  VK_HANJA
      -1,			// $1a
      keyEscape,		// $1b  VK_ESCAPE
      -1,			// $1c  VK_CONVERT
      -1,			// $1d  VK_NONCONVERT
      -1,			// $1e  VK_ACCEPT
      keyModeSwitch,	// $1f  VK_MODECHANGE
      $20,		// $20  VK_SPACE
      keyPrior,		// $21  VK_PRIOR
      keyNext,		// $22  VK_NEXT
      keyEnd,		// $23  VK_END
      keyHome,		// $24  VK_HOME
      keyLeft,		// $25  VK_LEFT
      keyUp,		// $26  VK_UP
      keyRight,		// $27  VK_RIGHT
      keyDown,		// $28  VK_DOWN
      keySelect,		// $29  VK_SELECT
      keyPrintScreen,	// $2a  VK_PRINT
      keyExecute,		// $2b  VK_EXECUTE
      keyPrintScrn,	// $2c  VK_SNAPSHOT
      keyInsert,		// $2d  VK_INSERT
      keyDelete,		// $2e  VK_DELETE
      keyHelp,		// $2f  VK_HELP
      $30,		// $30  '0'
      $31,		// $31  '1'
      $32,		// $32  '2'
      $33,		// $33  '3'
      $34,		// $34  '4'
      $35,		// $35  '5'
      $36,		// $36  '6'
      $37,		// $37  '7'
      $38,		// $38  '8'
      $39,		// $39  '9'
      -1,			// $3a
      -1,			// $3b
      -1,			// $3c
      -1,			// $3d
      -1,			// $3e
      -1,			// $3f
      -1,			// $40
      $41,		// $41  'A'
      $42,		// $42  'B'
      $43,		// $43  'C'
      $44,		// $44  'D'
      $45,		// $45  'E'
      $46,		// $46  'F'
      $47,		// $47  'G'
      $48,		// $48  'H'
      $49,		// $49  'I'
      $4a,		// $4a  'J'
      $4b,		// $4b  'K'
      $4c,		// $4c  'L'
      $4d,		// $4d  'M'
      $4e,		// $4e  'N'
      $4f,		// $4f  'O'
      $50,		// $50  'P'
      $51,		// $51  'Q'
      $52,		// $52  'R'
      $53,		// $53  'S'
      $54,		// $54  'T'
      $55,		// $55  'U'
      $56,		// $56  'V'
      $57,		// $57  'W'
      $58,		// $58  'X'
      $59,		// $59  'Y'
      $5a,		// $5a  'Z'
      -1,			// $5b  VK_LWIN
      -1,			// $5c  VK_RWIN
      -1,			// $5d  VK_APPS
      -1,			// $5e
      -1,			// $5f  VK_SLEEP
      keyP0,		// $60  VK_NUMPAD0
      keyP1,		// $61  VK_NUMPAD1
      keyP2,		// $62  VK_NUMPAD2
      keyP3,		// $63  VK_NUMPAD3
      keyP4,		// $64  VK_NUMPAD4
      keyP5,		// $65  VK_NUMPAD5
      keyP6,		// $66  VK_NUMPAD6
      keyP7,		// $67  VK_NUMPAD7
      keyP8,		// $68  VK_NUMPAD8
      keyP9,		// $69  VK_NUMPAD9
      keyPAsterisk,	// $6a  VK_MULTIPLY
      keyPPlus,		// $6b  VK_ADD
      keyPSeparator,	// $6c  VK_SEPARATOR
      keyPMinus,		// $6d  VK_SUBTRACT
      keyPDecimal,	// $6e  VK_DECIMAL
      keyPSlash,		// $6f  VK_DIVIDE
      keyF1,		// $70  VK_F1
      keyF2,		// $71  VK_F2
      keyF3,		// $72  VK_F3
      keyF4,		// $73  VK_F4
      keyF5,		// $74  VK_F5
      keyF6,		// $75  VK_F6
      keyF7,		// $76  VK_F7
      keyF8,		// $77  VK_F8
      keyF9,		// $78  VK_F9
      keyF10,		// $79  VK_F10
      keyF11,		// $7a  VK_F11
      keyF12,		// $7b  VK_F12
      keyF13,		// $7c  VK_F13
      keyF14,		// $7d  VK_F14
      keyF15,		// $7e  VK_F15
      keyF16,		// $7f  VK_F16
      keyF17,		// $80  VK_F17
      keyF18,		// $81  VK_F18
      keyF19,		// $82  VK_F19
      keyF20,		// $83  VK_F20
      keyF21,		// $84  VK_F21
      keyF22,		// $85  VK_F22
      keyF23,		// $86  VK_F23
      keyF24,		// $87  VK_F24
      -1,			// $88
      -1,			// $89
      -1,			// $8a
      -1,			// $8b
      -1,			// $8c
      -1,			// $8d
      -1,			// $8e
      -1,			// $8f
      keyNumLock,		// $90  VK_NUMLOCK
      keyScroll,		// $91  VK_SCROLL
      -1,			// $92  VK_OEM_NEC_EQUAL
      -1,			// $93  VK_OEM_FJ_MASSHOU
      -1,			// $94  VK_OEM_FJ_TOUROKU
      -1,			// $95  VK_OEM_FJ_LOYA
      -1,			// $96  VK_OEM_FJ_ROYA
      -1,			// $97
      -1,			// $98
      -1,			// $99
      -1,			// $9a
      -1,			// $9b
      -1,			// $9c
      -1,			// $9d
      -1,			// $9e
      -1,			// $9f
      keyShiftL,		// $a0  VK_LSHIFT
      keyShiftR,		// $a1  VK_RSHIFT
      keyCtrlL,		// $a2  VK_LCONTROL
      keyCtrlR,		// $a3  VK_RCONTROL
      -1,			// $a4  VK_LMENU
      -1,			// $a5  VK_RMENU
      -1,			// $a6  VK_BROWSER_BACK
      -1,			// $a7  VK_BROWSER_FORWARD
      -1,			// $a8  VK_BROWSER_REFRESH
      -1,			// $a9  VK_BROWSER_STOP
      -1,			// $aa  VK_BROWSER_SEARCH
      -1,			// $ab  VK_BROWSER_FAVORITES
      -1,			// $ac  VK_BROWSER_HOME
      -1,			// $ad  VK_VOLUME_MUTE
      -1,			// $ae  VK_VOLUME_DOWN
      -1,			// $af  VK_VOLUME_UP
      -1,			// $b0  VK_MEDIA_NEXT_TRACK
      -1,			// $b1  VK_MEDIA_PREV_TRACK
      -1,			// $b2  VK_MEDIA_STOP
      -1,			// $b3  VK_MEDIA_PLAY_PAUSE
      -1,			// $b4  VK_LAUNCH_MAIL
      -1,			// $b5  VK_LAUNCH_MEDIA_SELECT
      -1,			// $b6  VK_LAUNCH_APP1
      -1,			// $b7  VK_LAUNCH_APP2
      -1,			// $b8
      -1,			// $b9
      $dc, {U Umlaut}	// $ba  VK_OEM_1
      $2b, {+ char}	// $bb  VK_OEM_PLUS
      $2c, {, char}	// $bc  VK_OEM_COMMA
      $2d, {- char}	// $bd  VK_OEM_MINUS
      $2e, {. char}	// $be  VK_OEM_PERIOD
      $23, {# char}	// $bf  VK_OEM_2
      $d6, {O Umlaut}	// $c0  VK_OEM_3
      -1,			// $c1
      -1,			// $c2
      -1,			// $c3
      -1,			// $c4
      -1,			// $c5
      -1,			// $c6
      -1,			// $c7
      -1,			// $c8
      -1,			// $c9
      -1,			// $ca
      -1,			// $cb
      -1,			// $cc
      -1,			// $cd
      -1,			// $ce
      -1,			// $cf
      -1,			// $d0
      -1,			// $d1
      -1,			// $d2
      -1,			// $d3
      -1,			// $d4
      -1,			// $d5
      -1,			// $d6
      -1,			// $d7
      -1,			// $d8
      -1,			// $d9
      -1,			// $da
      -1,			// $db  VK_OEM_4
      keyDeadCircumflex,	// $dc  VK_OEM_5
      keyDeadAcute,	// $dd  VK_OEM_6
      $c4, {A Umlaut}	// $de  VK_OEM_7
      -1,    	        // $df  VK_OEM_8
      -1,			// $e0
      -1,			// $e1  VK_OEM_AX
      $3c, {< char}	// $e2  VK_OEM_102
      -1,			// $e3  VK_ICO_HELP
      keyP5,		// $e4  VK_ICO_00
      -1,			// $e5  VK_PROCESSKEY
      -1,			// $e6  VK_ICO_CLEAR
      -1,			// $e7  VK_PACKET
      -1,			// $e8
      -1,			// $e9  VK_OEM_RESET
      -1,			// $ea  VK_OEM_JUMP
      -1,			// $eb  VK_OEM_PA1
      -1,			// $ec  VK_OEM_PA2
      -1,			// $ed  VK_OEM_PA3
      -1,			// $ee  VK_OEM_WSCTRL
      -1,			// $ef  VK_OEM_CUSEL
      -1,			// $f0  VK_OEM_ATTN
      -1,			// $f1  VK_OEM_FINISH
      -1,			// $f2  VK_OEM_COPY
      -1,			// $f3  VK_OEM_AUTO
      -1,			// $f4  VK_OEM_ENLW
      -1,			// $f5  VK_OEM_BACKTAB
      -1,			// $f6  VK_ATTN
      -1,			// $f7  VK_CRSEL
      -1,			// $f8  VK_EXSEL
      -1,			// $f9  VK_EREOF
      -1,			// $fa  VK_PLAY
      -1,			// $fb  VK_ZOOM
      -1,			// $fc  VK_NONAME
      -1,			// $fd  VK_PA1
      -1,			// $fe  VK_OEM_CLEAR
      -1			// $ff
    );
  begin
    if TranslTable[VirtKey]  = -1 then
    begin
  {$IFDEF Debug}
      WriteLn('No mapping for virtual keycode $', IntToHex(VirtKey, 2));
  {$ENDIF}
      Result := keyNIL
    end else
    begin
      Result := TranslTable[VirtKey];
  {$IFDEF Debug}
      WriteLn('Key $', IntToHex(VirtKey, 2), ' mapped to $', IntToHex(Result, 4));
  {$ENDIF}
    end;
  end;

  procedure ClearShiftstate(var AShift: TShiftState);
  begin
    if (ssShift in AShift) then Exclude(AShift,ssShift);
    if (ssAlt in AShift) then Exclude(AShift,ssAlt);
    if (ssAltGr in AShift) then Exclude(AShift,ssAltGr);
    if (ssCtrl in AShift) then Exclude(AShift,ssCtrl);
  end;

  procedure SetShiftStateAscii(Ev: TKeyEvent; var AShift: TShiftState);
  begin
    If (KeyChars[Ev.CharCode and $FF].KeyShft = KeyShiftR) or
       (KeyChars[Ev.CharCode and $FF].KeyVirt = KeyShiftR) then Include(Ev.ShiftState,ssShift);
  end;

  procedure SetShiftStateScan(Ev: TKeyEvent; var AShift: TShiftState);
  begin
    case Ev.CharCode of
      87: if not (ssShift IN AShift) then Include(AShift,ssShift);
      89: if not (ssShift IN AShift) then Include(AShift,ssShift);
    end;
  end;

  function GetVKeyOf(bioskey: word): TKeyEvent;
  var
    VKey: TKeyEvent; r: TKeyRec;
  begin
    ClearShiftstate(VKey.ShiftState);
    r.keycode := bioskey;
    if r.keychar[0] = #0 then
    //if (bioskey and $ff) = 0 then
    begin
      case bioskey shr 8 of
        $47: writeln('Home/Pos1');
        $48: writeln('Pfeil hoch');
        $49: writeln('Seite hoch');
        $4B: writeln('Pfeil links');
        $4D: writeln('Pfeil rechts');
        $4F: writeln('End');
        $50: writeln('Pfeil ab');
        $51: writeln('Seite runter');
      end;
      VKey.ScanCode := bioskey shr 8;
      //VKey.ScanCode := ord(r.keychar[1]);
      VKey.VirtCode := GetVirtKeyCode(bioskey shr 8, true);
      //VKey.VirtCode := GetVirtKeyCode(ord(r.keychar[1]), true);
    end
    else
    begin
      case chr(bioskey and $ff) of
        'a'..'z':
          begin
            VKey.CharCode := bioskey and $ff;
            VKey.ScanCode := 0;
            VKey.VirtCode := GetVirtKeyCode(bioskey and $ff, false);
            VKey.ShiftState := [];
          end;
        'ä','ö','ü','ß':
          begin
            VKey.CharCode := bioskey and $ff;
            VKey.ScanCode := 0;
            VKey.VirtCode := 0;
            VKey.ShiftState := [];            
          end;
        'A'..'Z':
          begin
            VKey.CharCode := bioskey and $ff;
            VKey.ScanCode := 0;
            VKey.VirtCode := GetVirtKeyCode(bioskey and $ff, false);
            if not (ssShift IN VKey.ShiftState) then Include(VKey.ShiftState,ssShift);
            If KeyChars[VKey.CharCode].KeyShft = KeyShiftR then Include(VKey.ShiftState,ssShift);
            SetShiftStateAscii(VKey, VKey.ShiftState);
          end;
        'Ä','Ö','Ü':
          begin
            VKey.CharCode := bioskey and $ff;
            VKey.ScanCode := 0;
            VKey.VirtCode := 0;
          end;
        else 
          begin
            VKey.CharCode := bioskey and $ff;
            VKey.ScanCode := 0;
            VKey.VirtCode := GetVirtKeyCode(bioskey and $ff, false);
            if VKey.VirtCode = KeyShiftR then
            begin
              if not (ssShift IN VKey.ShiftState) then Include(VKey.ShiftState,ssShift);
            end else Exclude(Vkey.ShiftState,ssShift);
            if VKey.VirtCode = KeyAlt then
            begin
              if not (ssAlt IN VKey.ShiftState) then Include(VKey.ShiftState,ssAlt);
            end else Exclude(Vkey.ShiftState,ssAlt);
          end;
      end;
    end;
    GetVKeyOf := VKey;
  end;
  
  function GetDosKeyCode: word;
  var
    ch: char; chb: byte; scan: byte; DosKeyCode: word;
  begin
    GetDosKeyCode := 0;
    {
    if keypressed then
    begin
      ch := ' '; chb := 0;
      ch := readkey; chb := ord(ch);
      if chb = 0 then scan := ord(readkey) else scan := 0;
      DosKeyCode := (scan shl 8) + chb;
      GetDosKeyCode := DosKeyCode;
    end; 
    }
  end;

  function GetKeyCode: word;
  var
    r: TKeyRec;
  begin
    {
    sleep(10);
    r.keycode := 0;
    if keypressed then
    begin
      r.keychar[0] := readkey;        //Chr Code
      writeln(ord(r.keychar[0]));
      Result := r.keycode;
      if r.keychar[0] = #0 then
      begin
        r.keychar[1] := readkey;      //scan Code
        writeln(ord(r.keychar[1]));
        Result := r.keycode;
      end;
    end;
    }
  end;

  function GetVirtKeyCode(Code: word; scan: Boolean): word;
  begin
    if scan
       then Result := Scankeys[Code].KeyVirt
    else Result := Keychars[Code].KeyVirt;
  end;

  function ShiftStateAsString(AShift: TShiftState): String;
  var ShiftString: String;
  begin
    ShiftString := '';
    if (ssShift in AShift) then ShiftString := ShiftString + 'ssShift';
    if (ssAlt in AShift) then ShiftString := ShiftString + 'ssAlt';
    if (ssAltGr in AShift) then ShiftString := ShiftString + 'ssAltGr';
    if (ssCtrl in AShift) then ShiftString := ShiftString + 'ssCtrl';
  end;

  function PollKeyEvent: TKeyEvent;
  begin
    Result := GetVKeyOf(GetKeyCode);
  end;

  function GetKeyEventChar(ev: TKeyEvent): Char;
  begin
    Result := Chr(ev.CharCode);
  end;

  function GetKeyEventCode(ev: TKeyEvent): Byte;
  begin
    Result := ev.ScanCode;
  end;

  function GetKeyEventFlags(ev: TKeyEvent): word;
  var ch: Char; flags: word;
  begin
    ch := chr(ev.CharCode);
    case ord(ch) of
     65..90: flags := kbAscii;
     142: flags := kbAscii;
     153: flags := kbAscii;
     154: flags := kbAscii;
     225: flags := kbAscii;
     97..122: flags := kbAscii;
     132,148,129: flags := kbAscii;
    end;
    case ev.ScanCode of
     59..68,133,134: flags := kbFnKey;
    end;
    case flags of
     kbAscii: Writeln('kbAscii');
     kbFnKey: Writeln('kbFnKey');
    end;
  end;

  function GetKeyboardState(KeybState: TKeyboardState): Boolean;
  begin
    GetKeyboardState := false;
  end;

  function GetKeyState(vKey: Integer): shortint;
  begin

  end;

  function GetAsyncKeyState(vKey: Integer): shortint;
  begin

  end;

  function GetKeyboardShiftState: TShiftState;
  var
    State: array[0..255] of Byte;
  begin
    {$ifndef wince}
    fillchar(State,Sizeof(State),0);
    GetKeyboardState(State);
    {$endif}
    Result := [];
    if (State[VK_SHIFT] and 128) <> 0 then
      Include(Result, ssShift);
    if (State[VK_MENU] and 128) <> 0 then
      Include(Result, ssAlt);
    if (State[VK_CONTROL] and 128) <> 0 then
      Include(Result, ssCtrl);
    if (State[VK_LBUTTON] and 128) <> 0 then
      Include(Result, ssLeft);
    if (State[VK_RBUTTON] and 128) <> 0 then
      Include(Result, ssRight);
    if (State[VK_MBUTTON] and 128) <> 0 then
      Include(Result, ssMiddle);
    if (State[VK_CAPITAL] and 1) <> 0 then
      Include(Result, ssCaps);
    if (State[VK_NUMLOCK] and 1) <> 0 then
      Include(Result, ssNum);
    if (State[VK_SCROLL] and 1) <> 0 then
      Include(Result, ssScroll);
  end;

begin
  InitKeyChars;
end.

