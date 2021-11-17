unit WSocket;

{$B-}           { Enable partial boolean evaluation   }
{$T-}           { Untyped pointers                    }
{$IFNDEF VER80} { Not for Delphi 1                    }
    {$J+}       { Allow typed constant to be modified }
{$ENDIF}
{$IFDEF VER110} { C++ Builder V3.0                    }
    {$ObjExportAll On}
{$ENDIF}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, WSockBuf, Wait, WinSock;

const
  WSocketVersion        = 240;
  WM_ASYNCSELECT        = WM_USER + 1;
  WM_ASYNCGETHOSTBYNAME = WM_USER + 2;
{$IFDEF WIN32}
  winsocket = 'wsock32.dll';      { 32 bits TCP/IP system DLL              }
{$ELSE}
  winsocket = 'winsock.dll';      { 16 bits TCP/IP system DLL              }
{$ENDIF}

type
  ESocketException = class(Exception);

  TSocketState = (wsInvalidState,
                  wsOpened,     wsBound,
                  wsConnecting, wsConnected,
                  wsAccepting,  wsListening,
                  wsClosed);
  TSocketSendFlags = (wsSendNormal, wsSendUrgent);
  TSocketLingerOnOff = (wsLingerOff, wsLingerOn, wsLingerNoSet);

  TDataAvailable    = procedure (Sender: TObject; Error: word) of object;
  TDataSent         = procedure (Sender: TObject; Error: word) of object;
  TSessionClosed    = procedure (Sender: TObject; Error: word) of object;
  TSessionAvailable = procedure (Sender: TObject; Error: word) of object;
  TSessionConnected = procedure (Sender: TObject; Error: word) of object;
  TDnsLookupDone    = procedure (Sender: TObject; Error: Word) of object;
  TChangeState      = procedure (Sender: TObject;
                                 OldState, NewState : TSocketState) of object;
{$IFDEF VER110}  { C++Builder V3 }
  TSocket = integer;
{$ENDIF}

  TCustomWSocket = class(TComponent)
  private
    FHSocket            : TSocket;
    FPortAssigned       : Boolean;
    FAddrAssigned       : Boolean;
    FProtoAssigned      : Boolean;
    FProtoStr           : String;
    FAddrStr            : String;
    FPortStr            : String;
    FPortNum            : Integer;
    FLocalPort          : Integer;
    FProto              : integer;
    FType               : integer;
    FDnsResult          : String;
    FDnsResultList      : TStrings;
    FAddrFormat         : Integer;
    FASocket            : TSocket;               { Accepted socket }
    FState              : TSocketState;
    FFlushTimeout       : Integer;
    FBufList            : TList;
    FBufSize            : Integer;
    FSendFlags          : Integer;
    FMultiThreaded      : Boolean;
    FWait               : TWait;
    FStateWaited        : TSocketState;
    FLastError          : Integer;
    FPaused             : Boolean;
    FLingerOnOff        : TSocketLingerOnOff;
    FLingerTimeout      : Integer;              { In seconds, 0 = disabled }
    bMoreFlag           : Boolean;
    nMoreCnt            : Integer;
    nMoreMax            : Integer;
    bWrite              : Boolean;
    bAllSent            : Boolean;
    ReadLineBuffer      : String[255];
    ReadLineCount       : Integer;
    ReadLineFlag        : Boolean;
    FReadCount          : LongInt;
    FCloseInvoked       : Boolean;
    FWindowHandle       : HWND;
    FDnsLookupBuffer    : array [0..MAXGETHOSTSTRUCT] of char;
    FDnsLookupHandle    : THandle;
    FOnSessionAvailable : TSessionAvailable;
    FOnSessionConnected : TSessionConnected;
    FOnSessionClosed    : TSessionClosed;
    FOnChangeState      : TChangeState;
    FOnDataAvailable    : TDataAvailable;
    FOnDataSent         : TDataSent;
    FOnLineTooLong      : TNotifyEvent;
    FOnDnsLookupDone    : TDnsLookupDone;
    FOnError            : TNotifyEvent;
  protected
    procedure   WndProc(var MsgRec: TMessage);
    procedure   SocketError(sockfunc: string);
    procedure   WMASyncSelect(var msg: TMessage); message WM_ASYNCSELECT;
    procedure   WMAsyncGetHostByName(var msg: TMessage); message WM_ASYNCGETHOSTBYNAME;
    procedure   ChangeState(NewState : TSocketState);
    procedure   TryToSend;
    procedure   ASyncReceive(var msg: TMessage);
    procedure   ReadLineReceive;
    procedure   AssignDefaultValue; virtual;
    procedure   InternalClose(bShut : Boolean);
    procedure   Notification(AComponent: TComponent; operation: TOperation); override;
    procedure   SetSendFlags(newValue : TSocketSendFlags);
    function    GetSendFlags : TSocketSendFlags;
    procedure   SetAddr(InAddr : String);
    function    GetAddr : String;
    procedure   SetPort(sPort : String);
    function    GetPort : String;
    procedure   SetProto(sProto : String);
    function    GetProto : String;
    function    GetRcvdCount : LongInt;
    function    CheckFWait : Boolean;
    procedure   ReadLineStart;
    procedure   BindSocket; virtual;
    procedure   SendText(Str : String);
    procedure   RaiseExceptionFmt(const Fmt : String; args : array of const); virtual;
    procedure   RaiseException(const Msg : String); virtual;
    function    TriggerDataAvailable(Error : Word) : Boolean; virtual;
    procedure   TriggerSessionAvailable(Error : Word); virtual;
    procedure   TriggerSessionConnected(Error : Word); virtual;
    procedure   TriggerSessionClosed(Error : Word); virtual;
    procedure   TriggerDataSent(Error : Word); virtual;
    procedure   TriggerChangeState(OldState, NewState : TSocketState); virtual;
    procedure   TriggerDNSLookupDone(Error : Word); virtual;
    procedure   TriggerError; virtual;

  public
    sin         : TSockAddrIn;
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure   Connect; virtual;
    procedure   Close; virtual;
    procedure   Abort; virtual;
    procedure   Flush; virtual;
    procedure   WaitForClose; virtual;
    function    Listen : Integer; virtual;
    function    Accept: TSocket; virtual;
    function    Receive(Buffer : Pointer; BufferSize: integer) : integer; virtual;
    function    ReceiveStr : string;
    function    ReceiveFrom(Buffer      : Pointer;
                            BufferSize  : Integer;
                            var From    : TSockAddr;
                            var FromLen : Integer) : integer; virtual;
    function    PeekData(Buffer : Pointer; BufferSize: integer) : integer;
    function    Send(Data : Pointer; Len : Integer) : integer; virtual;
    function    SendStr(Str : String) : Integer; virtual;
    procedure   DnsLookup(HostName : String); virtual;
    procedure   CancelDnsLookup; virtual;
    function    GetPeerAddr: string; virtual;
    function    GetPeerName(var Name : TSockAddrIn; NameLen : Integer) : integer; virtual;
    function    GetXPort: string; virtual;
    function    TimerIsSet(var tvp : TTimeVal) : Boolean; virtual;
    procedure   TimerClear(var tvp : TTimeVal); virtual;
    function    TimerCmp(var tvp : TTimeVal; var uvp : TTimeVal; IsEqual : Boolean) : Boolean; virtual;
    function    Wait(Timeout : integer; State : TSocketState) : Boolean; virtual;
    procedure   ReadLine(Timeout : integer; var Buffer : String); virtual;
    function    GetSockName(var saddr : TSockAddrIn; var saddrlen : Integer) : integer; virtual;
    procedure   SetLingerOption;
    procedure   Dup(NewHSocket : TSocket); virtual;
    procedure   Shutdown(How : Integer); virtual;
    procedure   Pause; virtual;
    procedure   Resume; virtual;
    procedure   PutDataInSendBuffer(Data : Pointer; Len : Integer);
    procedure   PutStringInSendBuffer(Str : String);
{$IFNDEF VER80}
    procedure   MessageLoop;
    procedure   ProcessMessages;
{$ENDIF}
  protected
    property PortNum : Integer                      read  FPortNum;
    property Handle : HWND                          read  FWindowHandle;
    property HSocket : TSocket                      read  FHSocket
                                                    write Dup;

    property Addr : string                          read  GetAddr
                                                    write SetAddr;
    property Port : string                          read  GetPort
                                                    write SetPort;
    property Proto : String                         read  GetProto
                                                    write SetProto;
    property MultiThreaded   : Boolean              read  FMultiThreaded
                                                    write FMultiThreaded;
    property DnsResult : String                     read  FDnsResult;
    property DnsResultList : TStrings               read  FDnsResultList;
    property State : TSocketState                   read  FState;
    property AllSent   : Boolean                    read  bAllSent;
    property ReadCount : LongInt                    read  FReadCount;
    property RcvdCount : LongInt                    read  GetRcvdCount;
    property LastError : Integer                    read  FLastError;
    property LocalPort : Integer                    read  FLocalPort;
    property BufSize   : Integer                    read  FBufSize
                                                    write FBufSize;
    property OnDataAvailable : TDataAvailable       read  FOnDataAvailable
                                                    write FOnDataAvailable;
    property OnDataSent : TDataSent                 read  FOnDataSent
                                                    write FOnDataSent;
    property OnSessionClosed : TSessionClosed       read  FOnSessionClosed
                                                    write FOnSessionClosed;
    property OnSessionAvailable : TSessionAvailable read  FOnSessionAvailable
                                                    write FOnSessionAvailable;
    property OnSessionConnected : TSessionConnected read  FOnSessionConnected
                                                    write FOnSessionConnected;
    property OnChangeState : TChangeState           read  FOnChangeState
                                                    write FOnChangeState;
    property OnLineTooLong : TNotifyEvent           read  FOnLineTooLong
                                                    write FOnLineTooLong;
    property OnDnsLookupDone : TDnsLookupDone       read  FOnDnsLookupDone
                                                    write FOnDnsLookupDone;
    property OnError          : TNotifyEvent        read  FOnError
                                                    write FOnError;
    property WaitCtrl : TWait                       read  FWait
                                                    write FWait;
    property FlushTimeout : Integer                 read  FFlushTimeOut
                                                    write FFlushTimeout;
    property SendFlags : TSocketSendFlags           read  GetSendFlags
                                                    write SetSendFlags;
    property Text: String                           read  ReceiveStr
                                                    write SendText;
    property LingerOnOff   : TSocketLingerOnOff     read  FLingerOnOff
                                                    write FLingerOnOff;
    property LingerTimeout : Integer                read  FLingerTimeout
                                                    write FLingerTimeout;
  end;

  TWSocket = class(TCustomWSocket)
  public
    property PortNum;
    property Handle;
    property HSocket;
    property LocalPort;
    property BufSize;
    property Text;
    property AllSent;
  published
    property Addr;
    property Port;
    property Proto;
    property DnsResult;
    property DnsResultList;
    property State;
    property ReadCount;
    property RcvdCount;
    property LastError;
    property MultiThreaded;
    property OnDataAvailable;
    property OnDataSent;
    property OnSessionClosed;
    property OnSessionAvailable;
    property OnSessionConnected;
    property OnChangeState;
    property OnLineTooLong;
    property OnDnsLookupDone;
    property OnError;
    property WaitCtrl;
    property FlushTimeout;
    property SendFlags;
    property LingerOnOff;
    property LingerTimeout;
  end;

