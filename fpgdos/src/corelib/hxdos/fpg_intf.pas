unit fpg_intf;

interface

uses
  qtwinapi;

type
  tagDVTARGETDEVICE            = Record
                                    tdSize                     : DWord;
                                    tdDriverNameOffset,
                                    tdDeviceNameOffset,
                                    tdPortNameOffset,
                                    tdExtDevmodeOffset         : Word;
                                    Data                       : Record End;
                                    End;

  DVTARGETDEVICE               = TagDVTARGETDEVICE;
  PDVTARGETDEVICE              = ^tagDVTARGETDEVICE;
  PTAGDVTARGETDEVICE           = PDVTARGETDEVICE;
  LPCLIPFORMAT                 = ^TCLIPFORMAT;
  TCLIPFORMAT                  = Word;
  CLIPFORMAT                   = TCLIPFORMAT;
  PClipFormat                  = LPCLIPFORMAT;

  tagFORMATETC                 = Record
                                    CfFormat : Word {TCLIPFORMAT};
                                    Ptd      : PDVTARGETDEVICE;
                                    dwAspect : DWORD;
                                    lindex   : Long;
                                    tymed    : DWORD;
                                    End;

  FORMATETC                    = TagFORMATETC;
  TFORMATETC                   = FORMATETC;
  LPFORMATETC                  = ^FORMATETC;
  PFormatEtc                   = LPFORMATETC;

  PtagSTATDATA                 = ^tagSTATDATA;
  tagSTATDATA                  = Record
                                                                // field used by:
                                    FORMATETC   : Tformatetc;   // EnumAdvise, EnumData (cache), EnumFormats
                                    advf        : DWord;        // EnumAdvise, EnumData (cache)
                                    padvSink    : Pointer {IAdviseSink};  // EnumAdvise
                                    dwConnection: DWord;        // EnumAdvise
                                    End;
  PStatData                    = PtagSTATDATA;
  TStatData                    = tagSTATDATA;
  STATDATA                     = TagStatData;
  LPStatData                   = ^StatData;

    // Stats for data; used by several enumerations and by at least one
    // implementation of IDataAdviseHolder; if a field is not used, it
    // will be NULL.


  tagRemSTGMEDIUM              = Record
                                    tymed                     : DWord;
                                    dwHandleType              : DWord;
                                    pData,
                                    pUnkForRelease,
                                    cbData                    : ULong;
                                    Data                      : Record end;
                                    End;

  RemSTGMEDIUM                 = TagRemSTGMedium;
  TagSTGMEDIUM                 = Record
                                    Tymed : DWord;
                                    Case Integer Of
                                      0 : (BITMAP             : hBitmap;       PUnkForRelease :  Pointer {IUnknown});
                                      1 : (METAFILEPICT       : HANDLE );
                                      2 : (ENHMETAFILE        : hEnhMetaFile  );
                                      3 : (GLOBAL             : hGlobal       );
                                      4 : (lpszFileName       : String    );
                                      5 : (pstm                : Pointer{IStream}  );
                                      6 : (pstg                : Pointer{IStorage} );
                                      End;
  USTGMEDIUM                   = TagSTGMEDIUM;
  STGMEDIUM                    = USTGMEDIUM;
  TStgMedium                   = TagSTGMEDIUM;
  PStgMedium                   = ^TStgMedium;


  (*
  PIMoniker = ^IMoniker;
  IMoniker = Interface (IPersistStream)
      ['{0000000f-0000-0000-C000-000000000046}']
      Function BindToObject (const pbc:IBindCtx;const mktoleft:IMoniker; const RiidResult:TIID;Out vresult):HResult;StdCall;
      { Function RemoteBindToObject (const pbc:IBindCtx;const mktoleft:IMoniker;const RiidResult:TIID;Out vresult):HResult;StdCall; }
      Function BindToStorage(Const Pbc:IBindCtx;Const mktoLeft:IMoniker; const Riid:TIID;Out vobj):HResult; StdCall;
      { Function RemoteBindToStorage(Const Pbc:IBindCtx;Const mktoLeft:IMoniker;const Riid:TIID;Out vobj):HResult; StdCall; }
      Function Reduce (const pbc:IBindCtx; dwReduceHowFar:DWord; mktoLeft: PIMoniker; Out mkReduced:IMoniker):HResult; StdCall;
      Function ComposeWith(Const MkRight:IMoniker;fOnlyIfNotGeneric:BOOL; OUT mkComposite:IMoniker):HResult; StdCall;
      Function Enum(fForward:Bool;Out enumMoniker:IEnumMoniker):HResult;StdCall;
      Function IsEqual(Const mkOtherMoniker:IMoniker):HResult;StdCall;
      Function Hash   (Out dwHash:Dword):HResult;StdCall;
      Function IsRunning(Const bc:IBindCtx;Const MkToLeft:IMoniker;Const mknewlyRunning:IMoniker):HResult;StdCall;
      Function GetTimeOfLastChange(Const bc:IBindCtx;Const mkToLeft:IMoniker; out ft : FileTime):HResult; StdCall;
      Function Inverse(out mk : IMoniker):HResult; StdCall;
      Function CommonPrefixWith (Const mkOther:IMoniker):HResult; StdCall;
      Function RelativePathTo(Const mkother:IMoniker; Out mkRelPath : IMoniker):HResult;StdCall;
      Function GetDisplayName(Const bc:IBindCtx;const mktoleft:IMoniker;Out szDisplayName: pOleStr):HResult; StdCall;
      Function ParseDisplayName(Const bc:IBindCtx;Const mkToLeft:IMoniker;szDisplayName:POleStr;out cheaten:ULong;out mkOut:IMoniker):HResult; StdCall;
      Function IsSystemMoniker(Out dwMkSys:DWord):HResult;StdCall;
  End;
  *)

  IAdviseSink = Interface (IUnknown)
    ['{0000010f-0000-0000-C000-000000000046}']
    {$ifdef midl500} ['{00000150-0000-0000-C000-000000000046}'] {$endif}
    Procedure OnDataChange (Const pformatetc : Formatetc;const pstgmed : STGMEDIUM); StdCall;
    Procedure OnViewChange (dwAspect : DWord; lindex : Long); StdCall;
    Procedure OnRename (Const pmk : Pointer{IMoniker}); StdCall;
    Procedure OnSave; StdCall;
    Procedure OnClose; StdCall;
  End;

  IAdviseSink2 = Interface (IAdviseSink)
    ['{00000125-0000-0000-C000-000000000046}']
    Procedure OnLinkSrcChange(Const Pmk: Pointer{IMoniker}); StdCall;
  End;


  IEnumFORMATETC = Interface (IUnknown)
    ['{00000103-0000-0000-C000-000000000046}']
    Function Next(Celt:ULong;Out Rgelt:FormatEtc;pceltFetched:pULong=nil):HResult; StdCall;
