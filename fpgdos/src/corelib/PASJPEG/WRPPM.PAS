Unit WrPPM;

{ wrppm.c

  Copyright (C) 1991-1996, Thomas G. Lane.
  This file is part of the Independent JPEG Group's software.
  For conditions of distribution and use, see the accompanying README file.

  This file contains routines to write output images in PPM/PGM format.
  The extended 2-byte-per-sample raw PPM/PGM formats are supported.
  The PBMPLUS library is NOT required to compile this software
  (but it is highly useful as a set of PPM image manipulation programs).

  These routines may need modification for non-Unix environments or
  specialized applications.  As they stand, they assume output to
  an ordinary stdio stream. }

interface

{$I jconfig.inc}

uses
  jdeferr,
  jmorecfg,
  jerror,
  jpeglib,
  jinclude,
  jdmaster,
  cdjpeg;               { Common decls for cjpeg/djpeg applications }

{GLOBAL}
function jinit_write_ppm (cinfo : j_decompress_ptr) : djpeg_dest_ptr;

implementation

{ For 12-bit JPEG data, we either downscale the values to 8 bits
  (to write standard byte-per-sample PPM/PGM files), or output
  nonstandard word-per-sample PPM/PGM files.  Downscaling is done
  if PPM_NORAWWORD is defined (this can be done in the Makefile
  or in jconfig.h).
  (When the core library supports data precision reduction, a cleaner
  implementation will be to ask for that instead.) }

type
  CharPtr = ^char;


{$ifdef BITS_IN_JSAMPLE_IS_8}

procedure PUTPPMSAMPLE(var ptr : CharPtr; v : byte);
begin
  ptr^ := char(v);
  Inc(ptr);
end;

const
  BYTESPERSAMPLE = 1;
  PPM_MAXVAL = 255;
{$else}
  {$ifdef PPM_NORAWWORD}

procedure PUTPPMSAMPLE(var ptr : CharPtr; v : byte);
begin
  ptr^ := char (v shr (BITS_IN_JSAMPLE-8));
  Inc(ptr);
end;

const
  BYTESPERSAMPLE = 1;
  PPM_MAXVAL = 255;

  {$else}
  { The word-per-sample format always puts the LSB first. }

procedure PUTPPMSAMPLE(var ptr : CharPtr; v : int);
var
  {register} val_ : int;
begin
  val_ := v;
  ptr^ := char (val_ and $FF);
  Inc(ptr);
  ptr^ := char ((val_ shr 8) and $FF);
  Inc(ptr);
end;
const
  BYTESPERSAMPLE = 2;
  PPM_MAXVAL = (1 shl BITS_IN_JSAMPLE)-1;
  {$endif}
{$endif}


{ When JSAMPLE is the same size as char, we can just fwrite() the
  decompressed data to the PPM or PGM file.  On PCs, in order to make this
  work the output buffer must be allocated in near data space, because we are
  assuming small-data memory model wherein fwrite() can't reach far memory.
  If you need to process very wide images on a PC, you might have to compile
  in large-memory model, or else replace fwrite() with a putc() loop ---
  which will be much slower. }


{ Private version of data destination object }