procedure Register;

function WinsockInfo : TWSADATA;
function WSocketErrorDesc(error: integer) : string;
function WSocketGetHostByAddr(Addr : String) : PHostEnt;
function WSocketGetHostByName(Name : String) : PHostEnt;
function LocalHostName : String;
function LocalIPList : TStrings;
function WSocketResolveHost(InAddr : String) : TInAddr;

implementation

const
    GSocketCount   : integer = 0;
    DllStarted     : Boolean = FALSE;
var
    GInitData      : TWSADATA;
    IPList         : TStrings;

function LoadWinsock(FileName : PChar) : Boolean; forward;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure Register;
begin
    RegisterComponents('Neue', [TWSocket]);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF VER80}
procedure SetLength(var S: string; NewLength: Integer);
begin
    S[0] := chr(NewLength);
end;
{$ENDIF}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function atoi(value : string) : Integer;
var
    i : Integer;
begin
    Result := 0;
    i := 1;
    while (i <= Length(Value)) and (Value[i] = ' ') do
        i := i + 1;
    while (i <= Length(Value)) and (Value[i] >= '0') and (Value[i] <= '9')do begin
        Result := Result * 10 + ord(Value[i]) - ord('0');
        i := i + 1;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IsDigit(Ch : Char) : Boolean;
begin
    Result := (ch >= '0') and (ch <= '9');
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF VER80}
function TrimRight(Str : String) : String;
var
    i : Integer;
begin
    i := Length(Str);
    while (i > 0) and (Str[i] = ' ') do
        i := i - 1;
    Result := Copy(Str, 1, i);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TrimLeft(Str : String) : String;
var
    i : Integer;
begin
    if Str[1] <> ' ' then
        Result := Str
    else begin
        i := 1;
        while (i <= Length(Str)) and (Str[i] = ' ') do
            i := i + 1;
        Result := Copy(Str, i, Length(Str) - i + 1);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Trim(Str : String) : String;
begin
    Result := TrimLeft(TrimRight(Str));
end;
{$ENDIF}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomWSocket.RaiseException(const Msg : String);
begin
    if Assigned(FOnError) then
        TriggerError
    else
        raise ESocketException.Create(Msg);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomWSocket.RaiseExceptionFmt(const Fmt : String; args : array of const);
begin
    if Assigned(FOnError) then
        TriggerError
    else
        raise ESocketException.CreateFmt(Fmt, args);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function LoadWinsock(FileName : PChar) : Boolean;
var
    LastError : LongInt;
begin
    if not DllStarted then begin
        LastError := WSAStartup($101, GInitData);
        if LastError <> 0 then begin
            raise ESocketException.CreateFmt('%s: WSAStartup error #%d',
                                             [FileName, LastError]);
        end;
        DllStarted := TRUE;
    end;
    Result := TRUE;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function WinsockInfo : TWSADATA;
begin
    LoadWinsock(winsocket);
    Result := GInitData;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomWSocket.Notification(AComponent: TComponent; operation: TOperation);
begin
    inherited Notification(AComponent, operation);
    if operation = opRemove then begin
        if AComponent = FWait then
            FWait := nil;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomWSocket.AssignDefaultValue;
begin
    FillChar(sin, 0, Sizeof(sin));
    sin.sin_family  := AF_INET;
    FAddrFormat     := PF_INET;

    FPortAssigned   := FALSE;
    FAddrAssigned   := FALSE;

    FProtoAssigned  := TRUE;
    FProto          := IPPROTO_TCP;
    FProtoStr       := 'tcp';
    FType           := SOCK_STREAM;

    FLingerOnOff    := wsLingerOn;
    FLingerTimeout  := 0;
    FHSocket        := INVALID_SOCKET;
    FState          := wsClosed;
    FStateWaited    := wsInvalidState;
    bMoreFlag       := FALSE;
    nMoreCnt        := 0;
    nMoreMax        := 24;
    bWrite          := FALSE;
    bAllSent        := TRUE;
    ReadLineFlag    := FALSE;
    ReadLineCount   := 0;
    FPaused         := FALSE;
    FReadCount      := 0;
    FCloseInvoked   := FALSE;
    FFlushTimeout   := 60;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomWSocket.WndProc(var MsgRec: TMessage);
begin
     with MsgRec do begin
         if Msg = WM_ASYNCSELECT then
             WMASyncSelect(MsgRec)
         else if Msg = WM_ASYNCGETHOSTBYNAME then
             WMAsyncGetHostByName(MsgRec)
         else
             Result := DefWindowProc(Handle, Msg, wParam, lParam);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFNDEF VER80}
{ This function is a callback function. It means that it is called by       }
{ windows. This is the very low level message handler procedure setup to    }
{ handle the message sent by windows (winsock) to handle messages.          }
function XSocketWindowProc(
    ahWnd   : HWND;
    auMsg   : Integer;
    awParam : WPARAM;
    alParam : LPARAM): Integer; stdcall;
var
    Obj    : TWSocket;
    MsgRec : TMessage;
