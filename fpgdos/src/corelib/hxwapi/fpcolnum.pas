unit fpcolnum;

interface

uses
  fpimage;


type
  TColorRec = record
    case longint of
     0: (Col32: Longword);
     1: (red,green,blue,alpha: byte);
  end;
  TFPPackedColor = record
    R, G, B, A : byte;
  end;
  TRGBRec = record
    Red,Green,Blue: Smallint;
  end;
  RGBRec = TRGBRec;

const
  Palette15Bit: array[0..15] of word = (
    $0000,
    $0000,
    $0000,
    $0000,
    $0000,
    $0000,
    $0000,
    $0000,
    $0000,
    $0000,
    $0000,
    $0000,
    $0000,
    $0000,
    $0000,
    $0000
  );

  Palette16Bit: array[0..15] of word = (
    $0000,
    $0000,
    $0000,
    $0000,
    $0000,
    $0000,
    $0000,
    $0000,
    $0000,
    $0000,
    $0000,
    $0000,
    $0000,
    $0000,
    $0000,
    $0000
  );

  Palette32Bit: array[0..15] of Longword = (
    $00000000,
    $00000000,
    $00000000,
    $00000000,
    $00000000,
    $00000000,
    $00000000,
    $00000000,
    $00000000,
    $00000000,
    $00000000,
    $00000000,
    $00000000,
    $00000000,
    $00000000,
    $00000000
  );

  PaletteFPColor: array[0..15] of TFPColor = (

     (Red: $0000; Green: $0000; Blue: $0000; Alpha: alphaOpaque),  {colBlack}
     (Red: $0000; Green: $0000; Blue: $ffff; Alpha: alphaOpaque),   {colBlue}
     (Red: $0000; Green: $ffff; Blue: $0000; Alpha: alphaOpaque),   {colGreen}
     (Red: $0000; Green: $ffff; Blue: $ffff; Alpha: alphaOpaque),   {colCyan}
     (Red: $ffff; Green: $0000; Blue: $0000; Alpha: alphaOpaque),   {colRed}
     (Red: $ffff; Green: $0000; Blue: $ffff; Alpha: alphaOpaque),   {colMagenta}
     (Red: $ffff; Green: $ffff; Blue: $0000; Alpha: alphaOpaque),   {colDkYellow}
     (Red: $C000; Green: $C000; Blue: $C000; Alpha: alphaOpaque),   {colLtGray}
     (Red: $4000; Green: $4000; Blue: $4000; Alpha: alphaOpaque),   {colDkGray}
     (Red: $0000; Green: $0000; Blue: $8000; Alpha: alphaOpaque),   {ColDkBlue}
     (Red: $0000; Green: $8000; Blue: $0000; Alpha: alphaOpaque),   {colLtGreen}
     (Red: $0000; Green: $8000; Blue: $8000; Alpha: alphaOpaque),   {colTeal}  {Lt. Magenta}
     (Red: $8000; Green: $0000; Blue: $0000; Alpha: alphaOpaque),   {colDkRed}
     (Red: $ffff; Green: $0000; Blue: $ffff; Alpha: alphaOpaque),   {colFuchsia}
     (Red: $ffff; Green: $ffff; Blue: $0000; Alpha: alphaOpaque),   {colYellow}
     (Red: $ffff; Green: $ffff; Blue: $ffff; Alpha: alphaOpaque)     {colWhite}
  );

function RGB2Color16Bit(Color: Longword): word;
function RGB2Color15Bit(Color: Longword): word;
function Color16Bit2RGB(Color: word): Longword;
function Color15Bit2RGB(Color: word): Longword;
function ColorNumber(color: Longword): Longint;
function RGBfpColorNumber(rgbColor: TFPColor): Longint;
function FPColor2Packed(Col : TFPColor) : TFPPackedColor;
function Packed2FPColor(Col : TFPPackedColor) : TFPColor;


implementation


function RGB2Color16Bit(Color: Longword): word;
var r: TColorRec;
begin
  r.Col32 := Color;
  RGB2Color16Bit := (word(r.red shr 3) and $1F + word(r.green shr 2) shl 5) + word(r.blue shr 3) shl 11;
  {Color16Bit := (Color shr 11) + ((Color shr 5) and $3F) + (Color and $1F);}
  {
  r.blue := (pixel and 31) shl 3;
  r.green := ((pixel shr 5) and 63) shl 2;
  r.red := ((pixel shr 11) and 31) shl 3;
  }
end;

function RGB2Color15Bit(Color: Longword): word;
var r: TColorRec;
begin
  r.Col32 := Color;
  RGB2Color15Bit := (word(r.red shr 3) and $1F + word(r.green shr 3) shl 5) + word(r.blue shr 3) shl 10;
end;

function Color16Bit2RGB(Color: word): Longword;
var r: TColorRec;
begin
  r.blue := (Color and 31) shl 3;
  r.green := ((Color shr 5) and 63) shl 2;
  r.red := ((Color shr 11) and 31) shl 3;
  Color16Bit2RGB := r.Col32;
end;

function Color15Bit2RGB(Color: word): Longword;
var r: TColorRec;
begin
  r.blue := (Color and 31) shl 3;
  r.green := ((Color shr 5) and 63) shl 2;
  r.red := ((Color shr 10) and 31) shl 3;
  Color15Bit2RGB := r.Col32;
