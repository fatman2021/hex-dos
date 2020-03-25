
// sample in C using VESA32

//#define USECRT 0 /* set this to 0 if CRT should not be used */

// #define WIN32_LEAN_AND_MEAN
// #include <windows.h>

program vesa3;

uses 
  vesa32,
  {$ifdef USECRT}  
  Crt
  {$endif}
  ;
  
const
  COLS = 640;
  ROWS = 480;

{$L VESA32S.LIB}

var
  vgainfo: SVGAINFO;

{$ifndef USECRT}

function malloc(dwBytes: Integer): Pointer;
var
  pRC: Pointer = nil;
begin  
    asm 
        mov bx,word ptr dwBytes+2
        mov cx,word ptr dwBytes+0
        mov ax,501h
        int 31h
        jc label1
        push bx
        push cx
        pop eax
        mov pRC, eax
        label1:
    end;
    Result := pRC;
end;

procedure free(pVoid: Pointer);
begin
    
end;

function getch(): word;
var r: TRegisters;
begin
  r.AH := 0;
  intr(r,$16);
  Result := r.AX;
end;

function mainCRTStartup(): Integer; assembler;
asm 
   mov ax,4c00
   int 21
end;

{$endif}

//--- fill a screen rectangle with a color

procedure fill64k(xpos, ypos, xlen, ylen, color: integer);
var
  iOffs: integer;
  pScreen: array of Byte;
  i,j: Integer;
begin
    SetLength(pScreen, svgainfo.BytesPerScanLine * ypos + 2 * xpos);
    iOffs := svgainfo.BytesPerScanLine div 2 - xlen;
    pScreen := Addr(svgainfo.PhysBasePtr + svgainfo.BytesPerScanLine * ypos + 2 * xpos);

    for i := 0 to ylen do begin
        for j := 0 to xlen do begin
            pScreen++ := Byte(color);
        end;
        pScreen := pScreen + iOffs;
    end;
    
end;

var
  iMode: integer;
  iPrevMode: integer;
  iStateSize: integer;
  iVMemSize: integer;
  pSaveBuff: Pointer;
  pSaveBuff2: Pointer;

//int main(int cArgs, char * * pArgs)
begin

   {$ifdef _VESA32_}
     VesaInit(); //* call if the vesa code is linked statically */
   {$endif}
    // search a VESA 16bpp video mode

	if not (iMode = SearchVesaMode(COLS,ROWS,16)) then
	begin
		writeln('no support for VESA mode ' + Format('%ux%ux16'), COLS, ROWS);
    end;
    iMode := iMode or 0x4000;      // use LFB
    if (not GetVesaModeInfo(iMode, &svgainfo) then writeln('cannot get VESA mode info');

    //  save the current video state

    iPrevMode := GetVesaMode();
    iStateSize := GetVesaStateBufferSize();
    pSaveBuff := GetMem(pSaveBuff, iStateSize);
    if Assigned(pSaveBuff) then
    begin
        SaveVesaVideoState(pSaveBuff, iStateSize);
        iVMemSize := GetVesaMemoryBufferSize(iPrevMode);
        pSaveBuff2 := (pSaveBuff2, iVMemSize);
        if Assigned(pSaveBuff2) then SaveVesaVideoMemory(pSaveBuff2, iVMemSize);
        
    end;

    // set the 16bpp VESA color mode with LFB

    if (not SetVesaMode(iMode)) then
        writeln('cannot switch to VESA mode ' + Format('%X'), iMode);
    
    // now do the "real" work: display some rectangles

#if 1
    for (int i = 0; i < 30; i++)
        fill64k(i*8,i*8,640-i*16,480-i*16, i*0x871);
#else
    for (int i = 0; i < 1; i++)
        fill64k(i*8,i*8,640-i*16,480-i*16, 0x33CF);
#endif

    // wait for a key

    getch();

    // and restore previous video state

    iPrevMode = iPrevMode or 0x80;
    SetVesaMode(iPrevMode);
    if Assigned(pSaveBuff) then
    begin
        RestoreVesaVideoState(pSaveBuff);
        free(pSaveBuff);
        if Assigned(pSaveBuff2) then
        begin
          RestoreVesaVideoMemory(pSaveBuff2);
          free(pSaveBuff2);
        end;
    end;
   {$ifdef _VESA32_}
     VesaExit(); //* call if the vesa code is linked statically */
   {$endif}
	
end.