begin
    { At window createion asked windows to store a pointer to our object    }
    Obj := TWSocket(GetWindowLong(ahWnd, 0));

    { If the pointer is not assigned, just call the default procedure       }
    if not Assigned(Obj) then
        Result := DefWindowProc(ahWnd, auMsg, awParam, alParam)
    else begin
        { Delphi use a TMessage type to pass parameter to his own kind of   }
        { windows procedure. So we are doing the same...                    }
        MsgRec.Msg    := auMsg;
        MsgRec.wParam := awParam;
        MsgRec.lParam := alParam;
        Obj.WndProc(MsgRec);
        Result := MsgRec.Result;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Loop thru message processing until the WM_QUIT message is received        }
{ This is intended for multithreaded application using TWSocket.            }
procedure TCustomWSocket.MessageLoop;
var
    MsgRec : TMsg;
begin
    while GetMessage(MsgRec, 0{FWindowHandle}, 0, 0) do begin
        TranslateMessage(MsgRec);
        DispatchMessage(MsgRec)
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Loop thru message processing until all messages are processed.            }
{ This is intended for multithreaded application using TWSocket.            }
procedure TCustomWSocket.ProcessMessages;
var
    MsgRec : TMsg;
begin
    while PeekMessage(MsgRec, 0 {FWindowHandle}, 0, 0, PM_REMOVE) do begin
        TranslateMessage(MsgRec);
        DispatchMessage(MsgRec)
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This global variable is used to store the windows class characteristic    }
{ and is needed to register the window class used by TWSocket               }
var
    XSocketWindowClass: TWndClass = (
        style         : 0;
        lpfnWndProc   : @XSocketWindowProc;
        cbClsExtra    : 0;
        cbWndExtra    : SizeOf(Pointer);
        hInstance     : 0;
        hIcon         : 0;
        hCursor       : 0;
        hbrBackground : 0;
        lpszMenuName  : nil;
        lpszClassName : 'XSocketWindowClass');


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Allocate a window handle. This means registering a window class the first }
{ time we are called, and creating a new window each time we are called.    }
function XSocketAllocateHWnd(Obj : TObject): HWND;
var
    TempClass       : TWndClass;
    ClassRegistered : Boolean;
begin
    { Check if the window class is already registered                       }
    XSocketWindowClass.hInstance := HInstance;
    ClassRegistered := GetClassInfo(HInstance,
                                    XSocketWindowClass.lpszClassName,
                                    TempClass);
    if not ClassRegistered then begin
       { Not yet registered, do it right now                                }
       Result := WinProcs.RegisterClass(XSocketWindowClass);
       if Result = 0 then
           Exit;
    end;

    { Now create a new window                                               }
    Result := CreateWindowEx(WS_EX_TOOLWINDOW,
                           XSocketWindowClass.lpszClassName,
                           '',        { Window name   }
                           WS_POPUP,  { Window Style  }
                           0, 0,      { X, Y          }
                           0, 0,      { Width, Height }
                           0,         { hWndParent    }
                           0,         { hMenu         }
                           HInstance, { hInstance     }
                           nil);      { CreateParam   }

    { if successfull, the ask windows to store the object reference         }
    { into the reserved byte (see RegisterClass)                            }
    if (Result <> 0) and Assigned(Obj) then
        SetWindowLong(Result, 0, Integer(Obj));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Free the window handle                                                    }
procedure XSocketDeallocateHWnd(Wnd: HWND);
begin
    DestroyWindow(Wnd);
end;
{$ENDIF}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
constructor TCustomWSocket.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);

{$IFDEF VER80}
    { Delphi 16 bits has no thread, we can use the VCL                      }
    FWindowHandle := AllocateHWnd(WndProc);
{$ELSE}
    { Delphi 32 bits has threads and VCL is not thread safe.                }
    { We need to do our own way to be thread safe.                          }
    FWindowHandle := XSocketAllocateHWnd(Self);
{$ENDIF}

    FBufList       := TList.Create;
    FBufSize       := 1514;                { Default buffer size }
    FDnsResultList := TStringList.Create;

    AssignDefaultValue;

    GSocketCount := GSocketCount + 1;

    if not (csDesigning in ComponentState) then
        LoadWinsock(WINSOCKET);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
destructor TCustomWSocket.Destroy;
var
    nItem : Integer;
begin
    CancelDnsLookup;                 { Cancel any pending dns lookup      }

    if FState <> wsClosed then       { Close the socket if not yet closed }
        Close;

    GSocketCount := GSocketCount - 1;
    if (not (csDesigning in ComponentState)) and
       (DllStarted) and
       (GSocketCount <= 0) then begin
        WSACleanup;
        DllStarted   := FALSE;
        GSocketCount := 0;
    end;

    for nItem := 0 to FBufList.Count - 1 do
        TBuffer(FBufList.Items[nItem]).Free;
    FBufList.Free;
    FDnsResultList.Free;

{$IFDEF VER80}
    DeallocateHWnd(FWindowHandle);
{$ELSE}
    XSocketDeallocateHWnd(FWindowHandle);
{$ENDIF}

    inherited Destroy;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomWSocket.Dup(NewHSocket : TSocket);
var
    iStatus : Integer;
begin
    if (NewHSocket = 0) or (NewHSocket = INVALID_SOCKET) then begin
        WSASetLastError(WSAEINVAL);
        SocketError('Dup');
        Exit;
    end;

    if FState <> wsClosed then begin
        iStatus := CloseSocket(FHSocket);
        FHSocket := INVALID_SOCKET;
        if iStatus <> 0 then begin
            SocketError('Dup (closesocket)');
            Exit;
        end;

        ChangeState(wsClosed);
    end;
    FHsocket := NewHSocket;
    SetLingerOption;

    iStatus := WSAASyncSelect(FHSocket, Handle, WM_ASYNCSELECT,
                                 FD_READ or FD_WRITE or FD_CLOSE or FD_CONNECT);
    if iStatus <> 0 then begin
        SocketError('WSAAsyncSelect');
        Exit;
    end;

    ChangeState(wsConnected);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Wait for a given event.                                                   }
{ Return TRUE if the event has occured or FALSE if any error or user abort  }
function TCustomWSocket.Wait(Timeout : integer; State : TSocketState) : boolean;
var
    Tick : LongInt;
begin
    Result := FALSE;
    if FState <> State then begin
        FStateWaited := State;
{$IFDEF VER80}
        if TRUE then begin
{$ELSE}
        if FMultiThreaded then begin
            Tick := GetTickCount + Timeout * 1000;
            while (GetTickCount < Tick) and (FState <> State) do
                ProcessMessages;
        end
        else begin
{$ENDIF}
            if FWait <> nil then begin
                FWait.Caption := IntToStr(Timeout);
                FWait.Visible := TRUE;
                FWait.StartModal;
                FWait.Visible := FALSE;
            end
            else begin
                WSASetLastError(WSANO_DATA);
                SocketError('TWSocket.Wait');
                Exit;
            end;
        end;

        Result := (FState = State);
        FStateWaited := wsInvalidState;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Get the number of char received and waiting to be read                    }
function TCustomWSocket.GetRcvdCount : LongInt;
begin
    if IoctlSocket(FHSocket, FIONREAD, Result) = SOCKET_ERROR then begin
        Result := -1;
        SocketError('ioctlSocket');
        Exit;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomWSocket.ReadLineStart;
begin
    if not ReadLineFlag then begin
        ReadLineBuffer := '';
        ReadLineCount  := 0;
        ReadLineFlag   := TRUE;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TCustomWSocket.CheckFWait : Boolean;
begin
    Result := Assigned(FWait);
    if not Result then
        RaiseException('No wait object assigned');
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomWSocket.ReadLine(Timeout : integer; var Buffer : String);
var
    Tick : LongInt;
begin
    if (not FMultiThreaded) and (not CheckFWait) then
        Exit;

    ReadLineStart;
    ReadLineReceive;

    if ReadLineFlag then begin
{$IFDEF VER80}
        if TRUE then begin
{$ELSE}
        if FMultiThreaded then begin
            Tick := GetTickCount + Timeout * 1000;
            while (GetTickCount < Tick) and ReadLineFlag do
                ProcessMessages;
        end
        else begin
{$ENDIF}
            FWait.Caption := IntToStr(Timeout);
            FWait.Visible := TRUE;
            FWait.StartModal;
            FWait.Visible := FALSE;
        end;
    end;
    Buffer := ReadLineBuffer;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomWSocket.ReadLineReceive;
