unit fpg_impl;

{$mode objfpc}{$H+}

interface

uses
  qtwinapi;

const
  DROPEFFECT_NONE = 0;
  //Drop target cannot accept the data.
  DROPEFFECT_COPY = 1;
  //Drop results in a copy. The original data is untouched by the drag source.
  DROPEFFECT_MOVE = 2;
  //Drag source should remove the data.
  DROPEFFECT_LINK = 4;
  //Drag source should create a link to the original data.
  DROPEFFECT_SCROLL = $80000000;

type
    TfpgWinHandle = HWND;
    TfpgDCHandle  = HDC;
    
var
  MainInstance: THandle;    
  Win32MajorVersion: Integer = 0;
  Win32MinorVersion: Integer = 0;
  Win32Platform: Integer = 0;

implementation

end.

