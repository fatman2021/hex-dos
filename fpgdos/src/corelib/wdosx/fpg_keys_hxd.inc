{
   fpGUI  -  Free Pascal GUI Toolkit

   Copyright (C) 2006 - 2010 See the file AUTHORS.txt, included in this
   distribution, for details of the copyright.

   See the file COPYING.modifiedLGPL, included in this distribution,
   for details about redistributing fpGUI.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

   Description:
     Win32 GDI target implementation: Keycode translation helpers
}

{%mainunit fpg_hxd.pas}

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
    keyPrintScreen,	// $2c  VK_SNAPSHOT
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
    keyMenu,			// $5d  VK_APPS
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
{$IFDEF DebugKeys}
    WriteLn('No mapping for virtual keycode $', IntToHex(VirtKey, 2));
{$ENDIF}
    Result := keyNIL
  end else
  begin
    Result := TranslTable[VirtKey];
{$IFDEF DebugKeys}
    WriteLn('Key $', IntToHex(VirtKey, 2), ' mapped to $', IntToHex(Result, 4));
{$ENDIF}
  end;
end;


function GetKeyboardShiftState: TShiftState;
var
  State: array[Byte] of Byte;
begin
  {$ifndef wince}
  hxuser.GetKeyboardState(State);
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


