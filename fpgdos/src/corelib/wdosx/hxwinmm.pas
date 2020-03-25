unit hxwinmm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, qtwinapi;

{$i osdefs.inc}

type
  tagTIMECAPS = record
    wPeriodMin: UINT;
    wPeriodMax: UINT;
  end;
  TIMECAPS = tagTIMECAPS;
  PTIMECAPS = ^TIMECAPS;
  MMRESULT = Longint;
  TFNTimeCallBack = procedure(uTimerID, uMessage: UINT;
    dwUser, dw1, dw2: DWORD) stdcall;
  LPTIMECALLBACK = TFNTimeCallBack;

function timeBeginPeriod(uPeriod: UINT): MMRESULT;

function timeEndPeriod(uPeriod: UINT): MMRESULT;

function timeGetDevCaps(var ptc: TIMECAPS; cbtc: UINT): MMRESULT;

function timeGetTime: DWORD;

function timeKillEvent(uTimerId: UINT): MMRESULT;

function timeSetEvent(
  uDelay: UINT;
  uResolution: UINT;
  lpTimeProc: LPTIMECALLBACK;
  dwUser: DWORD_PTR;
  fuEvent: UINT
  ): MMRESULT;


implementation

function timeBeginPeriod(uPeriod: UINT): MMRESULT;
begin

end;

function timeEndPeriod(uPeriod: UINT): MMRESULT;
begin

end;

{$ifndef HX_DOS}
function timeGetDevCaps(var ptc: TIMECAPS; cbtc: UINT): MMRESULT;
begin

end;

function timeGetTime: DWORD;
begin
  Result := GetTickCount;
end;

function timeKillEvent(uTimerId: UINT): MMRESULT;
begin

end;

function timeSetEvent(
  uDelay: UINT;
  uResolution: UINT;
  lpTimeProc: LPTIMECALLBACK;
  dwUser: DWORD_PTR;
  fuEvent: UINT
  ): MMRESULT;
begin

end;
{$endif}

end.

