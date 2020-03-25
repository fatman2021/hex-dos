{
 UNIT hxVesa32 
 
 - Verfügbare Grafikmodi:                    Available graphics modes:

 $100	640×400	        8 Bits per Pixel (Bpp)
 $101	640×480	        8 Bpp
 $102	800×600	        4 Bpp
 $103	800×600	        8 Bpp
 $104	1024×768      	4 Bpp
 $105	1024×768      	8 Bpp
 $106	1280×1024     	4 Bpp
 $107	1280×1024     	8 Bpp
 $108	80×60 (Text)	4 Bpp
 $109	132×25 (Text)	4 Bpp
 $10A	132×43 (Text)	4 Bpp
 $10B	132×50 (Text)	4 Bpp
 $10C	132×60 (Text)	4 Bpp
 $10D	320×200	       15 Bpp
 $10E	320×200	       16 Bpp
 $10F	320×200        24 Bpp
 $110	640×480        15 Bpp
 $111	640×480        16 Bpp
 $112	640×480        24 Bpp
 $113	800×600        15 Bpp
 $114	800×600        16 Bpp
 $115	800×600        24 Bpp
 $116	1024×768	   15 Bpp
 $117	1024×768	   16 Bpp
 $118	1024×768	   24 Bpp
 $119	1280×1024	   15 Bpp
 $11A	1280×1024	   16 Bpp
 $11B	1280×1024	   24 Bpp
 $11C	1600×1200	    8 Bpp
 $11D	1600×1200	   15 Bpp
 $11E	1600×1200	   16 Bpp
 $11F	1600×1200	   24 Bpp
}

unit hxvesa32;

interface

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

(*
{$L HXGUIHLP.LIB}
procedure GetProfileString(pszSection,pszKey,pszBuffer: PByte; cbLen: dword); stdcall; external;
*)

{$L c:\lazarus\fpgui-1.4.1\src\lib\i386go32\VESA32S.LIB}

function GetVesaMode(): Integer; stdcall; external;
function GetVesaModeInfo(mode: dword; var info: SVGAINFO): BOOL; stdcall; external;
function GetVesaStateBufferSize(): Integer; stdcall; external;

procedure SetVesaDisplayStart(dwOffset,dwPitch,dwFlags: dword); stdcall; external;
function GetVesaDisplayStart(): dword; stdcall; external;

procedure RestoreVesaVideoState(state: Pointer); stdcall; external;
procedure SaveVesaVideoMemory(mem: Pointer; size: Integer); stdcall; external;
procedure SaveVesaVideoState(state: Pointer; size: Integer); stdcall; external;
function SearchVesamode(xres,yres,bpp: Integer): Integer; stdcall; external;
procedure SetVesaMode(mode: Integer); stdcall; external;

procedure SetVesaPaletteEntries(dwStart,nEntries: dword; pEntries: Pointer); stdcall; external;
procedure GetVesaPaetteEntries(dwStart,nEntries: dword; pEntries: Pointer); stdcall; external;

procedure VesaInit();  stdcall; external;
procedure VesaExit(); stdcall; external;

procedure SetCursorPaletteEntries(bScreenColor,bCursorColor: dword); stdcall; external;
procedure VesaMouseInit();  stdcall; external;
procedure VesaMouseExit(); stdcall; external;


implementation

end.

