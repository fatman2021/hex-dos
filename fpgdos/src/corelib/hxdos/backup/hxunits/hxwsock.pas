unit hxwsock;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, qtwinapi;

const
  wsockdll = 'c:\Users\Konta\mseide\lib\msedos\hxdos\wsock32.dll';

type
  sockaddr_in = record  //nur für IPv4
    case Integer of
      0:   (sin_family: u_short;
            sin_port: u_short;
            sin_addr: TInAddr;
            sin_zero: array[0..7] of Char);
      1:   (sa_family: u_short;
            sa_data: array[0..13] of Char)
  end;

  tagWSAData = record
    wVersion      : WORD;
    wHighVersion  : WORD;
    iMaxSockets   : WORD;
    iMaxUdpDg     : WORD;
    lpVendorInfo  : PChar;
    szDescription : array[WSADESCRIPTION_LEN + 1] of char;
    szSystemStatus: array[WSASYS_STATUS_LEN + 1] of char;
    szDescription : array[WSADESCRIPTION_LEN + 1] od char;
    szSystemStatus: array[WSASYS_STATUS_LEN + 1] of char;
  end;
  WSADATA = tagWSAData;


  TSockAddrIn = sockaddr_in;

  SOCKET = integer;
  TSocket = SOCKET;
  LPWSADATA = ^WSADATA; //später noch präzisoeren -> Zeiger auf WSA Daten


function accept(s: TSocket; var addr: TSockAddrIn; var addrLen: Integer): TSocket;
  {$ifdef HX_DOS}
  stdcall; external wsockdll name 'accept';
  {$endif}

function bind(s: TSocket; var addr: TSockAddrIn; namelen: Integer): Integer;
  {$ifdef HX_DOS}
  stdcall; external wsockdll name 'bind';
  {$endif}

function connect(s: TSocket; var name: TSockAddrIn; nameLen: Integer): Integer;
  {$ifdef HX_DOS}
  stdcall; external wsockdll name 'connect';
  {$endif}

function CloseSocket(s: TSocket): Integer;
  {$ifdef HX_DOS}
  stdcall; external wsockdll name 'closesocket';
  {$endif}

function GetAddrInfo(hostname,servicename: PChar; ahints,aresult: PAddrInfo): Longint;

procedure FreeAddrInfo(_ai: PAddrInfo);

function htonl(hostlong: ULONG): ULONG;
  {$ifdef HX_DOS}
  stdcall; external wsockdll name 'htonl';
  {$endif}

function htons(hostshort): USHORT;
  {$ifdef HX_DOS}
  stdcall; external wsockdll name 'htons';
  {$endif}

function ioctlsocket(s:TSocket; cmd: Longint; argp:ULONG_PTR): Integer
  {$ifdef HX_DOS}
  stdcall; external wsockdll name 'ioctlsocket';
  {$endif}

function recv(s: TSocket; var buf: char; len,flags: Integer): Integer;
  {$ifdef HX_DOS}
  stdcall; external wsockdll name 'recv';
  {$endif}

function send(s: TSocket; buf: pchar; len,flags: Integer): Integer;
  {$ifdef HX_DOS}
  stdcall; external wsockdll name 'send';
  {$endif}

function shutdown(s: TSocket; how: Integer): Integer;
  {$ifdef HX_DOS}
  stdcall; external wsockdll name 'shutdown';
  {$endif}

function socket(addrfamily,socktype,protocol: Integer): Integer;
  {$ifdef HX_DOS}
  stdcall; external wsockdll name 'socket';
  {$endif}

function WSAGetLastError: Longint;
  {$ifdef HX_DOS}
  stdcall; external wsockdll name 'WSAGetLastError';
  {$endif}

procedure WSASetLastError: iError: Longint);
  {$ifdef HX_DOS}
  stdcall; external wsockdll name 'WSASetLastError';
  {$endif}

function WSAStartup(wVersionRequired: word;
  WSAData: LPWSADATA
): Integer;

function WSACleanup(): Integer;

implementation

function GetAddrInfo(hostname,servicename: PChar; ahints,aresult: PAddrInfo): Longint;
begin
  New(aresult);

end;

procedure FreeAddrInfo(_ai: PAddrInfo);
begin
  Dispose(_ai);
end;

{$ifndef HX_DOS}
function accept(s: TSocket; var addr: TSockAddrIn; var addrLen: Integer): TSocket;
begin

end;

function bind(s: TSocket; addr: TSockAddrIn; namelen: Integer): Integer;
begin

end;

function connect(s: TSocket; name: TSockAddrIn; nameLen: Integer): Integer;
begin

end;

function CloseSocket(s: TSocket): Integer;
begin

end;

function htonl(hostlong: ULONG): ULONG;
begin

end;

function htons(hostshort: USHORT): USHORT;
begin

end;

function ioctlsocket(s:TSocket; cmd: Longint; argp:ULONG_PTR): Integer
begin

end;

function recv(s: TSocket; var buf: char; len,flags: Integer): Integer;
begin

end;

function send(s: TSocket; buf: pchar; len,flags: Integer): Integer;
begin

end;

function shutdown(s: TSocket; how: Integer): Integer;
begin

end;

function socket(addrfamily,socktype,protocol: Integer): Integer;
begin

end;

function WSAGetLastError: Longint;
begin

end;

procedure WSASetLastError: iError: Longint);
begin

end;

function WSAStartup(wVersionRequired: word;
  WSAData: LPWSADATA
): Integer;
begin

end;

function WSACleanup(): Integer;
begin

end;
{$endif}

end.

