unit vesa32;

interface

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

