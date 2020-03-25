{
    This file is part of the Free Pascal run time library.
    Copyright (c) 2003 by the Free Pascal development team

    fpImage base definitions.

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
{$mode objfpc}{$h+}
unit FPimage;

interface

uses sysutils, classes;

type

  TFPCustomImageReader = class;
  TFPCustomImageWriter = class;
  TFPCustomImage = class;

  FPImageException = class (exception);

  TFPColor = record
    red,green,blue,alpha : word;
  end;
  PFPColor = ^TFPColor;

  TColorFormat = (cfMono,cfGray2,cfGray4,cfGray8,cfGray16,cfGray24,
                  cfGrayA8,cfGrayA16,cfGrayA32,
                  cfRGB15,cfRGB16,cfRGB24,cfRGB32,cfRGB48,
                  cfRGBA8,cfRGBA16,cfRGBA32,cfRGBA64,
                  cfBGR15,cfBGR16,cfBGR24,cfBGR32,cfBGR48,
                  cfABGR8,cfABGR16,cfABGR32,cfABGR64);
  TColorData = qword;
  PColorData = ^TColorData;

  TDeviceColor = record
    Fmt : TColorFormat;
    Data : TColorData;
  end;

{$ifdef CPU68K}
  { 1.0 m68k cpu compiler does not allow
    types larger than 32k....
    if we remove range checking all should be fine PM }
  TFPColorArray = array [0..0] of TFPColor;
{$R-}
{$else not CPU68K}
  TFPColorArray = array [0..(maxint-1) div sizeof(TFPColor)-1] of TFPColor;
{$endif CPU68K}
  PFPColorArray = ^TFPColorArray;

  TFPImgProgressStage = (psStarting, psRunning, psEnding);
  TFPImgProgressEvent = procedure (Sender: TObject; Stage: TFPImgProgressStage;
                                   PercentDone: Byte; RedrawNow: Boolean; const R: TRect;
                                   const Msg: AnsiString; var Continue : Boolean) of object;
  // Delphi compatibility
  TProgressStage = TFPImgProgressStage;
  TProgressEvent = TFPImgProgressEvent;

  TFPPalette = class
    protected
      FData : PFPColorArray;
      FCount, FCapacity : integer;
      procedure SetCount (Value:integer); virtual;
      function GetCount : integer;
      procedure SetColor (index:integer; const Value:TFPColor); virtual;
      function GetColor (index:integer) : TFPColor;
      procedure SetCapacity (ind : Integer);
      procedure CheckIndex (index:integer); virtual;
      procedure EnlargeData; virtual;
    public
      constructor Create (ACount : integer);
      destructor Destroy; override;
      procedure Build (Img : TFPCustomImage); virtual;
      procedure Copy (APalette: TFPPalette); virtual;
      procedure Merge (pal : TFPPalette); virtual;
      function IndexOf (const AColor: TFPColor) : integer; virtual;
      function Add (const Value: TFPColor) : integer; virtual;
      procedure Clear; virtual;
      property Color [Index : integer] : TFPColor read GetColor write SetColor; default;
      property Count : integer read GetCount write SetCount;
      property Capacity : integer read FCapacity write SetCapacity;
  end;

  TFPCustomImage = class(TPersistent)
    private
      FOnProgress : TFPImgProgressEvent;
      FExtra : TStringlist;
      FPalette : TFPPalette;
      FHeight, FWidth : integer;
      procedure SetHeight (Value : integer);
      procedure SetWidth (Value : integer);
      procedure SetExtra (const key:String; const AValue:string);
      function GetExtra (const key:String) : string;
      procedure SetExtraValue (index:integer; const AValue:string);
      function GetExtraValue (index:integer) : string;
      procedure SetExtraKey (index:integer; const AValue:string);
      function GetExtraKey (index:integer) : string;
      procedure CheckIndex (x,y:integer);
      procedure CheckPaletteIndex (PalIndex:integer);
      procedure SetColor (x,y:integer; const Value:TFPColor);
      function GetColor (x,y:integer) : TFPColor;
      procedure SetPixel (x,y:integer; Value:integer);
      function GetPixel (x,y:integer) : integer;
      function GetUsePalette : boolean;
    protected
      // Procedures to store the data. Implemented in descendants
      procedure SetInternalColor (x,y:integer; const Value:TFPColor); virtual;
      function GetInternalColor (x,y:integer) : TFPColor; virtual;
      procedure SetInternalPixel (x,y:integer; Value:integer); virtual; abstract;
      function GetInternalPixel (x,y:integer) : integer; virtual; abstract;
      procedure SetUsePalette (Value:boolean);virtual;
      procedure Progress(Sender: TObject; Stage: TProgressStage;
                         PercentDone: Byte;  RedrawNow: Boolean; const R: TRect;
                         const Msg: AnsiString; var Continue: Boolean); Virtual;
    public
      constructor create (AWidth,AHeight:integer); virtual;
      destructor destroy; override;
      procedure Assign(Source: TPersistent); override;
      // Saving and loading
      procedure LoadFromStream (Str:TStream; Handler:TFPCustomImageReader);
      procedure LoadFromStream (Str:TStream);
      procedure LoadFromFile (const filename:String; Handler:TFPCustomImageReader);
      procedure LoadFromFile (const filename:String);
      procedure SaveToStream (Str:TStream; Handler:TFPCustomImageWriter);
      procedure SaveToFile (const filename:String; Handler:TFPCustomImageWriter);
      procedure SaveToFile (const filename:String);
      // Size and data
      procedure SetSize (AWidth, AHeight : integer); virtual;
      property  Height : integer read FHeight write SetHeight;
      property  Width : integer read FWidth write SetWidth;
      property  Colors [x,y:integer] : TFPColor read GetColor write SetColor; default;
      // Use of palette for colors
      property  UsePalette : boolean read GetUsePalette write SetUsePalette;
      property  Palette : TFPPalette read FPalette;
      property  Pixels [x,y:integer] : integer read GetPixel write SetPixel;
      // Info unrelated with the image representation
      property  Extra [const key:string] : string read GetExtra write SetExtra;
      property  ExtraValue [index:integer] : string read GetExtraValue write SetExtraValue;
      property  ExtraKey [index:integer] : string read GetExtraKey write SetExtraKey;
      procedure RemoveExtra (const key:string);
      function  ExtraCount : integer;
      property OnProgress: TFPImgProgressEvent read FOnProgress write FOnProgress;
  end;
  TFPCustomImageClass = class of TFPCustomImage;

{$ifdef CPU68K}
  { 1.0 m68k cpu compiler does not allow
    types larger than 32k....
    if we remove range checking all should be fine PM }
  TFPIntegerArray = array [0..0] of integer;
{$R-}
{$else not CPU68K}
  TFPIntegerArray = array [0..(maxint-1) div sizeof(integer)-1] of integer;
{$endif CPU68K}
  PFPIntegerArray = ^TFPIntegerArray;

  TFPMemoryImage = class (TFPCustomImage)
    private
      function GetInternalColor(x,y:integer):TFPColor;override;
      procedure SetInternalColor (x,y:integer; const Value:TFPColor);override;
      procedure SetUsePalette (Value:boolean);override;
    protected
      FData : PFPIntegerArray;
      procedure SetInternalPixel (x,y:integer; Value:integer); override;
      function GetInternalPixel (x,y:integer) : integer; override;
    public
      constructor create (AWidth,AHeight:integer); override;
      destructor destroy; override;
      procedure SetSize (AWidth, AHeight : integer); override;
  end;

  TFPCustomImageHandler = class
    private
      FOnProgress : TFPImgProgressEvent;
      FStream : TStream;
      FImage : TFPCustomImage;
    protected
      procedure Progress(Stage: TProgressStage; PercentDone: Byte;  RedrawNow: Boolean; const R: TRect;
                         const Msg: AnsiString; var Continue: Boolean); Virtual;
      property TheStream : TStream read FStream;
      property TheImage : TFPCustomImage read FImage;
    public
      constructor Create; virtual;
      Property OnProgress : TFPImgProgressEvent Read FOnProgress Write FOnProgress;
  end;

  TFPCustomImageReader = class (TFPCustomImageHandler)
    private
      FDefImageClass:TFPCustomImageClass;
    protected
      procedure InternalRead  (Str:TStream; Img:TFPCustomImage); virtual; abstract;
      function  InternalCheck (Str:TStream) : boolean; virtual; abstract;
    public
      constructor Create; override;
      function ImageRead (Str:TStream; Img:TFPCustomImage) : TFPCustomImage;
      // reads image
      function CheckContents (Str:TStream) : boolean;
      // Gives True if contents is readable
      property DefaultImageClass : TFPCustomImageClass read FDefImageClass write FDefImageClass;
      // Image Class to create when no img is given for reading
  end;
  TFPCustomImageReaderClass = class of TFPCustomImageReader;

  TFPCustomImageWriter = class (TFPCustomImageHandler)
    protected
      procedure InternalWrite (Str:TStream; Img:TFPCustomImage); virtual; abstract;
    public
      procedure ImageWrite (Str:TStream; Img:TFPCustomImage);
      // writes given image to stream
  end;
  TFPCustomImageWriterClass = class of TFPCustomImageWriter;

  TIHData = class
    private
      FExtension, FTypeName, FDefaultExt : string;
      FReader : TFPCustomImageReaderClass;
      FWriter : TFPCustomImageWriterClass;
  end;

  TImageHandlersManager = class
    private
      FData : TList;
      function GetReader (const TypeName:string) : TFPCustomImageReaderClass;
      function GetWriter (const TypeName:string) : TFPCustomImageWriterClass;
      function GetExt (const TypeName:string) : string;
      function GetDefExt (const TypeName:string) : string;
      function GetTypeName (index:integer) : string;
      function GetData (const ATypeName:string) : TIHData;
      function GetData (index : integer) : TIHData;
      function GetCount : integer;
    public
      constructor Create;
      destructor Destroy; override;
      procedure RegisterImageHandlers (const ATypeName,TheExtensions:string;
                   AReader:TFPCustomImageReaderClass; AWriter:TFPCustomImageWriterClass);
      procedure RegisterImageReader (const ATypeName,TheExtensions:string;
                   AReader:TFPCustomImageReaderClass);
      procedure RegisterImageWriter (const ATypeName,TheExtensions:string;
                   AWriter:TFPCustomImageWriterClass);
      property Count : integer read GetCount;
      property ImageReader [const TypeName:string] : TFPCustomImageReaderClass read GetReader;
      property ImageWriter [const TypeName:string] : TFPCustomImageWriterClass read GetWriter;
      property Extensions [const TypeName:string] : string read GetExt;
      property DefaultExtension [const TypeName:string] : string read GetDefExt;
      property TypeNames [index:integer] : string read GetTypeName;
    end;

{function ShiftAndFill (initial:word; CorrectBits:byte):word;
function FillOtherBits (initial:word;CorrectBits:byte):word;
}
function CalculateGray (const From : TFPColor) : word;
(*
function ConvertColor (const From : TDeviceColor) : TFPColor;
function ConvertColor (const From : TColorData; FromFmt:TColorFormat) : TFPColor;
function ConvertColorToData (const From : TFPColor; Fmt : TColorFormat) : TColorData;
function ConvertColorToData (const From : TDeviceColor; Fmt : TColorFormat) : TColorData;
function ConvertColor (const From : TFPColor; Fmt : TColorFormat) : TDeviceColor;
function ConvertColor (const From : TDeviceColor; Fmt : TColorFormat) : TDeviceColor;
*)

function AlphaBlend(color1, color2: TFPColor): TFPColor;

function FPColor (r,g,b,a:word) : TFPColor;
function FPColor (r,g,b:word) : TFPColor;
{$ifdef debug}function MakeHex (n:TColordata;nr:byte): string;{$endif}

operator = (const c,d:TFPColor) : boolean;
operator or (const c,d:TFPColor) : TFPColor;
operator and (const c,d:TFPColor) : TFPColor;
operator xor (const c,d:TFPColor) : TFPColor;
function CompareColors(const Color1, Color2: TFPColor): integer;

var ImageHandlers : TImageHandlersManager;

type
  TErrorTextIndices = (
    StrInvalidIndex,
    StrNoImageToWrite,
    StrNoFile,
    StrNoStream,
    StrPalette,
    StrImageX,
    StrImageY,
    StrImageExtra,
    StrTypeAlreadyExist,
    StrTypeReaderAlreadyExist,
    StrTypeWriterAlreadyExist,
    StrCantDetermineType,
    StrNoCorrectReaderFound,
    StrReadWithError,
    StrWriteWithError,
    StrNoPaletteAvailable
    );

const
  // MG: ToDo: move to implementation and add a function to map to resourcestrings
  ErrorText : array[TErrorTextIndices] of string =
    ('Invalid %s index %d',
     'No image to write',
     'File "%s" does not exist',
     'No stream to write to',
     'palette',
     'horizontal pixel',
     'vertical pixel',
     'extra',
     'Image type "%s" already exists',
     'Image type "%s" already has a reader class',
     'Image type "%s" already has a writer class',
     'Error while determining image type of stream: %s',
     'Can''t determine image type of stream',
     'Error while reading stream: %s',
     'Error while writing stream: %s',
     'No palette available'
     );

{$i fpcolors.inc}

type
  TGrayConvMatrix = record
    red, green, blue : single;
  end;

var
  GrayConvMatrix : TGrayConvMatrix;

const
  GCM_NTSC : TGrayConvMatrix = (red:0.299; green:0.587; blue:0.114);
  GCM_JPEG : TGrayConvMatrix = (red:0.299; green:0.587; blue:0.114);
  GCM_Mathematical : TGrayConvMatrix = (red:0.334; green:0.333; blue:0.333);
  GCM_Photoshop : TGrayConvMatrix = (red:0.213; green:0.715; blue:0.072);

function CreateBlackAndWhitePalette : TFPPalette;
function CreateWebSafePalette : TFPPalette;
function CreateGrayScalePalette : TFPPalette;
function CreateVGAPalette : TFPPalette;

Type
  TFPCompactImgDesc = record
    Gray: boolean; // true = red=green=blue, false: a RGB image
    Depth: word; // 8 or 16 bit
    HasAlpha: boolean; // has alpha channel
  end;

  { TFPCompactImgBase }

  TFPCompactImgBase = class(TFPCustomImage)
  private
    FDesc: TFPCompactImgDesc;
  public
    property Desc: TFPCompactImgDesc read FDesc;
  end;
  TFPCompactImgBaseClass = class of TFPCompactImgBase;

  { TFPCompactImgGray16Bit }

  TFPCompactImgGray16Bit = class(TFPCompactImgBase)
  protected
    FData: PWord;
    function GetInternalColor(x, y: integer): TFPColor; override;
    function GetInternalPixel({%H-}x, {%H-}y: integer): integer; override;
    procedure SetInternalColor (x, y: integer; const Value: TFPColor); override;
    procedure SetInternalPixel({%H-}x, {%H-}y: integer; {%H-}Value: integer); override;
  public
    constructor Create(AWidth, AHeight: integer); override;
    destructor Destroy; override;
    procedure SetSize(AWidth, AHeight: integer); override;
  end;

  TFPCompactImgGrayAlpha16BitValue = packed record
    g,a: word;
  end;
  PFPCompactImgGrayAlpha16BitValue = ^TFPCompactImgGrayAlpha16BitValue;

  { TFPCompactImgGrayAlpha16Bit }

  TFPCompactImgGrayAlpha16Bit = class(TFPCompactImgBase)
  protected
    FData: PFPCompactImgGrayAlpha16BitValue;
    function GetInternalColor(x, y: integer): TFPColor; override;
    function GetInternalPixel({%H-}x, {%H-}y: integer): integer; override;
    procedure SetInternalColor (x, y: integer; const Value: TFPColor); override;
    procedure SetInternalPixel({%H-}x, {%H-}y: integer; {%H-}Value: integer); override;
  public
    constructor Create(AWidth, AHeight: integer); override;
    destructor Destroy; override;
    procedure SetSize(AWidth, AHeight: integer); override;
  end;

  { TFPCompactImgGray8Bit }

  TFPCompactImgGray8Bit = class(TFPCompactImgBase)
  protected
    FData: PByte;
    function GetInternalColor(x, y: integer): TFPColor; override;
    function GetInternalPixel({%H-}x, {%H-}y: integer): integer; override;
    procedure SetInternalColor (x, y: integer; const Value: TFPColor); override;
    procedure SetInternalPixel({%H-}x, {%H-}y: integer; {%H-}Value: integer); override;
  public
    constructor Create(AWidth, AHeight: integer); override;
    destructor Destroy; override;
    procedure SetSize(AWidth, AHeight: integer); override;
  end;

  TFPCompactImgGrayAlpha8BitValue = packed record
    g,a: byte;
  end;
  PFPCompactImgGrayAlpha8BitValue = ^TFPCompactImgGrayAlpha8BitValue;

  { TFPCompactImgGrayAlpha8Bit }

  TFPCompactImgGrayAlpha8Bit = class(TFPCompactImgBase)
  protected
    FData: PFPCompactImgGrayAlpha8BitValue;
    function GetInternalColor(x, y: integer): TFPColor; override;
    function GetInternalPixel({%H-}x, {%H-}y: integer): integer; override;
    procedure SetInternalColor (x, y: integer; const Value: TFPColor); override;
    procedure SetInternalPixel({%H-}x, {%H-}y: integer; {%H-}Value: integer); override;
  public
    constructor Create(AWidth, AHeight: integer); override;
    destructor Destroy; override;
    procedure SetSize(AWidth, AHeight: integer); override;
  end;

  TFPCompactImgRGBA8BitValue = packed record
    r,g,b,a: byte;
  end;
  PFPCompactImgRGBA8BitValue = ^TFPCompactImgRGBA8BitValue;

  { TFPCompactImgRGBA8Bit }

  TFPCompactImgRGBA8Bit = class(TFPCompactImgBase)
  protected
    FData: PFPCompactImgRGBA8BitValue;
    function GetInternalColor(x, y: integer): TFPColor; override;
    function GetInternalPixel({%H-}x, {%H-}y: integer): integer; override;
    procedure SetInternalColor (x, y: integer; const Value: TFPColor); override;
    procedure SetInternalPixel({%H-}x, {%H-}y: integer; {%H-}Value: integer); override;
  public
    constructor Create(AWidth, AHeight: integer); override;
    destructor Destroy; override;
    procedure SetSize(AWidth, AHeight: integer); override;
  end;

  TFPCompactImgRGB8BitValue = packed record
    r,g,b: byte;
  end;
  PFPCompactImgRGB8BitValue = ^TFPCompactImgRGB8BitValue;

  { TFPCompactImgRGB8Bit }

  TFPCompactImgRGB8Bit = class(TFPCompactImgBase)
  protected
    FData: PFPCompactImgRGB8BitValue;
    function GetInternalColor(x, y: integer): TFPColor; override;
    function GetInternalPixel({%H-}x, {%H-}y: integer): integer; override;
    procedure SetInternalColor (x, y: integer; const Value: TFPColor); override;
    procedure SetInternalPixel({%H-}x, {%H-}y: integer; {%H-}Value: integer); override;
  public
    constructor Create(AWidth, AHeight: integer); override;
    destructor Destroy; override;
    procedure SetSize(AWidth, AHeight: integer); override;
  end;

  TFPCompactImgRGB16BitValue = packed record
    r,g,b: word;
  end;
  PFPCompactImgRGB16BitValue = ^TFPCompactImgRGB16BitValue;

  { TFPCompactImgRGB16Bit }

  TFPCompactImgRGB16Bit = class(TFPCompactImgBase)
  protected
    FData: PFPCompactImgRGB16BitValue;
    function GetInternalColor(x, y: integer): TFPColor; override;
    function GetInternalPixel({%H-}x, {%H-}y: integer): integer; override;
    procedure SetInternalColor (x, y: integer; const Value: TFPColor); override;
    procedure SetInternalPixel({%H-}x, {%H-}y: integer; {%H-}Value: integer); override;
  public
    constructor Create(AWidth, AHeight: integer); override;
    destructor Destroy; override;
    procedure SetSize(AWidth, AHeight: integer); override;
  end;

  { TFPCompactImgRGBA16Bit }

  TFPCompactImgRGBA16Bit = class(TFPCompactImgBase)
  protected
    FData: PFPColor;
    function GetInternalColor(x, y: integer): TFPColor; override;
    function GetInternalPixel({%H-}x, {%H-}y: integer): integer; override;
    procedure SetInternalColor (x, y: integer; const Value: TFPColor); override;
    procedure SetInternalPixel({%H-}x, {%H-}y: integer; {%H-}Value: integer); override;
  public
    constructor Create(AWidth, AHeight: integer); override;
    destructor Destroy; override;
    procedure SetSize(AWidth, AHeight: integer); override;
  end;

{ Create a descriptor to select a CompactImg class }
function GetFPCompactImgDesc(Gray: boolean; Depth: word; HasAlpha: boolean): TFPCompactImgDesc;

{ Returns a CompactImg class that fits the descriptor }
function GetFPCompactImgClass(const Desc: TFPCompactImgDesc): TFPCompactImgBaseClass;

{ Create a CompactImg with the descriptor }
function CreateFPCompactImg(const Desc: TFPCompactImgDesc; Width, Height: integer): TFPCustomImage;

{ Create a CompactImg with the same features as Img.
If Img is a TFPCompactImgBaseClass it will create that.
Otherwise it returns a CompactImg that fits the Img using GetMinimumPTDesc. }
function CreateCompatibleFPCompactImg(Img: TFPCustomImage; Width, Height: integer
): TFPCustomImage;

{ As CreateCompatibleFPCompactImg, but the image has always an alpha channel. }
function CreateCompatibleFPCompactImgWithAlpha(Img: TFPCustomImage;
Width, Height: integer): TFPCustomImage;

{ Returns the smallest descriptor that allows to store the Img.
It returns HasAlpha=false if all pixel are opaque.
It returns Gray=true if all red=green=blue.
It returns Depth=8 if all lo byte equals the hi byte or all lo bytes are 0.
To ignore rounding errors you can pass a FuzzyDepth. For example a FuzzyDepth
of 3 ignores the lower 3 bits when comparing.  }
function GetMinimumPTDesc(Img: TFPCustomImage; FuzzyDepth: word = 4): TFPCompactImgDesc;

{ Create a smaller CompactImg with the same information as Img.
Pass FreeImg=true to call Img.Free }
function GetMinimumFPCompactImg(Img: TFPCustomImage; FreeImg: boolean;
FuzzyDepth: word = 4): TFPCustomImage;



implementation

procedure FPImgError (Fmt:TErrorTextIndices; data : array of const);
begin
  raise FPImageException.CreateFmt (ErrorText[Fmt],data);
end;

procedure FPImgError (Fmt:TErrorTextIndices);
begin
  raise FPImageException.Create (ErrorText[Fmt]);
end;

{$i FPImage.inc}

{ TImageHandlersManager }

constructor TImageHandlersManager.Create;
begin
  inherited create;
  FData := Tlist.Create;
end;

destructor TImageHandlersManager.Destroy;
var r : integer;
begin
  for r := FData.count-1 downto 0 do
    TIHData(FData[r]).Free;
  FData.Free;
  inherited Destroy;
end;

function CalcDefExt (TheExtensions:string) : string;
var p : integer;
begin
  p := pos (';',TheExtensions);
  if p = 0 then
    result := TheExtensions
  else
    result := copy(TheExtensions, 1, p-1);
end;

procedure TImageHandlersManager.RegisterImageHandlers (const ATypeName,TheExtensions:string;
                   AReader:TFPCustomImageReaderClass; AWriter:TFPCustomImageWriterClass);
var ih : TIHData;
begin
  ih := GetData (ATypeName);
  if assigned (ih) then
    FPImgError (StrTypeAlreadyExist,[ATypeName]);
  ih := TIHData.Create;
  with ih do
    begin
    FTypeName := ATypeName;
    FExtension := lowercase(TheExtensions);
    FDefaultExt := CalcDefExt (TheExtensions);
    FReader := AReader;
    FWriter := AWriter;
    end;
  FData.Add (ih);
end;

procedure TImageHandlersManager.RegisterImageReader (const ATypeName,TheExtensions:string;
                   AReader:TFPCustomImageReaderClass);
var ih : TIHData;
begin
  ih := GetData (ATypeName);
  if assigned (ih) then
    begin
      if assigned (ih.FReader) then
        FPImgError (StrTypeReaderAlreadyExist,[ATypeName])
      else
        ih.FReader := AReader;
    end
  else
    begin
    ih := TIHData.Create;
    with ih do
      begin
      FTypeName := ATypeName;
      FExtension := Lowercase(TheExtensions);
      FDefaultExt := CalcDefExt (TheExtensions);
      FReader := AReader;
      FWriter := nil;
      end;
    FData.Add (ih);
    end;
end;

procedure TImageHandlersManager.RegisterImageWriter (const ATypeName,TheExtensions:string;
                   AWriter:TFPCustomImageWriterClass);
var ih : TIHData;
begin
  ih := GetData (ATypeName);
  if assigned (ih) then
    begin
    if assigned (ih.FWriter) then
      FPImgError (StrTypeWriterAlreadyExist,[ATypeName])
    else
      ih.FWriter := AWriter;
    end
  else
    begin
    ih := TIHData.Create;
    with ih do
      begin
      FTypeName := ATypeName;
      FExtension := lowercase(TheExtensions);
      FDefaultExt := CalcDefExt (TheExtensions);
      FReader := nil;
      FWriter := AWriter;
      end;
    FData.Add (ih);
    end;
end;

function TImageHandlersManager.GetCount : integer;
begin
  result := FData.Count;
end;

function TImageHandlersManager.GetData (const ATypeName:string) : TIHData;
var r : integer;
begin
  r := FData.count;
  repeat
    dec (r);
  until (r < 0) or (compareText (TIHData(FData[r]).FTypeName, ATypeName) = 0);
  if r >= 0 then
    result := TIHData(FData[r])
  else
    result := nil;
end;

function TImageHandlersManager.GetData (index:integer) : TIHData;
begin
  if (index >= 0) and (index < FData.count) then
    result := TIHData (FData[index])
  else
    result := nil;
end;

function TImageHandlersManager.GetTypeName (index:integer) : string;
var ih : TIHData;
begin
  ih := TIHData (FData[index]);
  result := ih.FTypeName;
end;

function TImageHandlersManager.GetReader (const TypeName:string) : TFPCustomImageReaderClass;
var ih : TIHData;
begin
  ih := GetData (TypeName);
  if assigned(ih) then
    result := ih.FReader
  else
    result := nil;
end;

function TImageHandlersManager.GetWriter (const TypeName:string) : TFPCustomImageWriterClass;
var ih : TIHData;
begin
  ih := GetData (TypeName);
  if assigned(ih) then
    result := ih.FWriter
  else
    result := nil;
end;

function TImageHandlersManager.GetExt (const TypeName:string) : string;
var ih : TIHData;
begin
  ih := GetData (TypeName);
  if assigned(ih) then
    result := ih.FExtension
  else
    result := '';
end;

function TImageHandlersManager.GetDefExt (const TypeName:string) : string;
var ih : TIHData;
begin
  ih := GetData (TypeName);
  if assigned(ih) then
    result := ih.FDefaultExt
  else
    result := '';
end;

{ TFPCustomImageHandler }

constructor TFPCustomImageHandler.create;
begin
  inherited create;
end;

procedure TFPCustomImageHandler.Progress(Stage: TProgressStage;
                         PercentDone: Byte;  RedrawNow: Boolean; const R: TRect;
                         const Msg: AnsiString; var Continue: Boolean);

begin
  If Assigned(FOnProgress) then
    FOnProgress(Self,Stage,PercentDone,RedrawNow,R,Msg,Continue)
  else If Assigned(FImage) then
    // It is debatable whether we should pass ourselves or the image ?
    FImage.Progress(Self,Stage,PercentDone,RedrawNow,R,Msg,Continue);
end;

{ TFPCustomImageReader }

constructor TFPCustomImageReader.Create;
begin
  inherited create;
  FDefImageClass := TFPMemoryImage;
end;

function TFPCustomImageReader.ImageRead (Str:TStream; Img:TFPCustomImage) : TFPCustomImage;
begin
  try
    if not assigned(Str) then
      raise FPImageException.Create(ErrorText[StrNoStream]);
    FStream := Str;
    if not assigned(img) then
      result := FDefImageClass.Create(0,0)
    else
      result := Img;
    FImage := result;
    if FImage.UsePalette then
      FImage.Palette.Clear;
    if CheckContents (Str) then
      begin
      InternalRead (Str, result)
      end
    else
      raise FPImageException.Create ('Wrong image format');
  finally
    FStream := nil;
    FImage := nil;
  end;
end;

function TFPCustomImageReader.CheckContents (Str:TStream) : boolean;
var InRead : boolean;
begin
  InRead := assigned(FStream);
  if not assigned(Str) then
    raise FPImageException.Create(ErrorText[StrNoStream]);
  try
    FSTream := Str;
    result := InternalCheck (Str);
  finally
    if not InRead then
      FStream := nil;
  end;
end;

{ TFPCustomImageWriter }

procedure TFPCustomImageWriter.ImageWrite (Str:TStream; Img:TFPCustomImage);
begin
  if not assigned(img) then
    raise FPImageException.Create(ErrorText[StrNoImageToWrite]);
  if not assigned(Str) then
    raise FPImageException.Create(ErrorText[StrNoStream]);
  try
    FStream := str;
    FImage := img;
    Str.position := 0;
    Str.Size := 0;
    InternalWrite(Str, Img);
  finally
    FStream := nil;
    FImage := nil;
  end;
end;

{ TFPPalette }

constructor TFPPalette.create (ACount : integer);
begin
  inherited create;
  if aCount > 0 then
    getmem (FData, sizeof(TFPColor)*ACount)
  else
    FData := nil;
  FCapacity := ACount;
  SetCount (0);
end;

destructor TFPPalette.destroy;
begin
  if FCapacity > 0 then
    freemem (FData);
  inherited;
end;

procedure TFPPalette.Build (Img : TFPCustomImage);
var x,y : integer;
begin
  if (Img.Palette <> self) then
    begin
    Count := 0;
    for x := 0 to img.width-1 do
      for y := 0 to img.height-1 do
        IndexOf(img[x,y]);
    end;
end;

procedure TFPPalette.Copy(APalette: TFPPalette);
var
  x: integer;
begin
  if (APalette <> Self) then
  begin
    Self.Clear;
    for x := 0 to APalette.Count - 1 do
        Add(APalette.Color[x])
  end;
end;

procedure TFPPalette.Merge (pal : TFPPalette);
var r : integer;
begin
  for r := 0 to pal.count-1 do
    IndexOf (pal[r]);
end;

procedure TFPPalette.CheckIndex (index:integer);
begin
  if (index >= FCount) or (index < 0) then
    FPImgError (StrInvalidIndex,[ErrorText[StrPalette],index]);
end;

function TFPPalette.Add (const Value:TFPColor) : integer;
begin
  result := FCount;
  inc (FCount);
  if FCount > FCapacity then
    EnlargeData;
  FData^[result] := Value;
end;

procedure TFPPalette.SetColor (index:integer; const Value:TFPColor);
begin
  if index = FCount then
    Add (Value)
  else
    begin
    CheckIndex (index);
    FData^[index] := Value;
    end;
end;

function TFPPalette.GetColor (index:integer) : TFPColor;
begin
  CheckIndex (index);
  result := FData^[index];
end;

function TFPPalette.GetCount : integer;
begin
  result := FCount;
end;

procedure TFPPalette.EnlargeData;
var old : integer;
    NewData : PFPColorArray;
begin
  old := FCapacity;
  if FCapacity <= 16 then
    FCapacity := 32
  else if FCapacity <= 128 then
    FCapacity := 256
  else
    // MG: changed to exponential growth
    inc (FCapacity, FCapacity);
  GetMem (NewData, sizeof(TFPColor)*FCapacity);
  if old > 0 then
    begin
    move (FData^[0], NewData^[0], sizeof(TFPColor)*FCount);
    FreeMem (FData);
    end;
  FData := NewData;
end;

procedure TFPPalette.SetCount (Value:integer);
var
    O : integer;
begin
  if Value <> FCount then
    begin
    if Value > FCapacity then
      begin
        FCapacity := Value+8;
        Reallocmem(FData,sizeof(TFPColor)*FCapacity);
      end;
    for o := FCount to Value-1 do
      FData^[o] := colBlack;
    FCount := Value;
    end;
end;

procedure TFPPalette.SetCapacity (ind : Integer);
var o : Integer;
begin
  if ind<count then ind:=count;
  if ind<>fcapacity then
    begin
      fcapacity:=ind;
      Reallocmem(FData,sizeof(TFPColor)*FCapacity);
    end;
  if ind>count then
    begin
      for o := FCount to ind-1 do
        FData^[o] := colBlack;
    end;
end;

function TFPPalette.IndexOf (const AColor:TFPColor) : integer;
begin
  result := FCount;
  repeat
    dec (result);
  until (result < 0) or (FData^[result]=AColor);
  if result < 0 then
    result := Add (AColor);
end;

procedure TFPPalette.Clear;
begin
  SetCount (0);
end;


{ Functions to create standard palettes, by Giulio Bernardi 2005 }

{ A simple 1 bit black and white palette }
function CreateBlackAndWhitePalette : TFPPalette;
var fppal : TFPPalette;
    Col : TFPColor;
begin
  fppal:=TFPPalette.Create(2);
  Col.Alpha:=AlphaOpaque;
  Col.Red:=$FFFF; Col.Green:=$FFFF; Col.Blue:=$FFFF;
  fppal.Color[0]:=Col;
  Col.Red:=$0000; Col.Green:=$0000; Col.Blue:=$0000;
  fppal.Color[1]:=Col;
  Result:=fppal;
end;

{ The "standard" netscape 216-color palette (aka: web safe palette) }
function CreateWebSafePalette : TFPPalette;
var Col : TFPColor;
    i : integer;
    fppal : TFPPalette;
begin
  fppal:=TFPPalette.Create(216);
  Col.Alpha:=AlphaOpaque;
  i:=0;
  Col.Red:=$FFFF;
  while true do
  begin
    Col.Green:=$FFFF;
    while true do
    begin
      Col.Blue:=$FFFF;
      while true do
      begin
        fppal.Color[i]:=Col;
        if Col.Blue=0 then break;
        dec(Col.Blue,$3333);
      end;
      if Col.Green=0 then break;
      dec(Col.Green,$3333);
    end;
    if Col.Red=0 then break;
    dec(Col.Red,$3333);
  end;
  Result:=fppal;
end;

{ A grayscale palette. Not very useful. }
function CreateGrayScalePalette : TFPPalette;
var Col : TFPColor;
    i : integer;
    fppal : TFPPalette;
begin
  fppal:=TFPPalette.Create(256);
  Col.Alpha:=AlphaOpaque;
  for i:=0 to $FF do
  begin
    Col.Red:=i;
    Col.Red:=(Col.Red shl 8) + Col.Red;
    Col.Green:=Col.Red;
    Col.Blue:=Col.Red;
    fppal.Color[i]:=Col;
  end;
  Result:=fppal;
end;

{ Standard VGA 16 color palette. }
function CreateVGAPalette : TFPPalette;
var fppal : TFPPalette;
begin
  fppal:=TFPPalette.Create(16);
  fppal.Color[0]:=colBlack;
  fppal.Color[1]:=colNavy;
  fppal.Color[2]:=colBlue;
  fppal.Color[3]:=colMaroon;
  fppal.Color[4]:=colPurple;
  fppal.Color[5]:=colDkGreen;
  fppal.Color[6]:=colRed;
  fppal.Color[7]:=colTeal;
  fppal.Color[8]:=colFuchsia;
  fppal.Color[9]:=colOlive;
  fppal.Color[10]:=colGray;
  fppal.Color[11]:=colLime;
  fppal.Color[12]:=colAqua;
  fppal.Color[13]:=colSilver;
  fppal.Color[14]:=colYellow;
  fppal.Color[15]:=colWhite;
  Result:=fppal;
end;

{$I FPColCnv.inc}


function GetFPCompactImgDesc(Gray: boolean; Depth: word; HasAlpha: boolean
  ): TFPCompactImgDesc;
begin
  Result.Gray:=Gray;
  Result.Depth:=Depth;
  Result.HasAlpha:=HasAlpha;
end;

function GetFPCompactImgClass(const Desc: TFPCompactImgDesc): TFPCompactImgBaseClass;
begin
  if Desc.Gray then begin
    if Desc.HasAlpha then begin
      // gray, alpha
      if Desc.Depth<=8 then
        Result:=TFPCompactImgGrayAlpha8Bit
      else
        Result:=TFPCompactImgGrayAlpha16Bit;
    end else begin
      // gray, no alpha
      if Desc.Depth<=8 then
        Result:=TFPCompactImgGray8Bit
      else
        Result:=TFPCompactImgGray16Bit;
    end;
  end else begin
    // RGB
    if Desc.HasAlpha then begin
      // RGB, alpha
      if Desc.Depth<=8 then
        Result:=TFPCompactImgRGBA8Bit
      else
        Result:=TFPCompactImgRGBA16Bit;
    end else begin
      // RGB, no alpha
      if Desc.Depth<=8 then
        Result:=TFPCompactImgRGB8Bit
      else
        Result:=TFPCompactImgRGB16Bit;
    end;
  end;
end;

function CreateFPCompactImg(const Desc: TFPCompactImgDesc; Width, Height: integer
  ): TFPCustomImage;
var
  ImgClass: TFPCompactImgBaseClass;
begin
  ImgClass:=GetFPCompactImgClass(Desc);
  Result:=ImgClass.Create(Width,Height);
end;

function CreateCompatibleFPCompactImg(Img: TFPCustomImage; Width, Height: integer
  ): TFPCustomImage;
begin
  if Img is TFPCompactImgBase then
    Result:=CreateFPCompactImg(TFPCompactImgBase(Img).Desc,Width,Height)
  else
    Result:=CreateFPCompactImg(GetMinimumPTDesc(Img),Width,Height);
end;

function CreateCompatibleFPCompactImgWithAlpha(Img: TFPCustomImage; Width,
  Height: integer): TFPCustomImage;
var
  Desc: TFPCompactImgDesc;
begin
  if Img is TFPCompactImgBase then
    Desc:=TFPCompactImgBase(Img).Desc
  else
    Desc:=GetMinimumPTDesc(Img);
  Desc.HasAlpha:=true;
  Result:=CreateFPCompactImg(Desc,Width,Height);
end;

function GetMinimumPTDesc(Img: TFPCustomImage; FuzzyDepth: word = 4): TFPCompactImgDesc;
var
  AllLoEqualsHi, AllLoAre0: Boolean;
  FuzzyMaskLoHi: Word;

  procedure Need16Bit(c: word); inline;
  var
    l: Byte;
  begin
    c:=c and FuzzyMaskLoHi;
    l:=Lo(c);
    AllLoAre0:=AllLoAre0 and (l=0);
    AllLoEqualsHi:=AllLoEqualsHi and (l=Hi(c));
  end;

var
  TestGray: Boolean;
  TestAlpha: Boolean;
  Test16Bit: Boolean;
  BaseImg: TFPCompactImgBase;
  ImgDesc: TFPCompactImgDesc;
  y: Integer;
  x: Integer;
  col: TFPColor;
  FuzzyMaskWord: Word;
  FuzzyOpaque: Word;
begin
  TestGray:=true;
  TestAlpha:=true;
  Test16Bit:=FuzzyDepth<8;
  Result.HasAlpha:=false;
  Result.Gray:=true;
  Result.Depth:=8;
  if Img is TFPCompactImgBase then begin
    BaseImg:=TFPCompactImgBase(Img);
    ImgDesc:=BaseImg.Desc;
    if ImgDesc.Depth<=8 then Test16Bit:=false;
    if ImgDesc.Gray then TestGray:=false;
    if not ImgDesc.HasAlpha then TestAlpha:=false;
  end;

  if (not TestGray) and (not TestAlpha) and (not Test16Bit) then exit;

  FuzzyMaskWord:=Word($ffff) shl FuzzyDepth;
  FuzzyOpaque:=alphaOpaque and FuzzyMaskWord;
  FuzzyMaskLoHi:=Word(lo(FuzzyMaskWord))+(Word(lo(FuzzyMaskWord)) shl 8);
  AllLoAre0:=true;
  AllLoEqualsHi:=true;
  for y:=0 to Img.Height-1 do begin
    for x:=0 to Img.Width-1 do begin
      col:=Img.Colors[x,y];
      if TestAlpha and ((col.alpha and FuzzyMaskWord)<>FuzzyOpaque) then begin
        TestAlpha:=false;
        Result.HasAlpha:=true;
        if (not TestGray) and (not Test16Bit) then break;
      end;
      if TestGray
      and ((col.red and FuzzyMaskWord)<>(col.green and FuzzyMaskWord))
      or ((col.red and FuzzyMaskWord)<>(col.blue and FuzzyMaskWord)) then begin
        TestGray:=false;
        Result.Gray:=false;
        if (not TestAlpha) and (not Test16Bit) then break;
      end;
      if Test16Bit then begin
        Need16Bit(col.red);
        Need16Bit(col.green);
        Need16Bit(col.blue);
        Need16Bit(col.alpha);
        if (not AllLoAre0) and (not AllLoEqualsHi) then begin
          Test16Bit:=false;
          Result.Depth:=16;
          if (not TestAlpha) and (not TestGray) then break;
        end;
      end;
    end;
  end;
end;

function GetMinimumFPCompactImg(Img: TFPCustomImage; FreeImg: boolean;
  FuzzyDepth: word = 4): TFPCustomImage;
var
  Desc: TFPCompactImgDesc;
  ImgClass: TFPCompactImgBaseClass;
  y: Integer;
  x: Integer;
begin
  Desc:=GetMinimumPTDesc(Img,FuzzyDepth);
  ImgClass:=GetFPCompactImgClass(Desc);
  if Img.ClassType=ImgClass then
    exit(Img);
  Result:=CreateFPCompactImg(Desc,Img.Width,Img.Height);
  for y:=0 to Img.Height-1 do
    for x:=0 to Img.Width-1 do
      Result.Colors[x,y]:=Img.Colors[x,y];
  if FreeImg then
    Img.Free;
end;

function ColorRound (c : double) : word;
begin
  if c > $FFFF then
    result := $FFFF
  else if c < 0.0 then
    result := 0
  else
    result := round(c);
end;

{ TFPCompactImgGrayAlpha16Bit }

function TFPCompactImgGrayAlpha16Bit.GetInternalColor(x, y: integer): TFPColor;
var
  v: TFPCompactImgGrayAlpha16BitValue;
begin
  v:=FData[x+y*Width];
  Result.red:=v.g;
  Result.green:=Result.red;
  Result.blue:=Result.red;
  Result.alpha:=v.a;
end;

function TFPCompactImgGrayAlpha16Bit.GetInternalPixel(x, y: integer): integer;
begin
  Result:=0;
end;

procedure TFPCompactImgGrayAlpha16Bit.SetInternalColor(x, y: integer;
  const Value: TFPColor);
var
  v: TFPCompactImgGrayAlpha16BitValue;
begin
  v.g:=Value.red;
  v.a:=Value.alpha;
  FData[x+y*Width]:=v;
end;

procedure TFPCompactImgGrayAlpha16Bit.SetInternalPixel(x, y: integer; Value: integer
  );
begin

end;

constructor TFPCompactImgGrayAlpha16Bit.Create(AWidth, AHeight: integer);
begin
  FDesc:=GetFPCompactImgDesc(true,16,true);
  inherited Create(AWidth, AHeight);
end;

destructor TFPCompactImgGrayAlpha16Bit.Destroy;
begin
  ReAllocMem(FData,0);
  inherited Destroy;
end;

procedure TFPCompactImgGrayAlpha16Bit.SetSize(AWidth, AHeight: integer);
begin
  if (AWidth=Width) and (AHeight=Height) then exit;
  ReAllocMem(FData,SizeOf(TFPCompactImgGrayAlpha16BitValue)*AWidth*AHeight);
  inherited SetSize(AWidth, AHeight);
end;

{ TFPCompactImgGrayAlpha8Bit }

function TFPCompactImgGrayAlpha8Bit.GetInternalColor(x, y: integer): TFPColor;
var
  v: TFPCompactImgGrayAlpha8BitValue;
begin
  v:=FData[x+y*Width];
  Result.red:=(v.g shl 8)+v.g;
  Result.green:=Result.red;
  Result.blue:=Result.red;
  Result.alpha:=(v.a shl 8)+v.a;
end;

function TFPCompactImgGrayAlpha8Bit.GetInternalPixel(x, y: integer): integer;
begin
  Result:=0;
end;

procedure TFPCompactImgGrayAlpha8Bit.SetInternalColor(x, y: integer;
  const Value: TFPColor);
var
  v: TFPCompactImgGrayAlpha8BitValue;
begin
  v.g:=Value.red shr 8;
  v.a:=Value.alpha shr 8;
  FData[x+y*Width]:=v;
end;

procedure TFPCompactImgGrayAlpha8Bit.SetInternalPixel(x, y: integer; Value: integer
  );
begin

end;

constructor TFPCompactImgGrayAlpha8Bit.Create(AWidth, AHeight: integer);
begin
  FDesc:=GetFPCompactImgDesc(true,8,true);
  inherited Create(AWidth, AHeight);
end;

destructor TFPCompactImgGrayAlpha8Bit.Destroy;
begin
  ReAllocMem(FData,0);
  inherited Destroy;
end;

procedure TFPCompactImgGrayAlpha8Bit.SetSize(AWidth, AHeight: integer);
begin
  if (AWidth=Width) and (AHeight=Height) then exit;
  ReAllocMem(FData,SizeOf(TFPCompactImgGrayAlpha8BitValue)*AWidth*AHeight);
  inherited SetSize(AWidth, AHeight);
end;

{ TFPCompactImgGray16Bit }

function TFPCompactImgGray16Bit.GetInternalColor(x, y: integer): TFPColor;
begin
  Result.red:=FData[x+y*Width];
  Result.green:=Result.red;
  Result.blue:=Result.red;
  Result.alpha:=alphaOpaque;
end;

function TFPCompactImgGray16Bit.GetInternalPixel(x, y: integer): integer;
begin
  Result:=0;
end;

procedure TFPCompactImgGray16Bit.SetInternalColor(x, y: integer;
  const Value: TFPColor);
begin
  FData[x+y*Width]:=Value.red;
end;

procedure TFPCompactImgGray16Bit.SetInternalPixel(x, y: integer; Value: integer);
begin

end;

constructor TFPCompactImgGray16Bit.Create(AWidth, AHeight: integer);
begin
  FDesc:=GetFPCompactImgDesc(true,16,false);
  inherited Create(AWidth, AHeight);
end;

destructor TFPCompactImgGray16Bit.Destroy;
begin
  ReAllocMem(FData,0);
  inherited Destroy;
end;

procedure TFPCompactImgGray16Bit.SetSize(AWidth, AHeight: integer);
begin
  if (AWidth=Width) and (AHeight=Height) then exit;
  ReAllocMem(FData,SizeOf(Word)*AWidth*AHeight);
  inherited SetSize(AWidth,AHeight);
end;

{ TFPCompactImgGray8Bit }

function TFPCompactImgGray8Bit.GetInternalColor(x, y: integer): TFPColor;
begin
  Result.red:=FData[x+y*Width];
  Result.red:=(Word(Result.red) shl 8)+Result.red;
  Result.green:=Result.red;
  Result.blue:=Result.red;
  Result.alpha:=alphaOpaque;
end;

function TFPCompactImgGray8Bit.GetInternalPixel(x, y: integer): integer;
begin
  Result:=0;
end;

procedure TFPCompactImgGray8Bit.SetInternalColor(x, y: integer;
  const Value: TFPColor);
begin
  FData[x+y*Width]:=Value.red shr 8;
end;

procedure TFPCompactImgGray8Bit.SetInternalPixel(x, y: integer; Value: integer);
begin

end;

constructor TFPCompactImgGray8Bit.Create(AWidth, AHeight: integer);
begin
  FDesc:=GetFPCompactImgDesc(true,8,false);
  inherited Create(AWidth, AHeight);
end;

destructor TFPCompactImgGray8Bit.Destroy;
begin
  ReAllocMem(FData,0);
  inherited Destroy;
end;

procedure TFPCompactImgGray8Bit.SetSize(AWidth, AHeight: integer);
begin
  if (AWidth=Width) and (AHeight=Height) then exit;
  ReAllocMem(FData,SizeOf(Byte)*AWidth*AHeight);
  inherited SetSize(AWidth,AHeight);
end;

{ TFPCompactImgRGBA8Bit }

function TFPCompactImgRGBA8Bit.GetInternalColor(x, y: integer): TFPColor;
var
  v: TFPCompactImgRGBA8BitValue;
begin
  v:=FData[x+y*Width];
  Result.red:=(v.r shl 8)+v.r;
  Result.green:=(v.g shl 8)+v.g;
  Result.blue:=(v.b shl 8)+v.b;
  Result.alpha:=(v.a shl 8)+v.a;
end;

function TFPCompactImgRGBA8Bit.GetInternalPixel(x, y: integer): integer;
begin
  Result:=0;
end;

procedure TFPCompactImgRGBA8Bit.SetInternalColor(x, y: integer;
  const Value: TFPColor);
var
  v: TFPCompactImgRGBA8BitValue;
begin
  v.r:=Value.red shr 8;
  v.g:=Value.green shr 8;
  v.b:=Value.blue shr 8;
  v.a:=Value.alpha shr 8;
  FData[x+y*Width]:=v;
end;

procedure TFPCompactImgRGBA8Bit.SetInternalPixel(x, y: integer; Value: integer);
begin

end;

constructor TFPCompactImgRGBA8Bit.Create(AWidth, AHeight: integer);
begin
  FDesc:=GetFPCompactImgDesc(false,8,true);
  inherited Create(AWidth, AHeight);
end;

destructor TFPCompactImgRGBA8Bit.Destroy;
begin
  ReAllocMem(FData,0);
  inherited Destroy;
end;

procedure TFPCompactImgRGBA8Bit.SetSize(AWidth, AHeight: integer);
begin
  if (AWidth=Width) and (AHeight=Height) then exit;
  ReAllocMem(FData,SizeOf(TFPCompactImgRGBA8BitValue)*AWidth*AHeight);
  inherited SetSize(AWidth,AHeight);
end;

{ TFPCompactImgRGB8Bit }

function TFPCompactImgRGB8Bit.GetInternalColor(x, y: integer): TFPColor;
var
  v: TFPCompactImgRGB8BitValue;
begin
  v:=FData[x+y*Width];
  Result.red:=(v.r shl 8)+v.r;
  Result.green:=(v.g shl 8)+v.g;
  Result.blue:=(v.b shl 8)+v.b;
  Result.alpha:=alphaOpaque;
end;

function TFPCompactImgRGB8Bit.GetInternalPixel(x, y: integer): integer;
begin
  Result:=0;
end;

procedure TFPCompactImgRGB8Bit.SetInternalColor(x, y: integer; const Value: TFPColor
  );
var
  v: TFPCompactImgRGB8BitValue;
begin
  v.r:=Value.red shr 8;
  v.g:=Value.green shr 8;
  v.b:=Value.blue shr 8;
  FData[x+y*Width]:=v;
end;

procedure TFPCompactImgRGB8Bit.SetInternalPixel(x, y: integer; Value: integer);
begin

end;

constructor TFPCompactImgRGB8Bit.Create(AWidth, AHeight: integer);
begin
  FDesc:=GetFPCompactImgDesc(false,8,false);
  inherited Create(AWidth, AHeight);
end;

destructor TFPCompactImgRGB8Bit.Destroy;
begin
  ReAllocMem(FData,0);
  inherited Destroy;
end;

procedure TFPCompactImgRGB8Bit.SetSize(AWidth, AHeight: integer);
begin
  if (AWidth=Width) and (AHeight=Height) then exit;
  ReAllocMem(FData,SizeOf(TFPCompactImgRGB8BitValue)*AWidth*AHeight);
  inherited SetSize(AWidth,AHeight);
end;

{ TFPCompactImgRGB16Bit }

function TFPCompactImgRGB16Bit.GetInternalColor(x, y: integer): TFPColor;
var
  v: TFPCompactImgRGB16BitValue;
begin
  v:=FData[x+y*Width];
  Result.red:=v.r;
  Result.green:=v.g;
  Result.blue:=v.b;
  Result.alpha:=alphaOpaque;
end;

function TFPCompactImgRGB16Bit.GetInternalPixel(x, y: integer): integer;
begin
  Result:=0;
end;

procedure TFPCompactImgRGB16Bit.SetInternalColor(x, y: integer;
  const Value: TFPColor);
var
  v: TFPCompactImgRGB16BitValue;
begin
  v.r:=Value.red;
  v.g:=Value.green;
  v.b:=Value.blue;
  FData[x+y*Width]:=v;
end;

procedure TFPCompactImgRGB16Bit.SetInternalPixel(x, y: integer; Value: integer);
begin

end;

constructor TFPCompactImgRGB16Bit.Create(AWidth, AHeight: integer);
begin
  FDesc:=GetFPCompactImgDesc(false,16,false);
  inherited Create(AWidth, AHeight);
end;

destructor TFPCompactImgRGB16Bit.Destroy;
begin
  ReAllocMem(FData,0);
  inherited Destroy;
end;

procedure TFPCompactImgRGB16Bit.SetSize(AWidth, AHeight: integer);
begin
  if (AWidth=Width) and (AHeight=Height) then exit;
  ReAllocMem(FData,SizeOf(TFPCompactImgRGB16BitValue)*AWidth*AHeight);
  inherited SetSize(AWidth,AHeight);
end;

{ TFPCompactImgRGBA16Bit }

function TFPCompactImgRGBA16Bit.GetInternalColor(x, y: integer): TFPColor;
begin
  Result:=FData[x+y*Width];
end;

function TFPCompactImgRGBA16Bit.GetInternalPixel(x, y: integer): integer;
begin
  Result:=0;
end;

procedure TFPCompactImgRGBA16Bit.SetInternalColor(x, y: integer;
  const Value: TFPColor);
begin
  FData[x+y*Width]:=Value;
end;

procedure TFPCompactImgRGBA16Bit.SetInternalPixel(x, y: integer; Value: integer);
begin

end;

constructor TFPCompactImgRGBA16Bit.Create(AWidth, AHeight: integer);
begin
  FDesc:=GetFPCompactImgDesc(false,16,true);
  inherited Create(AWidth, AHeight);
end;

destructor TFPCompactImgRGBA16Bit.Destroy;
begin
  ReAllocMem(FData,0);
  inherited Destroy;
end;

procedure TFPCompactImgRGBA16Bit.SetSize(AWidth, AHeight: integer);
begin
  if (AWidth=Width) and (AHeight=Height) then exit;
  ReAllocMem(FData,SizeOf(TFPColor)*AWidth*AHeight);
  inherited SetSize(AWidth,AHeight);
end;


function FPColor (r,g,b:word) : TFPColor;
begin
  with result do
    begin
    red := r;
    green := g;
    blue := b;
    alpha := alphaOpaque;
    end;
end;

function FPColor (r,g,b,a:word) : TFPColor;
begin
  with result do
    begin
    red := r;
    green := g;
    blue := b;
    alpha := a;
    end;
end;

operator = (const c,d:TFPColor) : boolean;
begin
  result := (c.Red = d.Red) and
            (c.Green = d.Green) and
            (c.Blue = d.Blue) and
            (c.Alpha = d.Alpha);
end;

function GetFullColorData (color:TFPColor) : TColorData;
begin
  result := PColorData(@color)^;
end;

function SetFullColorData (color:TColorData) : TFPColor;
begin
  result := PFPColor (@color)^;
end;

operator or (const c,d:TFPColor) : TFPColor;
begin
  result := SetFullColorData(GetFullColorData(c) OR GetFullColorData(d));
end;

operator and (const c,d:TFPColor) : TFPColor;
begin
  result := SetFullColorData(GetFullColorData(c) AND GetFullColorData(d));
end;

operator xor (const c,d:TFPColor) : TFPColor;
begin
  result := SetFullColorData(GetFullColorData(c) XOR GetFullColorData(d));
end;

{$ifdef debug}
function MakeHex (n:TColordata;nr:byte): string;
const hexnums : array[0..15] of char =
              ('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F');
var r : integer;
begin
  result := '';
  for r := 0 to nr-1 do
    begin
    result := hexnums[n and $F] + result;
    n := n shr 4;
    if ((r+1) mod 4) = 0 then
      result := ' ' + result;
    end;
end;
{$endif}

initialization
  ImageHandlers := TImageHandlersManager.Create;
  GrayConvMatrix := GCM_JPEG;
  // Following lines are here because the compiler 1.0 can't work with int64 constants
(*  ColorBits [cfRGB48,1] := ColorBits [cfRGB48,1] shl 16;
  ColorBits [cfRGBA64,1] := ColorBits [cfRGBA64,1] shl 32;
  ColorBits [cfRGBA64,2] := ColorBits [cfRGBA64,2] shl 16;
  ColorBits [cfABGR64,0] := ColorBits [cfABGR64,0] shl 32;
  ColorBits [cfABGR64,3] := ColorBits [cfABGR64,3] shl 16;
  ColorBits [cfBGR48,3] := ColorBits [cfBGR48,3] shl 16;
  PrepareBitMasks;*)

finalization
  ImageHandlers.Free;

end.
