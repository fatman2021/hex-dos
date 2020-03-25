{*******************************************************}
{                                                       }
{       Delphi Runtime Library                          }
{       JPEG Image Compression/Decompression Unit       }
{                                                       }
{       Copyright (c) 1997 Borland International        }
{       Copyright (c) 1998 Jacques Nomssi Nzali         }
{                                                       }
{*******************************************************}

unit jpeg;

interface

{$I jconfig.inc}

{$ifndef Delphi_Stream}
  Define "Delphi_Stream" in jconfig.inc - deliberate syntax error.
{$endif}

uses Windows, SysUtils, Classes, Graphics;

type
  TJPEGData = class(TSharedImage)
  private
    FData: TCustomMemoryStream;
    FHeight: Integer;
    FWidth: Integer;
    FGrayscale: Boolean;
  protected
    procedure FreeHandle; override;
  public
    destructor Destroy; override;
  end;

  TJPEGQualityRange = 1..100;   { 100 = best quality, 25 = pretty awful }
  TJPEGPerformance = (jpBestQuality, jpBestSpeed);
  TJPEGScale = (jsFullSize, jsHalf, jsQuarter, jsEighth);
  TJPEGPixelFormat = (jf24Bit, jf8Bit);

  TJPEGImage = class(TGraphic)
  private
    FImage: TJPEGData;
    FBitmap: TBitmap;
    FScaledWidth: Integer;
    FScaledHeight: Integer;
    FTempPal: HPalette;
    FSmoothing: Boolean;
    FGrayScale: Boolean;
    FPixelFormat: TJPEGPixelFormat;
    FQuality: TJPEGQualityRange;
    FProgressiveDisplay: Boolean;
    FProgressiveEncoding: Boolean;
    FPerformance: TJPEGPerformance;
    FScale: TJPEGScale;
    FNeedRecalc: Boolean;
    procedure CalcOutputDimensions;
    function GetBitmap: TBitmap;
    function GetGrayscale: Boolean;
    procedure SetGrayscale(Value: Boolean);
    procedure SetPerformance(Value: TJPEGPerformance);
    procedure SetPixelFormat(Value: TJPEGPixelFormat);
    procedure SetScale(Value: TJPEGScale);
    procedure SetSmoothing(Value: Boolean);
  protected
    procedure AssignTo(Dest: TPersistent); override;
    procedure Changed(Sender: TObject); override;
    procedure Draw(ACanvas: TCanvas; const Rect: TRect); override;
    function Equals(Graphic: TGraphic): Boolean; override;
    procedure FreeBitmap;
    function GetEmpty: Boolean; override;
    function GetHeight: Integer; override;
    function GetPalette: HPALETTE; override;
    function GetWidth: Integer; override;
    procedure NewBitmap;
    procedure NewImage;
    procedure ReadData(Stream: TStream); override;
    procedure ReadStream(Size: Longint; Stream: TStream);
    procedure SetHeight(Value: Integer); override;
    procedure SetPalette(Value: HPalette); override;
    procedure SetWidth(Value: Integer); override;
    procedure WriteData(Stream: TStream); override;
    property Bitmap: TBitmap read GetBitmap;  { volatile }
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Compress;
    procedure DIBNeeded;
    procedure JPEGNeeded;
    procedure Assign(Source: TPersistent); override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    procedure LoadFromClipboardFormat(AFormat: Word; AData: THandle;
      APalette: HPALETTE); override;
    procedure SaveToClipboardFormat(var AFormat: Word; var AData: THandle;
      var APalette: HPALETTE); override;

    { Options affecting / reflecting compression and decompression behavior }
    property Grayscale: Boolean read GetGrayscale write SetGrayscale;
    property ProgressiveEncoding: Boolean read FProgressiveEncoding write FProgressiveEncoding;

    { Compression options }
    property CompressionQuality: TJPEGQualityRange read FQuality write FQuality;

    { Decompression options }
    property PixelFormat: TJPEGPixelFormat read FPixelFormat write SetPixelFormat;
    property ProgressiveDisplay: Boolean read FProgressiveDisplay write FProgressiveDisplay;
    property Performance: TJPEGPerformance read FPerformance write SetPerformance;
    property Scale: TJPEGScale read FScale write SetScale;
    property Smoothing: Boolean read FSmoothing write SetSmoothing;
  end;

  TJPEGDefaults = record
    CompressionQuality: TJPEGQualityRange;
    Grayscale: Boolean;
    Performance: TJPEGPerformance;
    PixelFormat: TJPEGPixelFormat;
    ProgressiveDisplay: Boolean;
    ProgressiveEncoding: Boolean;
    Scale: TJPEGScale;
    Smoothing: Boolean;
  end;

var   { Default settings for all new TJPEGImage instances }
  JPEGDefaults: TJPEGDefaults = (
    CompressionQuality: 90;
    Grayscale: False;
    Performance: jpBestQuality;
    PixelFormat: jf24Bit;         { initialized to match video mode }
    ProgressiveDisplay: False;
    ProgressiveEncoding: False;
    Scale: jsFullSize;
    Smoothing: True;
  );

implementation

uses jconsts,
  jmorecfg, jerror, jpeglib, jcomapi, jdmaster, jdapistd,
  jdatadst, jcparam, jcapimin, jcapistd, jdapimin, jdatasrc;


{ The following types and external function declarations are used to
  call into functions of the Independent JPEG Group's (IJG) implementation
  of the JPEG image compression/decompression public standard.  The IJG
  library's C source code is compiled into OBJ files and linked into
  the Delphi application. Only types and functions needed by this unit
  are declared; all IJG internal structures are stubbed out with
  generic pointers to reduce internal source code congestion.

  IJG source code copyright (C) 1991-1996, Thomas G. Lane. }


{ Error handler }