end;

function ColorNumber(color: Longword): Longint;
var index: integer;
begin
  index := 0;
  while index < 16 {GetMaxColors + 1} do
  begin
    if color = Palette32Bit[index] then
    begin
      ColorNumber := index;
      index := 16;
    end;
    inc(index);
  end;
  ColorNumber := color;
end;

function RGBfpColorNumber(rgbColor: TFPColor): Longint;
var Index: Longint;
begin
  Index := 0;
  while Index < 16 do
  begin
    if (rgbColor.red = PaletteFPColor[Index].red) and
       (rgbColor.green = PaletteFPColor[Index].green) and
       (rgbColor.blue = PaletteFPColor[Index].blue) then
    begin
      Result := Index;
      Index := 16;
    end;
    Inc(Index);
  end;
end;

function FPColor2Packed(Col : TFPColor) : TFPPackedColor;
begin
  Result.R:=(Col.Red and $FF00) shr 8;
  Result.G:=(Col.Green and $FF00) shr 8;
  Result.B:=(Col.Blue and $FF00) shr 8;
  Result.A:=(Col.Alpha and $FF00) shr 8;
end;

function Packed2FPColor(Col : TFPPackedColor) : TFPColor;
begin
  Result.Red:=(Col.R shl 8) + Col.R;
  Result.Green:=(Col.G shl 8) + Col.G;
  Result.Blue:=(Col.B shl 8) + Col.B;
  Result.Alpha:=(Col.A shl 8) + Col.A;
end;



type
 TPalette = record
   Size: Longint;
   Colors: array[0..255] of RgbRec;
 end;

var
  index: integer; rec: TColorRec; r: TFPPackedColor; Palette: TPalette;
  APalette: TPalette;

initialization
  for index := 0 to 15 do
  begin
    r := FPColor2Packed(PaletteFPColor[Index]);
    rec.red := r.R;
    rec.green := r.G;
    rec.blue := r.B;
    rec.alpha := r.A;
    Palette32Bit[Index] := rec.Col32;
    Palette16Bit[index] := RGB2Color16Bit(rec.Col32 and $00FFFFFF);
    Palette15Bit[index] := RGB2Color15Bit(rec.Col32 and $00FFFFFF);
    APalette.Colors[Index].red := r.R;
    APalette.Colors[Index].green := r.G;
    APalette.Colors[Index].blue  := r.B;
    move(APalette.Colors[Index],Palette.Colors[Index],Sizeof(RgbRec));
    {$ifdef VENOMGFX}
    {$else}
    //SetRGBPalette(smallint(Index),smallint(rec.red),smallint(rec.green),smallint(rec.blue));
    (*
    Palette.Size := 16;
    SetLength(Palette.Colors, Palette.Size*Sizeof(RGBREC));
    Palette.Colors[0].red   :=  0;
    Palette.Colors[0].green :=  0;
    Palette.Colors[0].blue  :=  0;

    Palette.Colors[1].red   :=  $00;
    Palette.Colors[1].green :=  $00;
    Palette.Colors[1].blue  :=  $FC;

    Palette.Colors[2].red   :=  $24;
    Palette.Colors[2].green :=  $FC;
    Palette.Colors[2].blue  :=  $24;

    Palette.Colors[3].red   :=  $00;
    Palette.Colors[3].green :=  $FC;
    Palette.Colors[3].blue  :=  $FC;

    Palette.Colors[4].red   :=  $FC;
    Palette.Colors[4].green :=  $14;
    Palette.Colors[4].blue  :=  $14;

    Palette.Colors[5].red   :=  $B0;
    Palette.Colors[5].green :=  $00;
    Palette.Colors[5].blue  :=  $FC;

    Palette.Colors[6].red   :=  $70;
    Palette.Colors[6].green :=  $48;
    Palette.Colors[6].blue  :=  $00;

    Palette.Colors[7].red   :=  $C4;
    Palette.Colors[7].green :=  $C4;
    Palette.Colors[7].blue  :=  $C4;

    Palette.Colors[8].red   :=  $34;
    Palette.Colors[8].green :=  $34;
    Palette.Colors[8].blue  :=  $34;

    Palette.Colors[9].red   :=  $00;
    Palette.Colors[9].green :=  $00;
    Palette.Colors[9].blue  :=  $70;

    Palette.Colors[10].red  := $00;
    Palette.Colors[10].green:= $70;
    Palette.Colors[10].blue := $00;

    Palette.Colors[11].red  := $00;
    Palette.Colors[11].green:= $70;
    Palette.Colors[11].blue := $70;

    Palette.Colors[12].red  := $70;
    Palette.Colors[12].green:= $00;
    Palette.Colors[12].blue := $00;

    Palette.Colors[13].red  := $70;
    Palette.Colors[13].green:= $00;
    Palette.Colors[13].blue := $70;

    Palette.Colors[14].red  := $FC;
    Palette.Colors[14].green:= $FC;
    Palette.Colors[14].blue := $24;

    Palette.Colors[15].red  := $FC;
    Palette.Colors[15].green:= $FC;
    Palette.Colors[15].blue := $FC;

    SetAllPalette(Palette);
    *)
    {$endif}
  end;
end.