type
  ppm_dest_ptr = ^ppm_dest_struct;
  ppm_dest_struct = record
    pub : djpeg_dest_struct;    { public fields }

    { Usually these two pointers point to the same place: }
    iobuffer : CharPtr;          { fwrite's I/O buffer }
    pixrow : JSAMPROW;           { decompressor output buffer }
    buffer_width : size_t;       { width of I/O buffer }
    samples_per_row : JDIMENSION; { JSAMPLEs per output row }
  end;


{ Write some pixel data.
  In this module rows_supplied will always be 1.

  put_pixel_rows handles the "normal" 8-bit case where the decompressor
  output buffer is physically the same as the fwrite buffer. }

{METHODDEF}
procedure put_pixel_rows (cinfo : j_decompress_ptr;
                          dinfo : djpeg_dest_ptr;
                          rows_supplied : JDIMENSION); far;
var
  dest : ppm_dest_ptr;
begin
  dest := ppm_dest_ptr(dinfo);
  {void} JFWRITE(dest^.pub.output_file, dest^.iobuffer, dest^.buffer_width);
end;


{ This code is used when we have to copy the data and apply a pixel
  format translation.  Typically this only happens in 12-bit mode. }

{METHODDEF}
procedure copy_pixel_rows (cinfo : j_decompress_ptr;
                           dinfo : djpeg_dest_ptr;
                           rows_supplied : JDIMENSION); far;
var
  dest : ppm_dest_ptr;
  {register} bufferptr : CharPtr;
  {register} ptr : JSAMPLE_PTR;
  {register} col : JDIMENSION;
begin
  dest := ppm_dest_ptr(dinfo);
  ptr := JSAMPLE_PTR(dest^.pub.buffer^[0]);
  bufferptr := dest^.iobuffer;
  for col := pred(dest^.samples_per_row) downto 0 do
  begin
    PUTPPMSAMPLE(bufferptr, GETJSAMPLE(ptr^));
    Inc(ptr);
  end;
  {void} JFWRITE(dest^.pub.output_file, dest^.iobuffer, dest^.buffer_width);
end;


{ Write some pixel data when color quantization is in effect.
  We have to demap the color index values to straight data. }

{METHODDEF}
procedure put_demapped_rgb (cinfo : j_decompress_ptr;
                            dinfo : djpeg_dest_ptr;
                            rows_supplied : JDIMENSION); far;
var
  dest : ppm_dest_ptr;
  {register} bufferptr : CharPtr;
  {register} ptr : JSAMPLE_PTR;
  {register} col : JDIMENSION;

  {register} pixval : int;
  {register} color_map0 : JSAMPROW;
  {register} color_map1 : JSAMPROW;
  {register} color_map2 : JSAMPROW;
begin
  dest := ppm_dest_ptr(dinfo);
  ptr := JSAMPLE_PTR(dest^.pub.buffer^[0]);
  bufferptr := dest^.iobuffer;
  color_map0 := cinfo^.colormap^[0];
  color_map1 := cinfo^.colormap^[1];
  color_map2 := cinfo^.colormap^[2];

  for col := pred(cinfo^.output_width) downto 0 do
  begin
    pixval := GETJSAMPLE(ptr^);
    Inc(ptr);
    PUTPPMSAMPLE(bufferptr, GETJSAMPLE(color_map0^[pixval]));
    PUTPPMSAMPLE(bufferptr, GETJSAMPLE(color_map1^[pixval]));
    PUTPPMSAMPLE(bufferptr, GETJSAMPLE(color_map2^[pixval]));
  end;
  {void} JFWRITE(dest^.pub.output_file, dest^.iobuffer, dest^.buffer_width);
end;


{METHODDEF}
procedure put_demapped_gray (cinfo : j_decompress_ptr;
                             dinfo : djpeg_dest_ptr;
                             rows_supplied : JDIMENSION); far;
var
  dest : ppm_dest_ptr;
  {register} bufferptr : CharPtr;
  {register} ptr : JSAMPLE_PTR;
  {register} color_map : JSAMPROW;
  {register} col : JDIMENSION;
begin
  dest := ppm_dest_ptr(dinfo);
  color_map := cinfo^.colormap^[0];
  ptr := JSAMPLE_PTR(dest^.pub.buffer^[0]);
  bufferptr := dest^.iobuffer;
  for col := pred(cinfo^.output_width) downto 0 do
  begin
    PUTPPMSAMPLE(bufferptr, GETJSAMPLE(color_map^[GETJSAMPLE(ptr^)]));
    Inc(ptr);
  end;
  {void} JFWRITE(dest^.pub.output_file, dest^.iobuffer, dest^.buffer_width);
end;


{ Startup: write the file header. }

{METHODDEF}
procedure start_output_ppm (cinfo : j_decompress_ptr;
                            dinfo : djpeg_dest_ptr); far;
const
  LF = #10;
var
  dest : ppm_dest_ptr;
var
  header : string[200];

  function LongToStr(l : long) : string;
  var
    helpstr : string[20];
  begin
    Str(l, helpstr);
    LongToStr := helpstr;
  end;

begin
  dest := ppm_dest_ptr(dinfo);
  { Emit file header }
  case (cinfo^.out_color_space) of
  JCS_GRAYSCALE:
    begin
      { emit header for raw PGM format }
      header := 'P5'+LF+LongToStr(cinfo^.output_width)+' '+
                LongToStr(cinfo^.output_height)+LF+
                LongToStr(Long(PPM_MAXVAL)) + LF;
      JFWRITE(dest^.pub.output_file, @header[1], Length(header));
    end;
  JCS_RGB:
    begin
      { emit header for raw PPM format }
      header := 'P6'+LF+LongToStr(cinfo^.output_width)+' '+
                LongToStr(cinfo^.output_height)+LF+
                LongToStr(Long(PPM_MAXVAL)) + LF;
      JFWRITE(dest^.pub.output_file, @header[1], Length(header));
    end;
  else
    ERREXIT(j_common_ptr(cinfo), JERR_PPM_COLORSPACE);
  end;
end;


{ Finish up at the end of the file. }

{METHODDEF}
procedure finish_output_ppm (cinfo : j_decompress_ptr;
                             dinfo : djpeg_dest_ptr); far;
begin
  { Make sure we wrote the output file OK }
  {Flush(dinfo^.output_file^);}
  if (IOresult <> 0) then
    ERREXIT(j_common_ptr(cinfo), JERR_FILE_WRITE);
end;

{ The module selection routine for PPM format output. }

{GLOBAL}
function jinit_write_ppm (cinfo : j_decompress_ptr) : djpeg_dest_ptr;
var
  dest : ppm_dest_ptr;
begin
  { Create module interface object, fill in method pointers }
  dest := ppm_dest_ptr (
      cinfo^.mem^.alloc_small (j_common_ptr(cinfo), JPOOL_IMAGE,
                                  SIZEOF(ppm_dest_struct)) );
  dest^.pub.start_output := start_output_ppm;
  dest^.pub.finish_output := finish_output_ppm;

  { Calculate output image dimensions so we can allocate space }
  jpeg_calc_output_dimensions(cinfo);

  { Create physical I/O buffer.  Note we make this near on a PC. }
  dest^.samples_per_row := cinfo^.output_width * cinfo^.out_color_components;
  dest^.buffer_width := dest^.samples_per_row * (BYTESPERSAMPLE * SIZEOF(char));
  dest^.iobuffer := CharPtr( cinfo^.mem^.alloc_small
    (j_common_ptr(cinfo), JPOOL_IMAGE, dest^.buffer_width) );

  if (cinfo^.quantize_colors) or (BITS_IN_JSAMPLE <> 8) or
      (SIZEOF(JSAMPLE) <> SIZEOF(char)) then
  begin
    { When quantizing, we need an output buffer for colormap indexes
      that's separate from the physical I/O buffer.  We also need a
      separate buffer if pixel format translation must take place. }

    dest^.pub.buffer := cinfo^.mem^.alloc_sarray
      (j_common_ptr(cinfo), JPOOL_IMAGE,
       cinfo^.output_width * cinfo^.output_components, JDIMENSION(1));
    dest^.pub.buffer_height := 1;
    if (not cinfo^.quantize_colors) then
      dest^.pub.put_pixel_rows := copy_pixel_rows
    else
      if (cinfo^.out_color_space = JCS_GRAYSCALE) then
        dest^.pub.put_pixel_rows := put_demapped_gray
      else
        dest^.pub.put_pixel_rows := put_demapped_rgb;
  end
  else
  begin
    { We will fwrite() directly from decompressor output buffer. }
    { Synthesize a JSAMPARRAY pointer structure }
    { Cast here implies near^.far pointer conversion on PCs }
    dest^.pixrow := JSAMPROW(dest^.iobuffer);
    dest^.pub.buffer := JSAMPARRAY (@dest^.pixrow);
    dest^.pub.buffer_height := 1;
    dest^.pub.put_pixel_rows := put_pixel_rows;
  end;

  jinit_write_ppm := djpeg_dest_ptr(dest);
end;


end.
N      D ´Q      D ¨T      D ≠W      D ÆY      D Ø[      D ±]      D ≤`      D ≥c      D ¥f      D µi      D ∂k      D ∏m      D ∫p      D ºt      D Ωw      D æ{      D ø~      D ¡Å      D ¬Ñ      D √á      D ≈ä      D ∆ç      D «è      D …ë      D  î      D Àñ      D Õò      D Œõ      D œù      D “ü      D ”°      D ‘•      D ’ß      D ÷´      D ÿ≠      D ⁄±      D €¥      D ›∑      D ﬁ∏      D ‡æ      D ·¡      D ‚ƒ      D ‰«      D Â       D Ê–      D Á—   F  † |   ö\  † |   ?  † |   ?  † |   Í`  † |   ˆ`  † |   a  † |   ^  Ä }¸ˇˇˇ]  Ä ~¯ˇˇˇa  Ä ~Ùˇˇˇâ`  Ä ˇˇˇa  Ä ÄÏˇˇˇ0]  Ä ÅËˇˇˇ*P  Ä ÇÁˇˇˇ/P  Ä ÇÊˇˇˇ4P  Ä ÇÂˇˇˇ"a  Ä É‰ˇˇˇ)a  Ä É„ˇˇˇ0a  Ä É‚ˇˇˇ7a  Ä Ñ‡ˇˇˇ>a  Ä ÑﬁˇˇˇEa  Ä Ñ‹ˇˇˇ   ¿          ‡   —   La  $ Øh‰     D Ø       D ˘      D ˙	      D ˚      D ¸      D ˝      D ˛      D ˇ      D        D $      D '      D *      D 0      D 3      D 6      D 	<      D 
=      D >      D A      D D      D F      D H      D K      D R      D T      D [      D ^      D a      D d      D f      D h      D k      D r      D  t      D !{      D $~      D %      D &Ç      D 'Ñ      D (á      D )ä      D +å      D ,è      D -í      D 0ï      D 1ñ      D 2ô      D 3õ      D 4û      D 5°      D 7£      D 8¶      D 9©      D <¨      D =Ø      D >≤      D @µ      D A∏      D Bª      D Dæ      D E¬      D G∆      D H«      D J       D KÕ      D L–      D M”      D O÷      D PŸ      D Q‹      D Rﬂ      D S‚      D U‰      D VÁ      D WÍ      D XÌ      D Y      D [Ú      D \ı      D `¯      D c˚      D e˛      D f     D g     D h     D i     D j     D l     D m     D n     D o     D p     D q     D s     D t!     D u$     D v'     D w*     D x,     D z.     D |1     D ~5     D 8     D Ä<     D Å?     D ÉB     D ÑE     D ÖH     D áK     D àN     D âP     D ãR     D åU     D çW     D èY     D ê\     D ë^     D î`     D ïb     D ñf     D óh     D òl     D ön     D úr     D ùu     D üx     D †y     D ¢     D £Ç     D §Ö     D ¶à     D ßã     D ®é     D ™ë     D ´î     D ¨ö     D Øõ  F  † Í   ö\  † Í   ?  † Í   ?  † Í   Í`  † Í   ˆ`  † Í   a  † Í   ±\  Ä Î¸ˇˇˇ¬\  Ä Ï¯ˇˇˇ”\  Ä ÌÙˇˇˇ‰\  Ä Óˇˇˇı\  Ä ÔÏˇˇˇ]  Ä Ëˇˇˇ]  Ä Ò‰ˇˇˇ]  Ä Ú‡ˇˇˇA]  Ä Û‹ˇˇˇ0]  Ä Ùÿˇˇˇ*]  Ä ı‘ˇˇˇa  Ä ı–ˇˇˇ*P  Ä ˆœˇˇˇ/P  Ä ˆŒˇˇˇ4P  Ä ˆÕˇˇˇ   ¿          ‡   õ  ga  $ Ê     D        D ∫      D ª	      D º      D Ω      D ø      D ¿      D ¡      D ¬      D √      D ƒ      D ≈"      D ∆%      D «)      D »,      D …/      D  1      D Ã4      D –7      D ”:      D ‘=      D ’A      D ◊G      D ÿJ      D ŸN      D ⁄Q      D €T      D ‹V      D ﬁX      D ﬂ[      D ‡^      D ·a      D ‚c      D „e      D Âg      D Êj      D Ám      D Ëp      D Ès      D Íu      D Ïw      D Óz      D ~      D ÒÅ      D ÚÖ      D Ûà      D ıã      D ˆé      D ˜ë      D ˘î      D ˙ó      D ˚ô      D ˝õ      D ˛û      D ˇ†      D ¢      D •      D ß      D ©      D ´      D Ø      D 	±      D 
µ      D ∑      D ª      D æ      D ¡      D ¬      D »      D À      D Œ      D —      D ‘      D ⁄      D €   F  † ≤   ö\  † ≤   ?  † ≤   ?  † ≤   §\  † ≤   Í`  † ≤   ˆ`  † ≤   a  † ≤   ]  Ä ≥¸ˇˇˇ0]  Ä ¥¯ˇˇˇâ`  Ä µÙˇˇˇa  Ä ∂ˇˇˇ}a  Ä ∑Ïˇˇˇa  Ä ∑Ëˇˇˇ*P  Ä ∏Áˇˇˇ/P  Ä ∏Êˇˇˇ4P  Ä ∏Âˇˇˇ   ¿          ‡   €   äa  $ ËËÊ     D Ë       D -      D .	      D /      D 0      D 1      D 2      D 3      D 4      D 6$      D 7'      D 8*      D 90      D :3      D ;6      D =<      D >=      D @>      D AA      D BD      D CF      D DH      D EK      D FR      D HT      D I[      D L^      D Ma      D Nd      D Of      D Ph      D Qk      D Rr      D Tt      D U{      D X~      D Y      D ZÇ      D [Ñ      D \á      D ]ä      D _å      D `è      D aí      D dï      D eñ      D fô      D gõ      D hû      D i°      D k£      D l¶      D m©      D p¨      D qØ      D r≤      D tµ      D u∏      D vª      D xæ      D y¬      D {∆      D |«      D ~       D Õ      D Ä–      D Å”      D É÷      D ÑŸ      D Ö‹      D Üﬂ      D á‚      D â‰      D äÁ      D ãÍ      D åÌ      D ç      D èÚ      D êı      D î¯      D ó˚      D ò˛      D ô     D õ     D ú     D ù     D û     D ü     D †     D ¢     D £     D §     D •"     D ¶$     D ß&     D ©(     D ™+     D ´.     D ¨1     D ≠4     D Æ6     D ∞8     D ≤;     D ¥?     D µB     D ∂F     D ∑I     D πL     D ∫O     D ªR     D ΩU     D æX     D øZ     D ¡\     D ¬_     D √a     D ≈c     D ∆f     D «h     D  j     D Àl     D Ãp     D Õr     D Œv     D –x     D ‘|     D ’     D ◊Ç     D ÿÉ     D ⁄â     D €å     D ‹è     D ﬁí     D ﬂï     D ‡ò     D ‚õ     D „û     D Â§     D Ë•  F  †    ö\  †    ?  †    ?  †    §\  †    Í`  †    ˆ`  †    a  †    ±\  Ä  ¸ˇˇˇ¬\  Ä !¯ˇˇˇ”\  Ä "Ùˇˇˇ‰\  Ä #ˇˇˇı\  Ä $Ïˇˇˇ]  Ä %Ëˇˇˇ]  Ä &‰ˇˇˇ]  Ä '‡ˇˇˇ0]  Ä (‹ˇˇˇA]  Ä )ÿˇˇˇ*]  Ä *‘ˇˇˇa  Ä *–ˇˇˇ*P  Ä +œˇˇˇ/P  Ä +Œˇˇˇ4P  Ä +Õˇˇˇ   ¿          ‡   •  ßa  $ RòË     D R       D ı      D ˆ	      D ˜      D ¯      D ˙      D ˚      D ¸      D ˝      D ˛      D ˇ      D  "      D %      D )      D ,      D /      D 1      D 4      D 7      D :      D =      D @      D D      D G      D J      D M      D P      D S      D W      D Z      D ^      D a      D d      D g      D j      D l      D !n      D "q      D #t      D $v      D &x      D '{      D (~      D )Ä      D ,Ç      D -Ö      D .à      D 0ã      D 1é      D 2ê   