{ Progress monitor object }
type
  new_progress_mgr_ptr = ^new_progress_mgr;
  new_progress_mgr = record
    pub : jpeg_progress_mgr;
    { extra Delphi info }
    instance: TJPEGImage;       { ptr to current TJPEGImage object }
    last_pass: Integer;
    last_pct: Integer;
    last_time: Integer;
    last_scanline: Integer;
  end;

  TJPEGContext = record
    err: jpeg_error_mgr;
    progress: new_progress_mgr;
    FinalDCT: J_DCT_METHOD;
    FinalTwoPassQuant: Boolean;
    FinalDitherMode: J_DITHER_MODE;
    case byte of
      0: (common: jpeg_common_struct);
      1: (d: jpeg_decompress_struct);
      2: (c: jpeg_compress_struct);
  end;


type
  EJPEG = class(EInvalidGraphic);

procedure InvalidOperation(const Msg: string); near;
begin
  raise EInvalidGraphicOperation.Create(Msg);
end;

procedure JpegError(cinfo: j_common_ptr);
begin
  raise EJPEG.CreateFmt(sJPEGError,[cinfo^.err^.msg_code]);
end;

procedure EmitMessage(cinfo: j_common_ptr; msg_level: Integer); far;
begin
  { -- !! }
end;

procedure OutputMessage(cinfo: j_common_ptr); far;
begin
  { -- !! }
end;

procedure FormatMessage(cinfo: j_common_ptr; var buffer: string); far;
begin
  { -- !! }
end;

procedure ResetErrorMgr(cinfo: j_common_ptr);
begin
  cinfo^.err^.num_warnings := 0;
  cinfo^.err^.msg_code := 0;
end;


const
  jpeg_std_error: jpeg_error_mgr = (
    error_exit: JpegError;
    emit_message: EmitMessage;
    output_message: OutputMessage;
    format_message: FormatMessage;
    reset_error_mgr: ResetErrorMgr);


{ TJPEGData }

destructor TJPEGData.Destroy;
begin
  FData.Free;
  inherited Destroy;
end;

procedure TJPEGData.FreeHandle;
begin
end;

{ TJPEGImage }

constructor TJPEGImage.Create;
begin
  inherited Create;
  NewImage;
  FQuality := JPEGDefaults.CompressionQuality;
  FGrayscale := JPEGDefaults.Grayscale;
  FPerformance := JPEGDefaults.Performance;
  FPixelFormat := JPEGDefaults.PixelFormat;
  FProgressiveDisplay := JPEGDefaults.ProgressiveDisplay;
  FProgressiveEncoding := JPEGDefaults.ProgressiveEncoding;
  FScale := JPEGDefaults.Scale;
  FSmoothing := JPEGDefaults.Smoothing;
end;

destructor TJPEGImage.Destroy;
begin
  if FTempPal <> 0 then DeleteObject(FTempPal);
  FBitmap.Free;
  FImage.Release;
  inherited Destroy;
end;

procedure TJPEGImage.Assign(Source: TPersistent);
begin
  if Source is TJPEGImage then
  begin
    FImage.Release;
    FImage := TJPEGImage(Source).FImage;
    FImage.Reference;
    if TJPEGImage(Source).FBitmap <> nil then
    begin
      NewBitmap;
      FBitmap.Assign(TJPEGImage(Source).FBitmap);
    end;
  end
  else if Source is TBitmap then
  begin
    NewImage;
    NewBitmap;
    FBitmap.Assign(Source);
  end
  else
    inherited Assign(Source);
end;

procedure TJPEGImage.AssignTo(Dest: TPersistent);
begin
  if Dest is TBitmap then
    Dest.Assign(Bitmap)
  else
    inherited AssignTo(Dest);
end;

procedure ProgressCallback(const cinfo: jpeg_common_struct);
var
  Ticks: Integer;
  R: TRect;
  temp: Integer;
  progress : new_progress_mgr_ptr;
begin
  progress := new_progress_mgr_ptr(cinfo.progress);
  if (progress = nil) or (progress.instance = nil) then Exit;
  with progress^,pub do
  begin
    Ticks := GetTickCount;
    if (Ticks - last_time) < 500 then Exit;
    temp := last_time;
    last_time := Ticks;
    if temp = 0 then Exit;
    if cinfo.is_decompressor then
      with j_decompress_ptr(@cinfo)^ do
      begin
        R := Rect(0, last_scanline, output_width, output_scanline);
        if R.Bottom < last_scanline then
          R.Bottom := output_height;
      end
    else
      R := Rect(0,0,0,0);
    temp := Trunc(100.0*(completed_passes + (pass_counter/pass_limit))/total_passes);
    if temp = last_pct then Exit;
    last_pct := temp;
    if cinfo.is_decompressor then
      last_scanline := j_decompress_ptr(@cinfo)^.output_scanline;
    instance.Progress(instance, psRunning, temp, (R.Bottom - R.Top) >= 4, R, '');
  end;
end;

procedure ReleaseContext(var jc: TJPEGContext);
begin
  if jc.common.err = nil then Exit;
  jpeg_destroy(@jc.common);
  jc.common.err := nil;
end;

procedure InitDecompressor(Obj: TJPEGImage; var jc: TJPEGContext);
begin
  FillChar(jc, sizeof(jc), 0);
  jc.err := jpeg_std_error;
  jc.common.err := @jc.err;

  jpeg_CreateDecompress(@jc.d, JPEG_LIB_VERSION, sizeof(jc.d));
  with Obj do
  try
    jc.progress.pub.progress_monitor := @ProgressCallback;
    jc.progress.instance := Obj;
    jc.common.progress := @jc.progress;

    Obj.FImage.FData.Position := 0;
    jpeg_stdio_src(@jc.d, @FImage.FData);
    jpeg_read_header(@jc.d, TRUE);

    jc.d.scale_num := 1;
    jc.d.scale_denom := 1 shl Byte(FScale);
    jc.d.do_block_smoothing := FSmoothing;

    if FGrayscale then jc.d.out_color_space := JCS_GRAYSCALE;
    if (PixelFormat = jf8Bit) or (jc.d.out_color_space = JCS_GRAYSCALE) then
    begin
      jc.d.quantize_colors := True;
      jc.d.desired_number_of_colors := 236;
    end;

    if FPerformance = jpBestSpeed then
    begin
      jc.d.dct_method := JDCT_IFAST;
      jc.d.two_pass_quantize := False;
      { jc.d.do_fancy_upsampling := False;    !! AV inside jpeglib   }
      jc.d.dither_mode := JDITHER_ORDERED;
    end;

    jc.FinalDCT := jc.d.dct_method;
    jc.FinalTwoPassQuant := jc.d.two_pass_quantize;
    jc.FinalDitherMode := jc.d.dither_mode;
    if FProgressiveDisplay and jpeg_has_multiple_scans(@jc.d) then
    begin  { save requested settings, reset for fastest on all but last scan }
      jc.d.enable_2pass_quant := jc.d.two_pass_quantize;
      jc.d.dct_method := JDCT_IFAST;
      jc.d.two_pass_quantize := False;
      jc.d.dither_mode := JDITHER_ORDERED;
      jc.d.buffered_image := True;
    end;
  except
    ReleaseContext(jc);
    raise;
  end;
