Program JpegTran;

{ This file contains a command-line user interface for JPEG transcoding.
  It is very similar to cjpeg.c, but provides lossless transcoding between
  different JPEG file formats. }

{ Original: jpegtran.c ; Copyright (C) 1995-1996, Thomas G. Lane. }

{$define TWO_FILE_COMMANDLINE}

{$I jconfig.inc}

uses
  jdeferr,
  jerror,
  jmorecfg,
  jpeglib,
  cdjpeg,       { Common decls for cjpeg/djpeg applications }
  jdatasrc, JDatadst, transupp, JCTrans, JDtrans,
  JdAPImin, JcAPImin, JcParam,
  RdSwitch;


{ Argument-parsing code.
  The switch parser is designed to be useful with DOS-style command line
  syntax, ie, intermixed switches and file names, where only the switches
  to the left of a given file name affect processing of that file.
  The main program in this file doesn't actually use this capability... }


var
  progname,             { program name for error messages }
  outfilename : string; { for -outfile switch }
  copyoption : JCOPY_OPTION;                  { -copy switch }
  transformoption : jpeg_transform_info; { image transformation options }

procedure Stop(errcode : int);
begin
  Halt(errcode);
end;

{LOCAL}
procedure usage;
{ complain about bad command line }
begin
  Write(output, 'usage: ',progname,' [switches] ');
{$ifdef TWO_FILE_COMMANDLINE}
  WriteLn(output, 'inputfile outputfile');
{$else}
  WriteLn(output, '[inputfile]');
{$endif}

  WriteLn(output, 'Switches (names may be abbreviated):');
  WriteLn('  -copy none     Copy no extra markers from source file');
  WriteLn('  -copy comments Copy only comment markers (default)');
  WriteLn('  -copy all      Copy all extra markers');
{$ifdef ENTROPY_OPT_SUPPORTED}
  WriteLn('  -optimize      Optimize Huffman table (smaller file, but slow compression)');
{$endif}
{$ifdef C_PROGRESSIVE_SUPPORTED}
  WriteLn('  -progressive   Create progressive JPEG file');
{$endif}
{$ifdef TRANSFORMS_SUPPORTED}
  WriteLn('Switches for modifying the image:');
  WriteLn('  -grayscale     Reduce to grayscale (omit color data)');
  WriteLn('  -flip [horizontal|vertical]  Mirror image (left-right or top-bottom)');
  WriteLn('  -rotate [90|180|270]         Rotate image (degrees clockwise)');
  WriteLn('  -transpose     Transpose image');
  WriteLn('  -transverse    Transverse transpose image');
  WriteLn('  -trim          Drop non-transformable edge blocks');
  {$ifdef CROP_SUPPORTED}
  WriteLn('  -cut WxH+X+Y   Cut out a subset of the image');
  {$endif}
{$endif} { TRANSFORMS_SUPPORTED }
  WriteLn('Switches for advanced users:');
  WriteLn('  -restart N     Set restart interval in rows, or in blocks with B');
  WriteLn('  -maxmemory N   Maximum memory to use (in kbytes)');
  WriteLn('  -outfile name  Specify name for output file');
  WriteLn('  -verbose  or  -debug   Emit debug output');
  WriteLn('Switches for wizards:');
{$ifdef C_ARITH_CODING_SUPPORTED}
  WriteLn('  -arithmetic    Use arithmetic coding');
{$endif}
{$ifdef C_MULTISCAN_FILES_SUPPORTED}
  WriteLn('  -scans file    Create multi-scan JPEG per script file');
{$endif}
  Stop(EXIT_FAILURE);
end;

{LOCAL}
procedure select_transform (transform : JXFORM_CODE);
{ Silly little routine to detect multiple transform options,
  which we can't handle. }

begin
{$ifdef TRANSFORMS_SUPPORTED}
  if (transformoption.transform = JXFORM_NONE) or
     (transformoption.transform = transform) then
    transformoption.transform := transform
  else
  begin
    WriteLn(progname, ': can only do one image transformation at a time');
    usage;
  end;
{$else}
  WriteLn(progname, ': sorry, image transformation was not compiled');
  exit(EXIT_FAILURE);
{$endif}
end;

{LOCAL}
function parse_switches (cinfo : j_compress_ptr;
                         last_file_arg_seen: int;
                         for_real : boolean ) : int;
const
  printed_version : boolean = FALSE;

{ Parse optional switches.
  Returns argv[] index of first file-name argument (= argc if none).
  Any file names with indexes <= last_file_arg_seen are ignored;
  they have presumably been processed in a previous iteration.
  (Pass 0 for last_file_arg_seen on the first or only iteration.)
  for_real is FALSE on the first (dummy) pass; we may skip any expensive
  processing. }
var
  argn,
  argc : int;
  arg : string;

  simple_progressive : boolean;
const
  scansarg : string = '';       { saves -scans parm if any }
var
  lval : long;
  ch : char;
  code : integer;
begin
  { Set up default JPEG parameters. }
  simple_progressive := FALSE;
  outfilename := '';
  cinfo^.err^.trace_level := 0;
  copyoption := JCOPYOPT_DEFAULT;
  transformoption.transform := JXFORM_NONE;
  transformoption.trim := FALSE;
  transformoption.force_grayscale := FALSE;
  cinfo^.err^.trace_level := 0;

  { Scan command line options, adjust parameters }

  argn := 0;
  argc := ParamCount;

  while argn < argc do
  begin
    Inc(argn);
    arg := ParamStr(argn);
    if (arg[1] <> '-') then
    begin
      { Not a switch, must be a file name argument }
      if (argn <= last_file_arg_seen) then
      begin
        outfilename := '';      { -outfile applies to just one input file }
        continue;               { ignore this name if previously processed }
      end;
      break;                    { else done parsing switches }
    end;
    {Inc(arg);                  - advance past switch marker character }

    if (keymatch(arg, '-arithmetic', 1)) then
    begin
      { Use arithmetic coding. }
{$ifdef C_ARITH_CODING_SUPPORTED}
      cinfo^.arith_code := TRUE;
{$else}
      WriteLn(output, progname, ': sorry, arithmetic coding not supported');
      Stop(EXIT_FAILURE);
{$endif}
    end
    else
      if keymatch(arg, '-copy', 2) then
      begin { Select which extra markers to copy. }
        Inc(argn);
        if (argn >= argc) then          { advance to next argument }
          usage;
        if (keymatch(ParamStr(argn), 'none', 1)) then
          copyoption := JCOPYOPT_NONE
        else
          if (keymatch(ParamStr(argn), 'comments', 1)) then
            copyoption := JCOPYOPT_COMMENTS
          else
            if (keymatch(ParamStr(argn), 'all', 1)) then
              copyoption := JCOPYOPT_ALL
            else
              usage;
      end
      else
        if keymatch(arg, '-debug', 2) or keymatch(arg, '-verbose', 2) then
        begin
        { Enable debug printouts. }
        { On first -d, print version identification }

        if (not printed_version) then
        begin
          WriteLn('PASJPEG Group''s JPEGTRAN translation version ',
                  JVERSION, JCOPYRIGHT, JNOTICE);
          printed_version := TRUE;
        end;
        Inc(cinfo^.err^.trace_level);
      end
      else
  {$ifdef CROP_SUPPORTED}
        if keymatch(arg, '-cut', 2) then
        begin
        { Cut out a region of the image specified by an X geometry-like string }
        p : PChar;

          Inc(argn);
          if (argn >= argc) then
            usage;
          select_transform(JXFORM_CUT);

          arg := ParamStr(argn);
                  px := Pos('x', arg);
                  if ( px = 'x') then
                    usage;
                  arg_w := Copy(arg, 1, px-1);
                  Val(arg_w, lval, code);
                  if (code <> 0) then
                    usage;

          transformoption.newwidth := lval;
                  arg_w := Copy(arg, px+1, Length(arg));
                  Val(arg_w, lval, code);
                  if (code <> 0) then
                    usage;

          transformoption.newheight := lval;
          if (p^ <> '+') and (p^ <> '-') then
            usage;
                  arg_w := Copy(arg, px+1, Length(arg));
                  Val(arg_w, lval, code);
                  if (code <> 0) then
                    usage;

          transformoption.xoffs := lval;
                  arg_w := Copy(arg, px+1, Length(arg));
                  Val(arg_w, lval, code);
                  if (code <> 0) then
                    usage;

          if (p^ <> '+') and (p^ <> '-') then
            usage;
          transformoption.yoffs := lval;

          if (transformoption.newwidth=0) or (transformoption.newheight=0) then
          begin
            WriteLn(progname,': degenerate -cut size in ', argv[argn]);
            exit(EXIT_FAILURE);
          end
        end
        else
  {$endif}
          if keymatch(arg, '-flip', 2) then
          begin { Mirror left-right or top-bottom. }
            Inc(argn);
            if (argn >= argc) then        { advance to next argument }
              usage;
            if keymatch(ParamStr(argn), 'horizontal', 2) then
              select_transform(JXFORM_FLIP_H)
            else
              if keymatch(ParamStr(argn), 'vertical', 2) then
                select_transform(JXFORM_FLIP_V)
              else
                usage;
          end
          else
            if keymatch(arg, '-grayscale', 2) or
               keymatch(arg, '-greyscale',2) then
            begin  { Force to grayscale. }
  {$ifdef TRANSFORMS_SUPPORTED}
              transformoption.force_grayscale := TRUE;
  {$else}
              select_transform(JXFORM_NONE);    { force an error }
  {$endif}
            end
            else
              if keymatch(arg, '-maxmemory', 4) then
              begin
              { Maximum memory in Kb (or Mb with 'm'). }
                ch := 'x';

                Inc(argn);
                if (argn >= argc) then  { advance to next argument }
                  usage;

                arg := ParamStr(argn);
                if (length(arg) > 1) and (arg[length(arg)] in ['m','M']) then
                begin
                  ch := arg[length(arg)];
                  arg := Copy(arg, 1, Length(arg)-1);
                end;
                Val(arg, lval, code);
                if (code <> 0) then
                  usage;
                if (ch = 'm') or (ch = 'M') then
                  lval := lval * long(1000);
                cinfo^.mem^.max_memory_to_use := lval * long(1000);
              end
              else
                if keymatch(arg, '-optimize', 2) or
                   keymatch(arg, '-optimise', 2) then
                begin
                  { Enable entropy parm optimization. }
      {$ifdef ENTROPY_OPT_SUPPORTED}
                  cinfo^.optimize_coding := TRUE;
      {$else}
                  WriteLn(output, progname,
                    ': sorry, entropy optimization was not compiled');
                  Stop(EXIT_FAILURE);
      {$endif}

                end
                else
                  if keymatch(arg, '-outfile', 5) then
                  begin
                    { Set output file name. }
                    Inc(argn);
                    if (argn >= argc) then      { advance to next argument }
                      usage;
                    outfilename := ParamStr(argn);      { save it away for later use }
                  end
                  else
                    if keymatch(arg, '-progressive', 2) then
                    begin
                      { Select simple progressive mode. }
  {$ifdef C_PROGRESSIVE_SUPPORTED}
                      simple_progressive := TRUE;
                      { We must postpone execution until num_components is known. }
  {$else}
                      WriteLn(output, progname,
                        ': sorry, progressive output was not compiled');
                      Stop(EXIT_FAILURE);
  {$endif}
                    end
                    else
                      if keymatch(arg, '-restart', 2) then
                      begin
                        ch := 'x';
                        { Restart interval in MCU rows (or in MCUs with 'b'). }
                        Inc(argn);
                        if (argn >= argc) then { advance to next argument }
                          usage;
                        arg := ParamStr(argn);
                        if (length(arg) > 1) and (arg[length(arg)] in ['b','B']) then
                        begin
                          ch := arg[length(arg)];
                          arg := Copy(arg, 1, Length(arg)-1);
                        end;

                        Val(arg, lval, code);
                        if (code <> 1) or (lval < 0) or (lval > Long(65535)) then
                          usage;

                        if (ch = 'b') or (ch = 'B') then
                        begin
                          cinfo^.restart_interval := uint(lval);
                          cinfo^.restart_in_rows := 0; { else prior '-restart n' overrides me }
                        end
                        else
                        begin
                          cinfo^.restart_in_rows := int(lval);
                          { restart_interval will be computed during startup }
                        end;

                      end
                      else
                        if keymatch(arg, '-rotate', 3) then
                        begin { Rotate 90, 180, or 270 degrees (measured clockwise). }
                          Inc(argn);
                          if (argn >= argc)     then { advance to next argument }
                            usage;
                          if (keymatch(ParamStr(argn), '90', 2)) then
                            select_transform(JXFORM_ROT_90)
                          else
                            if keymatch(ParamStr(argn), '180', 3) then
                              select_transform(JXFORM_ROT_180)
                            else
                              if keymatch(ParamStr(argn), '270', 3) then
                                select_transform(JXFORM_ROT_270)
                              else
                                usage;
                         end
                         else
                         if keymatch(arg, '-scans', 2) then
                         begin
                           { Set scan script. }
         {$ifdef C_MULTISCAN_FILES_SUPPORTED}
                           Inc(argn);
                           if (argn >= argc) then       { advance to next argument }
                             usage;
                           scansarg := ParamStr(argn);
                           { We must postpone reading the file in case -progressive appears. }
         {$else}
                           WriteLn(output, progname,
                             ': sorry, multi-scan output was not compiled');
                           Stop(EXIT_FAILURE);
         {$endif}
                         end
                         else
                           if keymatch(arg, '-transpose', 2) then
                             { Transpose (across UL-to-LR axis). }
                             select_transform(JXFORM_TRANSPOSE)
                           else
                             if keymatch(arg, '-transverse', 7) then
                               { Transverse transpose (across UR-to-LL axis). }
                               select_transform(JXFORM_TRANSVERSE)
                             else
                               if keymatch(arg, '-trim', 4) then
                                 { Trim off any partial edge MCUs that
                                   the transform can't handle. }
                                 transformoption.trim := TRUE
                               else
                                 usage;                { bogus switch }
  end;

  { Post-switch-scanning cleanup }

  if (for_real) then
  begin

{$ifdef C_PROGRESSIVE_SUPPORTED}
    if (simple_progressive) then { process -progressive; -scans can override }
      jpeg_simple_progression(cinfo);
{$endif}

{$ifdef C_MULTISCAN_FILES_SUPPORTED}
    if (scansarg <> '') then       { process -scans if it was present }
    begin
      WriteLn('Scripts are not supported in PasJPEG.');
      {if not read_scan_script(cinfo, scansarg) then
        usage;
      }
    end;
{$endif}
  end;

  parse_switches  := argn;      { return index of next arg (file name) }
end;


{ The main program. }

{main (int argc, char **argv)}
var
  srcinfo : jpeg_decompress_struct;
  dstinfo : jpeg_compress_struct;
  jsrcerr, jdsterr : jpeg_error_mgr;
{$ifdef PROGRESS_REPORT}
  progress : cdjpeg_progress_mgr;
{$endif}
  src_coef_arrays,
  dst_coef_arrays : jvirt_barray_tbl_ptr;
  file_index : int;
  input_file : FILE;
  output_file : FILE;
begin
  { On Mac, fetch a command line. }
{$ifdef USE_CCOMMAND}
  argc := ccommand(@argv);
{$endif}

  progname 