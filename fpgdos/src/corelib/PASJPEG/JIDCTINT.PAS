Unit JIDctInt;
{$Q+}

{ This file contains a slow-but-accurate integer implementation of the
  inverse DCT (Discrete Cosine Transform).  In the IJG code, this routine
  must also perform dequantization of the input coefficients.

  A 2-D IDCT can be done by 1-D IDCT on each column followed by 1-D IDCT
  on each row (or vice versa, but it's more convenient to emit a row at
  a time).  Direct algorithms are also available, but they are much more
  complex and seem not to be any faster when reduced to code.

  This implementation is based on an algorithm described in
    C. Loeffler, A. Ligtenberg and G. Moschytz, "Practical Fast 1-D DCT
    Algorithms with 11 Multiplications", Proc. Int'l. Conf. on Acoustics,
    Speech, and Signal Processing 1989 (ICASSP '89), pp. 988-991.
  The primary algorithm described there uses 11 multiplies and 29 adds.
  We use their alternate method with 12 multiplies and 32 adds.
  The advantage of this method is that no data path contains more than one
  multiplication; this allows a very simple and accurate implementation in
  scaled fixed-point arithmetic, with a minimal number of shifts. }

{ Original : jidctint.c ;  Copyright (C) 1991-1998, Thomas G. Lane. }


interface

{$I jconfig.inc}

uses
  jmorecfg,
  jinclude,
  jpeglib,
  jdct;         { Private declarations for DCT subsystem }

{ Perform dequantization and inverse DCT on one block of coefficients. }

{GLOBAL}
procedure jpeg_idct_islow (cinfo : j_decompress_ptr;
                           compptr : jpeg_component_info_ptr;
                           coef_block : JCOEFPTR;
                           output_buf : JSAMPARRAY;
                           output_col : JDIMENSION);

implementation

{ This module is specialized to the case DCTSIZE = 8. }

{$ifndef DCTSIZE_IS_8}
  Sorry, this code only copes with 8x8 DCTs. { deliberate syntax err }
{$endif}

{ The poop on this scaling stuff is as follows:

  Each 1-D IDCT step produces outputs which are a factor of sqrt(N)
  larger than the true IDCT outputs.  The final outputs are therefore
  a factor of N larger than desired; since N=8 this can be cured by
  a simple right shift at the end of the algorithm.  The advantage of
  this arrangement is that we save two multiplications per 1-D IDCT,
  because the y0 and y4 inputs need not be divided by sqrt(N).

  We have to do addition and subtraction of the integer inputs, which
  is no problem, and multiplication by fractional constants, which is
  a problem to do in integer arithmetic.  We multiply all the constants
  by CONST_SCALE and convert them to integer constants (thus retaining
  CONST_BITS bits of precision in the constants).  After doing a
  multiplication we have to divide the product by CONST_SCALE, with proper
  rounding, to produce the correct output.  This division can be done
  cheaply as a right shift of CONST_BITS bits.  We postpone shifting
  as long as possible so that partial sums can be added together with
  full fractional precision.

  The outputs of the first pass are scaled up by PASS1_BITS bits so that
  they are represented to better-than-integral precision.  These outputs
  require BITS_IN_JSAMPLE + PASS1_BITS + 3 bits; this fits in a 16-bit word
  with the recommended scaling.  (To scale up 12-bit sample data further, an
  intermediate INT32 array would be needed.)

  To avoid overflow of the 32-bit intermediate results in pass 2, we must
  have BITS_IN_JSAMPLE + CONST_BITS + PASS1_BITS <= 26.  Error analysis
  shows that the values given below are the most effective. }

{$ifdef BITS_IN_JSAMPLE_IS_8}
const
  CONST_BITS = 13;
  PASS1_BITS = 2;
{$else}
const
  CONST_BITS = 13;
  PASS1_BITS = 1;       { lose a little precision to avoid overflow }
{$endif}

const
  CONST_SCALE = (INT32(1) shl CONST_BITS);

const
  FIX_0_298631336 = INT32(Round(CONST_SCALE * 0.298631336));  {2446}
  FIX_0_390180644 = INT32(Round(CONST_SCALE * 0.390180644));  {3196}
  FIX_0_541196100 = INT32(Round(CONST_SCALE * 0.541196100));  {4433}
  FIX_0_765366865 = INT32(Round(CONST_SCALE * 0.765366865));  {6270}
  FIX_0_899976223 = INT32(Round(CONST_SCALE * 0.899976223));  {7373}
  FIX_1_175875602 = INT32(Round(CONST_SCALE * 1.175875602));  {9633}
  FIX_1_501321110 = INT32(Round(CONST_SCALE * 1.501321110));  {12299}
  FIX_1_847759065 = INT32(Round(CONST_SCALE * 1.847759065));  {15137}
  FIX_1_961570560 = INT32(Round(CONST_SCALE * 1.961570560));  {16069}
  FIX_2_053119869 = INT32(Round(CONST_SCALE * 2.053119869));  {16819}
  FIX_2_562915447 = INT32(Round(CONST_SCALE * 2.562915447));  {20995}
  FIX_3_072711026 = INT32(Round(CONST_SCALE * 3.072711026));  {25172}



{ Multiply an INT32 variable by an INT32 constant to yield an INT32 result.
  For 8-bit samples with the recommended scaling, all the variable
  and constant values involved are no more than 16 bits wide, so a
  16x16->32 bit multiply can be used instead of a full 32x32 multiply.
  For 12-bit samples, a full 32-bit multiplication will be needed. }

{$ifdef BITS_IN_JSAMPLE_IS_8}

   {$IFDEF BASM16}
     {$IFNDEF WIN32}
   {MULTIPLY16C16(var,const)}
   function Multiply(X, Y: Integer): integer; assembler;
   asm
     mov ax, X
     imul Y
     mov al, ah
     mov ah, dl
   end;
     {$ENDIF}
   {$ENDIF}

   function Multiply(X, Y: INT32): INT32;
   begin
     Multiply := INT32(X) * INT32(Y);
   end;


{$else}
  {#define MULTIPLY(var,const)  ((var) * (const))}
   function Multiply(X, Y: INT32): INT32;
   begin
     Multiply := INT32(X) * INT32(Y);
   end;
{$endif}


{ Dequantize a coefficient by multiplying it by the multiplier-table
  entry; produce an int result.  In this module, both inputs and result
  are 16 bits or less, so either int or short multiply will work. }

function DEQUANTIZE(coef,quantval : int) : int;
begin
  Dequantize := ( ISLOW_MULT_TYPE(coef) * quantval);
end;

{ Descale and correctly round an INT32 value that's scaled by N bits.
  We assume RIGHT_SHIFT rounds towards minus infinity, so adding
  the fudge factor is correct for either sign of X. }

function DESCALE(x : INT32; n : int) : INT32;
var
  shift_temp : INT32;
begin
{$ifdef RIGHT_SHIFT_IS_UNSIGNED}
  shift_temp := x + (INT32(1) shl (n-1));
  if shift_temp < 0 then
    Descale :=  (shift_temp shr n) or ((not INT32(0)) shl (32-n))
  else
    Descale :=  (shift_temp shr n);
{$else}
  Descale := (x + (INT32(1) shl (n-1)) shr n;
{$endif}
end;

{ Perform dequantization and inverse DCT on one block of coefficients. }

{GLOBAL}
procedure jpeg_idct_islow (cinfo : j_decompress_ptr;
                           compptr : jpeg_component_info_ptr;
                           coef_block : JCOEFPTR;
                           output_buf : JSAMPARRAY;
                           output_col : JDIMENSION);
type
  PWorkspace = ^TWorkspace;
  TWorkspace = coef_bits_field; { buffers data between passes }
var
  tmp0, tmp1, tmp2, tmp3 : INT32;
  tmp10, tmp11, tmp12, tmp13 : INT32;
  z1, z2, z3, z4, z5 : INT32;
  inptr : JCOEFPTR;
  quantptr : ISLOW_MULT_TYPE_FIELD_PTR;
  wsptr : PWorkspace;
  outptr : JSAMPROW;
  range_limit : JSAMPROW;
  ctr : int;
  workspace : TWorkspace;
  {SHIFT_TEMPS}
var
  dcval : int;
var
  dcval_ : JSAMPLE;
begin
{ Each IDCT routine is responsible for range-limiting its results and
  converting them to unsigned form (0..MAXJSAMPLE).  The raw outputs could
  be quite far out of range if the input data is corrupt, so a bulletproof
  range-limiting step is required.  We use a mask-and-table-lookup method
  to do the combined operations quickly.  See the comments with
  prepare_range_limit_table (in jdmaster.c) for more info. }

  range_limit := JSAMPROW(@(cinfo^.sample_range_limit^[CENTERJSAMPLE]));


  { Pass 1: process columns from input, store into work array. }
  { Note results are scaled up by sqrt(8) compared to a true IDCT; }
  { furthermore, we scale the results by 2**PASS1_BITS. }

  inptr := coef_block;
  quantptr := ISLOW_MULT_TYPE_FIELD_PTR (compptr^.dct_table);
  wsptr := PWorkspace(@workspace);
  for ctr := pred(DCTSIZE) downto 0 do
  begin
    { Due to quantization, we will usually find that many of the input
      coefficients are zero, especially the AC terms.  We can exploit this
      by short-circuiting the IDCT calculation for any column in which all
      the AC terms are zero.  In that case each output is equal to the
      DC coefficient (with scale factor as needed).
      With typical images and quantization tables, half or more of the
      column DCT calculations can be simplified this way. }

    if ((inptr^[DCTSIZE*1]=0) and (inptr^[DCTSIZE*2]=0) and
        (inptr^[DCTSIZE*3]=0) and (inptr^[DCTSIZE*4]=0) and
        (inptr^[DCTSIZE*5]=0) and (inptr^[DCTSIZE*6]=0) and
        (inptr^[DCTSIZE*7]=0)) then
    begin
      { AC terms all zero }
      dcval := DEQUANTIZE(inptr^[DCTSIZE*0], quantptr^[DCTSIZE*0]) shl PASS1_BITS;

      wsptr^[DCTSIZE*0] := dcval;
      wsptr^[DCTSIZE*1] := dcval;
      wsptr^[DCTSIZE*2] := dcval;
      wsptr^[DCTSIZE*3] := dcval;
      wsptr^[DCTSIZE*4] := dcval;
      wsptr^[DCTSIZE*5] := dcval;
      wsptr^[DCTSIZE*6] := dcval;
      wsptr^[DCTSIZE*7] := dcval;

      Inc(JCOEF_PTR(inptr));            { advance pointers to next column }
      Inc(ISLOW_MULT_TYPE_PTR(quantptr));
      Inc(int_ptr(wsptr));
      continue;
    end;

    { Even part: reverse the even part of the forward DCT. }
    { The rotator is sqrt(2)*c(-6). }

    z2 := DEQUANTIZE(inptr^[DCTSIZE*2], quantptr^[DCTSIZE*2]);
    z3 := DEQUANTIZE(inptr^[DCTSIZE*6], quantptr^[DCTSIZE*6]);

    z1 := MULTIPLY(z2 + z3, FIX_0_541196100);
    tmp2 := z1 + MULTIPLY(z3, - FIX_1_847759065);
    tmp3 := z1 + MULTIPLY(z2, FIX_0_765366865);

    z2 := DEQUANTIZE(inptr^[DCTSIZE*0], quantptr^[DCTSIZE*0]);
    z3 := DEQUANTIZE(inptr^[DCTSIZE*4], quantptr^[DCTSIZE*4]);

    tmp0 := (z2 + z3) shl CONST_BITS;
    tmp1 := (z2 - z3) shl CONST_BITS;

    tmp10 := tmp0 + tmp3;
    tmp13 := tmp0 - tmp3;
    tmp11 := tmp1 + tmp2;
    tmp12 := tmp1 - tmp2;

    { Odd part per figure 8; the matrix is unitary and hence its
      transpose is its inverse.  i0..i3 are y7,y5,y3,y1 respectively. }

    tmp0 := DEQUANTIZE(inptr^[DCTSIZE*7], quantptr^[DCTSIZE*7]);
    tmp1 := DEQUANTIZE(inptr^[DCTSIZE*5], quantptr^[DCTSIZE*5]);
    tmp2 := DEQUANTIZE(inptr^[DCTSIZE*3], quantptr^[DCTSIZE*3]);
    tmp3 := DEQUANTIZE(inptr^[DCTSIZE*1], quantptr^[DCTSIZE*1]);

    z1 := tmp0 + tmp3;
    z2 := tmp1 + tmp2;
    z3 := tmp0 + tmp2;
    z4 := tmp1 + tmp3;
    z5 := MULTIPLY(z3 + z4, FIX_1_175875602); { sqrt(2) * c3 }

    tmp0 := MULTIPLY(tmp0, FIX_0_298631336); { sqrt(2) * (-c1+c3+c5-c7) }
    tmp1 := MULTIPLY(tmp1, FIX_2_053119869); { sqrt(2) * ( c1+c3-c5+c7) }
    tmp2 := MULTIPLY(tmp2, FIX_3_072711026); { sqrt(2) * ( c1+c3+c5-c7) }
    tmp3 := MULTIPLY(tmp3, FIX_1_501321110); { sqrt(2) * ( c1+c3-c5-c7) }
    z1 := MULTIPLY(z1, - FIX_0_899976223); { sqrt(2) * (c7-c3) }
    z2 := MULTIPLY(z2, - FIX_2_562915447); { sqrt(2) * (-c1-c3) }
    z3 := MULTIPLY(z3, - FIX_1_961570560); { sqrt(2) * (-c3-c5) }
    z4 := MULTIPLY(z4, - FIX_0_390180644); { sqrt(2) * (c5-c3) }

    Inc(z3, z5);
    Inc(z4, z5);

    Inc(tmp0, z1 + z3);
    Inc(tmp1, z2 + z4);
    Inc(tmp2, z2 + z3);
    Inc(tmp3, z1 + z4);

    { Final output stage: inputs are tmp10..tmp13, tmp0..tmp3 }

    wsptr^[DCTSIZE*0] := int (DESCALE(tmp10 + tmp3, CONST_BITS-PASS1_BITS));
    wsptr^[DCTSIZE*7] := int (DESCALE(tmp10 - tmp3, CONST_BITS-PASS1_BITS));
    wsptr^[DCTSIZE*1] := int (DESCALE(tmp11 + tmp2, CONST_BITS-PASS1_BITS));
    wsptr^[DCTSIZE*6] := int (DESCALE(tmp11 - tmp2, CONST_BITS-PASS1_BITS));
    wsptr^[DCTSIZE*2] := int (DESCALE(tmp12 + tmp1, CONST_BITS-PASS1_BITS));
    wsptr^[DCTSIZE*5] := int (DESCALE(tmp12 - tmp1, CONST_BITS-PASS1_BITS));
    wsptr^[DCTSIZE*3] := int (DESCALE(tmp13 + tmp0, CONST_BITS-PASS1_BITS));
    wsptr^[DCTSIZE*4] := int (DESCALE(tmp13 - tmp0, CONST_BITS-PASS1_BITS));

    Inc(JCOEF_PTR(inptr));              { advance pointers to next column }
    Inc(ISLOW_MULT_TYPE_PTR(quantptr));
    Inc(int_ptr(wsptr));
  end;

  { Pass 2: process rows from work array, store into output array. }
  { Note that we must descale the results by a factor of 8 == 2**3, }
  { and also undo the PASS1_BITS scaling. }

  wsptr := @workspace;
  for ctr := 0 to pred(DCTSIZE) do
  begin
    outptr := output_buf^[ctr];
    Inc(JSAMPLE_PTR(outptr), output_col);
    { Rows of zeroes can be exploited in the same way as we did with columns.
      However, the column calculation has created many nonzero AC terms, so
      the simplification applies less often (typically 5% to 10% of the time).
      On machines with very fast multiplication, it's possible that the
      test takes more time than it's worth.  In that case this section
      may be commented out. }

{$ifndef NO_ZERO_ROW_TEST}
    if ((wsptr^[1]=0) and (wsptr^[2]=0) and (wsptr^[3]=0) and (wsptr^[4]=0)
       and (wsptr^[5]=0) and (wsptr^[6]=0) and (wsptr^[7]=0)) then
    begin
      { AC terms all zero }
      JSAMPLE(dcval_) := range_limit^[int(DESCALE(INT32(wsptr^[0]),
                          PASS1_BITS+3)) and RANGE_MASK];

      outptr^[0] := dcval_;
      outptr^[1] := dcval_;
      outptr^[2] := dcval_;
      outptr^[3] := dcval_;
      outptr^[4] := dcval_;
      outptr^[5] := dcval_;
      outptr^[6] := dcval_;
      outptr^[7] := dcval_;

      Inc(int_ptr(wsptr), DCTSIZE);     { advance pointer to next row }
      continue;
    end;
{$endif}

    { Even part: reverse the even part of the forward DCT. }
    { The rotator is sqrt(2)*c(-6). }

    z2 := INT32 (wsptr^[2]);
    z3 := INT32 (wsptr^[6]);

    z1 := MULTIPLY(z2 + z3, FIX_0_541196100);
    tmp2 := z1 + MULTIPLY(z3, - FIX_1_847759065);
    tmp3 := z1 + MULTIPLY(z2, FIX_0_765366865);

    tmp0 := (INT32(wsptr^[0]) + INT32(wsptr^[4])) shl CONST_BITS;
    tmp1 := (INT32(wsptr^[0]) - INT32(wsptr^[4])) shl CONST_BITS;

    tmp10 := tmp0 + tmp3;
    tmp13 := tmp0 - tmp3;
    tmp11 := tmp1 + tmp2;
    tmp12 := tmp1 - tmp2;

    { Odd part per figure 8; the matrix is unitary and hence its
      transpose is its inverse.  i0..i3 are y7,y5,y3,y1 respectively. }

    tmp0 := INT32(wsptr^[7]);
    tmp1 := INT32(wsptr^[5]);
    tmp2 := INT32(wsptr^[3]);
    tmp3 := INT32(wsptr^[1]);

    z1 := tmp0 + tmp3;
    z2 := tmp1 + tmp2;
    z3 := tmp0 + tmp2;
    z4 := tmp1 + tmp3;
    z5 := MULTIPLY(z3 + z4, FIX_1_175875602); { sqrt(2) * c3 }

    tmp0 := MULTIPLY(tmp0, FIX_0_298631336); { sqrt(2) * (-c1+c3+c5-c7) }
    tmp1 := MULTIPLY(tmp1, FIX_2_053119869); { sqrt(2) * ( c1+c3-c5+c7) }
    tmp2 := MULTIPLY(tmp2, FIX_3_072711026); { sqrt(2) * ( c1+c3+c5-c7) }
    tmp3 := MULTIPLY(tmp3, FIX_1_501321110); { sqrt(2) * ( c1+c3-c5-c7) }
    z1 := MULTIPLY(z1, - FIX_0_899976223); { sqrt(2) * (c7-c3) }
    z2 := MULTIPLY(z2, - FIX_2_562915447); { sqrt(2) * (-c1-c3) }
    z3 := MULTIPLY(z3, - FIX_1_961570560); { sqrt(2) * (-c3-c5) }
    z4 := MULTIPLY(z4, - FIX_0_390180644); { sqrt(2) * (c5-c3) }

    Inc(z3, z5);
    Inc(z4, z5);

    Inc(tmp0, z1 + z3);
    Inc(tmp1, z2 + z4);
    Inc(tmp2, z2 + z3);
    Inc(tmp3, z1 + z4);

    { Final output stage: inputs are tmp10..tmp13, tmp0..tmp3 }

    outptr^[0] := range_limit^[ int(DESCALE(tmp10 + tmp3,
                                          CONST_BITS+PASS1_BITS+3))
                            and RANGE_MASK];
    outptr^[7] := range_limit^[ int(DESCALE(tmp10 - tmp3,
                                          CONST_BITS+PASS1_BITS+3))
                            and RANGE_MASK];
    outptr^[1] := range_limit^[ int(DESCALE(tmp11 + tmp2,
                                          CONST_BITS+PASS1_BITS+3))
                            and RANGE_MASK];
    outptr^[6] := range_limit^[ int(DESCALE(tmp11 - tmp2,
                                          CONST_BITS+PASS1_BITS+3))
                            and RANGE_MASK];
    outptr^[2] := range_limit^[ int(DESCALE(tmp12 + tmp1,
                                          CONST_BITS+PASS1_BITS+3))
                            and RANGE_MASK];
    outptr^[5] := range_limit^[ int(DESCALE(tmp12 - tmp1,
                                          CONST_BITS+PASS1_BITS+3))
                            and RANGE_MASK];
    outptr^[3] := range_limit^[ int(DESCALE(tmp13 + tmp0,
                                          CONST_BITS+PASS1_BITS+3))
                            and RANGE_MASK];
    outptr^[4] := range_limit^[ int(DESCALE(tmp13 - tmp0,
                                          CONST_BITS+PASS1_BITS+3))
                            and RANGE_MASK];

    Inc(int_ptr(wsptr), DCTSIZE);       { advance pointer to next row }
  end;
end;

end.
HORZLine(var dest:virtualwindow;X,Y,X2 : Longint; r,g,b : Word);

{------------------------------- Image loaders ------------------------------}

 Function Load_PCX(s:string;var w:virtualwindow):byte;
 Function Load_BMP(s:string;var w:virtualwindow):byte;
 Function Load_JPG(s:string;var w:virtualwindow):byte;
 Function Load_GIF(s:string;var w:virtualwindow):byte;
 Function Load_PNG(s:string;var w:virtualwindow):byte;

 Procedure Load_PCX_from_lib(s:string;id:longint;var w:virtualwindow);
 Function Save_BMP(var w:virtualwindow;s:string):boolean; { Saves into BMP}

{----------------------------- SPRITE Routinen ------------------------------}

 PROCEDURE ClrSprite(var Sprite:VirtualWindow;Color:Word);

 PROCEDURE Load_Sprite(Datei:String;var Sprite:VirtualWindow);

 PROCEDURE Save_Sprite(Datei:String;var Sprite:VirtualWindow);

 PROCEDURE PutSprite(var Dest,Sprite:VirtualWindow;x,y:LongInt);
 PROCEDURE GetSprite(var Source,Sprite:VirtualWindow;x,y:LongInt);
 Procedure PutSprite_and_clear(var Dest, Sprite:VirtualWindow;x,y:longint;c:word);

 PROCEDURE PutClippedSprite(var Dest,Sprite:VirtualWindow;x,y:LongInt);
 PROCEDURE GetClippedSprite(var source,sprite:VirtualWindow;x,y:LongInt);

 PROCEDURE PutHCSprite(var Dest,Sprite:VirtualWindow;x,y:LongInt;HideColor:Word);
 PROCEDURE GetHCSprite(var source:virtualwindow;Sprite:VirtualWindow;x,y:LongInt;HideColor:Word);

 PROCEDURE PutClippedHCSprite(var Dest,Sprite:VirtualWindow;x,y:LongInt;HideColor:Word);


 PROCEDURE GetClippedHCSprite(var source:virtualwindow;Sprite:VirtualWindow;x,y:LongInt;HideColor:Word);


 PROCEDURE PutBrightSprite(var Dest,Sprite:VirtualWindow;x,y:LongInt;rBright,gBright,bBright:ShortInt);

 PROCEDURE PutBrightClippedSprite(var Dest,Sprite:VirtualWindow;x,y:LongInt;rBright,gBright,bBright:ShortInt);

 PROCEDURE PutBrightHCSprite(var Dest,Sprite:VirtualWindow;x,y:LongInt;HideColor:Word;rBright,gBright,bBright:ShortInt);

 PROCEDURE PutBrightClippedHCSprite(var Dest,Sprite:VirtualWindow;x,y:LongInt;HideColor:Word;rBright,gBright,bBright:ShortInt);


 PROCEDURE PutTransSprite(var Dest,Sprite:VirtualWindow;x,y:LongInt;rLight,gLight,bLight:Byte);

 PROCEDURE PutTransClippedSprite(var Dest,Sprite:VirtualWindow;x,y:LongInt;rLight,gLight,bLight:Byte);

 PROCEDURE PutTransHCSprite(var Dest,Sprite:VirtualWindow;x,y:LongInt;HideColor:Word;rLight,gLight,bLight:Byte);

 PROCEDURE PutTransClippedHCSprite(var Dest,Sprite:VirtualWindow;x,y:LongInt;HideColor:Word;rLight,gLight,bLight:Byte);


 PROCEDURE PutAlphaSprite(var Dest,Sprite:VirtualWindow;x,y:LongInt);

 PROCEDURE PutAlphaClippedSprite(var Dest,Sprite:VirtualWindow;x,y:LongInt);

 PROCEDURE PutAlphaHCSprite(var Dest,Sprite:VirtualWindow;x,y:LongInt;HideColor:Word);

 PROCEDURE PutAlphaClippedHCSprite(var Dest,Sprite:VirtualWindow;x,y:LongInt;HideColor:Word);


 PROCEDURE FadeSprite(var Source, dest:virtualwindow);

 FUNCTION  ScaleSprite(var SourSprite:VirtualWindow;Breite,Hoehe:LongInt):VirtualWindow;
 FUNCTION SmoothScaleSprite2(var SourSprite:VirtualWindow;Breite,Hoehe:LongInt):VirtualWindow;

{ Function SmoothScaleSprite(Src:Virtualwindow;Breite,Hoehe:LongInt):Virtualwindow;}

 PROCEDURE AdjustSpriteLightness    (var SourSprite:VirtualWindow;r,g,b:ShortInt               );
 PROCEDURE AdjustSpriteHCLightness  (var SourSprite:VirtualWindow;r,g,b:ShortInt;HideColor:Word);
 PROCEDURE DecreaseSpriteLightness  (var SourSprite:VirtualWindow;r,g,b:Byte                   );
 PROCEDURE DecreaseSpriteHCLightness(var SourSprite:VirtualWindow;r,g,b:Byte;    HideColor:Word);
 PROCEDURE IncreaseSpriteLightness  (var SourSprite:VirtualWindow;r,g,b:Byte                   );
 PROCEDURE IncreaseSpriteHCLightness(var SourSprite:VirtualWindow;r,g,b:Byte;    HideColor:Word);

 PROCEDURE CopySprite(var Sour, dest:virtualwindow);

 Function Rotate180(var source:virtualwindow):VirtualWindow;
 Function Rotate90p(var source:virtualwindow):VirtualWindow;
 Function Rotate90m(var source:virtualwindow):VirtualWindow;
 Function FlipHorz(var source:virtualwindow):VirtualWindow;
 Function FlipVert(var source:virtualwindow):VirtualWindow;

 { I'm proud of this VERY FAST routine which scales and rotates a sprite at the same time !!! }

 PROCEDURE Rotate_Scale_Sprite  (var Sour, dest:virtualwindow;x,y,Breite,Hoehe,Winkel:LongInt);
 PROCEDURE Rotate_Scale_SpriteHC(var Sour, dest:virtualwindow;x,y,Breite,Hoehe,Winkel:LongInt;Hcolor:Word);

 {--------------------- Few routines for banked modes -----------------------}
 Procedure BankPutPixel(x,y:longint;c:word);
 PROCEDURE BankClr(Color:Word);
 PROCEDURE BankPutClippedHCSprite(var Sprite:VirtualWindow;x,y:LongInt;HideColor:Word);
 PROCEDURE BankGetClippedSprite(var Sprite:VirtualWindow;x,y:LongInt);
 PROCEDURE BankPutClippedSprite(var Sprite:VirtualWindow;x,y:LongInt);

 {---- Some routines used in my own projects. Not considered as public ---}
 Function PutChar_FN(var dest:virtualwindow;p:pointer;x,y,xd,yd:longint;compr:boolean;charbytes:byte;c:word):longint;
 {Function PutChar_FN(var dest:virtualwindow;p:pointer;x,y,xd,yd:longint;uni:boolean;c:word):longint;}
 { It is called from unit FNfont2. Draws a char into virtualwindow  }
 Procedure Fade_SVGA(a:byte);
 { fade screen in bank mode }
 Procedure NastavPaletu(p:palette);
 { for 256c modes. sets palette }
 Procedure NastavRegistrPalety(c,r,g,b:byte);
 { for 256c modes. sets register in palette }
 Function NajdiBarvuVpalete(p:palette;r,g,b:byte;var v:byte):boolean;
 { for 256c modes. searches RGB color in palette }
 Procedure HicolorTo256(zdroj:virtualwindow;var cil:virtualwindow;var pal:palette);
 { for 256c modes. converts sprite to 256 colors }
 Procedure GetSprite256(zdroj,cil:virtualwindow;x,y:longint);
 { for 256c modes. reads sprite to 256 colors format }
 Procedure ReplaceColor256(zdroj:virtualwindow;o,n:byte);
 { for 256c modes. replaces color O to color N }

 Function Is_Bitmap_Empty(var p;size:longint):boolean;

 Procedure Desaturation(var cil:virtualwindow;hodnota,hodnota2:real);

 Procedure MakeSpriteMap(var sour:virtualwindow;var buffer;c:word);

 Procedure SaveVGAPalette;

{============================================================================}



IMPLEMENTATION
uses GO32,DOS,Objects
     {$IFDEF JPG_SUPPORT}
     ,JPG_read
     {$ENDIF}
     ;


const _refresh_rate_request:longint = 0;
      _video_access_request:byte = 0;
      protected_vesa_interface:boolean = false;

type
BMP_header = packed record
{00}         magic:word;
{02}         sizebmp:longint;
{06}         reserved:longint;
{10}         offset_to_data:longint;
{14}         header_size:longint;
{18}         width:longint;
{22}         height:longint;
{26}         numplanes:word;
{28}         bits_per_pixel:word;
{30}         compressed:longint;
{34}         sizeimage:longint;
{38}         xres:longint;
{42}         yres:longint;
{46}         clrused:longint;
{50}         clrimportant:longint;
             end;

WordArray = array[0..65535] of word;

VAR  ScanCode            : Byte;
     grann               : longint;  { pro bankovani - granularita }
     curbank             : longint;  { prave pouzivany bank        }
     numm                : longint;  { pocet banku }
     bisgm               : longint;  { 64/granularita }
     Regs                : TRealRegs;
     SelectedMode        : Word;
     xpos1,ypos1         : Word;
     xpos2,ypos2         : Word;
     Old_cs,_cs,TextSize : Word;
     Loop1,Loop2,Loop3   : LongInt;
     Winkel1             : Real;
     HandlerInstalled    : Boolean;
     timer_installed     : boolean;
     timer_busy          : boolean;
     mouse_mode          : byte;
     pag_color           : longint;
     FontVariable        : Array[0..3503] of Byte;
     LinePosition        : Array[0..2000] of LongInt;
            VesaBaseInfo : packed Record
                { 0}        Signatur             : Array[1..4] of Char;
                { 4}        VesaVersion          : Array[1..2] of Byte;
                { 6}        OEM_ID               : LongInt;
                {10}        Eigenschaften        : LongInt;
                {14}        VideoModi            : LongInt;   { PTR na modelist }
                {18}        Videospeicher        : Word;      { Velikost videopameti v }
                                                              { 64KB uzlicich }
                            { rozsireni VESA 2.0 }
                {20}        OEM_Version          : Array[1..2] of Byte;
                {22}        Verleger             : LongInt;
                {26}        Produkt_ID           : LongInt;
                {30}        Produkt_Revision     : LongInt;
                            { VBE/AF extension - not really used }
                {34}        Accel_VBE_version    : word;
                {38}        Accel_Videomode_PTR  : longint;
                            { other }
                {42}        Leer                 : Array[1..214] of Byte;
                            OEM_Scratchpad       : Array[1..256] of Byte;
                           End;


            VesaModeInfo : packed Record
                { 0}        Modus_Attribute      : Word;
                { 2}        WinA_Attr            : Byte;
                { 3}        WinB_Attr            : Byte;
                { 4}        Granularitaet        : Word;
                { 6}        Fenster_Groesse      : Word;
                { 8}        Seg_Fenster_A        : Word;
                {10}        Seg_Fenster_B        : Word;
                {12}        BankRoutine          : Pointer;
                {16}        BytesPerScanline     : Word;
                {18}        HAufloesung          : Word;
                {20}        VAufloesung          : Word;
                {22}        Videozellen_Breite   : Byte;
                {23}        Videozellen_Hoehe    : Byte;
                {24}        Anz_Speicherplanes   : Byte;
                {25}        Bpp                  : Byte;
                {26}        Raster_Banks         : Byte;
                {27}        Speicherorganisation : Byte;
                {28}        Groesse_RasterBanks  : Byte;
                {29}        Video_Pages          : Byte;
                {30}        Reserviert           : Byte;
                {31}        Red_Mask_Size        : Byte;
                {32}        Red_Mask_Field       : Byte;
                {33}        Green_Mask_Size      : Byte;
                {34}        Green_Mask_Field     : Byte;
                {35}        Blue_Mask_Size       : Byte;
                {36}        Blue_Mask_Field      : Byte;
                {37}        Reserved_Mask_Size   : Byte;
                {38}        Reserved_Mask_Field  : Byte;
                {39}        Direct_Color_Organi  : Byte;
                            { VESA 2.0   }
                {40}        LFB_Adresse          : LongInt;
                {44}        reserved1            : longint;
                {48}        reserved2            : word;
                            { VESA 3.0   }
                {50}        LinBytesPerScanLine     : word;
                {52}        BnkNumberOfImagePlanes  : byte;
                {53}        LinNumberOfImagePlanes  : byte;
                {54}        LinRedMaskSize          : byte;
                {55}        LinRedMaskPosition      : byte;
                {56}        LinGreenMaskSize        : byte;
                {57}        LinGreenMaskPosition    : byte;
                {58}        LinBlueMaskSize         : byte;
                {59}        LinBlueMaskPosition     : byte;
                {60}        LinRSVDmaskSize         : byte;
                {61}        LinRSVDfieldPosition    : byte;
                {62}        MaxPixelClock           : longint;
                {63}        reserved                : array[0..182] of byte;
                            { neni soucasti standardu VESA - to jsou jen moje pracovni udaje ! }
                            LFB_Supported        : Boolean;
                            Banks                : Byte;
                            BSize {=BankByteSize}: LongInt;
                            End;

vbPMI: pointer;                {Protected mode interface}
vbPMIsize: longint;            {Size of pmode interface}
vbPMFSeg: word;                {Selector required for PMode functions}
vbPMISetWindow: pointer;       {Pointer to setWindow function}
vbPMISetDisplayStart: pointer; {Pointer to setDisplayStart function}

CRTCInfoBlock : packed record
HorizontalTotal:word;
HorizontalSyncStart:word;
HorizontalSyncEnd:word;
VerticalTotal:word;
VerticalSyncStart:word;
VerticalSyncEnd:word;
Flags:byte;
PixelClock:dword;    { units of Hz }
RefreshRate:word;    { units of 0.01 Hz }
reserved:array[0..39] of byte;
end;

{$include VESA_DDC.INC}
my_ddc     : VESA_EDID;
ddc_support: boolean;
{--------------------------- MOUSE VARIABLES ----------------------------}

mouse_regs    : trealregs; external name '___v2prt0_rmcb_regs';
mouse_seginfo : tseginfo;
mystack:pointer;
oldss,oldsp:longint;

mouse_internal:record
backup_ds:word;
end;

oldint1c : tseginfo;
newint1c : tseginfo;
int1c_ds : Word; external name '___v2prt0_ds_alias';

mouse_driver_installed: longbool;
const DEFAULT_POINTER:array[1..99] of dword=
($0,$F800F800,$F800F800,$F800F800,$F800F800,$F800,$FFFF,$F800F800,$F800F800,
$F800F800,$F800F800,$FFFF0000,$FFFF,$F800F800,$F800F800,$F800F800,$F800,
$FFFFFFFF,$FFFF,$F800F800,$F800F800,$F800F800,$FFFF0000,$FFFFFFFF,$FFFF,
$F800F800,$F800F800,$F800,$FFFFFFFF,$FFFFFFFF,$FFFF,$F800F800,$F800F800,
$FFFF0000,$FFFFFFFF,$FFFFFFFF,$FFFF,$F800F800,$F800,$FFFFFFFF,$FFFFFFFF,
$FFFFFFFF,$FFFF,$F800F800,$FFFF0000,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFF,
$F800,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFF,$FFFF0000,$FFFFFFFF,
$FFFFFFFF,$0,$0,$F800,$FFFFFFFF,$FFFF0000,$FFFFFFFF,$F8000000,$F800F800,
$FFFF0000,$F8000000,$FFFF0000,$FFFF,$F800F800,$F800,$F8000000,$F800,$FFFFFFFF,
$FFFF,$F800F800,$F800F800,$F800F800,$F800,$FFFFFFFF,$F8000000,$F800F800,
$F800F800,$F800F800,$FFFF0000,$FFFFFFFF,$F8000000,$F800F800,$F800F800,$F800F800,
$FFFF0000,$FFFF,$F800F800,$F800F800,$F800F800,$F800F800,$0,$F8000000);

const CLOCK_POINTER:array[1..99] of dword =
($F800,$0,$0,$0,$0,$F800F800,$FFFF0000,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$F8000000,
$F800,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFF,$F800F800,$FFFF0000,$FFFFFFFF,
$FFFFFFFF,$FFFFFFFF,$F8000000,$F800,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFF,
$F800F800,$F800,$FFFF0000,$FFFF0000,$0,$F800F800,$F800F800,$FFFF0000,$FFFF0000,
$FFFF0000,$F8000000,$F800F800,$F800F800,$FFFF0000,$FFFF0000,$F8000000,$F800F800,
$F800F800,$F800,$FFFF0000,$0,$F800F800,$F800F800,$F800F800,$F800,$FFFF,
$F800F800,$F800F800,$F800F800,$F800,$FFFF0000,$0,$F800F800,$F800F800,$F800F800,
$FFFF0000,$FFFF0000,$F8000000,$F800F800,$F800F800,$FFFF0000,$FFFFFFFF,$FFFFFFFF,
$F8000000,$F800F800,$F800,$FFFFFFFF,$FFFF0000,$FFFF,$F800F800,$F800,$FFFFFFFF,
$FFFF0000,$FFFF0000,$FFFF,$F800F800,$FFFF0000,$FFFF0000,$FFFF0000,$FFFF0000,
$F8000000,$F800,$FFFF0000,$FFFF0000,$FFFF0000,$0,$F800F800,$0,$0,$0,$0,$F8000000);

DEFAULT_POINTER_WIDTH=11;
DEFAULT_POINTER_HEIGHT=18;
CLOCK_POINTER_WIDTH=11;
CLOCK_POINTER_HEIGHT=18;


{----------------------------- DIVERSES -------------------------------------}


PROCEDURE Init_Textmode;
Begin
(*
 FillChar(Regs,SizeOf(Regs),0);
 Regs.ax:= $3;
 If not RealIntr($10,Regs) then ERROR('Init Textmode failed !','');
*)
asm
mov ax,4f02h
mov bx,3
int 10h
mov ax,3
int 10h
end;
End;



PROCEDURE Error(SourceText1,SourceText2:String);
Begin
 INIT_TEXTMODE;
 writeln(SourceText1);
 writeln(SourceText2);
 Halt;
End;


FUNCTION Get_CPU:Boolean;
CONST    Copyright    = 'GET_CPU, Copyright (c) 2001 by Christian T. Magnus a.k.a. Venom/Megelan, Venom Software. All rights reserved.';
VAR      Steuercodes  : DWord;
         CPUResult    : Byte;
         VendorString : Array[0..11] of Char;
Begin
 CPU_Info_Vendor    := 