end;

procedure TJPEGImage.CalcOutputDimensions;
var
  jc: TJPEGContext;
begin
  if not FNeedRecalc then Exit;
  InitDecompressor(Self, jc);
  try
    jc.common.progress := nil;
    jpeg_calc_output_dimensions(@jc.d);
    { read output dimensions }
    FScaledWidth := jc.d.output_width;
    FScaledHeight := jc.d.output_height;
    FProgressiveEncoding := jpeg_has_multiple_scans(@jc.d);
  finally
    ReleaseContext(jc);
  end;
end;

procedure TJPEGImage.Changed(Sender: TObject);
begin
  inherited Changed(Sender);
end;

procedure TJPEGImage.Compress;
var
  LinesWritten, LinesPerCall: Integer;
  SrcScanLine: Pointer;
  PtrInc: Integer;
  jc: TJPEGContext;
  Src: TBitmap;
begin
  FillChar(jc, sizeof(jc), 0);
  jc.err := jpeg_std_error;
  jc.common.err := @jc.err;

  jpeg_CreateCompress(@jc.c, JPEG_LIB_VERSION, sizeof(jc.c));
  try
    try
      jc.progress.pub.progress_monitor := @ProgressCallback;
      jc.progress.instance := Self;
      jc.common.progress := @jc.progress;

      if FImage.FData <> nil then NewImage;
      FImage.FData := TMemoryStream.Create;
      FImage.FData.Position := 0;
      jpeg_stdio_dest(@jc.c, @FImage.FData);

      if (FBitmap = nil) or (FBitmap.Width = 0) or (FBitmap.Height = 0) then Exit;
      jc.c.image_width := FBitmap.Width;
      FImage.FWidth := FBitmap.Width;
      jc.c.image_height := FBitmap.Height;
      FImage.FHeight := FBitmap.Height;
      jc.c.input_components := 3;           { JPEG requires 24bit RGB input }
      jc.c.in_color_space := JCS_RGB;

      Src := TBitmap.Create;
      try
        Src.Assign(FBitmap);
        Src.PixelFormat := pf24bit;

        jpeg_set_defaults(@jc.c);
        jpeg_set_quality(@jc.c, FQuality, True);

        if FGrayscale then
        begin
          FImage.FGrayscale := True;
          jpeg_set_colorspace(@jc.c, JCS_GRAYSCALE);
        end;

        if ProgressiveEncoding then
          jpeg_simple_progression(@jc.c);

        SrcScanline := Src.ScanLine[0];
        PtrInc := Integer(Src.ScanLine[1]) - Integer(SrcScanline);

          { if no dword padding required and source bitmap is top-down }
        if (PtrInc > 0) and ((PtrInc and 3) = 0) then
          LinesPerCall := jc.c.image_height  { do whole bitmap in one call }
        else
          LinesPerCall := 1;      { otherwise spoonfeed one row at a time }

        Progress(Self, psStarting, 0, False, Rect(0,0,0,0), '');
        try
          jpeg_start_compress(@jc.c, True);

          while (jc.c.next_scanline < jc.c.image_height) do
          begin
            LinesWritten := jpeg_write_scanlines(@jc.c, @SrcScanline, LinesPerCall);
            Inc(Integer(SrcScanline), PtrInc * LinesWritten);
          end;

          jpeg_finish_compress(@jc.c);
        finally
          if ExceptObject = nil then
            PtrInc := 100
          else
            PtrInc := 0;
          Progress(Self, psEnding, PtrInc, False, Rect(0,0,0,0), '');
        end;
      finally
        Src.Free;
      end;
    except
      on EAbort do    { OnProgress can raise EAbort to cancel image save }
        NewImage;     { Throw away any partial jpg data }
    end;
  finally
    ReleaseContext(jc);
  end;
end;

procedure TJPEGImage.DIBNeeded;
begin
  GetBitmap;
end;

procedure TJPEGImage.Draw(ACanvas: TCanvas; const Rect: TRect);
begin
  ACanvas.StretchDraw(Rect, Bitmap);
end;

function TJPEGImage.Equals(Graphic: TGraphic): Boolean;
begin
  Result := (Graphic is TJPEGImage) and
    (FImage = TJPEGImage(Graphic).FImage); { ---!! }
end;

procedure TJPEGImage.FreeBitmap;
begin
  FBitmap.Free;
  FBitmap := nil;
end;

function BuildPalette(const cinfo: jpeg_decompress_struct): HPalette;
var
  Pal: TMaxLogPalette;
  I: Integer;
  C: Byte;
begin
  Pal.palVersion := $300;
  Pal.palNumEntries := cinfo.actual_number_of_colors;
  if cinfo.out_color_space = JCS_GRAYSCALE then
    for I := 0 to Pal.palNumEntries-1 do
    begin
      C := cinfo.colormap^[0]^[I];
      Pal.palPalEntry[I].peRed := C;
      Pal.palPalEntry[I].peGreen := C;
      Pal.palPalEntry[I].peBlue := C;
      Pal.palPalEntry[I].peFlags := 0;
    end
  else
    for I := 0 to Pal.palNumEntries-1 do
    begin
      Pal.palPalEntry[I].peRed := cinfo.colormap^[2]^[I];
      Pal.palPalEntry[I].peGreen := cinfo.colormap^[1]^[I];
      Pal.palPalEntry[I].peBlue := cinfo.colormap^[0]^[I];
      Pal.palPalEntry[I].peFlags := 0;
    end;
  Result := CreatePalette(PLogPalette(@Pal)^);