var
    Status    : Integer;
    Ch        : Char;
    bMore     : Boolean;
    LastError : Integer;
    lCount    : LongInt;
begin
    bMore := True;
    while bMore do begin
        if FHSocket = INVALID_SOCKET then begin
            ReadLineFlag  := FALSE;
            if (not FMultiThreaded) and (FWait <> nil) then
                FWait.Stop;
            break;
        end;

        Status := -2;
        if FState = wsConnected then begin
            if IoctlSocket(FHSocket, FIONREAD, lCount) = SOCKET_ERROR then begin
                ReadLineFlag  := FALSE;
                SocketError('ioctlSocket');
                Exit;
            end
            else if lCount > 0 then
                Status := Recv(FHSocket, Ch, 1, 0);
        end;

        if Status = 1 then begin
            FReadCount                    := FReadCount + 1;
            if (Ch <> #10) and (Ch <> #13) then begin
                ReadLineCount                 := ReadLineCount + 1;
                ReadLineBuffer[ReadLineCount] := Ch;
                ReadLineBuffer[0]             := chr(ReadLineCount);
            end;
            { If buffer full, do as we received a LF (End Of Line) }
            if ReadLineCount >= High(ReadLineBuffer) - 1 then begin
                Ch := #10;
                if Assigned(FOnLineTooLong) then
                    FOnLineTooLong(Self);
            end;

            { Stop if end of line found (LF char) }
            if Ch = #10 then begin
                bMore         := FALSE;
                ReadLineFlag  := FALSE;
                if (not FMultiThreaded) and (FWait <> nil) then
                    FWait.Stop;
            end;
        end
        else if Status = 0 then begin
            { Connection closed }
            bMore         := FALSE;
            ReadLineFlag  := FALSE;
            if (not FMultiThreaded) and (FWait <> nil) then
                FWait.Stop;
            Close;
        end
        else if Status = SOCKET_ERROR then begin
            LastError := WSAGetLastError;
            if LastError = WSAECONNRESET then begin
                bMore := FALSE;
                ReadLineFlag  := FALSE;
                if (not FMultiThreaded) and (FWait <> nil) then
                    FWait.Stop;
                Close;
            end
            else if LastError <> WSAEWOULDBLOCK then begin
                SocketError('ReadLine');
                Exit;
            end;
        end
        else
            bMore := FALSE;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomWSocket.ChangeState(NewState : TSocketState);
var
    OldState : TSocketState;
begin
    OldState := FState;
    FState   := NewState;

    TriggerChangeState(OldState, NewState);

    if (not MultiThreaded) and (FWait <> nil) then begin
        if FStateWaited = NewState then
            FWait.Stop
        else begin
           if (FStateWaited = wsConnected) and (NewState = wsClosed) then
               FWait.Stop;
        end;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ The socket is non-blocking, so this routine will only receive as much     }
{ data as it is available.                                                  }
function TCustomWSocket.Receive(Buffer : Pointer; BufferSize: integer) : integer;
begin
    Result := Recv(FHSocket, Buffer^, BufferSize, 0);
    if Result < 0 then
        FLastError := WSAGetLastError
    else
        FReadCount := FReadCount + Result;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Receive as much data as possible into a string                            }
function TCustomWSocket.ReceiveStr : string;
var
    lCount : LongInt;
begin
    SetLength(Result, 0);
    IoctlSocket(FHSocket, FIONREAD, lCount);
{$IFDEF VER80}
    { Delphi 1 strings are limited }
    if lCount > High(Result) then
        lCount := High(Result);
{$ENDIF}
    if lCount > 0 then begin
        SetLength(Result, lCount);
        lCount := Recv(FHSocket, Result[1], lCount, 0);
        if lCount > 0 then
            SetLength(Result, lCount)
        else
            SetLength(Result, 0);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TCustomWSocket.ReceiveFrom(Buffer      : Pointer;
                              BufferSize  : Integer;
                              var From    : TSockAddr;
                              var FromLen : Integer) : integer;
begin
    Result := RecvFrom(FHSocket, Buffer^, BufferSize, 0, From, FromLen);
    if Result < 0 then
        FLastError := WSAGetLastError
    else
        FReadCount := FReadCount + Result;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TCustomWSocket.PeekData(Buffer : Pointer; BufferSize: integer) : integer;
begin
    Result := Recv(FHSocket, Buffer^, BufferSize, MSG_PEEK);
    if Result < 0 then
        FLastError := WSAGetLastError;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function SearchChar(Data : PChar; Len : Integer; Ch : Char) : PChar;
begin
    while Len > 0 do begin
        Len := Len - 1;
        if Data^ = Ch then begin
            Result := Data;
            exit;
        end;
        Data := Data + 1;
    end;
    Result := nil;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomWSocket.TryToSend;
var
    oBuffer   : TBuffer;
    Len       : Integer;
    Count     : Integer;
    Data      : Pointer;
    LastError : Integer;
    p         : PChar;
    bMore     : Boolean;
begin
    if (FHSocket = INVALID_SOCKET) or                { No more socket      }
       (FBufList.Count = 0) or                       { Nothing to send     }
       (bMoreFlag and (nMoreCnt >= nMoreMax)) then   { Waiting more signal }
        exit;

    bMore := TRUE;
    while bMore do begin
        oBuffer := FBufList.First;
        Data    := oBuffer.Peek(Len);
        if Len <= 0 then begin
            { Buffer is empty }
            if FBufList.Count <= 1 then begin
                { Every thing has been sent }
                bAllSent := TRUE;
                bMore    := FALSE;
            end
            else begin
                oBuffer.Free;
                FBufList.Delete(0);
                FBufList.Pack;
            end;
        end
        else begin
            if bMoreFlag then begin
                p := SearchChar(Data, Len, #10);
                if Assigned(p) then begin
                    len := p - PChar(Data) + 1;
                    nMoreCnt := nMoreCnt + 1;
                    if nMoreCnt >= nMoreMax then
                        bMore := FALSE;
                end;
            end;

            if FType = SOCK_DGRAM then
                Count := WinSock.SendTo(FHSocket, Data^, Len, FSendFlags,
                                        TSockAddr(sin), SizeOf(sin))
            else begin
                Count := WinSock.Send(FHSocket, Data^, Len, FSendFlags);
            end;

            if Count = 0 then
                bMore := FALSE  { Closed by remote }
            else if count = SOCKET_ERROR then begin
                LastError := WSAGetLastError;
                if (LastError = WSAECONNRESET) or (LastError = WSAENOTSOCK) or
                   (LastError = WSAENOTCONN) or (LastError = WSAEINVAL)
                then begin
                    Close;
                end
                else if LastError <> WSAEWOULDBLOCK then begin
                    SocketError('TryToSend failed');
                    Exit;
                end;
                bMore := FALSE;
            end
            else begin
                oBuffer.Remove(Count);
                if Count < Len then begin
                    { Could not write as much as we wanted. Stop sending }
                    bWrite := FALSE;
                    bMore  := FALSE;
                end;
            end;
        end;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomWSocket.PutStringInSendBuffer(Str : String);
begin
    PutDataInSendBuffer(@Str[1], Length(Str));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomWSocket.PutDataInSendBuffer(Data : Pointer; Len : Integer);
var
    oBuffer  : TBuffer;
    cWritten : Integer;
    bMore    : Boolean;
begin
    if Len <= 0 then
        exit;

    if FBufList.Count = 0 then begin
        oBuffer := TBuffer.Create(FBufSize);
        FBufList.Add(oBuffer);
    end
    else
        oBuffer := FBufList.Last;

    bMore := TRUE;
    while bMore do begin
        cWritten := oBuffer.Write(Data, Len);
        if cWritten >= Len then
            bMore := FALSE
        else begin
            Len  := Len - cWritten;
            Data := PChar(Data) + cWritten;
            if Len < 0 then
                bMore := FALSE
            else begin
                oBuffer := TBuffer.Create(FBufSize);
                FBufList.Add(oBuffer);
            end;
        end;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Return -1 if error, else return number of byte written                    }
