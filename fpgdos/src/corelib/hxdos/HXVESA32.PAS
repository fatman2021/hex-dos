{
 UNIT hxVesa32

 - Verf�gbare Grafikmodi:                    Available graphics modes:

 $100	640�400	        8 Bits per Pixel (Bpp)
 $101	640�480	        8 Bpp
 $102	800�600	        4 Bpp
 $103	800�600	        8 Bpp
 $104	1024�768      	4 Bpp
 $105	1024�768      	8 Bpp
 $106	1280�1024     	4 Bpp
 $107	1280�1024     	8 Bpp
 $108	80�60 (Text)	4 Bpp
 $109	132�25 (Text)	4 Bpp
 $10A	132�43 (Text)	4 Bpp
 $10B	132�50 (Text)	4 Bpp
 $10C	132�60 (Text)	4 Bpp
 $10D	320�200	       15 Bpp
 $10E	320�200	       16 Bpp
 $10F	320�200        24 Bpp
 $110	640�480        15 Bpp
 $111	640�480        16 Bpp
 $112	640�480        24 Bpp
 $113	800�600        15 Bpp
 $114	800�600        16 Bpp
 $115	800�600        24 Bpp
 $116	1024�768	   15 Bpp
 $117	1024�768	   16 Bpp
 $118	1024�768	   24 Bpp
 $119	1280�1024	   15 Bpp
 $11A	1280�1024	   16 Bpp
 $11B	1280�1024	   24 Bpp
 $11C	1600�1200	    8 Bpp
 $11D	1600�1200	   15 Bpp
 $11E	1600�1200	   16 Bpp
 $11F	1600�1200	   24 Bpp
}

unit hxvesa32;

interface

{$define HX_DOS}

const
  m640x400x8     = $100;
  m640x480x8     = $101;
  m800x600x4     = $102;
  m800x600x8     = $103;
  m1024x768x4    = $104;
  m1024x768x8    = $105;
  m1280x1024x4   = $106;
  m1280x1024x8   = $107;
  m80x60x4       = $108; { Text }
  m132x25x4      = $109; { Text }
  m132x43x4      = $10A; { Text }
  m132x50x4      = $10B; { Text }
  m132x60x4      = $10C; { Text }
  m320x200x15    = $10D;
  m320x200x16    = $10E;
  m320x200x24    = $10F;
  m640x480x15    = $110;
  m640x480x16    = $111;
  m640x480x24    = $112;
  m800x600x15    = $113;
  m800x600x16    = $114;
  m800x600x24    = $115;
  m1024x768x15   = $116;
  m1024x768x16   = $117;
  m1024x768x24   = $118;
  m1280x1024x15  = $119;
  m1280x1024x16  = $11A;
  m1280x1024x24  = $11B;
  m1600x1200x8   = $11C;
  m1600x1200x15  = $11D;
  m1600x1200x16  = $11E;
  m1600x1200x24  = $11F;


//const
  //vesalib={$ifdef link_dynamic}{$else}'C:\programs\fpc\fpgdos\src\lib\i386go32\VESA32S.LIB'{$endif};

{$I hxvesa.inc}
{$Linklib c:\programs\fpc\bin\go32v2\LIBC32S.LIB}
{$Linklib VESA32S.LIB}
function GetVesaMode(): Integer;
{$ifdef HX_DOS}
stdcall; external name '_GetVesamode@0';
{$endif}

function GetVesaModeInfo(mode: dword; var info: TSVGAINFO): LONGBOOL;
{$ifdef HX_DOS}
stdcall; external name '_GetVesamodeInfo@8';
{$endif}

function GetVesaStateBufferSize(): Integer;
{$ifdef HX_DOS}
stdcall; external name '_GetVesaStateBufferSize@0';
{$endif}

procedure SetVesaDisplayStart(dwOffset,dwPitch,dwFlags: dword);
{$ifdef HX_DOS}
stdcall; external name '_SetVesaDisplayStart@12';
{$endif}

function GetVesaDisplayStart(): dword;
{$ifdef HX_DOS}
stdcall; external name '_GetVesaDisplayStart@0';
{$endif}

procedure RestoreVesaVideoState(state: Pointer);
{$ifdef HX_DOS}
stdcall; external name '_RestoreVesaVideoState@4';
{$endif}

procedure SaveVesaVideoMemory(mem: Pointer; size: Integer);
{$ifdef HX_DOS}
stdcall; external name '_SaveVesaVideoMemory@8';
{$endif}

procedure SaveVesaVideoState(state: Pointer; size: Integer);
{$ifdef HX_DOS}
stdcall; external name '_SaveVesaVideoState@8';
{$endif}

function SearchVesamode(xres,yres,bpp: Integer): Integer;
{$ifdef HX_DOS}
stdcall; external name '_SearchVesaMode@12';
{$endif}

procedure SetVesaMode(mode: Integer);
{$ifdef HX_DOS}
stdcall; external name '_SetVesaMode@4';
{$endif}

procedure SetVesaPaletteEntries(dwStart,nEntries: dword; pEntries: Pointer);
{$ifdef HX_DOS}
stdcall; external name '_SetVesaPaletteEntries@12';
{$endif}

procedure GetVesaPaetteEntries(dwStart,nEntries: dword; pEntries: Pointer);
{$ifdef HX_DOS}
stdcall; external name '_GetVesaPaletteEntries@12';
{$endif}

procedure VesaInit();
{$ifdef HX_DOS}
stdcall; external name '_VesaInit@0';
{$endif}

procedure VesaExit();
{$ifdef HX_DOS}
stdcall; external name '_VesaExit@0';
{$endif}

procedure SetCursorPaletteEntries(bScreenColor,bCursorColor: dword);
{$ifdef HX_DOS}
stdcall; external name '_SetCursorPaletteEntries@8';
{$endif}

procedure VesaMouseInit();
{$ifdef HX_DOS}
stdcall; external name '_VesaMouseInit@0';
{$endif}

procedure VesaMouseExit();
{$ifdef HX_DOS}
stdcall; external name '_VesaMouseExit@0';
{$endif}


implementation

{$ifndef HX_DOS}
function GetVesaMode(): Integer;
begin

end;

function GetVesaModeInfo(mode: dword; var info: TSVGAINFO): LONGBOOL;
begin

end;

function GetVesaStateBufferSize(): Integer;
begin

end;


procedure SetVesaDisplayStart(dwOffset,dwPitch,dwFlags: dword);
begin

end;

function GetVesaDisplayStart(): dword;
begin

end;


procedure RestoreVesaVideoState(state: Pointer);
begin

end;

procedure SaveVesaVideoMemory(mem: Pointer; size: Integer);
begin

end;

procedure SaveVesaVideoState(state: Pointer; size: Integer);
begin

end;

function SearchVesamode(xres,yres,bpp: Integer): Integer;
begin

end;

procedure SetVesaMode(mode: Integer);
begin

end;


procedure SetVesaPaletteEntries(dwStart,nEntries: dword; pEntries: Pointer);
begin

end;

procedure GetVesaPaetteEntries(dwStart,nEntries: dword; pEntries: Pointer);
begin

end;


procedure VesaInit();
begin

end;

procedure VesaExit();
begin

end;


procedure SetCursorPaletteEntries(bScreenColor,bCursorColor: dword);
begin

end;

procedure VesaMouseInit();
begin

end;

procedure VesaMouseExit();
begin

end;
{$endif}


end.


