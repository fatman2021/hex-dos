unit gdi_mem;

interface

uses
  go32;
  
  
function GlobalAlloc(flags: UINT; size: SIZE_T): HGLOBAL;  

implementation


function GlobalAlloc(flags: UINT; size: SIZE_T): HGLOBAL;  
var
  HAlloc: HGLOBAL;
begin
  case flags of
    GHND:
      begin
        HAlloc := allocate_memory_block(size);
        Result := HAlloc;
      end;
    GMEM_MOVEABLE:
      begin
        HAlloc := allocate_memory_block(size);
        Result := HAlloc;
      end;
    GMEM_FIXED:
      begin
        HAlloc := allocate_memory_block(size);
        Result := HAlloc;
      end;
    GMEM_ZEROINIT:
      begin
        HAlloc := allocate_memory_block(size);
        Result := HAlloc;
      end;
  end;
end;

end.