function TCustomWSocket.Send(Data : Pointer; Len : Integer) : integer;
begin
    if FState <> wsConnected then begin
        WSASetLastError(WSAENOTCONN);
        SocketError('Send');
        Result := -1;
        Exit;
    end;

    bAllSent := FALSE;
    if Len <= 0 then
        Result := 0
    else begin
        Result   := Len;
        PutDataInSendBuffer(Data, Len);
    end;

    if bAllSent then
        Exit;

    TryToSend;

    if bAllSent then begin
        { We post a message to fire the FD_WRITE message wich in turn will }
        { fire the OnDataSent event. We cannot fire the event ourself      }
        { because the event handler will eventually call send again.       }
        { Sending the message prevent recursive call and stack overflow.   }
        { The PostMessage function posts (places) a message in a window's  }
        { message queue and then returns without waiting for the           }
        { corresponding window to process the message. The message will be }
        { seen and routed by Delphi a litle later, when we will be out of  }
        { the send function.                                               }
        PostMessage(Handle,
                    WM_ASYNCSELECT,
                    FHSocket,
                    MakeLong(FD_WRITE, 0));
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Return -1 if error, else return number of byte written                    }
function TCustomWSocket.SendStr(Str : String) : integer;
begin
   Result := Send(@Str[1], Length(Str));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomWSocket.SendText(Str : String);
begin
    SendStr(Str);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomWSocket.ASyncReceive(var msg: TMessage);
var
    bMore  : Boolean;
    lCount : LongInt;
begin
    bMore := TRUE;
    while bMore do begin
        FLastError := 0;

        try
           if ReadLineFlag then
               ReadLineReceive
           else if not TriggerDataAvailable(msg.lParamHi) then
               Break; { Nothing wants to receive }

           if FLastError <> 0 then
               bMore := FALSE
           {* Check if we have something new arrived, if yes, process it *}
           else if IoctlSocket(FHSocket, FIONREAD, lCount) = SOCKET_ERROR then begin
               FLastError := WSAGetLastError;
               bMore      := FALSE;
           end
           else if lCount = 0 then
               bMore := FALSE;
        except
           bMore := FALSE;
        end;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomWSocket.WMASyncSelect(var msg: TMessage);
var
    Check  : Word;
begin
    { Verify that the socket handle is ours handle }
    if msg.wParam <> FHSocket then
        Exit;

    if FPaused then
        exit;

    Check := msg.lParamLo and FD_CONNECT;
    if Check <> 0 then begin
        ChangeState(wsConnected);
        TriggerSessionConnected(msg.lParamHi);
        if (msg.lParamHi <> 0) and (FState <> wsClosed) then
            Close;
    end;

    Check := msg.lParamLo and FD_READ;
    if Check <> 0 then begin
        ASyncReceive(msg);
    end;

    Check := msg.lParamLo and FD_WRITE;
    if Check <> 0 then begin
        TryToSend;
        if bAllSent and Assigned(FOnDataSent) then
            TriggerDataSent(msg.lParamHi);
    end;

    Check := msg.lParamLo and FD_ACCEPT;
    if Check <> 0 then begin
        TriggerSessionAvailable(msg.lParamHi);
    end;

    Check := msg.lParamLo and FD_CLOSE;
    if Check <> 0 then begin
        {* In some strange situations I found that we receive a FD_CLOSE *}
        {* during the connection phase, breaking the connection early !  *}
        {* This occurs for example after a failed FTP transfert          *}
        if FState <> wsConnecting then begin
            {* Check if we have something arrived, if yes, process it *}
            ASyncReceive(msg);

            {* If we are busy reading a line, we need to terminate it *}
            if ReadLineFlag then begin
                ReadLineFlag  := FALSE;
                if (not FMultiThreaded) and (FWait <> nil) then
                    FWait.Stop;
            end;

            if Assigned(FOnSessionClosed) and (not FCloseInvoked) then begin
                FCloseInvoked := TRUE;
                TriggerSessionClosed(msg.lParamHi);
            end;
            if FState <> wsClosed then
                Close;
        end;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure GetIPList(phe  : PHostEnt; ToList : TStrings);
type
    TaPInAddr = array [0..255] of PInAddr;
    PaPInAddr = ^TaPInAddr;
var
    pptr : PaPInAddr;
    I    : Integer;
begin
    pptr := PaPInAddr(Phe^.h_addr_list);

    I := 0;
    while pptr^[I] <> nil do begin
        ToList.Add(StrPas(inet_ntoa(pptr^[I]^)));
        Inc(I);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomWSocket.WMAsyncGetHostByName(var msg: TMessage);
var
    Phe     : Phostent;
    Error   : Word;
begin
    if msg.wParam <> FDnsLookupHandle then
        Exit;
    FDnsLookupHandle := 0;
    Error := Msg.LParamHi;
    if Error = 0 then begin
        Phe        := PHostent(@FDnsLookupBuffer);
        if phe <> nil then begin
            GetIpList(Phe, FDnsResultList);
            FDnsResult := FDnsResultList.Strings[0];
        end;
    end;
    TriggerDnsLookupDone(Error);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomWSocket.SetProto(sProto : String);
var
    szProto : array [0..31] of char;
    Ppe     : Pprotoent;
begin
    if FProtoAssigned and (sProto = FProtoStr) then
        Exit;

    FProtoStr := sProto;
    if csDesigning in ComponentState then
        Exit;

    if FState <> wsClosed then begin
        RaiseException('Cannot change Proto if not closed');
        Exit;
    end;

    sProto := Trim(sProto);
    if sProto = 'not found' then
        Exit;
    FProtoAssigned := TRUE;

    if IsDigit(sProto[1]) then
        FProto := atoi(sProto)
    else begin
        StrPCopy(szProto, sProto);
        if not DllStarted then LoadWinsock(WINSOCKET);
        ppe := GetProtoByName(szProto);
        if Ppe = nil then begin
            FProtoAssigned := FALSE;
            SocketError('SetProto: Cannot convert protocol ''' + sProto + '''');
            Exit;
        end
        else
            FProto := ppe^.p_proto;
    end;

    if FProto = IPPROTO_UDP then
        FType := SOCK_DGRAM
    else
        FType := SOCK_STREAM;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TCustomWSocket.GetProto : String;
begin
    Result := FProtoStr;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomWSocket.SetPort(sPort : String);
var
    szPort   : array [0..31] of char;
    szProto  : array [0..31] of char;
    Pse      : Pservent;
begin
    if FPortAssigned and (FPortStr = sPort) then
        Exit;

    FPortStr := sPort;
    if csDesigning in ComponentState then
        Exit;

    if FState <> wsClosed then begin
        RaiseException('Cannot change Port if not closed');
        Exit;
    end;

    FPortAssigned := TRUE;
    sPort         := Trim(sPort);
    if IsDigit(sPort[1]) then
        sin.sin_port := htons(atoi(sPort))
    else begin
        StrPCopy(szPort, sPort);
        StrPCopy(szProto, GetProto);
        if not DllStarted then LoadWinsock(WINSOCKET);
        if szProto[0] = #0 then
            Pse := WinSock.GetServByName(szPort, nil)
        else
            Pse := WinSock.GetServByName(szPort, szProto);
        if Pse = nil then begin
            FPortAssigned := FALSE;
            SocketError('SetPort: Cannot convert port ''' + sPort + '''');
            Exit;
        end
        else
            sin.sin_port := Pse^.s_port;
    end;
    FPortNum := ntohs(sin.sin_port);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TCustomWSocket.GetPort : String;
begin
    Result := FPortStr;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TCustomWSocket.GetXPort: string;
var
    saddr    : TSockAddrIn;
    saddrlen : integer;
    port     : integer;
begin
    Result := 'error';
    if FState in [wsConnected, wsBound, wsListening] then begin
        saddrlen := sizeof(saddr);
        if WinSock.GetSockName(FHSocket, TSockAddr(saddr), saddrlen) = 0 then begin
            port     := ntohs(saddr.sin_port);
            Result   := Format('%d',[port]);
        end;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomWSocket.SetAddr(InAddr : String);
begin
    if FAddrAssigned and (FAddrStr = InAddr) then
        Exit;

    FAddrStr := InAddr;
    if csDesigning in ComponentState then
        Exit;

    if FState <> wsClosed then begin
        RaiseException('Cannot change Addr if not closed');
        Exit;
    end;

    FAddrAssigned       := FALSE;
    sin.sin_addr.s_addr := WSocketResolveHost(InAddr).s_addr;
    FAddrAssigned       := TRUE;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function WSocketResolveHost(InAddr : String) : TInAddr;
var
    szData  : array [0..256] of char;
    Phe     : Phostent;
    IPAddr  : u_long;
begin
    StrPCopy(szData, Trim(InAddr));
    if not DllStarted then
        LoadWinsock(WINSOCKET);
    IPAddr := Inet_addr(szData);
{$IFDEF VER80}
    { With Trumpet Winsock 2B and 30D (win 3.11), inet_addr returns faulty }
    { results for 0.0.0.0                                                  }
    if (IPAddr = INADDR_NONE) and (StrComp(szData, '0.0.0.0') = 0) then begin
        IPAddr        := 0;
        Result.s_addr := IPAddr;
        Exit;
    end;
{$ENDIF}
    if IPAddr = INADDR_NONE then begin
        if StrComp(szData, '255.255.255.255') = 0 then
            IPAddr := INADDR_BROADCAST
        else begin
            Phe := WinSock.GetHostByName(szData);
            if Phe = nil then begin
                raise ESocketException.CreateFmt(
                         'SetAddr: Cannot convert host address ''%s''',
                         [InAddr]);
            end
            else
                IPAddr := PInAddr(Phe^.h_addr_list^)^.s_addr;
        end;
    end;
    Result.s_addr := IPAddr;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TCustomWSocket.GetAddr : String;