//    Function RemoteNext(Celt:ULong;Out Rgelt:FormatEtc; pceltFetched:pULong=nil):HResult; StdCall;
    Function Skip(Celt:ULong):HResult;StdCall;
    Function Reset:HResult;StdCall;
    Function Clone(out penum:IEnumFORMATETC):HResult;StdCall;
  End;

  IEnumSTATDATA = Interface (IUnknown)
    ['{00000105-0000-0000-C000-000000000046}']
    Function Next(Celt:ULong;Out Rgelt:statdata; pceltFetched:pULong=nil):HResult; StdCall;
//   Function RemoteNext(Celt:ULong;Out Rgelt:statdata;Out pceltFetched:ULong):HResult; StdCall;
    Function Skip(Celt:ULong):HResult;StdCall;
    Function Reset:HResult;StdCall;
    Function Clone(out penum:IEnumstatdata):HResult;StdCall;
  End;

  IDataObject = Interface (IUnknown)
    ['{0000010e-0000-0000-C000-000000000046}']
    Function GetData(Const formatetcIn : FORMATETC;Out medium : STGMEDIUM):HRESULT; STDCALL;
    Function GetDataHere(CONST pformatetc : FormatETC; Out medium : STGMEDIUM):HRESULT; STDCALL;
    Function QueryGetData(const pformatetc : FORMATETC):HRESULT; STDCALL;
    Function GetCanonicalFormatEtc(const pformatetcIn : FORMATETC;Out pformatetcOut : FORMATETC):HResult; STDCALl;
    Function SetData (Const pformatetc : FORMATETC;const medium:STGMEDIUM;FRelease : BOOL):HRESULT; StdCall;
    Function EnumFormatEtc(dwDirection : DWord; OUT enumformatetcpara : IENUMFORMATETC):HRESULT; StdCall;
    Function DAdvise(const formatetc : FORMATETC;advf :DWORD; CONST AdvSink : IAdviseSink;OUT dwConnection:DWORD):HRESULT;StdCall;
    Function DUnadvise(dwconnection :DWord) :HRESULT;StdCall;
    Function EnumDAdvise(Out enumAdvise : IEnumStatData):HResult;StdCall;
  End;

  IDropSource = interface(IUnknown)
    ['{00000121-0000-0000-C000-000000000046}']
    function QueryContinueDrag(fEscapePressed: BOOL;
      grfKeyState: DWORD):HResult;StdCall;
    function GiveFeedback(dwEffect: DWORD): HResult;StdCall;
  end;

  IDropTarget = interface(IUnknown)
    ['{00000122-0000-0000-C000-000000000046}']
    function DragEnter(const dataObj: IDataObject; grfKeyState: DWORD; pt: TPoint; var dwEffect: DWORD): HResult;StdCall;
    function DragOver(grfKeyState: DWORD; pt: TPoint; var dwEffect: DWORD): HResult;StdCall;
    function DragLeave: HResult;StdCall;
    function Drop(const dataObj: IDataObject; grfKeyState: DWORD; pt: TPoint; var dwEffect: DWORD):HResult;StdCall;
  end;

implementation

end.
