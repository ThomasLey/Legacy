unit Black_System;

interface
uses
    StdCtrls, Windows, Messages, SysUtils, ShellApi,
    Classes, Graphics, Controls, Forms, Dialogs;

type TEditBlack = class(TEdit)
     public
           constructor create(aOwner: TComponent); override;
     end;

type TLabelBlack = class(TLabel)
     public
           constructor create(aOwner: TComponent); override;
     end;

type
  TBetriebsSystem = (bsWin95, bsWinNT, bsWin32, bsUnknown);

  TSystem = class(TComponent)
  private
    FHide       : Boolean;
    procedure SetHide(status: Boolean);
    function GetColorCount:Integer;
    function getTotalPhysMemory:Longint;
    function getAvailPhysMemory:Longint;
    function getTotalPageFile:Longint;
    function getAvailPageFile:Longint;
    function getWindowsDirectory:String;
    function getSystemDirectory:String;
    function getUserName:String;
    function getComputerName:String;
    function getProcessorType:String;
    function getProcessorCount:Integer;
    function getSystem: TBetriebsSystem;
  protected

  public

  published
     property ColorCount: Integer read GetColorCount;
     property Hide: Boolean read FHide write SetHide;   // True: im Taskman nicht sichtbar
     property TotalPhysMemory: Longint read getTotalPhysMemory;
     property AvailPhysMemory: Longint read getAvailPhysMemory;
     property TotalPageFile: Longint read getTotalPageFile;
     property AvailPageFile: Longint read getAvailPageFile;
     property WindowsDirectory: String read getWindowsDirectory;
     property SystemDirectory: String read getSystemDirectory;
     property UserName: String read getUserName;
     property ComputerName: String read getComputerName;
     property ProcessorType: String read getProcessorType;
     property ProcessorCount: Integer read getProcessorCount;
     property System: TBetriebsSystem read GetSystem;
  end;

procedure Register;

// Procedures and functions
implementation

constructor TEditBlack.create(aOwner: TComponent);
begin
     inherited Create(aOwner);
     Color := clBlack;
     Font.Color := clWhite;
end;

constructor TLabelBlack.create(aOwner: TComponent);
begin
     inherited Create(aOwner);
     Color := clBlack;
     Font.Color := clWhite;
end;


function TSystem.GetColorCount:Integer;
begin
   GetColorCount := 1 shl GetDeviceCaps(GetDC(0),BITSPIXEL);
end;

procedure TSystem.SetHide(status:Boolean);
begin
     FHide := Status;
     If Status then
        showwindow(application.handle,sw_hide)
     else
        showwindow(application.handle,sw_show)
end;

function TSystem.getTotalPhysMemory:Longint;
var memory : TMEMORYSTATUS;
begin
    GlobalMemoryStatus(memory);
    getTotalPhysMemory:= memory.dwTotalPhys;
end;

function TSystem.getAvailPhysMemory:Longint;
var memory : TMEMORYSTATUS;
begin
    GlobalMemoryStatus(memory);
    getAvailPhysMemory:= memory.dwAvailPhys;
end;

function TSystem.getTotalPageFile:Longint;
var memory : TMEMORYSTATUS;
begin
    GlobalMemoryStatus(memory);
    getTotalPageFile:= memory.dwTotalPageFile;
end;

function TSystem.getAvailPageFile:Longint;
var memory : TMEMORYSTATUS;
begin
    GlobalMemoryStatus(memory);
    getAvailPageFile:= memory.dwAvailPageFile;
end;

function TSystem.getWindowsDirectory:String;
var P: PChar;
begin
     P:=StrAlloc(MAX_PATH+1);
     windows.GetWindowsDirectory(P,MAX_PATH+1);
     getWindowsDirectory:= P;
     StrDispose(P);
end;

function TSystem.getSystemDirectory:String;
var P: PChar;
begin
     P:=StrAlloc(MAX_PATH+1);
     windows.GetSystemDirectory(P,MAX_PATH+1);
     getSystemDirectory:= P;
     StrDispose(P);
end;

function TSystem.getUserName:String;
var P   : PChar;
    size: DWord;
begin
     size :=1024;
     P:=StrAlloc(size);
     windows.GetUserName(P,size);
     getUserName:= P;
     StrDispose(P);
end;

function TSystem.getComputerName:String;
var P   : PChar;
    size: DWord;
begin
     size :=MAX_COMPUTERNAME_LENGTH+1;
     P:=StrAlloc(size);
     windows.GetComputerName(P,size);
     getComputerName:= P;
     StrDispose(P);
end;

function TSystem.getProcessorType:String;
var systeminfo:TSystemInfo;
    zw : string;

begin
   GetSystemInfo(systeminfo);
   case systeminfo.dwProcessorType of
               386  : zw := 'Intel 386';
               486  : zw := 'Intel 486';
               586  : zw := 'Intel Pentium';
               860  : zw := 'Intel 860';
              2000  : zw := 'MIPS R2000';
              3000  : zw := 'MIPS R3000';
              4000  : zw := 'MIPS R4000';
             21064  : zw := 'ALPHA 21064';
               601  : zw := 'PPC 601';
               603  : zw := 'PPC 603';
               604  : zw := 'PPC 604';
               620  : zw := 'PPC 620';
   end;
   result := zw;
end;

function TSystem.getProcessorCount:Integer;
var systeminfo:TSystemInfo;
begin
   GetSystemInfo(systeminfo);
   result := systeminfo.dwNumberOfProcessors;
end;

function TSystem.getSystem:TBetriebsSystem;
var os : TOSVERSIONINFO;
begin
   os.dwOSVersionInfoSize := sizeof(os);
   GetVersionEx(os);
   case os.dwPlatformId of
     VER_PLATFORM_WIN32s	: result := bsWin32;
     VER_PLATFORM_WIN32_WINDOWS	: result := bsWin95;
     VER_PLATFORM_WIN32_NT	: result := bsWinNT;
   else result := bsUnknown;
   end;
end;

// Procedure Register
procedure Register;
begin
     RegisterComponents('Neue', [TEditBlack, TLabelBlack, TSystem]);
end;

end.
 