begin
    Result := FAddrStr;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TCustomWSocket.GetSockName(var saddr : TSockAddrIn; var saddrlen : Integer) : integer;
begin
    Result := WinSock.GetSockName(FHSocket, TSockAddr(saddr), saddrlen);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TCustomWSocket.GetPeerAddr: string;
var
    saddr    : TSockAddrIn;
    saddrlen : integer;
    szAddr   : PChar;
begin
    Result := 'error';
    if FState = wsConnected then begin
        saddrlen := sizeof(saddr);
        if WinSock.GetPeerName(FHSocket, TSockAddr(saddr), saddrlen) = 0 then begin
            szAddr := Inet_ntoa(saddr.sin_addr);
            Result := StrPas(szAddr);
        end
        else begin
            SocketError('GetPeerName');
            Exit;
        end;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TCustomWSocket.GetPeerName(var Name : TSockAddrIn; NameLen : Integer) : integer;
begin
    if FState = wsConnected then
        Result := WinSock.GetPeerName(FHSocket, TSockAddr(Name), NameLen)
    else
        Result := SOCKET_ERROR;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomWSocket.CancelDnsLookup;
begin
    if FDnsLookupHandle = 0 then
        Exit;
    if WSACancelAsyncRequest(FDnsLookupHandle) <> 0 then begin
        FDnsLookupHandle := 0;
        SocketError('WSACancelAsyncRequest');
        Exit;
    end;
    FDnsLookupHandle := 0;

    if not (csDestroying in ComponentState) then
        TriggerDnsLookupDone(WSAEINTR);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomWSocket.DnsLookup(HostName : String);
var
    IPAddr  : TInAddr;
begin
    if HostName = '' then begin
        RaiseException('DNS lookup: invalid host name.');
        TriggerDnsLookupDone(WSAEINVAL);
        Exit;
    end;

    { Cancel any pending lookup }
    if FDnsLookupHandle <> 0 then
        WSACancelAsyncRequest(FDnsLookupHandle);

    FDnsResult := '';
    FDnsResultList.Clear;

{$IFDEF VER80}
    { Delphi 1 do not automatically add a terminating nul char }
    HostName := HostName + #0;
{$ENDIF}
    IPAddr.S_addr := Inet_addr(@HostName[1]);
    if IPAddr.S_addr <> INADDR_NONE then begin
        FDnsResult := StrPas(inet_ntoa(IPAddr));
        TriggerDnsLookupDone(0);
        Exit;
    end;

    FDnsLookupHandle := WSAAsyncGetHostByName(FWindowHandle,
                                              WM_ASYNCGETHOSTBYNAME,
                                              @HostName[1],
                                              @FDnsLookupBuffer,
                                              SizeOf(FDnsLookupBuffer));
    if FDnsLookupHandle = 0 then begin
        RaiseExceptionFmt(
                  '%s: can''t start DNS lookup, error #%d',
                  [HostName, WSAGetLastError]);
        Exit;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomWSocket.BindSocket;
var
    SockName      : TSockAddr;
    SockNamelen   : Integer;
    LocalSockName : TSockAddrIn;
begin
    FillChar(LocalSockName, Sizeof(LocalSockName), 0);
    SockNamelen                   := sizeof(LocalSockName);
    LocalSockName.sin_family      := AF_INET;
    LocalSockName.sin_port        := 0;
    LocalSockName.sin_addr.s_addr := INADDR_ANY;

    if bind(HSocket, LocalSockName, SockNamelen) <> 0 then begin
        RaiseExceptionFmt('winsock.bind failed, error #%d', [WSAGetLastError]);
        Exit;
    end;
    SockNamelen := sizeof(SockName);
    if winsock.getsockname(FHSocket, SockName, SockNamelen) <> 0 then begin
        RaiseExceptionFmt('winsock.getsockname failed, error #%d',
                          [WSAGetLastError]);
        Exit;
    end;
    FLocalPort := ntohs(SockName.sin_port);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomWSocket.SetLingerOption;
var
    iStatus : integer;
    li      : TLinger;
begin
    if FLingerOnOff = wsLingerNoSet then
        Exit;                            { Option set is disabled, ignore }

    if FHSocket = INVALID_SOCKET then begin
        RaiseException('Cannot set linger option at this time');
        Exit;
    end;

    li.l_onoff  := Ord(FLingerOnOff);    { 0/1 = disable/enable linger }
    li.l_linger := FLingerTimeout;       { timeout in seconds          }
    iStatus     := SetSockOpt(FHSocket, SOL_SOCKET, SO_LINGER, @li, SizeOf(li));

    if iStatus <> 0 then begin
        SocketError('setsockopt(SO_LINGER)');
        Exit;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomWSocket.Connect;
var
    iStatus : integer;
    optval  : integer;
begin
    if (FHSocket <> INVALID_SOCKET) and (FState <> wsClosed) then begin
        RaiseException('Connect: Socket already in use');
        Exit;
    end;

    if  not FPortAssigned then begin
        RaiseException('Connect: No Port Specified');
        Exit;
    end;

    if not FAddrAssigned then begin
        RaiseException('Connect: No IP Address Specified');
        Exit;
    end;

    if not FProtoAssigned then begin
        RaiseException('Connect: No Protocol Specified');
        Exit;
    end;

    FHSocket := WinSock.Socket(FAddrFormat, FType, FProto);
    if FHSocket = INVALID_SOCKET then begin
        SocketError('Connect (socket)');
        Exit;
    end;
    ChangeState(wsOpened);

    if FType = SOCK_DGRAM then begin
        BindSocket;
        if sin.sin_addr.s_addr = INADDR_BROADCAST then begin
            OptVal  := 1;
            iStatus := SetSockOpt(FHSocket, SOL_SOCKET, SO_BROADCAST,
                                 PChar(@OptVal), SizeOf(OptVal));
            if iStatus <> 0 then begin
                SocketError('setsockopt(SO_BROADCAST)');
                Exit;
            end;
        end;
    end
    else begin
        { Socket type is SOCK_STREAM }
        SetLingerOption;

        optval  := -1;
        iStatus := SetSockOpt(FHSocket, SOL_SOCKET, SO_KEEPALIVE, @optval, SizeOf(optval));

        if iStatus <> 0 then begin
            SocketError('setsockopt(SO_KEEPALIVE)');
            Exit;
        end;

        optval  := -1;
        iStatus := SetSockOpt(FHSocket, SOL_SOCKET, SO_REUSEADDR, @optval, SizeOf(optval));

        if iStatus <> 0 then begin
            SocketError('setsockopt(SO_REUSEADDR)');
            Exit;
        end;
    end;

    iStatus := WSAASyncSelect(FHSocket, Handle, WM_ASYNCSELECT,
                              FD_READ   or FD_WRITE or FD_CLOSE or
                              FD_ACCEPT or FD_CONNECT);
    if iStatus <> 0 then begin
        SocketError('WSAAsyncSelect');
        Exit;
    end;

    if FType = SOCK_DGRAM then begin
        ChangeState(wsConnected);
        TriggerSessionConnected(0);
    end
    else begin
        iStatus := WinSock.Connect(FHSocket, TSockAddr(sin), sizeof(sin));
        if iStatus = 0 then
            ChangeState(wsConnecting)
        else begin
            iStatus := WSAGetLastError;
            if iStatus = WSAEWOULDBLOCK then
                ChangeState(wsConnecting)
            else begin
                FLastError := WSAGetLastError;
                SocketError('Connect');
                Exit;
            end;
        end;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TCustomWSocket.Listen : Integer;