end;

procedure BuildColorMap(var cinfo: jpeg_decompress_struct; P: HPalette);
var
  Pal: TMaxLogPalette;
  Count, I: Integer;
begin
  Count := GetPaletteEntries(P, 0, 256, Pal.palPalEntry);
  if Count = 0 then Exit;       { jpeg_destroy will free colormap }
  cinfo.colormap := cinfo.mem.alloc_sarray(j_common_ptr(@cinfo), JPOOL_IMAGE, Count, 3);
  cinfo.actual_number_of_colors := Count;
  for I := 0 to Count-1 do
  begin
    Byte(cinfo.colormap^[2]^[I]) := Pal.palPalEntry[I].peRed;
    Byte(cinfo.colormap^[1]^[I]) := Pal.palPalEntry[I].peGreen;
    Byte(cinfo.colormap^[0]^[I]) := Pal.palPalEntry[I].peBlue;
  end;
end;

function TJPEGImage.GetBitmap: TBitmap;
var
  LinesPerCall, LinesRead: Integer;
  DestScanLine: Pointer;
  PtrInc: Integer;
  jc: TJPEGContext;
  GeneratePalette: Boolean;
begin
  Result := FBitmap;
  if Result <> nil then Exit;
  if (FBitmap = nil) then FBitmap := TBitmap.Create;
  Result := FBitmap;
  GeneratePalette := True;

  InitDecompressor(Self, jc);
  try
    try
      { Set the bitmap pixel format }
      FBitmap.Handle := 0;
      if (PixelFormat = jf8Bit) or (jc.d.out_color_space = JCS_GRAYSCALE) then
        FBitmap.PixelFormat := pf8bit
      else
        FBitmap.PixelFormat := pf24bit;

      Progress(Self, psStarting, 0, False, Rect(0,0,0,0), '');
      try
        if (FTempPal <> 0) then
        begin
          if (FPixelFormat = jf8Bit) then
          begin                        { Generate DIB using assigned palette }
            BuildColorMap(jc.d, FTempPal);
            FBitmap.Palette := CopyPalette(FTempPal);  { Keep FTempPal around }
            GeneratePalette := False;
          end
          else
          begin
            DeleteObject(FTempPal);
            FTempPal := 0;
          end;
        end;

        jpeg_start_decompress(@jc.d);

        { Set bitmap width and height }
        with FBitmap do
        begin
          Handle := 0;
          Width := jc.d.output_width;
          Height := jc.d.output_height;
          DestScanline := ScanLine[0];
          PtrInc := Integer(ScanLine[1]) - Integer(DestScanline);
          if (PtrInc > 0) and ((PtrInc and 3) = 0) then
             { if no dword padding is required and output bitmap is top-down }
            LinesPerCall := jc.d.rec_outbuf_height { read multiple rows per call }
          else
            LinesPerCall := 1;            { otherwise read one row at a time }
        end;

        if jc.d.buffered_image then
        begin  { decode progressive scans at low quality, high speed }
          while jpeg_consume_input(@jc.d) <> JPEG_REACHED_EOI do
          begin
            jpeg_start_output(@jc.d, jc.d.input_scan_number);
            { extract color palette }
            if (jc.common.progress^.completed_passes = 0) and (jc.d.colormap <> nil)
              and (FBitmap.PixelFormat = pf8bit) and GeneratePalette then
            begin
              FBitmap.Palette := BuildPalette(jc.d);
              PaletteModified := True;
            end;
            DestScanLine := FBitmap.ScanLine[0];
            while (jc.d.output_scanline < jc.d.output_height) do
            begin
              LinesRead := jpeg_read_scanlines(@jc.d, @DestScanline, LinesPerCall);
              Inc(Integer(DestScanline), PtrInc * LinesRead);
            end;
            jpeg_finish_output(@jc.d);
          end;
          { reset options for final pass at requested quality }
          jc.d.dct_method := jc.FinalDCT;
          jc.d.dither_mode := jc.FinalDitherMode;
          if jc.FinalTwoPassQuant then
          begin
            jc.d.two_pass_quantize := True;
            jc.d.colormap := nil;
          end;
          jpeg_start_output(@jc.d, jc.d.input_scan_number);
          DestScanLine := FBitmap.ScanLine[0];
        end;

        { build final color palette }
        if (not jc.d.buffered_image or jc.FinalTwoPassQuant) and
          (jc.d.colormap <> nil) and GeneratePalette then
        begin
          FBitmap.Palette := BuildPalette(jc.d);
          PaletteModified := True;
          DestScanLine := FBitmap.ScanLine[0];
        end;
        { final image pass for progressive, first and only pass for baseline }
        while (jc.d.output_scanline < jc.d.output_height) do
        begin
          LinesRead := jpeg_read_scanlines(@jc.d, @DestScanline, LinesPerCall);
          Inc(Integer(DestScanline), PtrInc * LinesRead);
        end;

        if jc.d.buffered_image then jpeg_finish_output(@jc.d);
        jpeg_finish_decompress(@jc.d);
      finally
        if ExceptObject = nil then
          PtrInc := 100
        else
          PtrInc := 0;
        Progress(Self, psEnding, PtrInc, PaletteModified, Rect(0,0,0,0), '');
        { Make sure new palette gets realized, in case OnProgress event didn't. }
        if PaletteModified then
          Changed(Self);
      end;
    except
      on EAbort do ;   { OnProgress can raise EAbort to cancel image load }
    end;
  finally
    ReleaseContext(jc);
  end;
end;

function TJPEGImage.GetEmpty: Boolean;
begin
  Result := (FImage.FData = nil) and FBitmap.Empty;
end;

function TJPEGImage.GetGrayscale: Boolean;
begin
  Result := FGrayscale or FImage.FGrayscale;
end;

function TJPEGImage.GetPalette: HPalette;
var
  DC: HDC;
begin
  Result := 0;
  if FBitmap <> nil then
    Result := FBitmap.Palette
  else if FTempPal <> 0 then
    Result := FTempPal
  else if FPixelFormat = jf24Bit then   { check for 8 bit screen }
  begin
    DC := GetDC(0);
    if (GetDeviceCaps(DC, BITSPIXEL) * GetDeviceCaps(DC, PLANES)) <= 8 then
    begin
      if FTempPal <> 0 then DeleteObject(FTempPal);  { Memory leak -- fix }
      FTempPal := CreateHalftonePalette(DC);
      Result := FTempPal;
    end;
    ReleaseDC(0, DC);
  end;
end;

function TJPEGImage.GetHeight: Integer;
begin
  if FBitmap <> nil then
    Result := FBitmap.Height
  else if FScale = jsFullSize then
    Result := FImage.FHeight
  else
  begin
    CalcOutputDimensions;
    Result := FScaledHeight;
  end;
end;

function TJPEGImage.GetWidth: Integer;
begin
  if FBitmap <> nil then
    Result := FBitmap.Width
  else if FScale = jsFullSize then
    Result := FImage.FWidth
  else
  begin
    CalcOutputDimensions;
    Result := FScaledWidth;
  end;
end;

procedure TJPEGImage.JPEGNeeded;
begin
  if FImage.FData = nil then
    Compress;
end;

procedure TJPEGImage.LoadFromClipboardFormat(AFormat: Word; AData: THandle;
  APalette: HPALETTE);
begin
  { --!! check for jpeg clipboard data, mime type image/jpeg }
  FBitmap.LoadFromClipboardFormat(AFormat, AData, APalette);
end;

procedure TJPEGImage.LoadFromStream(Stream: TStream);
begin
  ReadStream(Stream.Size - Stream.Position, Stream);
end;

procedure TJPEGImage.NewBitmap;
begin
  FBitmap.Free;
  FBitmap := TBitmap.Create;
end;

procedure TJPEGImage.NewImage;
begin
  if FImage <> nil then FImage.Release;
  FImage := TJPEGData.Create;
  FImage.Reference;
end;

procedure TJPEGImage.ReadData(Stream: TStream);
var
  Size: Longint;
begin
  Stream.Read(Size, SizeOf(Size));
  ReadStream(Size, Stream);
end;

procedure TJPEGImage.ReadStream(Size: Longint; Stream: TStream);
var
  jerr: jpeg_error_mgr;
  cinfo: jpeg_decompress_struct;
begin
  NewImage;
  with FImage do
  begin
    FData := TMemoryStream.Create;
    FData.Size := Size;
    Stream.ReadBuffer(FData.Memory^, Size);
    if Size > 0 then
    begin
      jerr := jpeg_std_error;  { use local var for thread isolation }
      cinfo.err := @jerr;
      jpeg_CreateDecompress(@cinfo, JPEG_LIB_VERSION, sizeof(cinfo));
      try
        FData.Position := 0;
        jpeg_stdio_src(@cinfo, @FData);
        jpeg_read_header(@cinfo, TRUE);
        FWidth := cinfo.image_width;
        FHeight := cinfo.image_height;
        FGrayscale := cinfo.jpeg_color_space = JCS_GRAYSCALE;
        FProgressiveEncoding := jpeg_has_multiple_scans(@cinfo);
      finally
        jpeg_destroy_decompress(@cinfo);
      end;
    end;
  end;
  PaletteModified := True;
  Changed(Self);
end;

procedure TJPEGImage.SaveToClipboardFormat(var AFormat: Word; var AData: THandle;
  var APalette: HPALETTE);
begin
{ --!!  check for jpeg clipboard format, mime type image/jpeg }
  Bitmap.SaveToClipboardFormat(AFormat, AData, APalette);
end;

procedure TJPEGImage.SaveToStream(Stream: TStream);
begin
  JPEGNeeded;
  with FImage.FData do
    Stream.Write(Memory^, Size);
end;

procedure TJPEGImage.SetGrayscale(Value: Boolean);
begin
  if FGrayscale <> Value then
  begin
    FreeBitmap;
    FGrayscale := Value;
    PaletteModified := True;
    Changed(Self);
  end;
end;

procedure TJPEGImage.SetHeight(Value: Integer);
begin
  InvalidOperation(SChangeJPGSize);
end;

procedure TJPEGImage.SetPalette(Value: HPalette);
var
  SignalChange: Boolean;
begin
  if Value <> FTempPal then
  begin
    SignalChange := (FBitmap <> nil) and (Value <> FBitmap.Palette);
    if SignalChange then FreeBitmap;
    FTempPal := Value;
    if SignalChange then
    begin
      PaletteModified := True;
      Changed(Self);
    end;
  end;
end;

procedure TJPEGImage.SetPerformance(Value: TJPEGPerformance);
begin
  if FPerformance <> Value then
  begin
    FreeBitmap;
    FPerformance := Value;
    PaletteModified := True;
    Changed(Self);
  end;
end;

procedure TJPEGImage.SetPixelFormat(Value: TJPEGPixelFormat);
begin
  if FPixelFormat <> Value then
  begin
    FreeBitmap;
    FPixelFormat := Value;
    PaletteModified := True;
    Changed(Self);
  end;
end;

procedure TJPEGImage.SetScale(Value: TJPEGScale);
begin
  if FScale <> Value then
  begin
    FreeBitmap;
    FScale := Value;
    FNeedRecalc := True;
    Changed(Self);
  end;
end;

procedure TJPEGImage.SetSmoothing(Value: Boolean);
begin
  if FSmoothing <> Value then
  begin
    FreeBitmap;
    FSmoothing := Value;
    Changed(Self);
  end;
end;

procedure TJPEGImage.SetWidth(Value: Integer);
begin
  InvalidOperation(SChangeJPGSize);
end;

procedure TJPEGImage.WriteData(Stream: TStream);
var
  Size: Longint;
begin
  Size := 0;
  if Assigned(FImage.FData) then Size := FImage.FData.Size;
  Stream.Write(Size, Sizeof(Size));
  if Size > 0 then Stream.Write(FImage.FData.Memory^, Size);
end;

procedure InitDefaults;
var
  DC: HDC;
begin
  DC := GetDC(0);
  if (GetDeviceCaps(DC, BITSPIXEL) * GetDeviceCaps(DC, PLANES)) <= 8 then
    JPEGDefaults.PixelFormat := jf8Bit
  else
    JPEGDefaults.PixelFormat := jf24Bit;
  ReleaseDC(0, DC);
end;

initialization
  InitDefaults;
  TPicture.RegisterFileFormat('jpg', 'JPEG Image File', TJPEGImage);
  TPicture.RegisterFileFormat('jpeg', 'JPEG Image File', TJPEGImage);
finalization
  TPicture.UnregisterGraphicClass(TJPEGImage);
end.Ë*@æ6∏_áµU†t	U A+H‹IN„≈èFƒGì|üc6πõ⁄©∑¿'™çü}k\9Â±ù¶D„∆k.kˆÈü˝¯éâ9≥ÿ¿!çùˆÌphø`—†IÃ|ò\œd˛ƒÏ≤á|Ã2µkd¯9&åmèE`!Kö6jc•µ±≠ÃJf…z‰’*æD¢•Â’íÛ¿ı|{Õa°ÅD0ctKhõÀ}ÙÌ±êÚ3f/«√_◊›≥õÀ_ö[ãdâó‚KØq1’Q»MµÉ
<5°çl¨å–!œp{çy(»’ÛÙÅz2Pü§?´œ”+ÙüÙ%⁄«{Iı∫H◊´”è–ìŸ˙Ω∫:˝ÀLÓΩΩ:B◊˜ƒÄA›Vƒb[…Ñ<{t£âD4¥eöŒﬂjH£ÕA?¯∂5v™5gcån¢P∂wåCK‰(¶Ñ+â1ù-H˝öªÆc§åuÊÎë"yY9Ω3A‚AºÏñ0æyãdwºÃ¢ìç&‚–Ë·°∂ı{ò˜%|Á¿È\PÜoMêY<Ëb∞Àî”Ó»x$Záﬁrß1"Úà?„+Êåê;r›âè\Õ…°¨ÏÂ¯VT[KWÇG˘Õ¯F˘ôıò!π‘¡√
j3ôè°`I>√ZÚ:œy\T¿îª>«”ÜÙôèpÓÆËŒt∆¨ë›w•êôX"É>2ñˇ÷5Djsˆ‰˚πÔ 6CßÌ˛Ω¨‹<«fJwpUÙ∫Âµof[∑≤Ó^-nµb_	¥“ êH3EcZπ√∆üù⁄j˛g…8~~+sD„‹íVÑæ,pc}+u‘x>ﬂû/¸√u‚ïV8	Õ9u§Ì≥’˚∑≠<6yÌC+çYT¡œoªπ⁄≠æMú˜s]}îR}•ç∆_üª ’Í◊íõ˙!·ª-<nŒÌv[¢57TΩ˘(õ≠^±´w‘ÙÍÓqózõ2˘Á=Î›˝j>•OüÙí}è9›˝`ÜŸ,⁄F‡"K–}ﬁ=l[·è>QÓÌqnÂa=ëÔÿÿ‡Ì‰¯´˚)ÊC3≠F^ˆH8W6MéÂ.…‹¡À!`@≥Ü»öÈl√Ôq´wöE~U≈9*9`¸ú˘k÷PpkK]e∏ÇU?=_DNàw €Dµè‚c®®HFˆie¬◊Ωbr9ñúC>!…9˙F“4Í≈dòë)&I19=„ü£QÿMû"ΩlÑ›7çn∏>_ÇGÅtpÑ∫≥(¨bOuûN·?‡q–˙.∫ípC4°’! nêàA<Ò»É!,Hj”C«˝îUJ‡O˝}:¯\ï=æêzeπ±DAaõ∫ÿB‹l‹ ã%Vûê≠•/ê/X≠]≠%WjNkOkÔkY∫Ô4øk‚t$KÁ‘Œ“ïR/8Íu√udä.W∑TW™´◊÷]“}Ø#_ÈpÍ	?ˇÇ±^˜£˛8Nû÷qµ=√{|1H0$F‹ﬂ∏±îAÖÊÛVBÎ<--jrÊr±MÅ»KXm∂	aÍ∫ô–Wü>Ã≥’™˝pµjQ(†…úãŸX-ìT);∞¢í‰úËÊº\õE¶˙I{4$7∑bu≤£>¶B˝1fIr<]°6∑»øZcu:jdî3»¢Œ4ê^â’ÓPDŒ≤∏√ë5uvbX	⁄äb(VíLC,†|J∆0d1Ö(È(tá|!$ã(Ä‡IHö0A‚É8Ö‚PƒM:Wxe!R>	]¥4¶ñ‹„ﬂCÆ‡ÌGŒn&œ
/´H]’Gµ‚N€+ª+aÇ√çè¨Õ¨¶ìFÕ~<⁄a	≈(∆@áô#á$˘G@I≤´;ŸX√á—˝w¨‘CRõTuÜA–Z˙~∞–o‰~Ÿ{~Ir≥ÄÚM¸…Ïì0vë·q∞1yxæ¬›„ 8∫Tï˜–◊ªîU=#rœÚh¢v/}ëˇuB‹ÆÊÂH¸3æ¨€c∆ÔV%¨+™“Ï‘úHÍπ:œ∆∂l/™¢ﬁ©˛i{Q≤ôµaè˜ÒgóN/vD|3ΩÑÅÓ"=O<]˙6ÒΩÁMè≤IÙ{˙ÁóCmm¨¬ìcA≠á0P…ÿÓ‹d`œKóyp÷«Ø•Ê⁄±˙e.±˝—"íY9156‚N¬àµèL®à=Q¸=£”´¯6|í<8¸∆Ñc6K\çÂó$s1´bsê±1≥5ÃÈí+‚pQ.»ï0?ÏÄsR1»áwKñ◊5øè=˚£w˛ïø95÷Ín~µ‹ ˜gg¯#K|Ã2dÜ!√P?+c÷0Ò4°É∏idﬂ5≥⁄ißk+âÜ’‘è÷ëJ˝j[≥ön•èÕµ[Äós®5å£’ÖÚ[X0∫√JΩ†lúà—ãnﬂ‘>YÜﬁ˜1x≥˚<ìæ?p&˛◊fkÛ1$+|≤3º&xÌ ﬂ∆Øp¸Tƒ[H4ÿÔˆ;›qô⁄öø.¡œ0)wTD#hT+ãî¨ 
ãÉäiAƒ‡a/„{¶Á¡ó±„ﬂÃqT~h›” €”JÇ”ãÉW„|Æyœ2ÓŒ˙‰I«G¬)àä«/5+∆J3)zÓ∫¿(.O¨3Ïå3ÿﬁ.œN*4/Iˆ∫ Õ¯Àe‘nœfà4Áó‚ﬂ*™s©]⁄\hHÚ 'É¿YπW¿ïfÒ⁄0‹µms≠∂¨µ‰è#ï»M¨‚¯p
±˝€ê·Pq'¶Ú„π_¿s¯·Ú	¬#Æ÷”q.€21C¯|yƒ*±dC\»ÅN˘'%;Tÿïµ®FÅ;P˘z1$–]£wØPπì$üƒ¯Ó8·ªì0‘±8*øî‰Âøè ÅÉröÉ0IFÇƒ®ö∑∞U{§‘$LÕ¡MÁå*YÛq·Iaéí\˜6‚≈0{,/€FÊ∑ñïõfÊsÁˆ"2ò_DÚ˜¡‘1»⁄#È‡ÔÓ8É_˜∂©Q≈á…¶cp=mÃØﬁB5#„9ùA-Áˆà±œ4wºˆòpØÚ«¯Ò'a˛Iù®o_#˛]Ó3‰%?_ïI}Kòûô(Ã++ßÊˆsPæØ±*9˜ˇ÷n:©››‡1]u"au4é¬k◊ﬂÒú—µÙ#çöÓoù˚b¸ÓIÇ∫®F”®·¶Gx‰=É˘ªvùrù_ÍÙ$ÓCı˜aÀß∂W¸u∫;cπk∑‡ª‚gâ?{ﬁˆ([›,ê[◊_˝—Ûªº6:%±D1â[’∑ó5ñõbÖ˜™Nÿƒè˜r«9|L-d∆Ÿ≤πLf≤-√∆ª2UöÍé[OµLÂ[®Pbï‡|d{íoeòÛ+ÆÜOñ†+¬¢ß"kºâKgÇkÍ¶F~)´Àìµà{M˘”%L~U∂Í¯•±©–£-»S©|xîœv Y<ãxsNÿD~Ì7ìFﬂ¡ﬂÓ6±Ñôπ!C®>òÛhÿrbóõà¿]hâ8õÿJÃsJ¶t%TX2;PÇò¬íHâ’ï@´H)ïåïpá°„œ∆Kˇ«ß÷ÅM%%¶òÑµR∏—LOSòHKV`Âå?\ëâã2iäBÒhe
V'1rNYKdhQä.a™≠–ä
Z¸$±l>öƒrÎÔ¡∂˝]8X"‰ë◊¨æ	 `>däg‚◊JxËˆAáPÃ
C,ƒR£tÃQú¢É—Œ¬‚ ÉÖ)P)éëí£≈æàTñM ®~ú/W§A_AK%Q‚Ig°ZåÏä *D:#;0W“¡˜êΩí3»„¸Ê·qÀf	2WÂô∆lic¨Ñw_ˆ\¬îù”©xJ47wsäé\t¥˙tsÒ,å}$—’ΩOI~RKöØ÷€≥Xñª˘≈"∆sZÄÍZ≈	eı>îBØﬁB« Õ(~q
dÁπ$ún∆ÑÙwq¶ïëê–vˆs¸ô∫çπ7¯”–œ ≥Ñ⁄yP5õO+·Àœ#füG~Ÿ∂ãNGºO=˜`úÁîÜ™˘πÎªâm.a‹%⁄˜sTww˜<ôbΩÁíE|ﬁTÓy·ÅÛ‡©∆êR{Ü~w3·iëÉ6@{'&}ùÁ˝<≠ˇu∫£z4ŸWæúÆ„…Cv?Ú∏)èg_@∂áB˛P˚Ãà«ÔyÜy=	;ê7"ºÁÜ8$#ÂÀE3§Ë~Ø>Wœ≤´ÇFõ´åÅ’«èÓÅ
*—$oñ∑Â!*æÏûQvFl∂ÿ∂í±ÃñÛï--ΩÌë≈Èı⁄‰!®≥eœc2ùƒ%∂Â´‚√):+Æ≥Ç¿Ê{oS@Z;KπﬁkxÂaéVåâx5[>æ>Ÿ)©8ì+ñYx{-QCP˜∏%@Òì4–._˙Lº’C‰¶˚∑™¯≈Rú˘FM?‰üêw„∂)í}r€¨zmq™µ,·ÛÓﬁ€Ñı|‰±cJ
0{ñ’HèÑºl6ßéÀ¶‚S§ S(vg@˝ÕÄ\(n¸7ªw.˛á›ß∫˛è≤{*§b¿(bZ8°¯Ωù¯¢ré⁄	∆Çl∞¨5`≈∏¨[‡¯M Ï'x¬õ^d#ßæü‡U˝ﬂO´^Jû#^&Çö~êwõcBx_![ËG<œ1∫˛ÄG!¸Jä·≥(Üü ﬁ"R√∑C¡2GˇÛç‘¥áS_V<C>¬¥ôÏRπâ·üCT∏)[ÜPøÙ7IÕ5Ë'ìo¬=®BﬁÇ∑ ˇ≠íÇxâ0¢˛2õóâSM/«í$d<¯ÄGS0Ì´â:·◊`~û¶†UUE´“ÉÜıdØ	‚(à_BÖÙ√“◊Y$îÓπ¡J∂‡Ÿè`Ä‚6Ä§ÇıˆQo]¿:P¨Õw o)xûki˘≈ìó\qg%¡√wÈ§Ò—÷Ä¥ﬁ§åSA>(ıÄ<ÆÄ6–®)D?´®ÙW≈`MÉfì~éÊ'M©∆†Q∂ëLå1ÀÃ√Q{Ks'R'¸fÄ„Kô‰∏Æe2ÕÏΩÌ°≥ZïB^§dS áL3ë|8ßçì’∆µ2˚Œ0K6"k@à∆H?ó◊H.Çã†Ê®∞aàÿ…«∂ïï3ñy%|Öo>Á”’)oS4'˜@=Ü‚CE∆∫nª≈¸Ør„êlq¯Í¡Ô”üÄT{ia`)»k¶òæ9 Ñ» <<Qè©y‹√‡ÂlThæﬁ‘ËI}úæÛ=œ•ßö≠™|ı8ZW~Å^æ9“÷∫ΩLVŒ∆HÃX∑Ò‹©[‡›6uX‘IvV∑3Ü9	…õ:˘∞ñ÷·„\ÄDdÅ,pÈ=s†»ø `Dπ¨˘n8¿∂ƒ§πfÛçÕ˛i~+kzfŒ.Âˆƒt*Â{k÷ˆ√x°Ëº!¨øuw¨îÒƒ|#Ú∂DÓ {%xôÿˇépq|ÛVI<H⁄]1jt∫m}À-fõd*≈˝%†íøµz¥ñã;0Ÿ Cw@Ìµ;Íûú»∆VÊÃsú∑G?¥ìÇ˝Ò!ø0¢@<>røˇÇ1T6y4ù{ê*ÕR€D
ıái<ª7vWˆëS∫Ë^’˝°˚uﬂôÓ”:èn“£;¥«£˚C…_}%nQ∑™{†ªlû…Çﬂ\i„¿G⁄⁄Ø[É<o&ÇU‡—PØ∑ÂîúXb›F÷¯i€¢ÿºÒœËàáù:ˇ˛&∫ÔßÊçÛ∆	‰çﬁ…È˚…°z”^|C<*<Rıí}üÈæHõ”∑∫J;\∏myD ˙tDÖ7¥ÇsK[†ﬁ>*•uˇîs<v*á-ƒå´õˆƒπÖÜ!Ä–Q6Ω¯	Ó∆zÁY´À≤8Ge__NÕÚ¸#ÎΩå_öåcï¯qwç^(öî;çT<‰oàxö[BzÅ√dßLH~GÆ$ˇ Jwë˜…è$ıøPÉï§s€Jí0_I±˙å9˙’˙˝n˝MÚ)Ib ˛œb‹åL∆ãô‘ø‡"ºh¯È&Ë^∂Ä ^∏>ó°Ïâf9’Í›«CÄ}È3
πÛáOAl|pµ±*µ÷	d»Ñ∂é_≠§û(∑∂5Å«ç≈Ø†R∑
∑'¿°ÃjÖ’xÀìtßÚòÜ”ı£÷BG¢]∫övç£÷_ÁØ€°#˝uä.E◊˙Æ˝]@ÎæÌ"ßÇÌ∫„∫k∫G∫˜∫nù•ûÍªãi◊t˚g\£êõ\kh«Q√C.’÷∂ﬁÚÀ l#1ıTŒgÀj»¢Løw9ﬁAH¨æÌ¬Î¶ÒúZ4ÇÇπ`n„]Aı˜ã¬¿—¿bh ª;⁄˚±;¶π¬F.Õ°∞˚9àÅ‰Ö‹ŒvL?vügñåNÆ·†ÖvS‘Rc¬ÓNä∂ÂåwõÙá7bıÔ„YJ|ÿ8;.E›‘î1@›(&ˇã∫)Ë˛˘oÍ6≈˜‰ø©€ﬂ+˛M›tü0Q˜i6#≠‰>πû/1ç9^	w-⁄ªö(¸nŒi>'¸Z∏q¿Ô¶Fùò¢Ô∏XŸ=
øè4˛l}§Ÿ-]ÊZ”€O‡G$–/r•¬£√í…¸&ä¿’X›©Fµâ¿≠‘yCô¸®π@P˝ 8Ä à‘ê˝I¯I·AÂØÒN>£úÂq®19.ﬂ√£Â8zUˆãF‚ÌUIπ}¯?ú†wÌñá˛í%°°Ÿ=Aôå„x®;cﬂ)÷&‘’jvkNß≈z*Û‡jlKCQ≠â¿ä>&õIÚ–„ø<,ò˛Kÿç&ÒΩ~gzΩ\ö˝G‚'œo< dÙ}GAk®≥çMxÚä¿Å5£≈Ï2v∫áó∑‡¡˝jñÙ‡lä/¢Ø,µ≠±BG≤lq∂ï¡ìSì"∆å¶A)øÕû$~Ã†0¸!ÈgGÜ„å©àŸlquU~âú‚bkÊl0[Y‘Nqx3O“"éMö®h{/<)„˙wdÎ∫÷uùÔ[–y˛Â7ë≈–8ƒKr¯gTÂË–
¶bÊ“OÜVôﬁˇê°ˇO!¬¢ÚTglVI∏Y‡ö‘!21!B˛ÑØ`h˘øÅêÍ0ÍˇË0§©√[ SÑ3†©TbÅc$gÃÀ®πAGbY≥˙…jﬁ'%qóH).lﬁ⁄¯Ü¬¬¶i±í32QÎdÂ
|$p≥âç,™O‘KäèÛ∑acc˛Ç/D®§ﬂÖÏ«ˇº
Ôæ›
∂"XÑ˚Ñ€îoœƒ£Ä∞≠V’*ùñKﬁGŒÛ'Âf	'	Mb@V‡‚9º@
˙€™¢s∑Òﬂë
˙ã›z@#ÌSÔµË˘2ˇªºÑEÀ4eö;?•ık¸„∫Èé ™M@NMqÚy±OÁ…ßü;&ûû« ØÓZïx*˝j‚uœkeIÇnÚ}Ô◊°üÈbæŒ®KA`æ**Êø·'+y∑∏ºQFZÚÁWa6√˚—∞Èú*¯`√˛Å¡‘Ÿ81ûzïÁ≈è