var
    iStatus : integer;
begin
    Result := SOCKET_ERROR;

    if not FPortAssigned then begin
        WSASetLastError(WSAEINVAL);
        SocketError('listen: port not assigned');
        Exit;
    end;

    if not FProtoAssigned then begin
        WSASetLastError(WSAEINVAL);
        SocketError('listen: protocol not assigned');
        Exit;
    end;

    if not FAddrAssigned then begin
        WSASetLastError(WSAEINVAL);
        SocketError('listen: address not assigned');
        Exit;
    end;

    FHSocket := WinSock.Socket(FAddrFormat, FType, FProto);

    if FHSocket = INVALID_SOCKET then begin
        SocketError('socket');
        exit;
    end;

    iStatus := Bind(FHSocket, TSockAddr(sin), sizeof(sin));
    if iStatus = 0 then
        ChangeState(wsBound)
    else begin
        SocketError('Bind');
        Close;
        exit;
    end;

    if FType = SOCK_DGRAM then begin
        ChangeState(wsListening);
        ChangeState(wsConnected);
        TriggerSessionConnected(0);
    end
    else if FType = SOCK_STREAM then begin
        iStatus := WinSock.Listen(FHSocket, 5);
        if iStatus = 0 then
            ChangeState(wsListening)
        else begin
            SocketError('Listen');
            Exit;
        end;
    end;

    iStatus := WSAASyncSelect(FHSocket, Handle, WM_ASYNCSELECT,
                              FD_READ   or FD_WRITE or
                              FD_ACCEPT or FD_CLOSE);
    if iStatus = 0 then
        Result := 0
    else begin
        SocketError('WSAASyncSelect');
        exit;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TCustomWSocket.Accept: TSocket;
var
   len     : integer;
begin
    if FState <> wsListening then begin
        WSASetLastError(WSAEINVAL);
        SocketError('not a listening socket');
        Result := INVALID_SOCKET;
        Exit;
    end;

    len := sizeof(sin);
{$IFDEF VER100}
    { Delphi 3 has changed var parameters to pointers }
    FASocket := WinSock.Accept(FHSocket, @sin, @len);
{$ELSE}
{$IFDEF VER110}
    { C++Builder 3 has changed var parameters to pointers }
    FASocket := WinSock.Accept(FHSocket, @sin, @len);
{$ELSE}
//    FASocket := WinSock.Accept(FHSocket, TSockAddr(sin), len);
    FASocket := WinSock.Accept(FHSocket, @sin, @len);
{$ENDIF}
{$ENDIF}
    if FASocket = INVALID_SOCKET then begin
        SocketError('Accept');
        Result := INVALID_SOCKET;
        Exit;
    end
    else
        Result := FASocket;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomWSocket.Pause;
begin
    FPaused := TRUE;
    WSAASyncSelect(FHSocket, Handle, 0, 0);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomWSocket.Resume;
begin
    FPaused := FALSE;
    WSAASyncSelect(FHSocket, Handle, WM_ASYNCSELECT,
                      FD_READ or FD_WRITE or FD_CLOSE or FD_CONNECT);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomWSocket.Shutdown(How : Integer);
begin
    if FHSocket <> INVALID_SOCKET then
        WinSock.Shutdown(FHSocket, How);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomWSocket.Abort;
begin
    InternalClose(FALSE);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomWSocket.Close;
begin
    InternalClose(TRUE);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomWSocket.Flush;
begin
{$IFDEF VER80}
    if TRUE then begin
{$ELSE}
    if FMultiThreaded then begin
        while (FHSocket <> INVALID_SOCKET) and     { No more socket   }
              (not bAllSent) do begin              { Nothing to send  }
                {Break;}
            TryToSend;
            ProcessMessages;
        end;
    end
    else begin
{$ENDIF}
        if not CheckFWait then
            Exit;
        FWait.Caption := IntToStr(FFlushTimeout);
        FWait.Visible := TRUE;
        FWait.Start;
        try
            while FWait.Running and                    { Not timedout     }
                  (FHSocket <> INVALID_SOCKET) and     { No more socket   }
                   (not bAllSent) do begin             { Nothing to send  }
                    { Break; }
                TryToSend;
                Application.ProcessMessages;
            end;
        finally
            FWait.Stop;
            FWait.Visible := FALSE;
        end;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomWSocket.InternalClose(bShut : Boolean);
var
    iStatus: integer;
begin
    if FHSocket = INVALID_SOCKET then begin
        if FState <> wsClosed then begin
            ChangeState(wsClosed);
            AssignDefaultValue;
        end;
        exit;
    end;

    if FState = wsClosed then
        Exit;

    if bShut then
        ShutDown(2);

    if FHSocket <> INVALID_SOCKET then begin
        repeat
            iStatus := CloseSocket(FHSocket);
            FHSocket := INVALID_SOCKET;
            if iStatus <> 0 then begin
                FLastError := WSAGetLastError;
                if FLastError <> WSAEWOULDBLOCK then begin
                    SocketError('Disconnect (closesocket)');
                    Exit;
                end;
{$IFDEF VER80}
                Application.ProcessMessages;
{$ELSE}
                if FMultiThreaded then
                    ProcessMessages
                else
                    Application.ProcessMessages;
{$ENDIF}
            end;
        until iStatus = 0;
    end;

    ChangeState(wsClosed);
    if (not (csDestroying in ComponentState)) and
       (not FCloseInvoked) and Assigned(FOnSessionClosed) then begin
        FCloseInvoked := TRUE;
        TriggerSessionClosed(0);
    end;
    AssignDefaultValue;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomWSocket.WaitForClose;
var
    lCount    : LongInt;
    Status    : Integer;
    Ch        : Char;
begin
    while (FHSocket <> INVALID_SOCKET) and (FState <> wsClosed) do begin
        Application.ProcessMessages;
        if IoctlSocket(FHSocket, FIONREAD, lCount) = SOCKET_ERROR then
            break;
        if lCount > 0 then begin
            if ReadLineFlag then
                ReadLineReceive
            else
                TriggerDataAvailable(0);
        end;

        Status := Recv(FHSocket, Ch, 0, 0);
        if Status <= 0 then begin
            FLastError := WSAGetLastError;
            if FLastError <> WSAEWOULDBLOCK then
                break;
        end;
        Application.ProcessMessages;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function WSocketGetHostByAddr(Addr : String) : PHostEnt;
var
    szAddr : array[0..256] of char;
    lAddr  : u_long;
begin
    if not DllStarted then
        LoadWinsock(WINSOCKET);
    StrPCopy(szAddr, Addr);
    lAddr  := Inet_addr(szAddr);
    Result := WinSock.GetHostByAddr(PChar(@lAddr), 4, PF_INET);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function WSocketGetHostByName(Name : String) : PHostEnt;
var
    szName : array[0..256] of char;
begin
    if not DllStarted then
        LoadWinsock(WINSOCKET);
    StrPCopy(szName, Name);
    Result := WinSock.GetHostByName(szName);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function LocalIPList : TStrings;
var
    phe  : PHostEnt;
begin
    IPList.Clear;
    Result := IPList;

    phe  := WSocketGetHostByName(LocalHostName);
    if phe <> nil then
        GetIpList(Phe, IPList);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function LocalHostName : String;
var
    Buffer     : array [0..63] of char;
begin
    if not DllStarted then
        LoadWinsock(WINSOCKET);
    if GetHostName(Buffer, SizeOf(Buffer)) <> 0 then
        raise ESocketException.Create('Winsock.GetHostName failed');
    Result := StrPas(Buffer);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TCustomWSocket.TimerIsSet(var tvp : TTimeVal) : Boolean;
begin
    Result := (tvp.tv_sec <> 0) or (tvp.tv_usec <> 0);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TCustomWSocket.TimerCmp(var tvp : TTimeVal; var uvp : TTimeVal; IsEqual : Boolean) : Boolean;
begin
    Result := (tvp.tv_sec = uvp.tv_sec) and (tvp.tv_usec = uvp.tv_usec);
    if not IsEqual then
        Result := not Result;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomWSocket.TimerClear(var tvp : TTimeVal);
begin
   tvp.tv_sec  := 0;
   tvp.tv_usec := 0;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomWSocket.SetSendFlags(newValue : TSocketSendFlags);
begin
    case newValue of
    wsSendNormal: FSendFlags := 0;
    wsSendUrgent: FSendFlags := MSG_OOB;
    else
        RaiseException('Invalid SendFlags');
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TCustomWSocket.GetSendFlags : TSocketSendFlags;
begin
    case FSendFlags of
    0       : Result := wsSendNormal;
    MSG_OOB : Result := wsSendUrgent;
    else
        RaiseException('Invalid internal SendFlags');
        Result := wsSendNormal;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomWSocket.TriggerSessionAvailable(Error : Word);
begin
    if Assigned(FOnSessionAvailable) then
        FOnSessionAvailable(Self, Error);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomWSocket.TriggerSessionConnected(Error : Word);
begin
    if Assigned(FOnSessionConnected) then
        FOnSessionConnected(Self, Error);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomWSocket.TriggerSessionClosed(Error : Word);
begin
    if Assigned(FOnSessionClosed) then
        FOnSessionClosed(Self, Error);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TCustomWSocket.TriggerDataAvailable(Error : Word) : Boolean;
begin
    Result := Assigned(FOnDataAvailable);
    if Result then
        FOnDataAvailable(Self, Error)
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomWSocket.TriggerDataSent(Error : Word);
begin
    if Assigned(FOnDataSent) then
        FOnDataSent(Self, Error);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomWSocket.TriggerError;
begin
    if Assigned(FOnError) then
        FOnError(Self);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomWSocket.TriggerDNSLookupDone(Error : Word);
begin
    if Assigned(FOnDNSLookupDone) then
        FOnDNSLookupDone(Self, Error);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomWSocket.TriggerChangeState(OldState, NewState : TSocketState);
begin
    if Assigned(FOnChangeState) then
        FOnChangeState(Self, OldState, NewState);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomWSocket.SocketError(sockfunc: string);
var
    error  : integer;
    line   : string;
begin
    error := WSAGetLastError;
    line  := 'Error '+ IntToStr(error) + ' in function ' + sockfunc +
             #13#10 + WSocketErrorDesc(error);

    if (error = WSAECONNRESET) or
       (error = WSAENOTCONN)   then begin
        CloseSocket(FHSocket);
        FHSocket := INVALID_SOCKET;
        ChangeState(wsClosed);
    end;

    RaiseException(line);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function WSocketErrorDesc(error: integer) : string;
begin
  case error of
    0:
      WSocketErrorDesc := 'No Error';
    WSAEINTR:
      WSocketErrorDesc := 'Interrupted system call';
    WSAEBADF:
      WSocketErrorDesc := 'Bad file number';
    WSAEACCES:
      WSocketErrorDesc := 'Permission denied';
    WSAEFAULT:
      WSocketErrorDesc := 'Bad address';
    WSAEINVAL:
      WSocketErrorDesc := 'Invalid argument';
    WSAEMFILE:
      WSocketErrorDesc := 'Too many open files';
    WSAEWOULDBLOCK:
      WSocketErrorDesc := 'Operation would block';
    WSAEINPROGRESS:
      WSocketErrorDesc := 'Operation now in progress';
    WSAEALREADY:
      WSocketErrorDesc := 'Operation already in progress';
    WSAENOTSOCK:
      WSocketErrorDesc := 'Socket operation on non-socket';
    WSAEDESTADDRREQ:
      WSocketErrorDesc := 'Destination address required';
    WSAEMSGSIZE:
      WSocketErrorDesc := 'Message too long';
    WSAEPROTOTYPE:
      WSocketErrorDesc := 'Protocol wrong type for socket';
    WSAENOPROTOOPT:
      WSocketErrorDesc := 'Protocol not available';
    WSAEPROTONOSUPPORT:
      WSocketErrorDesc := 'Protocol not supported';
    WSAESOCKTNOSUPPORT:
      WSocketErrorDesc := 'Socket type not supported';
    WSAEOPNOTSUPP:
      WSocketErrorDesc := 'Operation not supported on socket';
    WSAEPFNOSUPPORT:
      WSocketErrorDesc := 'Protocol family not supported';
    WSAEAFNOSUPPORT:
      WSocketErrorDesc := 'Address family not supported by protocol family';
    WSAEADDRINUSE:
      WSocketErrorDesc := 'Address already in use';
    WSAEADDRNOTAVAIL:
      WSocketErrorDesc := 'Address not available';
    WSAENETDOWN:
      WSocketErrorDesc := 'Network is down';
    WSAENETUNREACH:
      WSocketErrorDesc := 'Network is unreachable';
    WSAENETRESET:
      WSocketErrorDesc := 'Network dropped connection on reset';
    WSAECONNABORTED:
      WSocketErrorDesc := 'Connection aborted';
    WSAECONNRESET:
      WSocketErrorDesc := 'Connection reset by peer';
    WSAENOBUFS:
      WSocketErrorDesc := 'No buffer space available';
    WSAEISCONN:
      WSocketErrorDesc := 'Socket is already connected';
    WSAENOTCONN:
      WSocketErrorDesc := 'Socket is not connected';
    WSAESHUTDOWN:
      WSocketErrorDesc := 'Can''t send after socket shutdown';
    WSAETOOMANYREFS:
      WSocketErrorDesc := 'Too many references: can''t splice';
    WSAETIMEDOUT:
      WSocketErrorDesc := 'Connection timed out';
    WSAECONNREFUSED:
      WSocketErrorDesc := 'Connection refused';
    WSAELOOP:
      WSocketErrorDesc := 'Too many levels of symbolic links';
    WSAENAMETOOLONG:
      WSocketErrorDesc := 'File name too long';
    WSAEHOSTDOWN:
      WSocketErrorDesc := 'Host is down';
    WSAEHOSTUNREACH:
      WSocketErrorDesc := 'No route to host';
    WSAENOTEMPTY:
      WSocketErrorDesc := 'Directory not empty';
    WSAEPROCLIM:
      WSocketErrorDesc := 'Too many processes';
    WSAEUSERS:
      WSocketErrorDesc := 'Too many users';
    WSAEDQUOT:
      WSocketErrorDesc := 'Disc quota exceeded';
    WSAESTALE:
      WSocketErrorDesc := 'Stale NFS file handle';
    WSAEREMOTE:
      WSocketErrorDesc := 'Too many levels of remote in path';
    WSASYSNOTREADY:
      WSocketErrorDesc := 'Network sub-system is unusable';
    WSAVERNOTSUPPORTED:
      WSocketErrorDesc := 'WinSock DLL cannot support this application';
    WSANOTINITIALISED:
      WSocketErrorDesc := 'WinSock not initialized';
    WSAHOST_NOT_FOUND:
      WSocketErrorDesc := 'Host not found';
    WSATRY_AGAIN:
      WSocketErrorDesc := 'Non-authoritative host not found';
    WSANO_RECOVERY:
      WSocketErrorDesc := 'Non-recoverable error';
    WSANO_DATA:
      WSocketErrorDesc := 'No Data';
    else
      WSocketErrorDesc := 'Not a WinSock error';
  end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF VER80}
begin
    IPList := TStringList.Create;
{$ELSE}
initialization
    IPList := TStringList.Create;

finalization
    IPList.Destroy;

{$ENDIF}
end.

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

