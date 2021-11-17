(*==========================================================================;
 *
 *  Copyright (C) 1996-2000 Microsoft Corporation.  All Rights Reserved.
 *
 *  File:       dinput.h
 *  Content:    DirectInput include file
 *
 *  DirectX 8.0 Delphi adaptation by Tim Baumgarten
 *  partly based upon : DirectX 7.0 Delphi adaptation by Erik Unger
 *
 *  Modified: 18-Jan-2001 (013TH2001 Edition)
 *
 *  E-Mail: ampaze@gmx.net
 *
 *  This File contains only DX8.0 Definitions.
 *  If you want to use older versions use DirectInput.pas
 *
 ***************************************************************************)

(*==========================================================================;
 * History :
 *
 * 18-Jan-2001 (Tim Baumgarten) : Changed IDirectInput8{A/W}.EnumDevicesBySemantics and IDirectInput8{A/W}.ConfigureDevices to use "const" instead of "var" for the records.  
 * 23-Dec-2000 (Tim Baumgarten) : Changed all types that are declared as Cardinal in C to be Cardinal in Delphi
 *                              : Changed all types that are declared as DWord in C to be LongWord in Delphi
 * 26-Nov-2000 (Tim Baumgarten) : Returncodes are now typcasted with HResult
 *
 ***************************************************************************)
 
unit DirectInput8;

{$MINENUMSIZE 4}
{$ALIGN ON}
                                                
interface

uses
  Windows,
  MMSystem,
  DirectXGraphics;

var
  DInput8DLL : HMODULE = 0;

const DIRECTINPUT_VERSION = $0800;

type
  TRefGUID = packed record
    case integer of
    1 : (guid : PGUID);
    2 : (dwFlags : LongWord);
  end;

//
// Structures
//

  PCPoint = ^TCPoint;
  TCPoint = packed record
    lP    : LongInt;    // raw value
    dwLog : LongWord;   // logical_value / max_logical_value * 10000
  end;


  PDIActionA = ^TDIActionA;
  TDIActionA = packed record
    uAppData   : Pointer;
    dwSemantic : LongWord;
    dwFlags    : LongWord;
    case integer of
    0: (
         lptszActionName : LPCSTR;
         guidInstance    : TGUID;
         dwObjID         : LongWord;
         dwHow           : LongWord
       );
    1: (
         uResIdString : Cardinal;
       );
  end;

  PDIActionW = ^TDIActionW;
  TDIActionW = packed record
    uAppData   : Pointer;
    dwSemantic : LongWord;
    dwFlags    : LongWord;
    case integer of
    0: (
         lptszActionName : LPCWSTR;
         guidInstance    : TGUID;
         dwObjID         : LongWord;
         dwHow           : LongWord
       );
    1: (
         uResIdString : Cardinal;
       );
  end;

  PDIAction = ^TDIAction;
{$IFDEF UNICODE}
  TDIAction = TDIActionW;
{$ELSE}
  TDIAction = TDIActionA;
{$ENDIF}

  PDIActionFormatA = ^TDIActionFormatA;
  TDIActionFormatA = packed record
    dwSize        : LongWord;
    dwActionSize  : LongWord;
    dwDataSize    : LongWord;
    dwNumActions  : LongWord;
    rgoAction     : PDIActionA;
    guidActionMap : TGUID;
    dwGenre       : LongWord;
    dwBufferSize  : LongWord;
    lAxisMin      : LongInt;
    lAxisMax      : LongInt;
    hInstString   : THandle;
    ftTimeStamp   : TFileTime;
    dwCRC         : LongWord;
    tszActionMap  : array [0..MAX_PATH-1] of CHAR;
  end;

  PDIActionFormatW = ^TDIActionFormatW;
  TDIActionFormatW = packed record
    dwSize        : LongWord;
    dwActionSize  : LongWord;
    dwDataSize    : LongWord;
    dwNumActions  : LongWord;
    rgoAction     : PDIActionW;
    guidActionMap : TGUID;
    dwGenre       : LongWord;
    dwBufferSize  : LongWord;
    lAxisMin      : LongInt;
    lAxisMax      : LongInt;
    hInstString   : THandle;
    ftTimeStamp   : TFileTime;
    dwCRC         : LongWord;
    tszActionMap  : array [0..MAX_PATH-1] of WCHAR;
  end;

  PDIActionFormat = ^TDIActionFormat;
{$IFDEF UNICODE}
  TDIActionFormat = TDIActionFormatW;
{$ELSE}
  TDIActionFormat = TDIActionFormatA;
{$ENDIF}

  PDIColorSet = ^TDIColorSet;
  TDIColorSet = packed record
    dwSize            : LongWord;
    cTextFore         : TD3DColor;
    cTextHighlight    : TD3DColor;
    cCalloutLine      : TD3DColor;
    cCalloutHighlight : TD3DColor;
    cBorder           : TD3DColor;
    cControlFill      : TD3DColor;
    cHighlightFill    : TD3DColor;
    cAreaFill         : TD3DColor;
  end;

  PDICondition = ^TDICondition;
  TDICondition = packed record
    lOffset              : LongInt;
    lPositiveCoefficient : LongInt;
    lNegativeCoefficient : LongInt;
    dwPositiveSaturation : LongWord;
    dwNegativeSaturation : LongWord;
    lDeadBand            : LongInt;
  end;

  PDIConfigureDevicesParamsA = ^TDIConfigureDevicesParamsA;
  TDIConfigureDevicesParamsA = packed record
     dwSize         : LongWord;
     dwcUsers       : LongWord;
     lptszUserNames : LPSTR;
     dwcFormats     : LongWord;
     lprgFormats    : PDIActionFormatA;
     hwnd           : Hwnd;
     dics           : TDIColorSet;
     lpUnkDDSTarget : IUnknown;
  end;

  PDIConfigureDevicesParamsW = ^TDIConfigureDevicesParamsW;
  TDIConfigureDevicesParamsW = packed record
     dwSize         : LongWord;
     dwcUsers       : LongWord;
     lptszUserNames : LPWSTR;
     dwcFormats     : LongWord;
     lprgFormats    : PDIActionFormatW;
     hwnd           : Hwnd;
     dics           : TDIColorSet;
     lpUnkDDSTarget : IUnknown;
  end;

  PDIConfigureDevicesParams = ^TDIConfigureDevicesParams;
{$IFDEF UNICODE}
  TDIConfigureDevicesParams = TDIConfigureDevicesParamsW;
{$ELSE}
  TDIConfigureDevicesParams = TDIConfigureDevicesParamsA;
{$ENDIF}

  PDIConstantForce = ^TDIConstantForce;
  TDIConstantForce = packed record
    lMagnitude : LongInt;
  end;

  PDICustomForce = ^TDICustomForce;
  TDICustomForce = packed record
    cChannels      : LongWord;
    dwSamplePeriod : LongWord;
    cSamples       : LongWord;
    rglForceData   : PLongInt;
  end;

  PDIObjectDataFormat = ^TDIObjectDataFormat;
  TDIObjectDataFormat = packed record
    pguid   : PGUID;
    dwOfs   : LongWord;
    dwType  : LongWord;
    dwFlags : LongWord;
  end;

  PDIDataFormat = ^TDIDataFormat;
  TDIDataFormat = packed record
    dwSize     : LongWord;   
    dwObjSize  : LongWord;
    dwFlags    : LongWord;
    dwDataSize : LongWord;
    dwNumObjs  : LongWord;
    rgodf      : PDIObjectDataFormat;
  end;

  PDIDevCaps = ^TDIDevCaps;
  TDIDevCaps = packed record
    dwSize                : LongWord;
    dwFlags               : LongWord;
    dwDevType             : LongWord;
    dwAxes                : LongWord;
    dwButtons             : LongWord;
    dwPOVs                : LongWord;
    dwFFSamplePeriod      : LongWord;
    dwFFMinTimeResolution : LongWord;
    dwFirmwareRevision    : LongWord;
    dwHardwareRevision    : LongWord;
    dwFFDriverVersion     : LongWord;
  end;

  PDIDeviceImageInfoA = ^TDIDeviceImageInfoA;
  TDIDeviceImageInfoA = packed record
    tszImagePath    : array [0..MAX_PATH-1] of CHAR;
    dwFlags         : LongWord;
    // These are valid if DIDIFT_OVERLAY is present in dwFlags.
    dwViewID        : LongWord;
    rcOverlay       : TRect;
    dwObjID         : LongWord;
    dwcValidPts     : LongWord;
    rgptCalloutLine : array [0..4] of TPoint;
    rcCalloutRect   : TRect;
    dwTextAlign     : LongWord;
  end;

  PDIDeviceImageInfoW = ^TDIDeviceImageInfoW;
  TDIDeviceImageInfoW = packed record
    tszImagePath    : array [0..MAX_PATH-1] of WCHAR;
    dwFlags         : LongWord;
    // These are valid if DIDIFT_OVERLAY is present in dwFlags.
    dwViewID        : LongWord;
    rcOverlay       : TRect;
    dwObjID         : LongWord;
    dwcValidPts     : LongWord;
    rgptCalloutLine : array [0..4] of TPoint;
    rcCalloutRect   : TRect;
    dwTextAlign     : LongWord;
  end;

  PDIDeviceImageInfo = ^TDIDeviceImageInfo;
{$IFDEF UNICODE}
  TDIDeviceImageInfo = TDIDeviceImageInfoW;
{$ELSE}
  TDIDeviceImageInfo = TDIDeviceImageInfoA;
{$ENDIF}

  PDIDeviceImageInfoHeaderA = ^TDIDeviceImageInfoHeaderA;
  TDIDeviceImageInfoHeaderA = packed record
    dwSize             : LongWord;
    dwSizeImageInfo    : LongWord;
    dwcViews           : LongWord;
    dwcButtons         : LongWord;
    dwcAxes            : LongWord;
    dwcPOVs            : LongWord;
    dwBufferSize       : LongWord;
    dwBufferUsed       : LongWord;
    lprgImageInfoArray : PDIDeviceImageInfoA;
  end;

  PDIDeviceImageInfoHeaderW = ^TDIDeviceImageInfoHeaderW;
  TDIDeviceImageInfoHeaderW = packed record
    dwSize             : LongWord;
    dwSizeImageInfo    : LongWord;
    dwcViews           : LongWord;
    dwcButtons         : LongWord;
    dwcAxes            : LongWord;
    dwcPOVs            : LongWord;
    dwBufferSize       : LongWord;
    dwBufferUsed       : LongWord;
    lprgImageInfoArray : PDIDeviceImageInfoW;
  end;

  PDIDeviceImageInfoHeader = ^TDIDeviceImageInfoHeader;
{$IFDEF UNICODE}
  TDIDeviceImageInfoHeader = TDIDeviceImageInfoHeaderW;
{$ELSE}
  TDIDeviceImageInfoHeader = TDIDeviceImageInfoHeaderA;
{$ENDIF}

  PDIDeviceInstanceA = ^TDIDeviceInstanceA;
  TDIDeviceInstanceA = packed record
    dwSize          : LongWord;
    guidInstance    : TGUID;
    guidProduct     : TGUID;
    dwDevType       : LongWord;
    tszInstanceName : Array [0..MAX_PATH-1] of AnsiChar;
    tszProductName  : Array [0..MAX_PATH-1] of AnsiChar;
    guidFFDriver    : TGUID;
    wUsagePage      : Word;
    wUsage          : Word;
  end;

  PDIDeviceInstanceW = ^TDIDeviceInstanceW;
  TDIDeviceInstanceW = packed record
    dwSize          : LongWord;
    guidInstance    : TGUID;
    guidProduct     : TGUID;
    dwDevType       : LongWord;
    tszInstanceName : Array [0..MAX_PATH-1] of WideChar;
    tszProductName  : Array [0..MAX_PATH-1] of WideChar;
    guidFFDriver    : TGUID;
    wUsagePage      : Word;
    wUsage          : Word;
  end;

  PDIDeviceInstance = ^TDIDeviceInstance;
{$IFDEF UNICODE}
  TDIDeviceInstance = TDIDeviceInstanceW;
{$ELSE}
  TDIDeviceInstance = TDIDeviceInstanceA;
{$ENDIF}

  PDIDeviceObjectData = ^TDIDeviceObjectData;
  TDIDeviceObjectData = packed record
    dwOfs       : LongWord;
    dwData      : LongWord;
    dwTimeStamp : LongWord;
    dwSequence  : LongWord;
    uAppData    : Pointer;
  end;


  PDIDeviceObjectInstanceA = ^TDIDeviceObjectInstanceA;
  TDIDeviceObjectInstanceA = packed record
    dwSize              : LongWord;
    guidType            : TGUID;
    dwOfs               : LongWord;
    dwType              : LongWord;
    dwFlags             : LongWord;
    tszName             : Array [0..MAX_PATH-1] of CHAR;
    dwFFMaxForce        : LongWord;
    dwFFForceResolution : LongWord;
    wCollectionNumber   : Word;
    wDesignatorIndex    : Word;
    wUsagePage          : Word;
    wUsage              : Word;
    dwDimension         : LongWord;
    wExponent           : Word;
    wReserved           : Word;
  end;

  PDIDeviceObjectInstanceW = ^TDIDeviceObjectInstanceW;
  TDIDeviceObjectInstanceW = packed record
    dwSize              : LongWord;
    guidType            : TGUID;
    dwOfs               : LongWord;
    dwType              : LongWord;
    dwFlags             : LongWord;
    tszName             : Array [0..MAX_PATH-1] of WCHAR;
    dwFFMaxForce        : LongWord;
    dwFFForceResolution : LongWord;
    wCollectionNumber   : Word;
    wDesignatorIndex    : Word;
    wUsagePage          : Word;
    wUsage              : Word;
    dwDimension         : LongWord;
    wExponent           : Word;
    wReserved           : Word;
  end;

  PDIDeviceObjectInstance = ^TDIDeviceObjectInstance;
{$IFDEF UNICODE}
  TDIDeviceObjectInstance = TDIDeviceObjectInstanceW;
{$ELSE}
  TDIDeviceObjectInstance = TDIDeviceObjectInstanceA;
{$ENDIF}

  PDIEnvelope = ^TDIEnvelope;
  TDIEnvelope = packed record
    dwSize        : LongWord;  (* sizeof(DIENVELOPE)   *)
    dwAttackLevel : LongWord;
    dwAttackTime  : LongWord;  (* Microseconds         *)
    dwFadeLevel   : LongWord;
    dwFadeTime    : LongWord;  (* Microseconds         *)
  end;

  PDIEffect = ^TDIEffect;
  TDIEffect = packed record
    dwSize                  : LongWord;     (* sizeof(DIEFFECT)     *)
    dwFlags                 : LongWord;     (* DIEFF_*              *)
    dwDuration              : LongWord;     (* Microseconds         *)
    dwSamplePeriod          : LongWord;     (* Microseconds         *)
    dwGain                  : LongWord;
    dwTriggerButton         : LongWord;     (* or DIEB_NOTRIGGER    *)
    dwTriggerRepeatInterval : LongWord;     (* Microseconds         *)
    cAxes                   : LongWord;     (* Number of axes       *)
    rgdwAxes                : PLongWord;    (* Array of axes        *)
    rglDirection            : PLongInt;     (* Array of directions  *)
    lpEnvelope              : PDIEnvelope;  (* Optional             *)
    cbTypeSpecificParams    : LongWord;     (* Size of params       *)
    lpvTypeSpecificParams   : Pointer;      (* Pointer to params    *)
    dwStartDelay            : LongWord;     (* Microseconds         *)
  end;

  PDIEffectInfoA = ^TDIEffectInfoA;
  TDIEffectInfoA = packed record
    dwSize          : LongWord;
    guid            : TGUID;
    dwEffType       : LongWord;
    dwStaticParams  : LongWord;
    dwDynamicParams : LongWord;
    tszName         : array [0..MAX_PATH-1] of CHAR;
  end;

  PDIEffectInfoW = ^TDIEffectInfoW;
  TDIEffectInfoW = packed record
    dwSize          : LongWord;
    guid            : TGUID;
    dwEffType       : LongWord;
    dwStaticParams  : LongWord;
    dwDynamicParams : LongWord;
    tszName         : array [0..MAX_PATH-1] of WCHAR;
  end;

  PDIEffectInfo = ^TDIEffectInfo;
{$IFDEF UNICODE}
  TDIEffectInfo = TDIEffectInfoW;
{$ELSE}
  TDIEffectInfo = TDIEffectInfoA;
{$ENDIF}

  PDIEffEscape = ^TDIEffEscape;
  TDIEffEscape = packed record
    dwSize       : LongWord;
    dwCommand    : LongWord;
    lpvInBuffer  : Pointer;
    cbInBuffer   : LongWord;
    lpvOutBuffer : Pointer;
    cbOutBuffer  : LongWord;
  end;

  PDIFileEffect = ^TDIFileEffect;
  TDIFileEffect = packed record
    dwSize         : LongWord;
    GuidEffect     : TGUID;
    lpDiEffect     : PDIEffect;
    szFriendlyName : array [0..MAX_PATH-1] of AnsiChar;
  end;

  PDIJoyState = ^TDIJoyState;
  TDIJoyState = packed record
    lX         : LongInt;                   (* x-axis position              *)
    lY         : LongInt;                   (* y-axis position              *)
    lZ         : LongInt;                   (* z-axis position              *)
    lRx        : LongInt;                   (* x-axis rotation              *)
    lRy        : LongInt;                   (* y-axis rotation              *)
    lRz        : LongInt;                   (* z-axis rotation              *)
    rglSlider  : array [0..1] of LongInt;   (* extra axes positions         *)
    rgdwPOV    : array [0..3] of LongWord;  (* POV directions               *)
    rgbButtons : array [0..31] of Byte;     (* 32 buttons                   *)
  end;

  PDIJoyState2 = ^TDIJoyState2;
  TDIJoyState2 = packed record
    lX         : LongInt;                   (* x-axis position              *)
    lY         : LongInt;                   (* y-axis position              *)
    lZ         : LongInt;                   (* z-axis position              *)
    lRx        : LongInt;                   (* x-axis rotation              *)
    lRy        : LongInt;                   (* y-axis rotation              *)
    lRz        : LongInt;                   (* z-axis rotation              *)
    rglSlider  : array [0..1] of LongInt;   (* extra axes positions         *)
    rgdwPOV    : array [0..3] of LongWord;  (* POV directions               *)
    rgbButtons : array [0..127] of Byte;    (* 128 buttons                  *)
    lVX        : LongInt;                   (* x-axis velocity              *)
    lVY        : LongInt;                   (* y-axis velocity              *)
    lVZ        : LongInt;                   (* z-axis velocity              *)
    lVRx       : LongInt;                   (* x-axis angular velocity      *)
    lVRy       : LongInt;                   (* y-axis angular velocity      *)
    lVRz       : LongInt;                   (* z-axis angular velocity      *)
    rglVSlider : array [0..1] of LongInt;   (* extra axes velocities        *)
    lAX        : LongInt;                   (* x-axis acceleration          *)
    lAY        : LongInt;                   (* y-axis acceleration          *)
    lAZ        : LongInt;                   (* z-axis acceleration          *)
    lARx       : LongInt;                   (* x-axis angular acceleration  *)
    lARy       : LongInt;                   (* y-axis angular acceleration  *)
    lARz       : LongInt;                   (* z-axis angular acceleration  *)
    rglASlider : array [0..1] of LongInt;   (* extra axes accelerations     *)
    lFX        : LongInt;                   (* x-axis force                 *)
    lFY        : LongInt;                   (* y-axis force                 *)
    lFZ        : LongInt;                   (* z-axis force                 *)
    lFRx       : LongInt;                   (* x-axis torque                *)
    lFRy       : LongInt;                   (* y-axis torque                *)
    lFRz       : LongInt;                   (* z-axis torque                *)
    rglFSlider : array [0..1] of LongInt;   (* extra axes forces            *)
  end;

  TDIKeyboardState = array[0..255] of Byte;

  PDIMouseState = ^TDIMouseState;
  TDIMouseState = packed record
    lX         : LongInt;
    lY         : LongInt;
    lZ         : LongInt;
    rgbButtons : array [0..3] of Byte;  // up to 4 buttons
  end;

  PDIMouseState2 = ^TDIMouseState2;
  TDIMouseState2 = packed record
    lX         : LongInt;
    lY         : LongInt;
    lZ         : LongInt;
    rgbButtons : array [0..7] of Byte;  // up to 8 buttons
  end;

  PDIPeriodic = ^TDIPeriodic;
  TDIPeriodic = packed record
    dwMagnitude : LongWord;
    lOffset     : LongInt;
    dwPhase     : LongWord;
    dwPeriod    : LongWord;
  end;

  PDIPropHeader = ^TDIPropHeader;
  TDIPropHeader = packed record
    dwSize       : LongWord;
    dwHeaderSize : LongWord;
    dwObj        : LongWord;
    dwHow        : LongWord;
  end;

const
  MAXCPOINTSNUM  = 8;

type
  PDIPropCal = ^TDIPropCal;
  TDIPropCal = packed record
    diph    : TDIPropHeader;
    lMin    : LongInt;
    lCenter : LongInt;
    lMax    : LongInt;
  end;

  PDIPropCPoints = ^TDIPropCPoints;
  TDIPropCPoints = packed record
    diph         : TDIPropHeader;
    dwCPointsNum : LongWord;
    cp           : array [0..MAXCPOINTSNUM-1] of TCPoint;
  end;

  PDIProPDWord = ^TDIProPDWord;
  TDIProPDWord = packed record
    diph   : TDIPropHeader;
    dwData : LongWord;
  end;

  PDIPropGUIDAndPath = ^TDIPropGUIDAndPath;
  TDIPropGUIDAndPath = packed record
    diph      : TDIPropHeader;
    guidClass : TGUID;
    wszPath   : array [0..MAX_PATH-1] of WideChar;
  end;

  PDIPropPointer = ^TDIPropPointer;
  TDIPropPointer = packed record
    diph  : TDIPropHeader;
    uData : Pointer;
  end;

  PDIPropRange = ^TDIPropRange;
  TDIPropRange = packed record
    diph : TDIPropHeader;
    lMin : LongInt;
    lMax : LongInt;
  end;

  PDIPropString = ^TDIPropString;
  TDIPropString = packed record
    diph : TDIPropHeader;
    wsz  : array [0..MAX_PATH - 1] of WideChar;
  end;

  PDIRampForce = ^TDIRampForce;
  TDIRampForce = packed record
    lStart : LongInt;
    lEnd   : LongInt;
  end;  

  MAKEDIPROP = PGUID;

(****************************************************************************
 *
 *      Class IDs
 *
 ****************************************************************************)
const

  CLSID_DirectInput8       : TGUID = '{25E609E4-B259-11CF-BFC7-444553540000}';
  CLSID_DirectInputDevice8 : TGUID = '{25E609E5-B259-11CF-BFC7-444553540000}';

(****************************************************************************
 *
 *      Predefined object types
 *
 ****************************************************************************)

  GUID_XAxis   : TGUID = '{A36D02E0-C9F3-11CF-BFC7-444553540000}';
  GUID_YAxis   : TGUID = '{A36D02E1-C9F3-11CF-BFC7-444553540000}';
  GUID_ZAxis   : TGUID = '{A36D02E2-C9F3-11CF-BFC7-444553540000}';
  GUID_RxAxis  : TGUID = '{A36D02F4-C9F3-11CF-BFC7-444553540000}';
  GUID_RyAxis  : TGUID = '{A36D02F5-C9F3-11CF-BFC7-444553540000}';
  GUID_RzAxis  : TGUID = '{A36D02E3-C9F3-11CF-BFC7-444553540000}';
  GUID_Slider  : TGUID = '{A36D02E4-C9F3-11CF-BFC7-444553540000}';

  GUID_Button  : TGUID = '{A36D02F0-C9F3-11CF-BFC7-444553540000}';
  GUID_Key     : TGUID = '{55728220-D33C-11CF-BFC7-444553540000}';

  GUID_POV     : TGUID = '{A36D02F2-C9F3-11CF-BFC7-444553540000}';

  GUID_Unknown : TGUID = '{A36D02F3-C9F3-11CF-BFC7-444553540000}';

(****************************************************************************
 *
 *      Predefined product GUIDs
 *
 ****************************************************************************)

  GUID_SysMouse       : TGUID = '{6F1D2B60-D5A0-11CF-BFC7-444553540000}';
  GUID_SysKeyboard    : TGUID = '{6F1D2B61-D5A0-11CF-BFC7-444553540000}';
  GUID_Joystick       : TGUID = '{6F1D2B70-D5A0-11CF-BFC7-444553540000}';
  GUID_SysMouseEm     : TGUID = '{6F1D2B80-D5A0-11CF-BFC7-444553540000}';
  GUID_SysMouseEm2    : TGUID = '{6F1D2B81-D5A0-11CF-BFC7-444553540000}';
  GUID_SysKeyboardEm  : TGUID = '{6F1D2B82-D5A0-11CF-BFC7-444553540000}';
  GUID_SysKeyboardEm2 : TGUID = '{6F1D2B83-D5A0-11CF-BFC7-444553540000}';

(****************************************************************************
 *
 *      Predefined force feedback effects
 *
 ****************************************************************************)

  GUID_ConstantForce : TGUID = '{13541C20-8E33-11D0-9AD0-00A0C9A06E35}';
  GUID_RampForce     : TGUID = '{13541C21-8E33-11D0-9AD0-00A0C9A06E35}';
  GUID_Square        : TGUID = '{13541C22-8E33-11D0-9AD0-00A0C9A06E35}';
  GUID_Sine          : TGUID = '{13541C23-8E33-11D0-9AD0-00A0C9A06E35}';
  GUID_Triangle      : TGUID = '{13541C24-8E33-11D0-9AD0-00A0C9A06E35}';
  GUID_SawtoothUp    : TGUID = '{13541C25-8E33-11D0-9AD0-00A0C9A06E35}';
  GUID_SawtoothDown  : TGUID = '{13541C26-8E33-11D0-9AD0-00A0C9A06E35}';
  GUID_Spring        : TGUID = '{13541C27-8E33-11D0-9AD0-00A0C9A06E35}';
  GUID_Damper        : TGUID = '{13541C28-8E33-11D0-9AD0-00A0C9A06E35}';
  GUID_Inertia       : TGUID = '{13541C29-8E33-11D0-9AD0-00A0C9A06E35}';
  GUID_Friction      : TGUID = '{13541C2A-8E33-11D0-9AD0-00A0C9A06E35}';
  GUID_CustomForce   : TGUID = '{13541C2B-8E33-11D0-9AD0-00A0C9A06E35}';


//
// Interfaces
//

type

  IDirectInputEffect = interface (IUnknown)
    ['{E7E1F7C0-88D2-11D0-9AD0-00A0C9A06E35}']
    (** IDirectInputEffect methods ***)
    function Initialize(hinst : THandle; const dwVersion : LongWord; const rguid : TGUID) : HResult; stdcall;
    function GetEffectGuid(out pguid : TGUID) : HResult;  stdcall;
    function GetParameters(var peff : TDIEffect; const dwFlags : LongWord) : HResult;  stdcall;
    function SetParameters(var peff : TDIEffect; const dwFlags : LongWord) : HResult;  stdcall;
    function Start(const dwIterations : LongWord; const dwFlags : LongWord) : HResult;  stdcall;
    function Stop : HResult;  stdcall;
    function GetEffectStatus(out pdwFlags : LongWord) : HResult;  stdcall;
    function Download : HResult;  stdcall;
    function Unload : HResult;  stdcall;
    function Escape(var pesc : PDIEffEscape) : HResult;  stdcall;
  end;

  TDIEnumDeviceObjectsCallbackA = function(var lpddoi : TDIDeviceObjectInstanceA; pvRef : Pointer) : Integer; stdcall;
  TDIEnumDeviceObjectsCallbackW = function(var lpddoi : TDIDeviceObjectInstanceW; pvRef : Pointer) : Integer; stdcall;
  TDIEnumDeviceObjectsCallback = function(var lpddoi : TDIDeviceObjectInstance; pvRef : Pointer) : Integer; stdcall;
  TDIEnumDeviceObjectsProc = TDIEnumDeviceObjectsCallback;

  TDIEnumEffectsCallbackA = function(var pdei : TDIEffectInfoA; pvRef : Pointer) : Integer; stdcall;
  TDIEnumEffectsCallbackW = function(var pdei : TDIEffectInfoW; pvRef : Pointer) : Integer; stdcall;
  TDIEnumEffectsCallback = function(var pdei : TDIEffectInfo; pvRef : Pointer) : Integer; stdcall;
  TDIEnumEffectsProc = TDIEnumEffectsCallback;

  TDIEnumCreatedEffectObjectsCallback = function(peff : IDirectInputEffect; pvRev : Pointer) : Integer; stdcall;
  TDIEnumCreatedEffectObjectsProc = TDIEnumCreatedEffectObjectsCallback;

  TDIEnumEffectsInFileCallback = function(var lpDiFileEf : TDIFileEffect; pvRef : Pointer) : Integer; stdcall;

  IDirectInputDevice8A = interface (IUnknown)
    ['{54D41080-DC15-4833-A41B-748F73A38179}']
    (*** IDirectInputDevice8A methods ***)
    function GetCapabilities(var lpDIDevCaps : TDIDevCaps) : HResult; stdcall;
    function EnumObjects(lpCallback : TDIEnumDeviceObjectsCallbackA; pvRef : Pointer; const dwFlags : LongWord) : HResult; stdcall;
    function GetProperty(const rguidProp : PGUID; var pdiph : TDIPropHeader) : HResult; stdcall;
    function SetProperty(const rguidProp : PGUID; const pdiph : TDIPropHeader) : HResult; stdcall;
    function Acquire : HResult; stdcall;
    function Unacquire : HResult; stdcall;
    function GetDeviceState(const cbData : LongWord; lpvData : Pointer) : HResult; stdcall;
    function GetDeviceData(const cbObjectData : LongWord; rgdod : PDIDeviceObjectData; var pdwInOut : LongWord; const dwFlags : LongWord) : HResult; stdcall;
    function SetDataFormat(lpdf : PDIDataFormat) : HResult; stdcall;
    function SetEventNotification(const hEvent : THandle) : HResult; stdcall;
    function SetCooperativeLevel(const hwnd : HWND; const dwFlags : LongWord) : HResult; stdcall;
    function GetObjectInfo(var pdidoi : TDIDeviceObjectInstanceA; const dwObj, dwHow : LongWord) : HResult; stdcall;
    function GetDeviceInfo(var pdidi : TDIDeviceInstanceA) : HResult; stdcall;
    function RunControlPanel(const hwndOwner : HWND; const dwFlags : LongWord) : HResult; stdcall;
    function Initialize(const hinst : THandle; const dwVersion : LongWord; const rguid : TGUID) : HResult; stdcall;


    function CreateEffect(const rguid : TGUID; lpeff : PDIEffect; out ppdeff : IDirectInputEffect; punkOuter : IUnknown) : HResult; stdcall;
    function EnumEffects(lpCallback: TDIEnumEffectsCallbackA; pvRef : Pointer; const dwEffType : LongWord) : HResult; stdcall;
    function GetEffectInfo(var pdei : TDIEffectInfoA; const rguid : TGUID) : HResult; stdcall;
    function GetForceFeedbackState(var pdwOut : LongWord) : HResult; stdcall;
    function SendForceFeedbackCommand(const dwFlags : LongWord) : HResult; stdcall;
    function EnumCreatedEffectObjects(lpCallback : TDIEnumCreatedEffectObjectsCallback; pvRef : Pointer; const fl : LongWord) : HResult; stdcall;
    function Escape(var pesc : TDIEffEscape) : HResult; stdcall;
    function Poll : HResult; stdcall;
    function SendDeviceData(const cbObjectData : LongWord; rgdod : PDIDeviceObjectData; var pdwInOut : LongWord; const fl : LongWord) : HResult; stdcall;

    function EnumEffectsInFile(const lpszFileName : PChar; pec : TDIEnumEffectsInFileCallback; pvRef : Pointer; const dwFlags : LongWord) : HResult; stdcall;
    function WriteEffectToFile(const lpszFileName : PChar; const dwEntries : LongWord; rgDIFileEft : PDIFileEffect; const dwFlags : LongWord) : HResult; stdcall;

    function BuildActionMap(var lpdiaf : TDIActionFormatA; const lpszUserName : PAnsiChar; const dwFlags : LongWord) : HResult; stdcall;
    function SetActionMap(var lpdiActionFormat : TDIActionFormatA; const lptszUserName : PAnsiChar; const dwFlags : LongWord) : HResult; stdcall;
    function GetImageInfo(var lpdiDevImageInfoHeader : TDIDeviceImageInfoHeaderA) : HResult; stdcall;
  end;

  IDirectInputDevice8W = interface (IUnknown)
    ['{54D41081-DC15-4833-A41B-748F73A38179}']
    (*** IDirectInputDevice8A methods ***)
    function GetCapabilities(var lpDIDevCaps : TDIDevCaps) : HResult; stdcall;
    function EnumObjects(lpCallback : TDIEnumDeviceObjectsCallbackW; pvRef : Pointer; const dwFlags : LongWord) : HResult; stdcall;
    function GetProperty(const rguidProp : PGUID; var pdiph : TDIPropHeader) : HResult; stdcall;
    function SetProperty(const rguidProp : PGUID; const pdiph : TDIPropHeader) : HResult; stdcall;
    function Acquire : HResult; stdcall;
    function Unacquire : HResult; stdcall;
    function GetDeviceState(const cbData : LongWord; lpvData : Pointer) : HResult; stdcall;
    function GetDeviceData(const cbObjectData : LongWord; rgdod : PDIDeviceObjectData; var pdwInOut : LongWord; const dwFlags : LongWord) : HResult; stdcall;
    function SetDataFormat(var lpdf : TDIDataFormat) : HResult; stdcall;
    function SetEventNotification(const hEvent : THandle) : HResult; stdcall;
    function SetCooperativeLevel(const hwnd : HWND; const dwFlags : LongWord) : HResult; stdcall;
    function GetObjectInfo(var pdidoi : TDIDeviceObjectInstanceW; const dwObj, dwHow : LongWord) : HResult; stdcall;
    function GetDeviceInfo(var pdidi : TDIDeviceInstanceW) : HResult; stdcall;
    function RunControlPanel(const hwndOwner : HWND; const dwFlags : LongWord) : HResult; stdcall;
    function Initialize(const hinst : THandle; const dwVersion : LongWord; const rguid : TGUID) : HResult; stdcall;

    function CreateEffect(const rguid : TGUID; lpeff : PDIEffect; out ppdeff : IDirectInputEffect; punkOuter : IUnknown) : HResult;  stdcall;
    function EnumEffects(lpCallback : TDIEnumEffectsCallbackW; pvRef : Pointer; const dwEffType : LongWord) : HResult;  stdcall;
    function GetEffectInfo(var pdei : TDIEffectInfoW; const rguid : TGUID) : HResult;  stdcall;
    function GetForceFeedbackState(var pdwOut : LongWord) : HResult;  stdcall;
    function SendForceFeedbackCommand(const dwFlags : LongWord) : HResult;  stdcall;
    function EnumCreatedEffectObjects(lpCallback : TDIEnumCreatedEffectObjectsCallback; pvRef : Pointer; const fl : LongWord) : HResult;  stdcall;
    function Escape(var pesc : TDIEffEscape) : HResult;  stdcall;
    function Poll : HResult;  stdcall;
    function SendDeviceData(const cbObjectData : LongWord; rgdod : PDIDeviceObjectData; var pdwInOut : LongWord; const fl : LongWord) : HResult;  stdcall;

    function EnumEffectsInFile(const lpszFileName : PWideChar; pec : TDIEnumEffectsInFileCallback; pvRef : Pointer; const dwFlags : LongWord) : HResult; stdcall;
    function WriteEffectToFile(const lpszFileName : PWideChar; const dwEntries : LongWord; rgDIFileEft : PDIFileEffect; const dwFlags : LongWord) : HResult; stdcall;

    function BuildActionMap(var lpdiaf : TDIActionFormatW; const lpszUserName : PWideChar; const dwFlags : LongWord) : HResult; stdcall;
    function SetActionMap(var lpdiActionFormat : TDIActionFormatW; const lptszUserName : PWideChar; const  dwFlags : LongWord) : HResult; stdcall;
    function GetImageInfo(var lpdiDevImageInfoHeader : TDIDeviceImageInfoHeaderW) : HResult; stdcall;
  end;


{$IFDEF UNICODE}
  IDirectInputDevice8 = IDirectInputDevice8W;
{$ELSE}
  IDirectInputDevice8 = IDirectInputDevice8A;
{$ENDIF}


  TDIEnumDevicesCallbackA = function (var lpddi : TDIDeviceInstanceA; pvRef : Pointer) : Integer; stdcall;
  TDIEnumDevicesCallbackW = function (var lpddi : TDIDeviceInstanceW; pvRef : Pointer) : Integer; stdcall;
  TDIEnumDevicesCallback = function (var lpddi : TDIDeviceInstance; pvRef : Pointer) : Integer; stdcall;
  TDIEnumDevicesProc = TDIEnumDevicesCallback;

  TDIConfigureDevicesCallback = function(lpDDSTarget : IUnknown; pvRef : Pointer) : Integer; stdcall;
  TDIConfigureDevicesProc = TDIConfigureDevicesCallback;

  TDIEnumDevicesBySemanticsCallbackA = function(var lpddi : TDIDeviceInstanceA; out lpdid : IDirectInputDevice8A; const dwFlags, dwRemaining : LongWord; pvRef : Pointer) : Integer; stdcall;
  TDIEnumDevicesBySemanticsCallbackW = function(var lpddi : TDIDeviceInstanceW; out lpdid : IDirectInputDevice8W; const dwFlags, dwRemaining : LongWord; pvRef : Pointer) : Integer; stdcall;

{$IFDEF UNICODE}
  TDIEnumDevicesBySemanticsCallback = TDIEnumDevicesBySemanticsCallbackW;
{$ELSE}
  TDIEnumDevicesBySemanticsCallback = TDIEnumDevicesBySemanticsCallbackA;
{$ENDIF}
  TDIEnumDevicesBySemanticsProc = TDIEnumDevicesBySemanticsCallback;


  IDirectInput8A = interface (IUnknown)
    ['{BF798030-483A-4DA2-AA99-5D64ED369700}']
    {*** IDirectInput8A methods ***}
    function CreateDevice(const rguid : TGUID; out lplpDirectInputDevice : IDirectInputDevice8A; pUnkOuter : IUnknown) : HResult; stdcall;
    function EnumDevices(const dwDevType : LongWord; lpCallback : TDIEnumDevicesCallbackA; pvRef : Pointer; const dwFlags : LongWord) : HResult; stdcall;
    function GetDeviceStatus(const rguidInstance : TGUID) : HResult; stdcall;
    function RunControlPanel(const hwndOwner : HWND; const dwFlags : LongWord) : HResult; stdcall;
    function Initialize(const hinst : THandle; const dwVersion : LongWord) : HResult; stdcall;
    function FindDevice(const rguidClass : TGUID; ptszName : PAnsiChar; out pguidInstance : TGUID): HResult; stdcall;
    function EnumDevicesBySemantics(ptszUserName : PAnsiChar; const lpdiActionFormat : TDIActionFormatA; lpCallback : TDIEnumDevicesBySemanticsCallbackA; pvRef : Pointer; const dwFlags : LongWord)  : HResult; stdcall;
    function ConfigureDevices(lpdiCallback : TDIConfigureDevicesCallback; const lpdiCDParams : TDIConfigureDevicesParamsA; const dwFlags : LongWord; pvRefData : Pointer) : HResult; stdcall;
  end;

  IDirectInput8W = interface (IUnknown)
    ['{BF798031-483A-4DA2-AA99-5D64ED369700}']
    {*** IDirectInput8W methods ***}
    function CreateDevice(const rguid : TGUID; out lplpDirectInputDevice : IDirectInputDevice8W; pUnkOuter : IUnknown) : HResult; stdcall;
    function EnumDevices(const dwDevType : LongWord; lpCallback : TDIEnumDevicesCallbackW; pvRef : Pointer; const dwFlags : LongWord) : HResult; stdcall;
    function GetDeviceStatus(const rguidInstance : TGUID) : HResult; stdcall;
    function RunControlPanel(const hwndOwner : HWND; const dwFlags : LongWord) : HResult; stdcall;
    function Initialize(const hinst : THandle; const dwVersion : LongWord) : HResult; stdcall;
    function FindDevice(const rguidClass : TGUID; ptszName : PWideChar; out pguidInstance : TGUID): HResult; stdcall;
    function EnumDevicesBySemantics(ptszUserName : PWideChar; const lpdiActionFormat : TDIActionFormatW; lpCallback : TDIEnumDevicesBySemanticsCallbackW; pvRef : Pointer; const dwFlags : LongWord)  : HResult; stdcall;
    function ConfigureDevices(lpdiCallback : TDIConfigureDevicesCallback; const lpdiCDParams : TDIConfigureDevicesParamsW; const dwFlags : LongWord; pvRefData : Pointer) : HResult; stdcall;
  end;

{$IFDEF UNICODE}
  IDirectInput8 = IDirectInput8W;
{$ELSE}
  IDirectInput8 = IDirectInput8A;
{$ENDIF}


type
  IID_IDirectInput8W = IDirectInput8W;
  IID_IDirectInput8A = IDirectInput8A;
  IID_IDirectInput8  = IDirectInput8;

  IID_IDirectInputDevice8W = IDirectInputDevice8W;
  IID_IDirectInputDevice8A = IDirectInputDevice8A;
  IID_IDirectInputDevice8  = IDirectInputDevice8;

  IID_IDirectInputEffect = IDirectInputEffect;


const
  DIEFT_ALL                   = $00000000;

  DIEFT_CONSTANTFORCE         = $00000001;
  DIEFT_RAMPFORCE             = $00000002;
  DIEFT_PERIODIC              = $00000003;
  DIEFT_CONDITION             = $00000004;
  DIEFT_CUSTOMFORCE           = $00000005;
  DIEFT_HARDWARE              = $000000FF;

  DIEFT_FFATTACK              = $00000200;
  DIEFT_FFFADE                = $00000400;
  DIEFT_SATURATION            = $00000800;
  DIEFT_POSNEGCOEFFICIENTS    = $00001000;
  DIEFT_POSNEGSATURATION      = $00002000;
  DIEFT_DEADBAND              = $00004000;
  DIEFT_STARTDELAY            = $00008000;

  DI_DEGREES                  =     100;
  DI_FFNOMINALMAX             =   10000;
  DI_SECONDS                  = 1000000;


  DIEFF_OBJECTIDS             = $00000001;
  DIEFF_OBJECTOFFSETS         = $00000002;
  DIEFF_CARTESIAN             = $00000010;
  DIEFF_POLAR                 = $00000020;
  DIEFF_SPHERICAL             = $00000040;

  DIEP_DURATION               = $00000001;
  DIEP_SAMPLEPERIOD           = $00000002;
  DIEP_GAIN                   = $00000004;
  DIEP_TRIGGERBUTTON          = $00000008;
  DIEP_TRIGGERREPEATINTERVAL  = $00000010;
  DIEP_AXES                   = $00000020;
  DIEP_DIRECTION              = $00000040;
  DIEP_ENVELOPE               = $00000080;
  DIEP_TYPESPECIFICPARAMS     = $00000100;
{$IFDEF DIRECTX5}
  DIEP_ALLPARAMS              = $000001FF;
{$ELSE}
  DIEP_STARTDELAY             = $00000200;
  DIEP_ALLPARAMS_DX5          = $000001FF;
  DIEP_ALLPARAMS              = $000003FF;
{$ENDIF}
  DIEP_START                  = $20000000;
  DIEP_NORESTART              = $40000000;
  DIEP_NODOWNLOAD             = $80000000;
  DIEB_NOTRIGGER              = $FFFFFFFF;

  DIES_SOLO                   = $00000001;
  DIES_NODOWNLOAD             = $80000000;

  DIEGES_PLAYING              = $00000001;
  DIEGES_EMULATED             = $00000002;

  DIDEVTYPE_DEVICE   = 1;
  DIDEVTYPE_MOUSE    = 2;
  DIDEVTYPE_KEYBOARD = 3;
  DIDEVTYPE_JOYSTICK = 4;

  DI8DEVCLASS_ALL          = 0;
  DI8DEVCLASS_DEVICE       = 1;
  DI8DEVCLASS_Pointer      = 2;
  DI8DEVCLASS_KEYBOARD     = 3;
  DI8DEVCLASS_GAMECTRL     = 4;

  DI8DEVTYPE_DEVICE        = $11;
  DI8DEVTYPE_MOUSE         = $12;
  DI8DEVTYPE_KEYBOARD      = $13;
  DI8DEVTYPE_JOYSTICK      = $14;
  DI8DEVTYPE_GAMEPAD       = $15;
  DI8DEVTYPE_DRIVING       = $16;
  DI8DEVTYPE_FLIGHT        = $17;
  DI8DEVTYPE_1STPERSON     = $18;
  DI8DEVTYPE_DEVICECTRL    = $19;
  DI8DEVTYPE_SCREENPointer = $1A;
  DI8DEVTYPE_REMOTE        = $1B;
  DI8DEVTYPE_SUPPLEMENTAL  = $1C;

  DIDEVTYPE_HID = $00010000;

  DIDEVTYPEMOUSE_UNKNOWN        = 1;
  DIDEVTYPEMOUSE_TRADITIONAL    = 2;
  DIDEVTYPEMOUSE_FINGERSTICK    = 3;
  DIDEVTYPEMOUSE_TOUCHPAD       = 4;
  DIDEVTYPEMOUSE_TRACKBALL      = 5;

  DIDEVTYPEKEYBOARD_UNKNOWN     = 0;
  DIDEVTYPEKEYBOARD_PCXT        = 1;
  DIDEVTYPEKEYBOARD_OLIVETTI    = 2;
  DIDEVTYPEKEYBOARD_PCAT        = 3;
  DIDEVTYPEKEYBOARD_PCENH       = 4;
  DIDEVTYPEKEYBOARD_NOKIA1050   = 5;
  DIDEVTYPEKEYBOARD_NOKIA9140   = 6;
  DIDEVTYPEKEYBOARD_NEC98       = 7;
  DIDEVTYPEKEYBOARD_NEC98LAPTOP = 8;
  DIDEVTYPEKEYBOARD_NEC98106    = 9;
  DIDEVTYPEKEYBOARD_JAPAN106    = 10;
  DIDEVTYPEKEYBOARD_JAPANAX     = 11;
  DIDEVTYPEKEYBOARD_J3100       = 12;

  DIDEVTYPEJOYSTICK_UNKNOWN     = 1;
  DIDEVTYPEJOYSTICK_TRADITIONAL = 2;
  DIDEVTYPEJOYSTICK_FLIGHTSTICK = 3;
  DIDEVTYPEJOYSTICK_GAMEPAD     = 4;
  DIDEVTYPEJOYSTICK_RUDDER      = 5;
  DIDEVTYPEJOYSTICK_WHEEL       = 6;
  DIDEVTYPEJOYSTICK_HEADTRACKER = 7;

  DI8DEVTYPEMOUSE_UNKNOWN     = 1;
  DI8DEVTYPEMOUSE_TRADITIONAL = 2;
  DI8DEVTYPEMOUSE_FINGERSTICK = 3;
  DI8DEVTYPEMOUSE_TOUCHPAD    = 4;
  DI8DEVTYPEMOUSE_TRACKBALL   = 5;
  DI8DEVTYPEMOUSE_ABSOLUTE    = 6;

  DI8DEVTYPEKEYBOARD_UNKNOWN     = 0;
  DI8DEVTYPEKEYBOARD_PCXT        = 1;
  DI8DEVTYPEKEYBOARD_OLIVETTI    = 2;
  DI8DEVTYPEKEYBOARD_PCAT        = 3;
  DI8DEVTYPEKEYBOARD_PCENH       = 4;
  DI8DEVTYPEKEYBOARD_NOKIA1050   = 5;
  DI8DEVTYPEKEYBOARD_NOKIA9140   = 6;
  DI8DEVTYPEKEYBOARD_NEC98       = 7;
  DI8DEVTYPEKEYBOARD_NEC98LAPTOP = 8;
  DI8DEVTYPEKEYBOARD_NEC98106    = 9;
  DI8DEVTYPEKEYBOARD_JAPAN106    = 10;
  DI8DEVTYPEKEYBOARD_JAPANAX     = 11;
  DI8DEVTYPEKEYBOARD_J3100       = 12;

  DI8DEVTYPE_LIMITEDGAMESUBTYPE = 1;

  DI8DEVTYPEJOYSTICK_LIMITED  = DI8DEVTYPE_LIMITEDGAMESUBTYPE;
  DI8DEVTYPEJOYSTICK_STANDARD = 2;

  DI8DEVTYPEGAMEPAD_LIMITED  = DI8DEVTYPE_LIMITEDGAMESUBTYPE;
  DI8DEVTYPEGAMEPAD_STANDARD = 2;
  DI8DEVTYPEGAMEPAD_TILT     = 3;

  DI8DEVTYPEDRIVING_LIMITED         = DI8DEVTYPE_LIMITEDGAMESUBTYPE;
  DI8DEVTYPEDRIVING_COMBINEDPEDALS  = 2;
  DI8DEVTYPEDRIVING_DUALPEDALS      = 3;
  DI8DEVTYPEDRIVING_THREEPEDALS     = 4;
  DI8DEVTYPEDRIVING_HANDHELD        = 5;

  DI8DEVTYPEFLIGHT_LIMITED = DI8DEVTYPE_LIMITEDGAMESUBTYPE;
  DI8DEVTYPEFLIGHT_STICK   = 2;
  DI8DEVTYPEFLIGHT_YOKE    = 3;
  DI8DEVTYPEFLIGHT_RC      = 4;

  DI8DEVTYPE1STPERSON_LIMITED = DI8DEVTYPE_LIMITEDGAMESUBTYPE;
  DI8DEVTYPE1STPERSON_UNKNOWN = 2;
  DI8DEVTYPE1STPERSON_SIXDOF  = 3;
  DI8DEVTYPE1STPERSON_SHOOTER = 4;

  DI8DEVTYPESCREENPTR_UNKNOWN  = 2;
  DI8DEVTYPESCREENPTR_LIGHTGUN = 3;
  DI8DEVTYPESCREENPTR_LIGHTPEN = 4;
  DI8DEVTYPESCREENPTR_TOUCH    = 5;

  DI8DEVTYPEREMOTE_UNKNOWN = 2;

  DI8DEVTYPEDEVICECTRL_UNKNOWN                  = 2;
  DI8DEVTYPEDEVICECTRL_COMMSSELECTION           = 3;
  DI8DEVTYPEDEVICECTRL_COMMSSELECTION_HARDWIRED = 4;

  DI8DEVTYPESUPPLEMENTAL_UNKNOWN           = 2;
  DI8DEVTYPESUPPLEMENTAL_2NDHANDCONTROLLER = 3;
  DI8DEVTYPESUPPLEMENTAL_HEADTRACKER       = 4;
  DI8DEVTYPESUPPLEMENTAL_HANDTRACKER       = 5;
  DI8DEVTYPESUPPLEMENTAL_SHIFTSTICKGATE    = 6;
  DI8DEVTYPESUPPLEMENTAL_SHIFTER           = 7;
  DI8DEVTYPESUPPLEMENTAL_THROTTLE          = 8;
  DI8DEVTYPESUPPLEMENTAL_SPLITTHROTTLE     = 9;
  DI8DEVTYPESUPPLEMENTAL_COMBINEDPEDALS    = 10;
  DI8DEVTYPESUPPLEMENTAL_DUALPEDALS        = 11;
  DI8DEVTYPESUPPLEMENTAL_THREEPEDALS       = 12;
  DI8DEVTYPESUPPLEMENTAL_RUDDERPEDALS      = 13;

  DIDC_ATTACHED           = $00000001;
  DIDC_POLLEDDEVICE       = $00000002;
  DIDC_EMULATED           = $00000004;
  DIDC_POLLEDDATAFORMAT   = $00000008;
  DIDC_FORCEFEEDBACK      = $00000100;
  DIDC_FFATTACK           = $00000200;
  DIDC_FFFADE             = $00000400;
  DIDC_SATURATION         = $00000800;
  DIDC_POSNEGCOEFFICIENTS = $00001000;
  DIDC_POSNEGSATURATION   = $00002000;
  DIDC_DEADBAND           = $00004000;
  DIDC_STARTDELAY         = $00008000;
  DIDC_ALIAS              = $00010000;
  DIDC_PHANTOM            = $00020000;

  DIDC_HIDDEN             = $00040000;  

  DIDFT_ALL = $00000000;

  DIDFT_RELAXIS = $00000001;
  DIDFT_ABSAXIS = $00000002;
  DIDFT_AXIS    = $00000003;

  DIDFT_PSHBUTTON = $00000004;
  DIDFT_TGLBUTTON = $00000008;
  DIDFT_BUTTON    = $0000000C;

  DIDFT_POV        = $00000010;
  DIDFT_COLLECTION = $00000040;
  DIDFT_NODATA     = $00000080;

  DIDFT_ANYINSTANCE  = $00FFFF00;
  DIDFT_INSTANCEMASK = DIDFT_ANYINSTANCE;

  DIDFT_FFACTUATOR        = $01000000;
  DIDFT_FFEFFECTTRIGGER   = $02000000;
  DIDFT_OUTPUT            = $10000000;
  DIDFT_VENDORDEFINED     = $04000000;
  DIDFT_ALIAS             = $08000000;

  DIDFT_NOCOLLECTION = $00FFFF00;

  DIDF_ABSAXIS = $00000001;
  DIDF_RELAXIS = $00000002;

  DIA_FORCEFEEDBACK = $00000001;
  DIA_APPMAPPED     = $00000002;
  DIA_APPNOMAP      = $00000004;
  DIA_NORANGE       = $00000008;
  DIA_APPFIXED      = $00000010;

  DIAH_UNMAPPED      = $00000000;
  DIAH_USERCONFIG    = $00000001;
  DIAH_APPREQUESTED  = $00000002;
  DIAH_HWAPP         = $00000004;
  DIAH_HWDEFAULT     = $00000008;
  DIAH_DEFAULT       = $00000020;
  DIAH_ERROR         = $80000000;

  DIAFTS_NEWDEVICELOW     = $FFFFFFFF;
  DIAFTS_NEWDEVICEHIGH    = $FFFFFFFF;
  DIAFTS_UNUSEDDEVICELOW  = $00000000;
  DIAFTS_UNUSEDDEVICEHIGH = $00000000;

  DIDBAM_DEFAULT          = $00000000;
  DIDBAM_PRESERVE         = $00000001;
  DIDBAM_INITIALIZE       = $00000002;
  DIDBAM_HWDEFAULTS       = $00000004;

  DIDSAM_DEFAULT          = $00000000;
  DIDSAM_NOUSER           = $00000001;
  DIDSAM_FORCESAVE        = $00000002;

  DICD_DEFAULT            = $00000000;
  DICD_EDIT               = $00000001;

  DIDIFT_CONFIGURATION = $00000001;
  DIDIFT_OVERLAY       = $00000002;

  DIDAL_CENTERED       = $00000000;
  DIDAL_LEFTALIGNED    = $00000001;
  DIDAL_RIGHTALIGNED   = $00000002;
  DIDAL_MIDDLE         = $00000000;
  DIDAL_TOPALIGNED     = $00000004;
  DIDAL_BOTTOMALIGNED  = $00000008;

  DIDOI_FFACTUATOR      = $00000001;
  DIDOI_FFEFFECTTRIGGER = $00000002;
  DIDOI_POLLED          = $00008000;
  DIDOI_ASPECTPOSITION  = $00000100;
  DIDOI_ASPECTVELOCITY  = $00000200;
  DIDOI_ASPECTACCEL     = $00000300;
  DIDOI_ASPECTFORCE     = $00000400;
  DIDOI_ASPECTMASK      = $00000F00;
  DIDOI_GUIDISUSAGE     = $00010000;

  DIPH_DEVICE = 0;
  DIPH_BYOFFSET = 1;
  DIPH_BYID = 2;
  DIPH_BYUSAGE = 3;

  DIPROPRANGE_NOMIN = $80000000;
  DIPROPRANGE_NOMAX = $7FFFFFFF;

  DIPROP_BUFFERSIZE = MAKEDIPROP(1);
  DIPROP_AXISMODE   = MAKEDIPROP(2);

  DIPROPAXISMODE_ABS = 0;
  DIPROPAXISMODE_REL = 1;

  DIPROP_GRANULARITY = MAKEDIPROP(3);
  DIPROP_RANGE       = MAKEDIPROP(4);
  DIPROP_DEADZONE    = MAKEDIPROP(5);
  DIPROP_SATURATION  = MAKEDIPROP(6);
  DIPROP_FFGAIN      = MAKEDIPROP(7);
  DIPROP_FFLOAD      = MAKEDIPROP(8);
  DIPROP_AUTOCENTER  = MAKEDIPROP(9);

  DIPROPAUTOCENTER_OFF = 0;
  DIPROPAUTOCENTER_ON  = 1;

  DIPROP_CALIBRATIONMODE = MAKEDIPROP(10);

  DIPROPCALIBRATIONMODE_COOKED = 0;
  DIPROPCALIBRATIONMODE_RAW    = 1;

  DIPROP_CALIBRATION        = MAKEDIPROP(11);
  DIPROP_GUIDANDPATH        = MAKEDIPROP(12);
  DIPROP_INSTANCENAME       = MAKEDIPROP(13);
  DIPROP_PRODUCTNAME        = MAKEDIPROP(14);
  DIPROP_JOYSTICKID         = MAKEDIPROP(15);
  DIPROP_GETPORTDISPLAYNAME = MAKEDIPROP(16);
  DIPROP_ENABLEREPORTID     = MAKEDIPROP(17);
  DIPROP_GETPHYSICALRANGE   = MAKEDIPROP(18);
  DIPROP_GETLOGICALRANGE    = MAKEDIPROP(19);
  DIPROP_KEYNAME            = MAKEDIPROP(20);
  DIPROP_CPOINTS            = MAKEDIPROP(21);
  DIPROP_APPDATA            = MAKEDIPROP(22);
  DIPROP_SCANCODE           = MAKEDIPROP(23);
  DIPROP_VIDPID             = MAKEDIPROP(24);
  DIPROP_USERNAME           = MAKEDIPROP(25);
  DIPROP_TYPENAME           = MAKEDIPROP(26);

  DIGDD_PEEK = $00000001;
{
#define DISEQUENCE_COMPARE(dwSequence1, cmp, dwSequence2) \
                         (int) ((dwSequence1) - (dwSequence2))  cmp 0
}

  DISCL_EXCLUSIVE    = $00000001;
  DISCL_NONEXCLUSIVE = $00000002;
  DISCL_FOREGROUND   = $00000004;
  DISCL_BACKGROUND   = $00000008;
  DISCL_NOWINKEY     = $00000010;

  DISFFC_RESET            = $00000001;
  DISFFC_STOPALL          = $00000002;
  DISFFC_PAUSE            = $00000004;
  DISFFC_CONTINUE         = $00000008;
  DISFFC_SETACTUATORSON   = $00000010;
  DISFFC_SETACTUATORSOFF  = $00000020;

  DIGFFS_EMPTY            = $00000001;
  DIGFFS_STOPPED          = $00000002;
  DIGFFS_PAUSED           = $00000004;
  DIGFFS_ACTUATORSON      = $00000010;
  DIGFFS_ACTUATORSOFF     = $00000020;
  DIGFFS_POWERON          = $00000040;
  DIGFFS_POWEROFF         = $00000080;
  DIGFFS_SAFETYSWITCHON   = $00000100;
  DIGFFS_SAFETYSWITCHOFF  = $00000200;
  DIGFFS_USERFFSWITCHON   = $00000400;
  DIGFFS_USERFFSWITCHOFF  = $00000800;
  DIGFFS_DEVICELOST       = $80000000;

  DISDD_CONTINUE          = $00000001;

  DIFEF_DEFAULT            = $00000000;
  DIFEF_INCLUDENONSTANDARD = $00000001;
  DIFEF_MODIFYIFNEEDED	   = $00000010;

  DIMOFS_X       = 0;
  DIMOFS_Y       = 4;
  DIMOFS_Z       = 8;
  DIMOFS_BUTTON0 = 12;
  DIMOFS_BUTTON1 = 13;
  DIMOFS_BUTTON2 = 14;
  DIMOFS_BUTTON3 = 15;
  // DX7 supports up to 8 mouse buttons
  DIMOFS_BUTTON4 = DIMOFS_BUTTON0 + 4;
  DIMOFS_BUTTON5 = DIMOFS_BUTTON0 + 5;
  DIMOFS_BUTTON6 = DIMOFS_BUTTON0 + 6;
  DIMOFS_BUTTON7 = DIMOFS_BUTTON0 + 7;


  _c_dfDIMouse_Objects: array[0..6] of TDIObjectDataFormat = (
    (  pguid: @GUID_XAxis;
       dwOfs: DIMOFS_X;
       dwType: DIDFT_AXIS or DIDFT_NOCOLLECTION;
       dwFlags: 0),
    (  pguid: @GUID_YAxis;
       dwOfs: DIMOFS_Y;
       dwType: DIDFT_AXIS or DIDFT_NOCOLLECTION;
       dwFlags: 0),
    (  pguid: @GUID_ZAxis;
       dwOfs: DIMOFS_Z;
       dwType: $80000000 or DIDFT_AXIS or DIDFT_NOCOLLECTION;
       dwFlags: 0),
    (  pguid: nil;
       dwOfs: DIMOFS_BUTTON0;
       dwType: DIDFT_BUTTON or DIDFT_NOCOLLECTION;
       dwFlags: 0),
    (  pguid: nil;
       dwOfs: DIMOFS_BUTTON1;
       dwType: DIDFT_BUTTON or DIDFT_NOCOLLECTION;
       dwFlags: 0),
    (  pguid: nil;
       dwOfs: DIMOFS_BUTTON2;
       dwType: $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION;
       dwFlags: 0),
    (  pguid: nil;
       dwOfs: DIMOFS_BUTTON3;
       dwType: $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION;
       dwFlags: 0)
    );

  c_dfDIMouse: TDIDataFormat = (
    dwSize: Sizeof(c_dfDIMouse);              // $18
    dwObjSize: Sizeof(TDIObjectDataFormat);   // $10
    dwFlags: DIDF_RELAXIS;                    //
    dwDataSize: Sizeof(TDIMouseState);        // $10
    dwNumObjs: High(_c_dfDIMouse_Objects)+1;  // 7
    rgodf: @_c_dfDIMouse_Objects[Low(_c_dfDIMouse_Objects)]
  );


  _c_dfDIMouse2_Objects: array[0..10] of TDIObjectDataFormat = (
    (  pguid: @GUID_XAxis;
       dwOfs: DIMOFS_X;
       dwType: DIDFT_AXIS or DIDFT_NOCOLLECTION;
       dwFlags: 0),
    (  pguid: @GUID_YAxis;
       dwOfs: DIMOFS_Y;
       dwType: DIDFT_AXIS or DIDFT_NOCOLLECTION;
       dwFlags: 0),
    (  pguid: @GUID_ZAxis;
       dwOfs: DIMOFS_Z;
       dwType: $80000000 or DIDFT_AXIS or DIDFT_NOCOLLECTION;
       dwFlags: 0),
    (  pguid: nil;
       dwOfs: DIMOFS_BUTTON0;
       dwType: DIDFT_BUTTON or DIDFT_NOCOLLECTION;
       dwFlags: 0),
    (  pguid: nil;
       dwOfs: DIMOFS_BUTTON1;
       dwType: DIDFT_BUTTON or DIDFT_NOCOLLECTION;
       dwFlags: 0),
    (  pguid: nil;
       dwOfs: DIMOFS_BUTTON2;
       dwType: $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION;
       dwFlags: 0),
    (  pguid: nil;
       dwOfs: DIMOFS_BUTTON3;
       dwType: $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION;
       dwFlags: 0),
    // fields introduced with IDirectInputDevice7.GetDeviceState       
    (  pguid: nil;
       dwOfs: DIMOFS_BUTTON4;
       dwType: $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION;
       dwFlags: 0),
    (  pguid: nil;
       dwOfs: DIMOFS_BUTTON5;
       dwType: $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION;
       dwFlags: 0),
    (  pguid: nil;
       dwOfs: DIMOFS_BUTTON6;
       dwType: $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION;
       dwFlags: 0),
    (  pguid: nil;
       dwOfs: DIMOFS_BUTTON7;
       dwType: $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION;
       dwFlags: 0)
    );

  c_dfDIMouse2: TDIDataFormat = (
    dwSize: Sizeof(c_dfDIMouse);              // $18
    dwObjSize: Sizeof(TDIObjectDataFormat);   // $10
    dwFlags: DIDF_RELAXIS;                    //
    dwDataSize: Sizeof(TDIMouseState2);        // $14
    dwNumObjs: High(_c_dfDIMouse_Objects)+1;  // 11
    rgodf: @_c_dfDIMouse2_Objects[Low(_c_dfDIMouse2_Objects)]
  );


  DIK_ESCAPE          = $01;
  DIK_1               = $02;
  DIK_2               = $03;
  DIK_3               = $04;
  DIK_4               = $05;
  DIK_5               = $06;
  DIK_6               = $07;
  DIK_7               = $08;
  DIK_8               = $09;
  DIK_9               = $0A;
  DIK_0               = $0B;
  DIK_MINUS           = $0C;    (* - on main keyboard *)
  DIK_EQUALS          = $0D;
  DIK_BACK            = $0E;    (* backspace *)
  DIK_TAB             = $0F;
  DIK_Q               = $10;
  DIK_W               = $11;
  DIK_E               = $12;
  DIK_R               = $13;
  DIK_T               = $14;
  DIK_Y               = $15;
  DIK_U               = $16;
  DIK_I               = $17;
  DIK_O               = $18;
  DIK_P               = $19;
  DIK_LBRACKET        = $1A;
  DIK_RBRACKET        = $1B;
  DIK_RETURN          = $1C;    (* Enter on main keyboard *)
  DIK_LCONTROL        = $1D;
  DIK_A               = $1E;
  DIK_S               = $1F;
  DIK_D               = $20;
  DIK_F               = $21;
  DIK_G               = $22;
  DIK_H               = $23;
  DIK_J               = $24;
  DIK_K               = $25;
  DIK_L               = $26;
  DIK_SEMICOLON       = $27;
  DIK_APOSTROPHE      = $28;
  DIK_GRAVE           = $29;    (* accent grave *)
  DIK_LSHIFT          = $2A;
  DIK_BACKSLASH       = $2B;
  DIK_Z               = $2C;
  DIK_X               = $2D;
  DIK_C               = $2E;
  DIK_V               = $2F;
  DIK_B               = $30;
  DIK_N               = $31;
  DIK_M               = $32;
  DIK_COMMA           = $33;
  DIK_PERIOD          = $34;    (* . on main keyboard *)
  DIK_SLASH           = $35;    (* / on main keyboard *)
  DIK_RSHIFT          = $36;
  DIK_MULTIPLY        = $37;    (* * on numeric keypad *)
  DIK_LMENU           = $38;    (* left Alt *)
  DIK_SPACE           = $39;
  DIK_CAPITAL         = $3A;
  DIK_F1              = $3B;
  DIK_F2              = $3C;
  DIK_F3              = $3D;
  DIK_F4              = $3E;
  DIK_F5              = $3F;
  DIK_F6              = $40;
  DIK_F7              = $41;
  DIK_F8              = $42;
  DIK_F9              = $43;
  DIK_F10             = $44;
  DIK_NUMLOCK         = $45;
  DIK_SCROLL          = $46;    (* Scroll Lock *)
  DIK_NUMPAD7         = $47;
  DIK_NUMPAD8         = $48;
  DIK_NUMPAD9         = $49;
  DIK_SUBTRACT        = $4A;    (* - on numeric keypad *)
  DIK_NUMPAD4         = $4B;
  DIK_NUMPAD5         = $4C;
  DIK_NUMPAD6         = $4D;
  DIK_ADD             = $4E;    (* + on numeric keypad *)
  DIK_NUMPAD1         = $4F;
  DIK_NUMPAD2         = $50;
  DIK_NUMPAD3         = $51;
  DIK_NUMPAD0         = $52;
  DIK_DECIMAL         = $53;    (* . on numeric keypad *)
  // $54 to $55 unassigned
  DIK_OEM_102         = $56;    (* < > | on UK/Germany keyboards *)
  DIK_F11             = $57;
  DIK_F12             = $58;
  // $59 to $63 unassigned
  DIK_F13             = $64;    (*                     (NEC PC98) *)
  DIK_F14             = $65;    (*                     (NEC PC98) *)
  DIK_F15             = $66;    (*                     (NEC PC98) *)
  // $67 to $6F unassigned
  DIK_KANA            = $70;    (* (Japanese keyboard)            *)
  DIK_ABNT_C1         = $73;    (* / ? on Portugese (Brazilian) keyboards *)
  // $74 to $78 unassigned
  DIK_CONVERT         = $79;    (* (Japanese keyboard)            *)
  // $7A unassigned  
  DIK_NOCONVERT       = $7B;    (* (Japanese keyboard)            *)
  // $7C unassigned
  DIK_YEN             = $7D;    (* (Japanese keyboard)            *)
  DIK_ABNT_C2         = $7E;    (* Numpad . on Portugese (Brazilian) keyboards *)  
  // $7F to 8C unassigned
  DIK_NUMPADEQUALS    = $8D;    (* = on numeric keypad (NEC PC98) *)
  // $8E to $8F unassigned
  DIK_CIRCUMFLEX      = $90;    (* (Japanese keyboard)            *)
  DIK_AT              = $91;    (*                     (NEC PC98) *)
  DIK_COLON           = $92;    (*                     (NEC PC98) *)
  DIK_UNDERLINE       = $93;    (*                     (NEC PC98) *)
  DIK_KANJI           = $94;    (* (Japanese keyboard)            *)
  DIK_STOP            = $95;    (*                     (NEC PC98) *)
  DIK_AX              = $96;    (*                     (Japan AX) *)
  DIK_UNLABELED       = $97;    (*                        (J3100) *)
  // $98 unassigned
  DIK_NEXTTRACK       = $99;    (* Next Track *)
  // $9A to $9D unassigned    
  DIK_NUMPADENTER     = $9C;    (* Enter on numeric keypad *)
  DIK_RCONTROL        = $9D;
  // $9E to $9F unassigned
  DIK_MUTE            = $A0;    (* Mute *)
  DIK_CALCULATOR      = $A1;    (* Calculator *)
  DIK_PLAYPAUSE       = $A2;    (* Play / Pause *)
  DIK_MEDIASTOP       = $A4;    (* Media Stop *)
  // $A5 to $AD unassigned  
  DIK_VOLUMEDOWN      = $AE;    (* Volume - *)
  // $AF unassigned  
  DIK_VOLUMEUP        = $B0;    (* Volume + *)
  // $B1 unassigned  
  DIK_WEBHOME         = $B2;    (* Web home *)
  DIK_NUMPADCOMMA     = $B3;    (* , on numeric keypad (NEC PC98) *)
  // $B4 unassigned
  DIK_DIVIDE          = $B5;    (* / on numeric keypad *)
  // $B6 unassigned
  DIK_SYSRQ           = $B7;
  DIK_RMENU           = $B8;    (* right Alt *)
  // $B9 to $C4 unassigned
  DIK_PAUSE           = $C5;    (* Pause (watch out - not realiable on some kbds) *)
  // $C6 unassigned
  DIK_HOME            = $C7;    (* Home on arrow keypad *)
  DIK_UP              = $C8;    (* UpArrow on arrow keypad *)
  DIK_PRIOR           = $C9;    (* PgUp on arrow keypad *)
  // $CA unassigned
  DIK_LEFT            = $CB;    (* LeftArrow on arrow keypad *)
  // $CC unassigned  
  DIK_RIGHT           = $CD;    (* RightArrow on arrow keypad *)
  // $CE unassigned
  DIK_END             = $CF;    (* End on arrow keypad *)
  DIK_DOWN            = $D0;    (* DownArrow on arrow keypad *)
  DIK_NEXT            = $D1;    (* PgDn on arrow keypad *)
  DIK_INSERT          = $D2;    (* Insert on arrow keypad *)
  DIK_DELETE          = $D3;    (* Delete on arrow keypad *)
  DIK_LWIN            = $DB;    (* Left Windows key *)
  DIK_RWIN            = $DC;    (* Right Windows key *)
  DIK_APPS            = $DD;    (* AppMenu key *)
  DIK_POWER           = $DE;
  DIK_SLEEP           = $DF;
  // $E0 to $E2 unassigned
  DIK_WAKE            = $E3;    (* System Wake *)
  // $E4 unassigned
  DIK_WEBSEARCH       = $E5;    (* Web Search *)
  DIK_WEBFAVORITES    = $E6;    (* Web Favorites *)
  DIK_WEBREFRESH      = $E7;    (* Web Refresh *)
  DIK_WEBSTOP         = $E8;    (* Web Stop *)
  DIK_WEBFORWARD      = $E9;    (* Web Forward *)
  DIK_WEBBACK         = $EA;    (* Web Back *)
  DIK_MYCOMPUTER      = $EB;    (* My Computer *)
  DIK_MAIL            = $EC;    (* Mail *)
  DIK_MEDIASELECT     = $ED;    (* Media Select *)


(*
 *  Alternate names for keys, to facilitate transition from DOS.
 *)
  DIK_BACKSPACE      = DIK_BACK;      (* backspace *)
  DIK_NUMPADSTAR     = DIK_MULTIPLY;  (* * on numeric keypad *)
  DIK_LALT           = DIK_LMENU;     (* left Alt *)
  DIK_CAPSLOCK       = DIK_CAPITAL;   (* CapsLock *)
  DIK_NUMPADMINUS    = DIK_SUBTRACT;  (* - on numeric keypad *)
  DIK_NUMPADPLUS     = DIK_ADD;       (* + on numeric keypad *)
  DIK_NUMPADPERIOD   = DIK_DECIMAL;   (* . on numeric keypad *)
  DIK_NUMPADSLASH    = DIK_DIVIDE;    (* / on numeric keypad *)
  DIK_RALT           = DIK_RMENU;     (* right Alt *)
  DIK_UPARROW        = DIK_UP;        (* UpArrow on arrow keypad *)
  DIK_PGUP           = DIK_PRIOR;     (* PgUp on arrow keypad *)
  DIK_LEFTARROW      = DIK_LEFT;      (* LeftArrow on arrow keypad *)
  DIK_RIGHTARROW     = DIK_RIGHT;     (* RightArrow on arrow keypad *)
  DIK_DOWNARROW      = DIK_DOWN;      (* DownArrow on arrow keypad *)
  DIK_PGDN           = DIK_NEXT;      (* PgDn on arrow keypad *)

(*
 *  Alternate names for keys originally not used on US keyboards.
 *)

  DIK_PREVTRACK      = DIK_CIRCUMFLEX;  (* Japanese keyboard *)


  DIJOFS_X  =0;
  DIJOFS_Y  =4;
  DIJOFS_Z  =8;
  DIJOFS_RX =12;
  DIJOFS_RY =16;
  DIJOFS_RZ =20;

  DIJOFS_BUTTON_ = 48;

  DIJOFS_BUTTON0 = DIJOFS_BUTTON_ + 0;
  DIJOFS_BUTTON1 = DIJOFS_BUTTON_ + 1;
  DIJOFS_BUTTON2 = DIJOFS_BUTTON_ + 2;
  DIJOFS_BUTTON3 = DIJOFS_BUTTON_ + 3;
  DIJOFS_BUTTON4 = DIJOFS_BUTTON_ + 4;
  DIJOFS_BUTTON5 = DIJOFS_BUTTON_ + 5;
  DIJOFS_BUTTON6 = DIJOFS_BUTTON_ + 6;
  DIJOFS_BUTTON7 = DIJOFS_BUTTON_ + 7;
  DIJOFS_BUTTON8 = DIJOFS_BUTTON_ + 8;
  DIJOFS_BUTTON9 = DIJOFS_BUTTON_ + 9;
  DIJOFS_BUTTON10 = DIJOFS_BUTTON_ + 10;
  DIJOFS_BUTTON11 = DIJOFS_BUTTON_ + 11;
  DIJOFS_BUTTON12 = DIJOFS_BUTTON_ + 12;
  DIJOFS_BUTTON13 = DIJOFS_BUTTON_ + 13;
  DIJOFS_BUTTON14 = DIJOFS_BUTTON_ + 14;
  DIJOFS_BUTTON15 = DIJOFS_BUTTON_ + 15;
  DIJOFS_BUTTON16 = DIJOFS_BUTTON_ + 16;
  DIJOFS_BUTTON17 = DIJOFS_BUTTON_ + 17;
  DIJOFS_BUTTON18 = DIJOFS_BUTTON_ + 18;
  DIJOFS_BUTTON19 = DIJOFS_BUTTON_ + 19;
  DIJOFS_BUTTON20 = DIJOFS_BUTTON_ + 20;
  DIJOFS_BUTTON21 = DIJOFS_BUTTON_ + 21;
  DIJOFS_BUTTON22 = DIJOFS_BUTTON_ + 22;
  DIJOFS_BUTTON23 = DIJOFS_BUTTON_ + 23;
  DIJOFS_BUTTON24 = DIJOFS_BUTTON_ + 24;
  DIJOFS_BUTTON25 = DIJOFS_BUTTON_ + 25;
  DIJOFS_BUTTON26 = DIJOFS_BUTTON_ + 26;
  DIJOFS_BUTTON27 = DIJOFS_BUTTON_ + 27;
  DIJOFS_BUTTON28 = DIJOFS_BUTTON_ + 28;
  DIJOFS_BUTTON29 = DIJOFS_BUTTON_ + 29;
  DIJOFS_BUTTON30 = DIJOFS_BUTTON_ + 30;
  DIJOFS_BUTTON31 = DIJOFS_BUTTON_ + 31;

  DIENUM_STOP     = 0;
  DIENUM_CONTINUE = 1;


  DIEDFL_ALLDEVICES       = $00000000;
  DIEDFL_ATTACHEDONLY     = $00000001;
  DIEDFL_FORCEFEEDBACK    = $00000100;

  DIEDFL_INCLUDEALIASES   = $00010000;
  DIEDFL_INCLUDEPHANTOMS  = $00020000;

  DIEDFL_INCLUDEHIDDEN    = $00040000;

  DIEDBS_MAPPEDPRI1           = $00000001;
  DIEDBS_MAPPEDPRI2           = $00000002;
  DIEDBS_RECENTDEVICE         = $00000010;
  DIEDBS_NEWDEVICE            = $00000020;

  DIEDBSFL_ATTACHEDONLY       = $00000000;
  DIEDBSFL_THISUSER           = $00000010;
  DIEDBSFL_FORCEFEEDBACK      = DIEDFL_FORCEFEEDBACK;
  DIEDBSFL_AVAILABLEDEVICES   = $00001000;
  DIEDBSFL_MULTIMICEKEYBOARDS = $00002000;
  DIEDBSFL_NONGAMINGDEVICES   = $00004000;
  DIEDBSFL_VALID              = $00007110;


(****************************************************************************
 *
 *  Return Codes
 *
 ****************************************************************************)

(*
 *  The operation completed successfully.
 *)

  DI_OK = S_OK;

(*
 *  The device exists but is not currently attached.
 *)
  DI_NOTATTACHED = S_FALSE;

(*
 *  The device buffer overflowed.  Some input was lost.
 *)
  DI_BUFFEROVERFLOW = S_FALSE;

(*
 *  The change in device properties had no effect.
 *)
  DI_PROPNOEFFECT = S_FALSE;

(*
 *  The operation had no effect.
 *)
  DI_NOEFFECT = S_FALSE;

(*
 *  The device is a polled device.  As a result, device buffering
 *  will not collect any data and event notifications will not be
 *  signalled until GetDeviceState is called.
 *)
  DI_POLLEDDEVICE = $00000002;

(*
 *  The parameters of the effect were successfully updated by
 *  IDirectInputEffect::SetParameters, but the effect was not
 *  downloaded because the device is not exclusively acquired
 *  or because the DIEP_NODOWNLOAD flag was passed.
 *)
  DI_DOWNLOADSKIPPED = $00000003;

(*
 *  The parameters of the effect were successfully updated by
 *  IDirectInputEffect::SetParameters, but in order to change
 *  the parameters, the effect needed to be restarted.
 *)
  DI_EFFECTRESTARTED = $00000004;

(*
 *  The parameters of the effect were successfully updated by
 *  IDirectInputEffect::SetParameters, but some of them were
 *  beyond the capabilities of the device and were truncated.
 *)
  DI_TRUNCATED = $00000008;

(*
 *  The settings have been successfully applied but could not be
 *  persisted.
 *)
 DI_SETTINGSNOTSAVED = $0000000B;

(*
 *  Equal to DI_EFFECTRESTARTED | DI_TRUNCATED.
 *)
  DI_TRUNCATEDANDRESTARTED = $0000000C;


  SEVERITY_ERROR_FACILITY_WIN32 =
      HResult(SEVERITY_ERROR shl 31) or HResult(FACILITY_WIN32 shl 16);

(*
 *  The application requires a newer version of DirectInput.
 *)

  DIERR_OLDDIRECTINPUTVERSION = SEVERITY_ERROR_FACILITY_WIN32
      or ERROR_OLD_WIN_VERSION;

(*
 *  The application was written for an unsupported prerelease version
 *  of DirectInput.
 *)
  DIERR_BETADIRECTINPUTVERSION = SEVERITY_ERROR_FACILITY_WIN32
      or ERROR_RMODE_APP;

(*
 *  The object could not be created due to an incompatible driver version
 *  or mismatched or incomplete driver components.
 *)
  DIERR_BADDRIVERVER = SEVERITY_ERROR_FACILITY_WIN32
      or ERROR_BAD_DRIVER_LEVEL;

(*
 * The device or device instance or effect is not registered with DirectInput.
 *)
  DIERR_DEVICENOTREG = REGDB_E_CLASSNOTREG;

(*
 * The requested object does not exist.
 *)
  DIERR_NOTFOUND = SEVERITY_ERROR_FACILITY_WIN32
      or ERROR_FILE_NOT_FOUND;

(*
 * The requested object does not exist.
 *)
  DIERR_OBJECTNOTFOUND = SEVERITY_ERROR_FACILITY_WIN32
      or ERROR_FILE_NOT_FOUND;

(*
 * An invalid parameter was passed to the returning function,
 * or the object was not in a state that admitted the function
 * to be called.
 *)
  DIERR_INVALIDPARAM = E_INVALIDARG;

(*
 * The specified interface is not supported by the object
 *)
  DIERR_NOINTERFACE = E_NOINTERFACE;

(*
 * An undetermined error occured inside the DInput subsystem
 *)
  DIERR_GENERIC = E_FAIL;

(*
 * The DInput subsystem couldn't allocate sufficient memory to complete the
 * caller's request.
 *)
  DIERR_OUTOFMEMORY = E_OUTOFMEMORY;

(*
 * The function called is not supported at this time
 *)
  DIERR_UNSUPPORTED = E_NOTIMPL;

(*
 * This object has not been initialized
 *)
  DIERR_NOTINITIALIZED = SEVERITY_ERROR_FACILITY_WIN32
      or ERROR_NOT_READY;

(*
 * This object is already initialized
 *)
  DIERR_ALREADYINITIALIZED = SEVERITY_ERROR_FACILITY_WIN32
      or ERROR_ALREADY_INITIALIZED;

(*
 * This object does not support aggregation
 *)
  DIERR_NOAGGREGATION = CLASS_E_NOAGGREGATION;

(*
 * Another app has a higher priority level, preventing this call from
 * succeeding.
 *)
  DIERR_OTHERAPPHASPRIO = E_ACCESSDENIED;

(*
 * Access to the device has been lost.  It must be re-acquired.
 *)
  DIERR_INPUTLOST = SEVERITY_ERROR_FACILITY_WIN32
      or ERROR_READ_FAULT;

(*
 * The operation cannot be performed while the device is acquired.
 *)
  DIERR_ACQUIRED = SEVERITY_ERROR_FACILITY_WIN32
      or ERROR_BUSY;

(*
 * The operation cannot be performed unless the device is acquired.
 *)
  DIERR_NOTACQUIRED = SEVERITY_ERROR_FACILITY_WIN32
      or ERROR_INVALID_ACCESS;

(*
 * The specified property cannot be changed.
 *)
  DIERR_READONLY = E_ACCESSDENIED;

(*
 * The device already has an event notification associated with it.
 *)
  DIERR_HANDLEEXISTS = E_ACCESSDENIED;

(*
 * Data is not yet available.
 *)
  E_PENDING = HResult($80070007);

(*
 * Unable to IDirectInputJoyConfig_Acquire because the user
 * does not have sufficient privileges to change the joystick
 * configuration.
 *)
  DIERR_INSUFFICIENTPRIVS = HResult($80040200);

(*
 * The device is full.
 *)
  DIERR_DEVICEFULL = DIERR_INSUFFICIENTPRIVS + 1;

(*
 * Not all the requested information fit into the buffer.
 *)
  DIERR_MOREDATA = DIERR_INSUFFICIENTPRIVS + 2;

(*
 * The effect is not downloaded.
 *)
  DIERR_NOTDOWNLOADED = DIERR_INSUFFICIENTPRIVS + 3;

(*
 *  The device cannot be reinitialized because there are still effects
 *  attached to it.
 *)
  DIERR_HASEFFECTS = DIERR_INSUFFICIENTPRIVS + 4;

(*
 *  The operation cannot be performed unless the device is acquired
 *  in DISCL_EXCLUSIVE mode.
 *)
  DIERR_NOTEXCLUSIVEACQUIRED = DIERR_INSUFFICIENTPRIVS + 5;

(*
 *  The effect could not be downloaded because essential information
 *  is missing.  For example, no axes have been associated with the
 *  effect, or no type-specific information has been created.
 *)
  DIERR_INCOMPLETEEFFECT = DIERR_INSUFFICIENTPRIVS + 6;

(*
 *  Attempted to read buffered device data from a device that is
 *  not buffered.
 *)
  DIERR_NOTBUFFERED = DIERR_INSUFFICIENTPRIVS + 7;

(*
 *  An attempt was made to modify parameters of an effect while it is
 *  playing.  Not all hardware devices support altering the parameters
 *  of an effect while it is playing.
 *)
  DIERR_EFFECTPLAYING = DIERR_INSUFFICIENTPRIVS + 8;

(*
 *  The operation could not be completed because the device is not
 *  plugged in.
 *)
  DIERR_UNPLUGGED                = $80040209;

(*
 *  SendDeviceData failed because more information was requested
 *  to be sent than can be sent to the device.  Some devices have
 *  restrictions on how much data can be sent to them.  (For example,
 *  there might be a limit on the number of buttons that can be
 *  pressed at once.)
 *)
 DIERR_REPORTFULL                = $8004020A;


(*
 *  A mapper file function failed because reading or writing the user or IHV
 *  settings file failed.
 *)
 DIERR_MAPFILEFAIL               = $8004020B;


(*--- DINPUT Mapper Definitions: New for Dx8         ---*)


(*--- Keyboard
      Physical Keyboard Device       ---*)

  DIKEYBOARD_ESCAPE                       = $81000401;
  DIKEYBOARD_1                            = $81000402;
  DIKEYBOARD_2                            = $81000403;
  DIKEYBOARD_3                            = $81000404;
  DIKEYBOARD_4                            = $81000405;
  DIKEYBOARD_5                            = $81000406;
  DIKEYBOARD_6                            = $81000407;
  DIKEYBOARD_7                            = $81000408;
  DIKEYBOARD_8                            = $81000409;
  DIKEYBOARD_9                            = $8100040A;
  DIKEYBOARD_0                            = $8100040B;
  DIKEYBOARD_MINUS                        = $8100040C;    (* - on main keyboard *)
  DIKEYBOARD_EQUALS                       = $8100040D;
  DIKEYBOARD_BACK                         = $8100040E;    (* backspace *)
  DIKEYBOARD_TAB                          = $8100040F;
  DIKEYBOARD_Q                            = $81000410;
  DIKEYBOARD_W                            = $81000411;
  DIKEYBOARD_E                            = $81000412;
  DIKEYBOARD_R                            = $81000413;
  DIKEYBOARD_T                            = $81000414;
  DIKEYBOARD_Y                            = $81000415;
  DIKEYBOARD_U                            = $81000416;
  DIKEYBOARD_I                            = $81000417;
  DIKEYBOARD_O                            = $81000418;
  DIKEYBOARD_P                            = $81000419;
  DIKEYBOARD_LBRACKET                     = $8100041A;
  DIKEYBOARD_RBRACKET                     = $8100041B;
  DIKEYBOARD_RETURN                       = $8100041C;    (* Enter on main keyboard *)
  DIKEYBOARD_LCONTROL                     = $8100041D;
  DIKEYBOARD_A                            = $8100041E;
  DIKEYBOARD_S                            = $8100041F;
  DIKEYBOARD_D                            = $81000420;
  DIKEYBOARD_F                            = $81000421;
  DIKEYBOARD_G                            = $81000422;
  DIKEYBOARD_H                            = $81000423;
  DIKEYBOARD_J                            = $81000424;
  DIKEYBOARD_K                            = $81000425;
  DIKEYBOARD_L                            = $81000426;
  DIKEYBOARD_SEMICOLON                    = $81000427;
  DIKEYBOARD_APOSTROPHE                   = $81000428;
  DIKEYBOARD_GRAVE                        = $81000429;    (* accent grave *)
  DIKEYBOARD_LSHIFT                       = $8100042A;
  DIKEYBOARD_BACKSLASH                    = $8100042B;
  DIKEYBOARD_Z                            = $8100042C;
  DIKEYBOARD_X                            = $8100042D;
  DIKEYBOARD_C                            = $8100042E;
  DIKEYBOARD_V                            = $8100042F;
  DIKEYBOARD_B                            = $81000430;
  DIKEYBOARD_N                            = $81000431;
  DIKEYBOARD_M                            = $81000432;
  DIKEYBOARD_COMMA                        = $81000433;
  DIKEYBOARD_PERIOD                       = $81000434;    (* . on main keyboard *)
  DIKEYBOARD_SLASH                        = $81000435;    (* / on main keyboard *)
  DIKEYBOARD_RSHIFT                       = $81000436;
  DIKEYBOARD_MULTIPLY                     = $81000437;    (* * on numeric keypad *)
  DIKEYBOARD_LMENU                        = $81000438;    (* left Alt *)
  DIKEYBOARD_SPACE                        = $81000439;
  DIKEYBOARD_CAPITAL                      = $8100043A;
  DIKEYBOARD_F1                           = $8100043B;
  DIKEYBOARD_F2                           = $8100043C;
  DIKEYBOARD_F3                           = $8100043D;
  DIKEYBOARD_F4                           = $8100043E;
  DIKEYBOARD_F5                           = $8100043F;
  DIKEYBOARD_F6                           = $81000440;
  DIKEYBOARD_F7                           = $81000441;
  DIKEYBOARD_F8                           = $81000442;
  DIKEYBOARD_F9                           = $81000443;
  DIKEYBOARD_F10                          = $81000444;
  DIKEYBOARD_NUMLOCK                      = $81000445;
  DIKEYBOARD_SCROLL                       = $81000446;    (* Scroll Lock *)
  DIKEYBOARD_NUMPAD7                      = $81000447;
  DIKEYBOARD_NUMPAD8                      = $81000448;
  DIKEYBOARD_NUMPAD9                      = $81000449;
  DIKEYBOARD_SUBTRACT                     = $8100044A;    (* - on numeric keypad *)
  DIKEYBOARD_NUMPAD4                      = $8100044B;
  DIKEYBOARD_NUMPAD5                      = $8100044C;
  DIKEYBOARD_NUMPAD6                      = $8100044D;
  DIKEYBOARD_ADD                          = $8100044E;    (* + on numeric keypad *)
  DIKEYBOARD_NUMPAD1                      = $8100044F;
  DIKEYBOARD_NUMPAD2                      = $81000450;
  DIKEYBOARD_NUMPAD3                      = $81000451;
  DIKEYBOARD_NUMPAD0                      = $81000452;
  DIKEYBOARD_DECIMAL                      = $81000453;    (* . on numeric keypad *)
  DIKEYBOARD_OEM_102                      = $81000456;    (* < > | on UK/Germany keyboards *)
  DIKEYBOARD_F11                          = $81000457;
  DIKEYBOARD_F12                          = $81000458;
  DIKEYBOARD_F13                          = $81000464;    (*                     (NEC PC98) *)
  DIKEYBOARD_F14                          = $81000465;    (*                     (NEC PC98) *)
  DIKEYBOARD_F15                          = $81000466;    (*                     (NEC PC98) *)
  DIKEYBOARD_KANA                         = $81000470;    (* (Japanese keyboard)            *)
  DIKEYBOARD_ABNT_C1                      = $81000473;    (* / ? on Portugese (Brazilian) keyboards *)
  DIKEYBOARD_CONVERT                      = $81000479;    (* (Japanese keyboard)            *)
  DIKEYBOARD_NOCONVERT                    = $8100047B;    (* (Japanese keyboard)            *)
  DIKEYBOARD_YEN                          = $8100047D;    (* (Japanese keyboard)            *)
  DIKEYBOARD_ABNT_C2                      = $8100047E;    (* Numpad . on Portugese (Brazilian) keyboards *)
  DIKEYBOARD_NUMPADEQUALS                 = $8100048D;    (* = on numeric keypad (NEC PC98) *)
  DIKEYBOARD_PREVTRACK                    = $81000490;    (* Previous Track (DIK_CIRCUMFLEX on Japanese keyboard) *)
  DIKEYBOARD_AT                           = $81000491;    (*                     (NEC PC98) *)
  DIKEYBOARD_COLON                        = $81000492;    (*                     (NEC PC98) *)
  DIKEYBOARD_UNDERLINE                    = $81000493;    (*                     (NEC PC98) *)
  DIKEYBOARD_KANJI                        = $81000494;    (* (Japanese keyboard)            *)
  DIKEYBOARD_STOP                         = $81000495;    (*                     (NEC PC98) *)
  DIKEYBOARD_AX                           = $81000496;    (*                     (Japan AX) *)
  DIKEYBOARD_UNLABELED                    = $81000497;    (*                        (J3100) *)
  DIKEYBOARD_NEXTTRACK                    = $81000499;    (* Next Track *)
  DIKEYBOARD_NUMPADENTER                  = $8100049C;    (* Enter on numeric keypad *)
  DIKEYBOARD_RCONTROL                     = $8100049D;
  DIKEYBOARD_MUTE                         = $810004A0;    (* Mute *)
  DIKEYBOARD_CALCULATOR                   = $810004A1;    (* Calculator *)
  DIKEYBOARD_PLAYPAUSE                    = $810004A2;    (* Play / Pause *)
  DIKEYBOARD_MEDIASTOP                    = $810004A4;    (* Media Stop *)
  DIKEYBOARD_VOLUMEDOWN                   = $810004AE;    (* Volume - *)
  DIKEYBOARD_VOLUMEUP                     = $810004B0;    (* Volume + *)
  DIKEYBOARD_WEBHOME                      = $810004B2;    (* Web home *)
  DIKEYBOARD_NUMPADCOMMA                  = $810004B3;    (* , on numeric keypad (NEC PC98) *)
  DIKEYBOARD_DIVIDE                       = $810004B5;    (* / on numeric keypad *)
  DIKEYBOARD_SYSRQ                        = $810004B7;
  DIKEYBOARD_RMENU                        = $810004B8;    (* right Alt *)
  DIKEYBOARD_PAUSE                        = $810004C5;    (* Pause *)
  DIKEYBOARD_HOME                         = $810004C7;    (* Home on arrow keypad *)
  DIKEYBOARD_UP                           = $810004C8;    (* UpArrow on arrow keypad *)
  DIKEYBOARD_PRIOR                        = $810004C9;    (* PgUp on arrow keypad *)
  DIKEYBOARD_LEFT                         = $810004CB;    (* LeftArrow on arrow keypad *)
  DIKEYBOARD_RIGHT                        = $810004CD;    (* RightArrow on arrow keypad *)
  DIKEYBOARD_END                          = $810004CF;    (* End on arrow keypad *)
  DIKEYBOARD_DOWN                         = $810004D0;    (* DownArrow on arrow keypad *)
  DIKEYBOARD_NEXT                         = $810004D1;    (* PgDn on arrow keypad *)
  DIKEYBOARD_INSERT                       = $810004D2;    (* Insert on arrow keypad *)
  DIKEYBOARD_DELETE                       = $810004D3;    (* Delete on arrow keypad *)
  DIKEYBOARD_LWIN                         = $810004DB;    (* Left Windows key *)
  DIKEYBOARD_RWIN                         = $810004DC;    (* Right Windows key *)
  DIKEYBOARD_APPS                         = $810004DD;    (* AppMenu key *)
  DIKEYBOARD_POWER                        = $810004DE;    (* System Power *)
  DIKEYBOARD_SLEEP                        = $810004DF;    (* System Sleep *)
  DIKEYBOARD_WAKE                         = $810004E3;    (* System Wake *)
  DIKEYBOARD_WEBSEARCH                    = $810004E5;    (* Web Search *)
  DIKEYBOARD_WEBFAVORITES                 = $810004E6;    (* Web Favorites *)
  DIKEYBOARD_WEBREFRESH                   = $810004E7;    (* Web Refresh *)
  DIKEYBOARD_WEBSTOP                      = $810004E8;    (* Web Stop *)
  DIKEYBOARD_WEBFORWARD                   = $810004E9;    (* Web Forward *)
  DIKEYBOARD_WEBBACK                      = $810004EA;    (* Web Back *)
  DIKEYBOARD_MYCOMPUTER                   = $810004EB;    (* My Computer *)
  DIKEYBOARD_MAIL                         = $810004EC;    (* Mail *)
  DIKEYBOARD_MEDIASELECT                  = $810004ED;    (* Media Select *)
                                                     

(*--- MOUSE
      Physical Mouse Device             ---*)

  DIMOUSE_XAXISAB                         = $82000200 or DIMOFS_X;       (* X Axis-absolute: Some mice natively report absolute coordinates  *)
  DIMOUSE_YAXISAB                         = $82000200 or DIMOFS_Y;       (* Y Axis-absolute: Some mice natively report absolute coordinates *)
  DIMOUSE_XAXIS                           = $82000300 or DIMOFS_X;       (* X Axis *)
  DIMOUSE_YAXIS                           = $82000300 or DIMOFS_Y;       (* Y Axis *)
  DIMOUSE_WHEEL                           = $82000300 or DIMOFS_Z;       (* Z Axis *)
  DIMOUSE_BUTTON0                         = $82000400 or DIMOFS_BUTTON0; (* Button 0 *)
  DIMOUSE_BUTTON1                         = $82000400 or DIMOFS_BUTTON1; (* Button 1 *)
  DIMOUSE_BUTTON2                         = $82000400 or DIMOFS_BUTTON2; (* Button 2 *)
  DIMOUSE_BUTTON3                         = $82000400 or DIMOFS_BUTTON3; (* Button 3 *)
  DIMOUSE_BUTTON4                         = $82000400 or DIMOFS_BUTTON4; (* Button 4 *)
  DIMOUSE_BUTTON5                         = $82000400 or DIMOFS_BUTTON5; (* Button 5 *)
  DIMOUSE_BUTTON6                         = $82000400 or DIMOFS_BUTTON6; (* Button 6 *)
  DIMOUSE_BUTTON7                         = $82000400 or DIMOFS_BUTTON7; (* Button 7 *)


(*--- VOICE
      Physical Dplay Voice Device       ---*)

  DIVOICE_CHANNEL1                        = $83000401;
  DIVOICE_CHANNEL2                        = $83000402;
  DIVOICE_CHANNEL3                        = $83000403;
  DIVOICE_CHANNEL4                        = $83000404;
  DIVOICE_CHANNEL5                        = $83000405;
  DIVOICE_CHANNEL6                        = $83000406;
  DIVOICE_CHANNEL7                        = $83000407;
  DIVOICE_CHANNEL8                        = $83000408;
  DIVOICE_TEAM                            = $83000409;
  DIVOICE_ALL                             = $8300040A;
  DIVOICE_RECORDMUTE                      = $8300040B;
  DIVOICE_PLAYBACKMUTE                    = $8300040C;
  DIVOICE_TRANSMIT                        = $8300040D;

  DIVOICE_VOICECOMMAND                    = $83000410;


(*--- Driving Simulator - Racing
      Vehicle control is primary objective  ---*)

  DIVIRTUAL_DRIVING_RACE                  = $01000000;
  DIAXIS_DRIVINGR_STEER                   = $01008A01;  (* Steering *)
  DIAXIS_DRIVINGR_ACCELERATE              = $01039202;  (* Accelerate *)
  DIAXIS_DRIVINGR_BRAKE                   = $01041203;  (* Brake-Axis *)
  DIBUTTON_DRIVINGR_SHIFTUP               = $01000C01;  (* Shift to next higher gear *)
  DIBUTTON_DRIVINGR_SHIFTDOWN             = $01000C02;  (* Shift to next lower gear *)
  DIBUTTON_DRIVINGR_VIEW                  = $01001C03;  (* Cycle through view options *)
  DIBUTTON_DRIVINGR_MENU                  = $010004FD;  (* Show menu options *)

(*--- Priority 2 controls                            ---*)

  DIAXIS_DRIVINGR_ACCEL_AND_BRAKE         = $01014A04;  (* Some devices combine accelerate and brake in a single axis *)
  DIHATSWITCH_DRIVINGR_GLANCE             = $01004601;  (* Look around *)
  DIBUTTON_DRIVINGR_BRAKE                 = $01004C04;  (* Brake-button *)
  DIBUTTON_DRIVINGR_DASHBOARD             = $01004405;  (* Select next dashboard option *)
  DIBUTTON_DRIVINGR_AIDS                  = $01004406;  (* Driver correction aids *)
  DIBUTTON_DRIVINGR_MAP                   = $01004407;  (* Display Driving Map *)
  DIBUTTON_DRIVINGR_BOOST                 = $01004408;  (* Turbo Boost *)
  DIBUTTON_DRIVINGR_PIT                   = $01004409;  (* Pit stop notification *)
  DIBUTTON_DRIVINGR_ACCELERATE_LINK       = $0103D4E0;  (* Fallback Accelerate button *)
  DIBUTTON_DRIVINGR_STEER_LEFT_LINK       = $0100CCE4;  (* Fallback Steer Left button *)
  DIBUTTON_DRIVINGR_STEER_RIGHT_LINK      = $0100CCEC;  (* Fallback Steer Right button *)
  DIBUTTON_DRIVINGR_GLANCE_LEFT_LINK      = $0107C4E4;  (* Fallback Glance Left button *)
  DIBUTTON_DRIVINGR_GLANCE_RIGHT_LINK     = $0107C4EC;  (* Fallback Glance Right button *)
  DIBUTTON_DRIVINGR_DEVICE                = $010044FE;  (* Show input device and controls *)
  DIBUTTON_DRIVINGR_PAUSE                 = $010044FC;  (* Start / Pause / Restart game *)

(*--- Driving Simulator - Combat
      Combat from within a vehicle is primary objective  ---*)

  DIVIRTUAL_DRIVING_COMBAT                = $02000000;
  DIAXIS_DRIVINGC_STEER                   = $02008A01;  (* Steering  *)
  DIAXIS_DRIVINGC_ACCELERATE              = $02039202;  (* Accelerate *)
  DIAXIS_DRIVINGC_BRAKE                   = $02041203;  (* Brake-axis *)
  DIBUTTON_DRIVINGC_FIRE                  = $02000C01;  (* Fire *)
  DIBUTTON_DRIVINGC_WEAPONS               = $02000C02;  (* Select next weapon *)
  DIBUTTON_DRIVINGC_TARGET                = $02000C03;  (* Select next available target *)
  DIBUTTON_DRIVINGC_MENU                  = $020004FD;  (* Show menu options *)

(*--- Priority 2 controls                            ---*)

  DIAXIS_DRIVINGC_ACCEL_AND_BRAKE         = $02014A04;  (* Some devices combine accelerate and brake in a single axis *)
  DIHATSWITCH_DRIVINGC_GLANCE             = $02004601;  (* Look around *)
  DIBUTTON_DRIVINGC_SHIFTUP               = $02004C04;  (* Shift to next higher gear *)
  DIBUTTON_DRIVINGC_SHIFTDOWN             = $02004C05;  (* Shift to next lower gear *)
  DIBUTTON_DRIVINGC_DASHBOARD             = $02004406;  (* Select next dashboard option *)
  DIBUTTON_DRIVINGC_AIDS                  = $02004407;  (* Driver correction aids *)
  DIBUTTON_DRIVINGC_BRAKE                 = $02004C08;  (* Brake-button *)
  DIBUTTON_DRIVINGC_FIRESECONDARY         = $02004C09;  (* Alternative fire button *)
  DIBUTTON_DRIVINGC_ACCELERATE_LINK       = $0203D4E0;  (* Fallback Accelerate button *)
  DIBUTTON_DRIVINGC_STEER_LEFT_LINK       = $0200CCE4;  (* Fallback Steer Left button *)
  DIBUTTON_DRIVINGC_STEER_RIGHT_LINK      = $0200CCEC;  (* Fallback Steer Right button *)
  DIBUTTON_DRIVINGC_GLANCE_LEFT_LINK      = $0207C4E4;  (* Fallback Glance Left button *)
  DIBUTTON_DRIVINGC_GLANCE_RIGHT_LINK     = $0207C4EC;  (* Fallback Glance Right button *)
  DIBUTTON_DRIVINGC_DEVICE                = $020044FE;  (* Show input device and controls *)
  DIBUTTON_DRIVINGC_PAUSE                 = $020044FC;  (* Start / Pause / Restart game *)

(*--- Driving Simulator - Tank
      Combat from withing a tank is primary objective  ---*)

  DIVIRTUAL_DRIVING_TANK                  = $03000000;
  DIAXIS_DRIVINGT_STEER                   = $03008A01;  (* Turn tank left / right *)
  DIAXIS_DRIVINGT_BARREL                  = $03010202;  (* Raise / lower barrel *)
  DIAXIS_DRIVINGT_ACCELERATE              = $03039203;  (* Accelerate *)
  DIAXIS_DRIVINGT_ROTATE                  = $03020204;  (* Turn barrel left / right *)
  DIBUTTON_DRIVINGT_FIRE                  = $03000C01;  (* Fire *)
  DIBUTTON_DRIVINGT_WEAPONS               = $03000C02;  (* Select next weapon *)
  DIBUTTON_DRIVINGT_TARGET                = $03000C03;  (* Selects next available target *)
  DIBUTTON_DRIVINGT_MENU                  = $030004FD;  (* Show menu options *)

(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_DRIVINGT_GLANCE             = $03004601;  (* Look around *)
  DIAXIS_DRIVINGT_BRAKE                   = $03045205;  (* Brake-axis *)
  DIAXIS_DRIVINGT_ACCEL_AND_BRAKE         = $03014A06;  (* Some devices combine accelerate and brake in a single axis *)
  DIBUTTON_DRIVINGT_VIEW                  = $03005C04;  (* Cycle through view options *)
  DIBUTTON_DRIVINGT_DASHBOARD             = $03005C05;  (* Select next dashboard option *)
  DIBUTTON_DRIVINGT_BRAKE                 = $03004C06;  (* Brake-button *)
  DIBUTTON_DRIVINGT_FIRESECONDARY         = $03004C07;  (* Alternative fire button *)
  DIBUTTON_DRIVINGT_ACCELERATE_LINK       = $0303D4E0;  (* Fallback Accelerate button *)
  DIBUTTON_DRIVINGT_STEER_LEFT_LINK       = $0300CCE4;  (* Fallback Steer Left button *)
  DIBUTTON_DRIVINGT_STEER_RIGHT_LINK      = $0300CCEC;  (* Fallback Steer Right button *)
  DIBUTTON_DRIVINGT_BARREL_UP_LINK        = $030144E0;  (* Fallback Barrel up button *)
  DIBUTTON_DRIVINGT_BARREL_DOWN_LINK      = $030144E8;  (* Fallback Barrel down button *)
  DIBUTTON_DRIVINGT_ROTATE_LEFT_LINK      = $030244E4;  (* Fallback Rotate left button *)
  DIBUTTON_DRIVINGT_ROTATE_RIGHT_LINK     = $030244EC;  (* Fallback Rotate right button *)
  DIBUTTON_DRIVINGT_GLANCE_LEFT_LINK      = $0307C4E4;  (* Fallback Glance Left button *)
  DIBUTTON_DRIVINGT_GLANCE_RIGHT_LINK     = $0307C4EC;  (* Fallback Glance Right button *)
  DIBUTTON_DRIVINGT_DEVICE                = $030044FE;  (* Show input device and controls *)
  DIBUTTON_DRIVINGT_PAUSE                 = $030044FC;  (* Start / Pause / Restart game *)

(*--- Flight Simulator - Civilian
      Plane control is the primary objective  ---*)

  DIVIRTUAL_FLYING_CIVILIAN               = $04000000;
  DIAXIS_FLYINGC_BANK                     = $04008A01;  (* Roll ship left / right *)
  DIAXIS_FLYINGC_PITCH                    = $04010A02;  (* Nose up / down *)
  DIAXIS_FLYINGC_THROTTLE                 = $04039203;  (* Throttle *)
  DIBUTTON_FLYINGC_VIEW                   = $04002401;  (* Cycle through view options *)
  DIBUTTON_FLYINGC_DISPLAY                = $04002402;  (* Select next dashboard / heads up display option *)
  DIBUTTON_FLYINGC_GEAR                   = $04002C03;  (* Gear up / down *)
  DIBUTTON_FLYINGC_MENU                   = $040004FD;  (* Show menu options *)

(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_FLYINGC_GLANCE              = $04004601;  (* Look around *)
  DIAXIS_FLYINGC_BRAKE                    = $04046A04;  (* Apply Brake *)
  DIAXIS_FLYINGC_RUDDER                   = $04025205;  (* Yaw ship left/right *)
  DIAXIS_FLYINGC_FLAPS                    = $04055A06;  (* Flaps *)
  DIBUTTON_FLYINGC_FLAPSUP                = $04006404;  (* Increment stepping up until fully retracted *)
  DIBUTTON_FLYINGC_FLAPSDOWN              = $04006405;  (* Decrement stepping down until fully extended *)
  DIBUTTON_FLYINGC_BRAKE_LINK             = $04046CE0;  (* Fallback brake button *)
  DIBUTTON_FLYINGC_FASTER_LINK            = $0403D4E0;  (* Fallback throttle up button *)
  DIBUTTON_FLYINGC_SLOWER_LINK            = $0403D4E8;  (* Fallback throttle down button *)
  DIBUTTON_FLYINGC_GLANCE_LEFT_LINK       = $0407C4E4;  (* Fallback Glance Left button *)
  DIBUTTON_FLYINGC_GLANCE_RIGHT_LINK      = $0407C4EC;  (* Fallback Glance Right button *)
  DIBUTTON_FLYINGC_GLANCE_UP_LINK         = $0407C4E0;  (* Fallback Glance Up button *)
  DIBUTTON_FLYINGC_GLANCE_DOWN_LINK       = $0407C4E8;  (* Fallback Glance Down button *)
  DIBUTTON_FLYINGC_DEVICE                 = $040044FE;  (* Show input device and controls *)
  DIBUTTON_FLYINGC_PAUSE                  = $040044FC;  (* Start / Pause / Restart game *)

(*--- Flight Simulator - Military
      Aerial combat is the primary objective  ---*)

  DIVIRTUAL_FLYING_MILITARY               = $05000000;
  DIAXIS_FLYINGM_BANK                     = $05008A01;  (* Bank - Roll ship left / right *)
  DIAXIS_FLYINGM_PITCH                    = $05010A02;  (* Pitch - Nose up / down *)
  DIAXIS_FLYINGM_THROTTLE                 = $05039203;  (* Throttle - faster / slower *)
  DIBUTTON_FLYINGM_FIRE                   = $05000C01;  (* Fire *)
  DIBUTTON_FLYINGM_WEAPONS                = $05000C02;  (* Select next weapon *)
  DIBUTTON_FLYINGM_TARGET                 = $05000C03;  (* Selects next available target *)
  DIBUTTON_FLYINGM_MENU                   = $050004FD;  (* Show menu options *)

(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_FLYINGM_GLANCE              = $05004601;  (* Look around *)
  DIBUTTON_FLYINGM_COUNTER                = $05005C04;  (* Activate counter measures *)
  DIAXIS_FLYINGM_RUDDER                   = $05024A04;  (* Rudder - Yaw ship left/right *)
  DIAXIS_FLYINGM_BRAKE                    = $05046205;  (* Brake-axis *)
  DIBUTTON_FLYINGM_VIEW                   = $05006405;  (* Cycle through view options *)
  DIBUTTON_FLYINGM_DISPLAY                = $05006406;  (* Select next dashboard option *)
  DIAXIS_FLYINGM_FLAPS                    = $05055206;  (* Flaps *)
  DIBUTTON_FLYINGM_FLAPSUP                = $05005407;  (* Increment stepping up until fully retracted *)
  DIBUTTON_FLYINGM_FLAPSDOWN              = $05005408;  (* Decrement stepping down until fully extended *)
  DIBUTTON_FLYINGM_FIRESECONDARY          = $05004C09;  (* Alternative fire button *)
  DIBUTTON_FLYINGM_GEAR                   = $0500640A;  (* Gear up / down *)
  DIBUTTON_FLYINGM_BRAKE_LINK             = $050464E0;  (* Fallback brake button *)
  DIBUTTON_FLYINGM_FASTER_LINK            = $0503D4E0;  (* Fallback throttle up button *)
  DIBUTTON_FLYINGM_SLOWER_LINK            = $0503D4E8;  (* Fallback throttle down button *)
  DIBUTTON_FLYINGM_GLANCE_LEFT_LINK       = $0507C4E4;  (* Fallback Glance Left button *)
  DIBUTTON_FLYINGM_GLANCE_RIGHT_LINK      = $0507C4EC;  (* Fallback Glance Right button *)
  DIBUTTON_FLYINGM_GLANCE_UP_LINK         = $0507C4E0;  (* Fallback Glance Up button *)
  DIBUTTON_FLYINGM_GLANCE_DOWN_LINK       = $0507C4E8;  (* Fallback Glance Down button *)
  DIBUTTON_FLYINGM_DEVICE                 = $050044FE;  (* Show input device and controls *)
  DIBUTTON_FLYINGM_PAUSE                  = $050044FC;  (* Start / Pause / Restart game *)

(*--- Flight Simulator - Combat Helicopter
      Combat from helicopter is primary objective  ---*)

  DIVIRTUAL_FLYING_HELICOPTER             = $06000000;
  DIAXIS_FLYINGH_BANK                     = $06008A01;  (* Bank - Roll ship left / right *)
  DIAXIS_FLYINGH_PITCH                    = $06010A02;  (* Pitch - Nose up / down *)
  DIAXIS_FLYINGH_COLLECTIVE               = $06018A03;  (* Collective - Blade pitch/power *)
  DIBUTTON_FLYINGH_FIRE                   = $06001401;  (* Fire *)
  DIBUTTON_FLYINGH_WEAPONS                = $06001402;  (* Select next weapon *)
  DIBUTTON_FLYINGH_TARGET                 = $06001403;  (* Selects next available target *)
  DIBUTTON_FLYINGH_MENU                   = $060004FD;  (* Show menu options *)

(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_FLYINGH_GLANCE              = $06004601;  (* Look around *)
  DIAXIS_FLYINGH_TORQUE                   = $06025A04;  (* Torque - Rotate ship around left / right axis *)
  DIAXIS_FLYINGH_THROTTLE                 = $0603DA05;  (* Throttle *)
  DIBUTTON_FLYINGH_COUNTER                = $06005404;  (* Activate counter measures *)
  DIBUTTON_FLYINGH_VIEW                   = $06006405;  (* Cycle through view options *)
  DIBUTTON_FLYINGH_GEAR                   = $06006406;  (* Gear up / down *)
  DIBUTTON_FLYINGH_FIRESECONDARY          = $06004C07;  (* Alternative fire button *)
  DIBUTTON_FLYINGH_FASTER_LINK            = $0603DCE0;  (* Fallback throttle up button *)
  DIBUTTON_FLYINGH_SLOWER_LINK            = $0603DCE8;  (* Fallback throttle down button *)
  DIBUTTON_FLYINGH_GLANCE_LEFT_LINK       = $0607C4E4;  (* Fallback Glance Left button *)
  DIBUTTON_FLYINGH_GLANCE_RIGHT_LINK      = $0607C4EC;  (* Fallback Glance Right button *)
  DIBUTTON_FLYINGH_GLANCE_UP_LINK         = $0607C4E0;  (* Fallback Glance Up button *)
  DIBUTTON_FLYINGH_GLANCE_DOWN_LINK       = $0607C4E8;  (* Fallback Glance Down button *)
  DIBUTTON_FLYINGH_DEVICE                 = $060044FE;  (* Show input device and controls *)
  DIBUTTON_FLYINGH_PAUSE                  = $060044FC;  (* Start / Pause / Restart game *)

(*--- Space Simulator - Combat
      Space Simulator with weapons  ---*)

  DIVIRTUAL_SPACESIM                      = $07000000;
  DIAXIS_SPACESIM_LATERAL                 = $07008201;  (* Move ship left / right *)
  DIAXIS_SPACESIM_MOVE                    = $07010202;  (* Move ship forward/backward *)
  DIAXIS_SPACESIM_THROTTLE                = $07038203;  (* Throttle - Engine speed *)
  DIBUTTON_SPACESIM_FIRE                  = $07000401;  (* Fire *)
  DIBUTTON_SPACESIM_WEAPONS               = $07000402;  (* Select next weapon *)
  DIBUTTON_SPACESIM_TARGET                = $07000403;  (* Selects next available target *)
  DIBUTTON_SPACESIM_MENU                  = $070004FD;  (* Show menu options *)
  
(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_SPACESIM_GLANCE             = $07004601;  (* Look around *)
  DIAXIS_SPACESIM_CLIMB                   = $0701C204;  (* Climb - Pitch ship up/down *)
  DIAXIS_SPACESIM_ROTATE                  = $07024205;  (* Rotate - Turn ship left/right *)
  DIBUTTON_SPACESIM_VIEW                  = $07004404;  (* Cycle through view options *)
  DIBUTTON_SPACESIM_DISPLAY               = $07004405;  (* Select next dashboard / heads up display option *)
  DIBUTTON_SPACESIM_RAISE                 = $07004406;  (* Raise ship while maintaining current pitch *)
  DIBUTTON_SPACESIM_LOWER                 = $07004407;  (* Lower ship while maintaining current pitch *)
  DIBUTTON_SPACESIM_GEAR                  = $07004408;  (* Gear up / down *)
  DIBUTTON_SPACESIM_FIRESECONDARY         = $07004409;  (* Alternative fire button *)
  DIBUTTON_SPACESIM_LEFT_LINK             = $0700C4E4;  (* Fallback move left button *)
  DIBUTTON_SPACESIM_RIGHT_LINK            = $0700C4EC;  (* Fallback move right button *)
  DIBUTTON_SPACESIM_FORWARD_LINK          = $070144E0;  (* Fallback move forward button *)
  DIBUTTON_SPACESIM_BACKWARD_LINK         = $070144E8;  (* Fallback move backwards button *)
  DIBUTTON_SPACESIM_FASTER_LINK           = $0703C4E0;  (* Fallback throttle up button *)
  DIBUTTON_SPACESIM_SLOWER_LINK           = $0703C4E8;  (* Fallback throttle down button *)
  DIBUTTON_SPACESIM_TURN_LEFT_LINK        = $070244E4;  (* Fallback turn left button *)
  DIBUTTON_SPACESIM_TURN_RIGHT_LINK       = $070244EC;  (* Fallback turn right button *)
  DIBUTTON_SPACESIM_GLANCE_LEFT_LINK      = $0707C4E4;  (* Fallback Glance Left button *)
  DIBUTTON_SPACESIM_GLANCE_RIGHT_LINK     = $0707C4EC;  (* Fallback Glance Right button *)
  DIBUTTON_SPACESIM_GLANCE_UP_LINK        = $0707C4E0;  (* Fallback Glance Up button *)
  DIBUTTON_SPACESIM_GLANCE_DOWN_LINK      = $0707C4E8;  (* Fallback Glance Down button *)
  DIBUTTON_SPACESIM_DEVICE                = $070044FE;  (* Show input device and controls *)
  DIBUTTON_SPACESIM_PAUSE                 = $070044FC;  (* Start / Pause / Restart game *)

(*--- Fighting - First Person
      Hand to Hand combat is primary objective  ---*)

  DIVIRTUAL_FIGHTING_HAND2HAND            = $08000000;
  DIAXIS_FIGHTINGH_LATERAL                = $08008201;  (* Sidestep left/right *)
  DIAXIS_FIGHTINGH_MOVE                   = $08010202;  (* Move forward/backward *)
  DIBUTTON_FIGHTINGH_PUNCH                = $08000401;  (* Punch *)
  DIBUTTON_FIGHTINGH_KICK                 = $08000402;  (* Kick *)
  DIBUTTON_FIGHTINGH_BLOCK                = $08000403;  (* Block *)
  DIBUTTON_FIGHTINGH_CROUCH               = $08000404;  (* Crouch *)
  DIBUTTON_FIGHTINGH_JUMP                 = $08000405;  (* Jump *)
  DIBUTTON_FIGHTINGH_SPECIAL1             = $08000406;  (* Apply first special move *)
  DIBUTTON_FIGHTINGH_SPECIAL2             = $08000407;  (* Apply second special move *)
  DIBUTTON_FIGHTINGH_MENU                 = $080004FD;  (* Show menu options *)

(*--- Priority 2 controls                            ---*)

  DIBUTTON_FIGHTINGH_SELECT               = $08004408;  (* Select special move *)
  DIHATSWITCH_FIGHTINGH_SLIDE             = $08004601;  (* Look around *)
  DIBUTTON_FIGHTINGH_DISPLAY              = $08004409;  (* Shows next on-screen display option *)
  DIAXIS_FIGHTINGH_ROTATE                 = $08024203;  (* Rotate - Turn body left/right *)
  DIBUTTON_FIGHTINGH_DODGE                = $0800440A;  (* Dodge *)
  DIBUTTON_FIGHTINGH_LEFT_LINK            = $0800C4E4;  (* Fallback left sidestep button *)
  DIBUTTON_FIGHTINGH_RIGHT_LINK           = $0800C4EC;  (* Fallback right sidestep button *)
  DIBUTTON_FIGHTINGH_FORWARD_LINK         = $080144E0;  (* Fallback forward button *)
  DIBUTTON_FIGHTINGH_BACKWARD_LINK        = $080144E8;  (* Fallback backward button *)
  DIBUTTON_FIGHTINGH_DEVICE               = $080044FE;  (* Show input device and controls *)
  DIBUTTON_FIGHTINGH_PAUSE                = $080044FC;  (* Start / Pause / Restart game *)

(*--- Fighting - First Person Shooting
      Navigation and combat are primary objectives  ---*)

  DIVIRTUAL_FIGHTING_FPS                  = $09000000;
  DIAXIS_FPS_ROTATE                       = $09008201;  (* Rotate character left/right *)
  DIAXIS_FPS_MOVE                         = $09010202;  (* Move forward/backward *)
  DIBUTTON_FPS_FIRE                       = $09000401;  (* Fire *)
  DIBUTTON_FPS_WEAPONS                    = $09000402;  (* Select next weapon *)
  DIBUTTON_FPS_APPLY                      = $09000403;  (* Use item *)
  DIBUTTON_FPS_SELECT                     = $09000404;  (* Select next inventory item *)
  DIBUTTON_FPS_CROUCH                     = $09000405;  (* Crouch/ climb down/ swim down *)
  DIBUTTON_FPS_JUMP                       = $09000406;  (* Jump/ climb up/ swim up *)
  DIAXIS_FPS_LOOKUPDOWN                   = $09018203;  (* Look up / down  *)
  DIBUTTON_FPS_STRAFE                     = $09000407;  (* Enable strafing while active *)
  DIBUTTON_FPS_MENU                       = $090004FD;  (* Show menu options *)

(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_FPS_GLANCE                  = $09004601;  (* Look around *)
  DIBUTTON_FPS_DISPLAY                    = $09004408;  (* Shows next on-screen display option/ map *)
  DIAXIS_FPS_SIDESTEP                     = $09024204;  (* Sidestep *)
  DIBUTTON_FPS_DODGE                      = $09004409;  (* Dodge *)
  DIBUTTON_FPS_GLANCEL                    = $0900440A;  (* Glance Left *)
  DIBUTTON_FPS_GLANCER                    = $0900440B;  (* Glance Right *)
  DIBUTTON_FPS_FIRESECONDARY              = $0900440C;  (* Alternative fire button *)
  DIBUTTON_FPS_ROTATE_LEFT_LINK           = $0900C4E4;  (* Fallback rotate left button *)
  DIBUTTON_FPS_ROTATE_RIGHT_LINK          = $0900C4EC;  (* Fallback rotate right button *)
  DIBUTTON_FPS_FORWARD_LINK               = $090144E0;  (* Fallback forward button *)
  DIBUTTON_FPS_BACKWARD_LINK              = $090144E8;  (* Fallback backward button *)
  DIBUTTON_FPS_GLANCE_UP_LINK             = $0901C4E0;  (* Fallback look up button *)
  DIBUTTON_FPS_GLANCE_DOWN_LINK           = $0901C4E8;  (* Fallback look down button *)
  DIBUTTON_FPS_DEVICE                     = $090044FE;  (* Show input device and controls *)
  DIBUTTON_FPS_PAUSE                      = $090044FC;  (* Start / Pause / Restart game *)

(*--- Fighting - Third Person action
      Perspective of camera is behind the main character  ---*)

  DIVIRTUAL_FIGHTING_THIRDPERSON          = $0A000000;
  DIAXIS_TPS_TURN                         = $0A020201;  (* Turn left/right *)
  DIAXIS_TPS_MOVE                         = $0A010202;  (* Move forward/backward *)
  DIBUTTON_TPS_RUN                        = $0A000401;  (* Run or walk toggle switch *)
  DIBUTTON_TPS_ACTION                     = $0A000402;  (* Action Button *)
  DIBUTTON_TPS_SELECT                     = $0A000403;  (* Select next weapon *)
  DIBUTTON_TPS_USE                        = $0A000404;  (* Use inventory item currently selected *)
  DIBUTTON_TPS_JUMP                       = $0A000405;  (* Character Jumps *)
  DIBUTTON_TPS_MENU                       = $0A0004FD;  (* Show menu options *)
  
(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_TPS_GLANCE                  = $0A004601;  (* Look around *)
  DIBUTTON_TPS_VIEW                       = $0A004406;  (* Select camera view *)
  DIBUTTON_TPS_STEPLEFT                   = $0A004407;  (* Character takes a left step *)
  DIBUTTON_TPS_STEPRIGHT                  = $0A004408;  (* Character takes a right step *)
  DIAXIS_TPS_STEP                         = $0A00C203;  (* Character steps left/right *)
  DIBUTTON_TPS_DODGE                      = $0A004409;  (* Character dodges or ducks *)
  DIBUTTON_TPS_INVENTORY                  = $0A00440A;  (* Cycle through inventory *)
  DIBUTTON_TPS_TURN_LEFT_LINK             = $0A0244E4;  (* Fallback turn left button *)
  DIBUTTON_TPS_TURN_RIGHT_LINK            = $0A0244EC;  (* Fallback turn right button *)
  DIBUTTON_TPS_FORWARD_LINK               = $0A0144E0;  (* Fallback forward button *)
  DIBUTTON_TPS_BACKWARD_LINK              = $0A0144E8;  (* Fallback backward button *)
  DIBUTTON_TPS_GLANCE_UP_LINK             = $0A07C4E0;  (* Fallback look up button *)
  DIBUTTON_TPS_GLANCE_DOWN_LINK           = $0A07C4E8;  (* Fallback look down button *)
  DIBUTTON_TPS_GLANCE_LEFT_LINK           = $0A07C4E4;  (* Fallback glance up button *)
  DIBUTTON_TPS_GLANCE_RIGHT_LINK          = $0A07C4EC;  (* Fallback glance right button *)
  DIBUTTON_TPS_DEVICE                     = $0A0044FE;  (* Show input device and controls *)
  DIBUTTON_TPS_PAUSE                      = $0A0044FC;  (* Start / Pause / Restart game *)

(*--- Strategy - Role Playing
      Navigation and problem solving are primary actions  ---*)
      
  DIVIRTUAL_STRATEGY_ROLEPLAYING          = $0B000000;
  DIAXIS_STRATEGYR_LATERAL                = $0B008201;  (* sidestep - left/right *)
  DIAXIS_STRATEGYR_MOVE                   = $0B010202;  (* move forward/backward *)
  DIBUTTON_STRATEGYR_GET                  = $0B000401;  (* Acquire item *)
  DIBUTTON_STRATEGYR_APPLY                = $0B000402;  (* Use selected item *)
  DIBUTTON_STRATEGYR_SELECT               = $0B000403;  (* Select nextitem *)
  DIBUTTON_STRATEGYR_ATTACK               = $0B000404;  (* Attack *)
  DIBUTTON_STRATEGYR_CAST                 = $0B000405;  (* Cast Spell *)
  DIBUTTON_STRATEGYR_CROUCH               = $0B000406;  (* Crouch *)
  DIBUTTON_STRATEGYR_JUMP                 = $0B000407;  (* Jump *)
  DIBUTTON_STRATEGYR_MENU                 = $0B0004FD;  (* Show menu options *)

(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_STRATEGYR_GLANCE            = $0B004601;  (* Look around *)
  DIBUTTON_STRATEGYR_MAP                  = $0B004408;  (* Cycle through map options *)
  DIBUTTON_STRATEGYR_DISPLAY              = $0B004409;  (* Shows next on-screen display option *)
  DIAXIS_STRATEGYR_ROTATE                 = $0B024203;  (* Turn body left/right *)
  DIBUTTON_STRATEGYR_LEFT_LINK            = $0B00C4E4;  (* Fallback sidestep left button *)
  DIBUTTON_STRATEGYR_RIGHT_LINK           = $0B00C4EC;  (* Fallback sidestep right button *)
  DIBUTTON_STRATEGYR_FORWARD_LINK         = $0B0144E0;  (* Fallback move forward button *)
  DIBUTTON_STRATEGYR_BACK_LINK            = $0B0144E8;  (* Fallback move backward button *)
  DIBUTTON_STRATEGYR_ROTATE_LEFT_LINK     = $0B0244E4;  (* Fallback turn body left button *)
  DIBUTTON_STRATEGYR_ROTATE_RIGHT_LINK    = $0B0244EC;  (* Fallback turn body right button *)
  DIBUTTON_STRATEGYR_DEVICE               = $0B0044FE;  (* Show input device and controls *)
  DIBUTTON_STRATEGYR_PAUSE                = $0B0044FC;  (* Start / Pause / Restart game *)

(*--- Strategy - Turn based
      Navigation and problem solving are primary actions  ---*)
      
  DIVIRTUAL_STRATEGY_TURN                 = $0C000000;
  DIAXIS_STRATEGYT_LATERAL                = $0C008201;  (* Sidestep left/right *)
  DIAXIS_STRATEGYT_MOVE                   = $0C010202;  (* Move forward/backwards *)
  DIBUTTON_STRATEGYT_SELECT               = $0C000401;  (* Select unit or object *)
  DIBUTTON_STRATEGYT_INSTRUCT             = $0C000402;  (* Cycle through instructions *)
  DIBUTTON_STRATEGYT_APPLY                = $0C000403;  (* Apply selected instruction *)
  DIBUTTON_STRATEGYT_TEAM                 = $0C000404;  (* Select next team / cycle through all *)
  DIBUTTON_STRATEGYT_TURN                 = $0C000405;  (* Indicate turn over *)
  DIBUTTON_STRATEGYT_MENU                 = $0C0004FD;  (* Show menu options *)
  
(*--- Priority 2 controls                            ---*)

  DIBUTTON_STRATEGYT_ZOOM                 = $0C004406;  (* Zoom - in / out *)
  DIBUTTON_STRATEGYT_MAP                  = $0C004407;  (* cycle through map options *)
  DIBUTTON_STRATEGYT_DISPLAY              = $0C004408;  (* shows next on-screen display options *)
  DIBUTTON_STRATEGYT_LEFT_LINK            = $0C00C4E4;  (* Fallback sidestep left button *)
  DIBUTTON_STRATEGYT_RIGHT_LINK           = $0C00C4EC;  (* Fallback sidestep right button *)
  DIBUTTON_STRATEGYT_FORWARD_LINK         = $0C0144E0;  (* Fallback move forward button *)
  DIBUTTON_STRATEGYT_BACK_LINK            = $0C0144E8;  (* Fallback move back button *)
  DIBUTTON_STRATEGYT_DEVICE               = $0C0044FE;  (* Show input device and controls *)
  DIBUTTON_STRATEGYT_PAUSE                = $0C0044FC;  (* Start / Pause / Restart game *)

(*--- Sports - Hunting
      Hunting                ---*)

  DIVIRTUAL_SPORTS_HUNTING                = $0D000000;
  DIAXIS_HUNTING_LATERAL                  = $0D008201;  (* sidestep left/right *)
  DIAXIS_HUNTING_MOVE                     = $0D010202;  (* move forward/backwards *)
  DIBUTTON_HUNTING_FIRE                   = $0D000401;  (* Fire selected weapon *)
  DIBUTTON_HUNTING_AIM                    = $0D000402;  (* Select aim/move *)
  DIBUTTON_HUNTING_WEAPON                 = $0D000403;  (* Select next weapon *)
  DIBUTTON_HUNTING_BINOCULAR              = $0D000404;  (* Look through Binoculars *)
  DIBUTTON_HUNTING_CALL                   = $0D000405;  (* Make animal call *)
  DIBUTTON_HUNTING_MAP                    = $0D000406;  (* View Map *)
  DIBUTTON_HUNTING_SPECIAL                = $0D000407;  (* Special game operation *)
  DIBUTTON_HUNTING_MENU                   = $0D0004FD;  (* Show menu options *)

(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_HUNTING_GLANCE              = $0D004601;  (* Look around *)
  DIBUTTON_HUNTING_DISPLAY                = $0D004408;  (* show next on-screen display option *)
  DIAXIS_HUNTING_ROTATE                   = $0D024203;  (* Turn body left/right *)
  DIBUTTON_HUNTING_CROUCH                 = $0D004409;  (* Crouch/ Climb / Swim down *)
  DIBUTTON_HUNTING_JUMP                   = $0D00440A;  (* Jump/ Climb up / Swim up *)
  DIBUTTON_HUNTING_FIRESECONDARY          = $0D00440B;  (* Alternative fire button *)
  DIBUTTON_HUNTING_LEFT_LINK              = $0D00C4E4;  (* Fallback sidestep left button *)
  DIBUTTON_HUNTING_RIGHT_LINK             = $0D00C4EC;  (* Fallback sidestep right button *)
  DIBUTTON_HUNTING_FORWARD_LINK           = $0D0144E0;  (* Fallback move forward button *)
  DIBUTTON_HUNTING_BACK_LINK              = $0D0144E8;  (* Fallback move back button *)
  DIBUTTON_HUNTING_ROTATE_LEFT_LINK       = $0D0244E4;  (* Fallback turn body left button *)
  DIBUTTON_HUNTING_ROTATE_RIGHT_LINK      = $0D0244EC;  (* Fallback turn body right button *)
  DIBUTTON_HUNTING_DEVICE                 = $0D0044FE;  (* Show input device and controls *)
  DIBUTTON_HUNTING_PAUSE                  = $0D0044FC;  (* Start / Pause / Restart game *)

(*--- Sports - Fishing
      Catching Fish is primary objective   ---*)

  DIVIRTUAL_SPORTS_FISHING                = $0E000000;
  DIAXIS_FISHING_LATERAL                  = $0E008201;  (* sidestep left/right *)
  DIAXIS_FISHING_MOVE                     = $0E010202;  (* move forward/backwards *)
  DIBUTTON_FISHING_CAST                   = $0E000401;  (* Cast line *)
  DIBUTTON_FISHING_TYPE                   = $0E000402;  (* Select cast type *)
  DIBUTTON_FISHING_BINOCULAR              = $0E000403;  (* Look through Binocular *)
  DIBUTTON_FISHING_BAIT                   = $0E000404;  (* Select type of Bait *)
  DIBUTTON_FISHING_MAP                    = $0E000405;  (* View Map *)
  DIBUTTON_FISHING_MENU                   = $0E0004FD;  (* Show menu options *)

(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_FISHING_GLANCE              = $0E004601;  (* Look around *)
  DIBUTTON_FISHING_DISPLAY                = $0E004406;  (* Show next on-screen display option *)
  DIAXIS_FISHING_ROTATE                   = $0E024203;  (* Turn character left / right *)
  DIBUTTON_FISHING_CROUCH                 = $0E004407;  (* Crouch/ Climb / Swim down *)
  DIBUTTON_FISHING_JUMP                   = $0E004408;  (* Jump/ Climb up / Swim up *)
  DIBUTTON_FISHING_LEFT_LINK              = $0E00C4E4;  (* Fallback sidestep left button *)
  DIBUTTON_FISHING_RIGHT_LINK             = $0E00C4EC;  (* Fallback sidestep right button *)
  DIBUTTON_FISHING_FORWARD_LINK           = $0E0144E0;  (* Fallback move forward button *)
  DIBUTTON_FISHING_BACK_LINK              = $0E0144E8;  (* Fallback move back button *)
  DIBUTTON_FISHING_ROTATE_LEFT_LINK       = $0E0244E4;  (* Fallback turn body left button *)
  DIBUTTON_FISHING_ROTATE_RIGHT_LINK      = $0E0244EC;  (* Fallback turn body right button *)
  DIBUTTON_FISHING_DEVICE                 = $0E0044FE;  (* Show input device and controls *)
  DIBUTTON_FISHING_PAUSE                  = $0E0044FC;  (* Start / Pause / Restart game *)

(*--- Sports - Baseball - Batting
      Batter control is primary objective  ---*)

  DIVIRTUAL_SPORTS_BASEBALL_BAT           = $0F000000;
  DIAXIS_BASEBALLB_LATERAL                = $0F008201;  (* Aim left / right *)
  DIAXIS_BASEBALLB_MOVE                   = $0F010202;  (* Aim up / down *)
  DIBUTTON_BASEBALLB_SELECT               = $0F000401;  (* cycle through swing options *)
  DIBUTTON_BASEBALLB_NORMAL               = $0F000402;  (* normal swing *)
  DIBUTTON_BASEBALLB_POWER                = $0F000403;  (* swing for the fence *)
  DIBUTTON_BASEBALLB_BUNT                 = $0F000404;  (* bunt *)
  DIBUTTON_BASEBALLB_STEAL                = $0F000405;  (* Base runner attempts to steal a base *)
  DIBUTTON_BASEBALLB_BURST                = $0F000406;  (* Base runner invokes burst of speed *)
  DIBUTTON_BASEBALLB_SLIDE                = $0F000407;  (* Base runner slides into base *)
  DIBUTTON_BASEBALLB_CONTACT              = $0F000408;  (* Contact swing *)
  DIBUTTON_BASEBALLB_MENU                 = $0F0004FD;  (* Show menu options *)

(*--- Priority 2 controls                            ---*)

  DIBUTTON_BASEBALLB_NOSTEAL              = $0F004409;  (* Base runner goes back to a base *)
  DIBUTTON_BASEBALLB_BOX                  = $0F00440A;  (* Enter or exit batting box *)
  DIBUTTON_BASEBALLB_LEFT_LINK            = $0F00C4E4;  (* Fallback sidestep left button *)
  DIBUTTON_BASEBALLB_RIGHT_LINK           = $0F00C4EC;  (* Fallback sidestep right button *)
  DIBUTTON_BASEBALLB_FORWARD_LINK         = $0F0144E0;  (* Fallback move forward button *)
  DIBUTTON_BASEBALLB_BACK_LINK            = $0F0144E8;  (* Fallback move back button *)
  DIBUTTON_BASEBALLB_DEVICE               = $0F0044FE;  (* Show input device and controls *)
  DIBUTTON_BASEBALLB_PAUSE                = $0F0044FC;  (* Start / Pause / Restart game *)

(*--- Sports - Baseball - Pitching
      Pitcher control is primary objective   ---*)

  DIVIRTUAL_SPORTS_BASEBALL_PITCH         = $10000000;
  DIAXIS_BASEBALLP_LATERAL                = $10008201;  (* Aim left / right *)
  DIAXIS_BASEBALLP_MOVE                   = $10010202;  (* Aim up / down *)
  DIBUTTON_BASEBALLP_SELECT               = $10000401;  (* cycle through pitch selections *)
  DIBUTTON_BASEBALLP_PITCH                = $10000402;  (* throw pitch *)
  DIBUTTON_BASEBALLP_BASE                 = $10000403;  (* select base to throw to *)
  DIBUTTON_BASEBALLP_THROW                = $10000404;  (* throw to base *)
  DIBUTTON_BASEBALLP_FAKE                 = $10000405;  (* Fake a throw to a base *)
  DIBUTTON_BASEBALLP_MENU                 = $100004FD;  (* Show menu options *)

(*--- Priority 2 controls                            ---*)

  DIBUTTON_BASEBALLP_WALK                 = $10004406;  (* Throw intentional walk / pitch out *)
  DIBUTTON_BASEBALLP_LOOK                 = $10004407;  (* Look at runners on bases *)
  DIBUTTON_BASEBALLP_LEFT_LINK            = $1000C4E4;  (* Fallback sidestep left button *)
  DIBUTTON_BASEBALLP_RIGHT_LINK           = $1000C4EC;  (* Fallback sidestep right button *)
  DIBUTTON_BASEBALLP_FORWARD_LINK         = $100144E0;  (* Fallback move forward button *)
  DIBUTTON_BASEBALLP_BACK_LINK            = $100144E8;  (* Fallback move back button *)
  DIBUTTON_BASEBALLP_DEVICE               = $100044FE;  (* Show input device and controls *)
  DIBUTTON_BASEBALLP_PAUSE                = $100044FC;  (* Start / Pause / Restart game *)

(*--- Sports - Baseball - Fielding
      Fielder control is primary objective  ---*)

  DIVIRTUAL_SPORTS_BASEBALL_FIELD         = $11000000;
  DIAXIS_BASEBALLF_LATERAL                = $11008201;  (* Aim left / right *)
  DIAXIS_BASEBALLF_MOVE                   = $11010202;  (* Aim up / down *)
  DIBUTTON_BASEBALLF_NEAREST              = $11000401;  (* Switch to fielder nearest to the ball *)
  DIBUTTON_BASEBALLF_THROW1               = $11000402;  (* Make conservative throw *)
  DIBUTTON_BASEBALLF_THROW2               = $11000403;  (* Make aggressive throw *)
  DIBUTTON_BASEBALLF_BURST                = $11000404;  (* Invoke burst of speed *)
  DIBUTTON_BASEBALLF_JUMP                 = $11000405;  (* Jump to catch ball *)
  DIBUTTON_BASEBALLF_DIVE                 = $11000406;  (* Dive to catch ball *)
  DIBUTTON_BASEBALLF_MENU                 = $110004FD;  (* Show menu options *)
  
(*--- Priority 2 controls                            ---*)

  DIBUTTON_BASEBALLF_SHIFTIN              = $11004407;  (* Shift the infield positioning *)
  DIBUTTON_BASEBALLF_SHIFTOUT             = $11004408;  (* Shift the outfield positioning *)
  DIBUTTON_BASEBALLF_AIM_LEFT_LINK        = $1100C4E4;  (* Fallback aim left button *)
  DIBUTTON_BASEBALLF_AIM_RIGHT_LINK       = $1100C4EC;  (* Fallback aim right button *)
  DIBUTTON_BASEBALLF_FORWARD_LINK         = $110144E0;  (* Fallback move forward button *)
  DIBUTTON_BASEBALLF_BACK_LINK            = $110144E8;  (* Fallback move back button *)
  DIBUTTON_BASEBALLF_DEVICE               = $110044FE;  (* Show input device and controls *)
  DIBUTTON_BASEBALLF_PAUSE                = $110044FC;  (* Start / Pause / Restart game *)

(*--- Sports - Basketball - Offense
      Offense  ---*)

  DIVIRTUAL_SPORTS_BASKETBALL_OFFENSE     = $12000000;
  DIAXIS_BBALLO_LATERAL                   = $12008201;  (* left / right *)
  DIAXIS_BBALLO_MOVE                      = $12010202;  (* up / down *)
  DIBUTTON_BBALLO_SHOOT                   = $12000401;  (* shoot basket *)
  DIBUTTON_BBALLO_DUNK                    = $12000402;  (* dunk basket *)
  DIBUTTON_BBALLO_PASS                    = $12000403;  (* throw pass *)
  DIBUTTON_BBALLO_FAKE                    = $12000404;  (* fake shot or pass *)
  DIBUTTON_BBALLO_SPECIAL                 = $12000405;  (* apply special move *)
  DIBUTTON_BBALLO_PLAYER                  = $12000406;  (* select next player *)
  DIBUTTON_BBALLO_BURST                   = $12000407;  (* invoke burst *)
  DIBUTTON_BBALLO_CALL                    = $12000408;  (* call for ball / pass to me *)
  DIBUTTON_BBALLO_MENU                    = $120004FD;  (* Show menu options *)

(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_BBALLO_GLANCE               = $12004601;  (* scroll view *)
  DIBUTTON_BBALLO_SCREEN                  = $12004409;  (* Call for screen *)
  DIBUTTON_BBALLO_PLAY                    = $1200440A;  (* Call for specific offensive play *)
  DIBUTTON_BBALLO_JAB                     = $1200440B;  (* Initiate fake drive to basket *)
  DIBUTTON_BBALLO_POST                    = $1200440C;  (* Perform post move *)
  DIBUTTON_BBALLO_TIMEOUT                 = $1200440D;  (* Time Out *)
  DIBUTTON_BBALLO_SUBSTITUTE              = $1200440E;  (* substitute one player for another *)
  DIBUTTON_BBALLO_LEFT_LINK               = $1200C4E4;  (* Fallback sidestep left button *)
  DIBUTTON_BBALLO_RIGHT_LINK              = $1200C4EC;  (* Fallback sidestep right button *)
  DIBUTTON_BBALLO_FORWARD_LINK            = $120144E0;  (* Fallback move forward button *)
  DIBUTTON_BBALLO_BACK_LINK               = $120144E8;  (* Fallback move back button *)
  DIBUTTON_BBALLO_DEVICE                  = $120044FE;  (* Show input device and controls *)
  DIBUTTON_BBALLO_PAUSE                   = $120044FC;  (* Start / Pause / Restart game *)

(*--- Sports - Basketball - Defense
      Defense  ---*)

  DIVIRTUAL_SPORTS_BASKETBALL_DEFENSE     = $13000000;
  DIAXIS_BBALLD_LATERAL                   = $13008201;  (* left / right *)
  DIAXIS_BBALLD_MOVE                      = $13010202;  (* up / down *)
  DIBUTTON_BBALLD_JUMP                    = $13000401;  (* jump to block shot *)
  DIBUTTON_BBALLD_STEAL                   = $13000402;  (* attempt to steal ball *)
  DIBUTTON_BBALLD_FAKE                    = $13000403;  (* fake block or steal *)
  DIBUTTON_BBALLD_SPECIAL                 = $13000404;  (* apply special move *)
  DIBUTTON_BBALLD_PLAYER                  = $13000405;  (* select next player *)
  DIBUTTON_BBALLD_BURST                   = $13000406;  (* invoke burst *)
  DIBUTTON_BBALLD_PLAY                    = $13000407;  (* call for specific defensive play *)
  DIBUTTON_BBALLD_MENU                    = $130004FD;  (* Show menu options *)

(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_BBALLD_GLANCE               = $13004601;  (* scroll view *)
  DIBUTTON_BBALLD_TIMEOUT                 = $13004408;  (* Time Out *)
  DIBUTTON_BBALLD_SUBSTITUTE              = $13004409;  (* substitute one player for another *)
  DIBUTTON_BBALLD_LEFT_LINK               = $1300C4E4;  (* Fallback sidestep left button *)
  DIBUTTON_BBALLD_RIGHT_LINK              = $1300C4EC;  (* Fallback sidestep right button *)
  DIBUTTON_BBALLD_FORWARD_LINK            = $130144E0;  (* Fallback move forward button *)
  DIBUTTON_BBALLD_BACK_LINK               = $130144E8;  (* Fallback move back button *)
  DIBUTTON_BBALLD_DEVICE                  = $130044FE;  (* Show input device and controls *)
  DIBUTTON_BBALLD_PAUSE                   = $130044FC;  (* Start / Pause / Restart game *)

(*--- Sports - Football - Play
      Play selection  ---*)

  DIVIRTUAL_SPORTS_FOOTBALL_FIELD         = $14000000;
  DIBUTTON_FOOTBALLP_PLAY                 = $14000401;  (* cycle through available plays *)
  DIBUTTON_FOOTBALLP_SELECT               = $14000402;  (* select play *)
  DIBUTTON_FOOTBALLP_HELP                 = $14000403;  (* Bring up pop-up help *)
  DIBUTTON_FOOTBALLP_MENU                 = $140004FD;  (* Show menu options *)

(*--- Priority 2 controls                            ---*)

  DIBUTTON_FOOTBALLP_DEVICE               = $140044FE;  (* Show input device and controls *)
  DIBUTTON_FOOTBALLP_PAUSE                = $140044FC;  (* Start / Pause / Restart game *)

(*--- Sports - Football - QB
      Offense: Quarterback / Kicker  ---*)

  DIVIRTUAL_SPORTS_FOOTBALL_QBCK          = $15000000;
  DIAXIS_FOOTBALLQ_LATERAL                = $15008201;  (* Move / Aim: left / right *)
  DIAXIS_FOOTBALLQ_MOVE                   = $15010202;  (* Move / Aim: up / down *)
  DIBUTTON_FOOTBALLQ_SELECT               = $15000401;  (* Select *)
  DIBUTTON_FOOTBALLQ_SNAP                 = $15000402;  (* snap ball - start play *)
  DIBUTTON_FOOTBALLQ_JUMP                 = $15000403;  (* jump over defender *)
  DIBUTTON_FOOTBALLQ_SLIDE                = $15000404;  (* Dive/Slide *)
  DIBUTTON_FOOTBALLQ_PASS                 = $15000405;  (* throws pass to receiver *)
  DIBUTTON_FOOTBALLQ_FAKE                 = $15000406;  (* pump fake pass or fake kick *)
  DIBUTTON_FOOTBALLQ_MENU                 = $150004FD;  (* Show menu options *)

(*--- Priority 2 controls                            ---*)

  DIBUTTON_FOOTBALLQ_FAKESNAP             = $15004407;  (* Fake snap  *)
  DIBUTTON_FOOTBALLQ_MOTION               = $15004408;  (* Send receivers in motion *)
  DIBUTTON_FOOTBALLQ_AUDIBLE              = $15004409;  (* Change offensive play at line of scrimmage *)
  DIBUTTON_FOOTBALLQ_LEFT_LINK            = $1500C4E4;  (* Fallback sidestep left button *)
  DIBUTTON_FOOTBALLQ_RIGHT_LINK           = $1500C4EC;  (* Fallback sidestep right button *)
  DIBUTTON_FOOTBALLQ_FORWARD_LINK         = $150144E0;  (* Fallback move forward button *)
  DIBUTTON_FOOTBALLQ_BACK_LINK            = $150144E8;  (* Fallback move back button *)
  DIBUTTON_FOOTBALLQ_DEVICE               = $150044FE;  (* Show input device and controls *)
  DIBUTTON_FOOTBALLQ_PAUSE                = $150044FC;  (* Start / Pause / Restart game *)

(*--- Sports - Football - Offense
      Offense - Runner  ---*)

  DIVIRTUAL_SPORTS_FOOTBALL_OFFENSE       = $16000000;
  DIAXIS_FOOTBALLO_LATERAL                = $16008201;  (* Move / Aim: left / right *)
  DIAXIS_FOOTBALLO_MOVE                   = $16010202;  (* Move / Aim: up / down *)
  DIBUTTON_FOOTBALLO_JUMP                 = $16000401;  (* jump or hurdle over defender *)
  DIBUTTON_FOOTBALLO_LEFTARM              = $16000402;  (* holds out left arm *)
  DIBUTTON_FOOTBALLO_RIGHTARM             = $16000403;  (* holds out right arm *)
  DIBUTTON_FOOTBALLO_THROW                = $16000404;  (* throw pass or lateral ball to another runner *)
  DIBUTTON_FOOTBALLO_SPIN                 = $16000405;  (* Spin to avoid defenders *)
  DIBUTTON_FOOTBALLO_MENU                 = $160004FD;  (* Show menu options *)

(*--- Priority 2 controls                            ---*)

  DIBUTTON_FOOTBALLO_JUKE                 = $16004406;  (* Use special move to avoid defenders *)
  DIBUTTON_FOOTBALLO_SHOULDER             = $16004407;  (* Lower shoulder to run over defenders *)
  DIBUTTON_FOOTBALLO_TURBO                = $16004408;  (* Speed burst past defenders *)
  DIBUTTON_FOOTBALLO_DIVE                 = $16004409;  (* Dive over defenders *)
  DIBUTTON_FOOTBALLO_ZOOM                 = $1600440A;  (* Zoom view in / out *)
  DIBUTTON_FOOTBALLO_SUBSTITUTE           = $1600440B;  (* substitute one player for another *)
  DIBUTTON_FOOTBALLO_LEFT_LINK            = $1600C4E4;  (* Fallback sidestep left button *)
  DIBUTTON_FOOTBALLO_RIGHT_LINK           = $1600C4EC;  (* Fallback sidestep right button *)
  DIBUTTON_FOOTBALLO_FORWARD_LINK         = $160144E0;  (* Fallback move forward button *)
  DIBUTTON_FOOTBALLO_BACK_LINK            = $160144E8;  (* Fallback move back button *)
  DIBUTTON_FOOTBALLO_DEVICE               = $160044FE;  (* Show input device and controls *)
  DIBUTTON_FOOTBALLO_PAUSE                = $160044FC;  (* Start / Pause / Restart game *)

(*--- Sports - Football - Defense
      Defense     ---*)

  DIVIRTUAL_SPORTS_FOOTBALL_DEFENSE       = $17000000;
  DIAXIS_FOOTBALLD_LATERAL                = $17008201;  (* Move / Aim: left / right *)
  DIAXIS_FOOTBALLD_MOVE                   = $17010202;  (* Move / Aim: up / down *)
  DIBUTTON_FOOTBALLD_PLAY                 = $17000401;  (* cycle through available plays *)
  DIBUTTON_FOOTBALLD_SELECT               = $17000402;  (* select player closest to the ball *)
  DIBUTTON_FOOTBALLD_JUMP                 = $17000403;  (* jump to intercept or block *)
  DIBUTTON_FOOTBALLD_TACKLE               = $17000404;  (* tackler runner *)
  DIBUTTON_FOOTBALLD_FAKE                 = $17000405;  (* hold down to fake tackle or intercept *)
  DIBUTTON_FOOTBALLD_SUPERTACKLE          = $17000406;  (* Initiate special tackle *)
  DIBUTTON_FOOTBALLD_MENU                 = $170004FD;  (* Show menu options *)

(*--- Priority 2 controls                            ---*)

  DIBUTTON_FOOTBALLD_SPIN                 = $17004407;  (* Spin to beat offensive line *)
  DIBUTTON_FOOTBALLD_SWIM                 = $17004408;  (* Swim to beat the offensive line *)
  DIBUTTON_FOOTBALLD_BULLRUSH             = $17004409;  (* Bull rush the offensive line *)
  DIBUTTON_FOOTBALLD_RIP                  = $1700440A;  (* Rip the offensive line *)
  DIBUTTON_FOOTBALLD_AUDIBLE              = $1700440B;  (* Change defensive play at the line of scrimmage *)
  DIBUTTON_FOOTBALLD_ZOOM                 = $1700440C;  (* Zoom view in / out *)
  DIBUTTON_FOOTBALLD_SUBSTITUTE           = $1700440D;  (* substitute one player for another *)
  DIBUTTON_FOOTBALLD_LEFT_LINK            = $1700C4E4;  (* Fallback sidestep left button *)
  DIBUTTON_FOOTBALLD_RIGHT_LINK           = $1700C4EC;  (* Fallback sidestep right button *)
  DIBUTTON_FOOTBALLD_FORWARD_LINK         = $170144E0;  (* Fallback move forward button *)
  DIBUTTON_FOOTBALLD_BACK_LINK            = $170144E8;  (* Fallback move back button *)
  DIBUTTON_FOOTBALLD_DEVICE               = $170044FE;  (* Show input device and controls *)
  DIBUTTON_FOOTBALLD_PAUSE                = $170044FC;  (* Start / Pause / Restart game *)

(*--- Sports - Golf
                                ---*)

  DIVIRTUAL_SPORTS_GOLF                   = $18000000;
  DIAXIS_GOLF_LATERAL                     = $18008201;  (* Move / Aim: left / right *)
  DIAXIS_GOLF_MOVE                        = $18010202;  (* Move / Aim: up / down *)
  DIBUTTON_GOLF_SWING                     = $18000401;  (* swing club *)
  DIBUTTON_GOLF_SELECT                    = $18000402;  (* cycle between: club / swing strength / ball arc / ball spin *)
  DIBUTTON_GOLF_UP                        = $18000403;  (* increase selection *)
  DIBUTTON_GOLF_DOWN                      = $18000404;  (* decrease selection *)
  DIBUTTON_GOLF_TERRAIN                   = $18000405;  (* shows terrain detail *)
  DIBUTTON_GOLF_FLYBY                     = $18000406;  (* view the hole via a flyby *)
  DIBUTTON_GOLF_MENU                      = $180004FD;  (* Show menu options *)
  
(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_GOLF_SCROLL                 = $18004601;  (* scroll view *)
  DIBUTTON_GOLF_ZOOM                      = $18004407;  (* Zoom view in / out *)
  DIBUTTON_GOLF_TIMEOUT                   = $18004408;  (* Call for time out *)
  DIBUTTON_GOLF_SUBSTITUTE                = $18004409;  (* substitute one player for another *)
  DIBUTTON_GOLF_LEFT_LINK                 = $1800C4E4;  (* Fallback sidestep left button *)
  DIBUTTON_GOLF_RIGHT_LINK                = $1800C4EC;  (* Fallback sidestep right button *)
  DIBUTTON_GOLF_FORWARD_LINK              = $180144E0;  (* Fallback move forward button *)
  DIBUTTON_GOLF_BACK_LINK                 = $180144E8;  (* Fallback move back button *)
  DIBUTTON_GOLF_DEVICE                    = $180044FE;  (* Show input device and controls *)
  DIBUTTON_GOLF_PAUSE                     = $180044FC;  (* Start / Pause / Restart game *)

(*--- Sports - Hockey - Offense
      Offense       ---*)

  DIVIRTUAL_SPORTS_HOCKEY_OFFENSE         = $19000000;
  DIAXIS_HOCKEYO_LATERAL                  = $19008201;  (* Move / Aim: left / right *)
  DIAXIS_HOCKEYO_MOVE                     = $19010202;  (* Move / Aim: up / down *)
  DIBUTTON_HOCKEYO_SHOOT                  = $19000401;  (* Shoot *)
  DIBUTTON_HOCKEYO_PASS                   = $19000402;  (* pass the puck *)
  DIBUTTON_HOCKEYO_BURST                  = $19000403;  (* invoke speed burst *)
  DIBUTTON_HOCKEYO_SPECIAL                = $19000404;  (* invoke special move *)
  DIBUTTON_HOCKEYO_FAKE                   = $19000405;  (* hold down to fake pass or kick *)
  DIBUTTON_HOCKEYO_MENU                   = $190004FD;  (* Show menu options *)

(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_HOCKEYO_SCROLL              = $19004601;  (* scroll view *)
  DIBUTTON_HOCKEYO_ZOOM                   = $19004406;  (* Zoom view in / out *)
  DIBUTTON_HOCKEYO_STRATEGY               = $19004407;  (* Invoke coaching menu for strategy help *)
  DIBUTTON_HOCKEYO_TIMEOUT                = $19004408;  (* Call for time out *)
  DIBUTTON_HOCKEYO_SUBSTITUTE             = $19004409;  (* substitute one player for another *)
  DIBUTTON_HOCKEYO_LEFT_LINK              = $1900C4E4;  (* Fallback sidestep left button *)
  DIBUTTON_HOCKEYO_RIGHT_LINK             = $1900C4EC;  (* Fallback sidestep right button *)
  DIBUTTON_HOCKEYO_FORWARD_LINK           = $190144E0;  (* Fallback move forward button *)
  DIBUTTON_HOCKEYO_BACK_LINK              = $190144E8;  (* Fallback move back button *)
  DIBUTTON_HOCKEYO_DEVICE                 = $190044FE;  (* Show input device and controls *)
  DIBUTTON_HOCKEYO_PAUSE                  = $190044FC;  (* Start / Pause / Restart game *)

(*--- Sports - Hockey - Defense
      Defense       ---*)

  DIVIRTUAL_SPORTS_HOCKEY_DEFENSE         = $1A000000;
  DIAXIS_HOCKEYD_LATERAL                  = $1A008201;  (* Move / Aim: left / right *)
  DIAXIS_HOCKEYD_MOVE                     = $1A010202;  (* Move / Aim: up / down *)
  DIBUTTON_HOCKEYD_PLAYER                 = $1A000401;  (* control player closest to the puck *)
  DIBUTTON_HOCKEYD_STEAL                  = $1A000402;  (* attempt steal *)
  DIBUTTON_HOCKEYD_BURST                  = $1A000403;  (* speed burst or body check *)
  DIBUTTON_HOCKEYD_BLOCK                  = $1A000404;  (* block puck *)
  DIBUTTON_HOCKEYD_FAKE                   = $1A000405;  (* hold down to fake tackle or intercept *)
  DIBUTTON_HOCKEYD_MENU                   = $1A0004FD;  (* Show menu options *)

(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_HOCKEYD_SCROLL              = $1A004601;  (* scroll view *)
  DIBUTTON_HOCKEYD_ZOOM                   = $1A004406;  (* Zoom view in / out *)
  DIBUTTON_HOCKEYD_STRATEGY               = $1A004407;  (* Invoke coaching menu for strategy help *)
  DIBUTTON_HOCKEYD_TIMEOUT                = $1A004408;  (* Call for time out *)
  DIBUTTON_HOCKEYD_SUBSTITUTE             = $1A004409;  (* substitute one player for another *)
  DIBUTTON_HOCKEYD_LEFT_LINK              = $1A00C4E4;  (* Fallback sidestep left button *)
  DIBUTTON_HOCKEYD_RIGHT_LINK             = $1A00C4EC;  (* Fallback sidestep right button *)
  DIBUTTON_HOCKEYD_FORWARD_LINK           = $1A0144E0;  (* Fallback move forward button *)
  DIBUTTON_HOCKEYD_BACK_LINK              = $1A0144E8;  (* Fallback move back button *)
  DIBUTTON_HOCKEYD_DEVICE                 = $1A0044FE;  (* Show input device and controls *)
  DIBUTTON_HOCKEYD_PAUSE                  = $1A0044FC;  (* Start / Pause / Restart game *)

(*--- Sports - Hockey - Goalie
      Goal tending  ---*)

  DIVIRTUAL_SPORTS_HOCKEY_GOALIE          = $1B000000;
  DIAXIS_HOCKEYG_LATERAL                  = $1B008201;  (* Move / Aim: left / right *)
  DIAXIS_HOCKEYG_MOVE                     = $1B010202;  (* Move / Aim: up / down *)
  DIBUTTON_HOCKEYG_PASS                   = $1B000401;  (* pass puck *)
  DIBUTTON_HOCKEYG_POKE                   = $1B000402;  (* poke / check / hack *)
  DIBUTTON_HOCKEYG_STEAL                  = $1B000403;  (* attempt steal *)
  DIBUTTON_HOCKEYG_BLOCK                  = $1B000404;  (* block puck *)
  DIBUTTON_HOCKEYG_MENU                   = $1B0004FD;  (* Show menu options *)
  
(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_HOCKEYG_SCROLL              = $1B004601;  (* scroll view *)
  DIBUTTON_HOCKEYG_ZOOM                   = $1B004405;  (* Zoom view in / out *)
  DIBUTTON_HOCKEYG_STRATEGY               = $1B004406;  (* Invoke coaching menu for strategy help *)
  DIBUTTON_HOCKEYG_TIMEOUT                = $1B004407;  (* Call for time out *)
  DIBUTTON_HOCKEYG_SUBSTITUTE             = $1B004408;  (* substitute one player for another *)
  DIBUTTON_HOCKEYG_LEFT_LINK              = $1B00C4E4;  (* Fallback sidestep left button *)
  DIBUTTON_HOCKEYG_RIGHT_LINK             = $1B00C4EC;  (* Fallback sidestep right button *)
  DIBUTTON_HOCKEYG_FORWARD_LINK           = $1B0144E0;  (* Fallback move forward button *)
  DIBUTTON_HOCKEYG_BACK_LINK              = $1B0144E8;  (* Fallback move back button *)
  DIBUTTON_HOCKEYG_DEVICE                 = $1B0044FE;  (* Show input device and controls *)
  DIBUTTON_HOCKEYG_PAUSE                  = $1B0044FC;  (* Start / Pause / Restart game *)

(*--- Sports - Mountain Biking
                     ---*)

  DIVIRTUAL_SPORTS_BIKING_MOUNTAIN        = $1C000000;
  DIAXIS_BIKINGM_TURN                     = $1C008201;  (* left / right *)
  DIAXIS_BIKINGM_PEDAL                    = $1C010202;  (* Pedal faster / slower / brake *)
  DIBUTTON_BIKINGM_JUMP                   = $1C000401;  (* jump over obstacle *)
  DIBUTTON_BIKINGM_CAMERA                 = $1C000402;  (* switch camera view *)
  DIBUTTON_BIKINGM_SPECIAL1               = $1C000403;  (* perform first special move *)
  DIBUTTON_BIKINGM_SELECT                 = $1C000404;  (* Select *)
  DIBUTTON_BIKINGM_SPECIAL2               = $1C000405;  (* perform second special move *)
  DIBUTTON_BIKINGM_MENU                   = $1C0004FD;  (* Show menu options *)

(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_BIKINGM_SCROLL              = $1C004601;  (* scroll view *)
  DIBUTTON_BIKINGM_ZOOM                   = $1C004406;  (* Zoom view in / out *)
  DIAXIS_BIKINGM_BRAKE                    = $1C044203;  (* Brake axis  *)
  DIBUTTON_BIKINGM_LEFT_LINK              = $1C00C4E4;  (* Fallback turn left button *)
  DIBUTTON_BIKINGM_RIGHT_LINK             = $1C00C4EC;  (* Fallback turn right button *)
  DIBUTTON_BIKINGM_FASTER_LINK            = $1C0144E0;  (* Fallback pedal faster button *)
  DIBUTTON_BIKINGM_SLOWER_LINK            = $1C0144E8;  (* Fallback pedal slower button *)
  DIBUTTON_BIKINGM_BRAKE_BUTTON_LINK      = $1C0444E8;  (* Fallback brake button *)
  DIBUTTON_BIKINGM_DEVICE                 = $1C0044FE;  (* Show input device and controls *)
  DIBUTTON_BIKINGM_PAUSE                  = $1C0044FC;  (* Start / Pause / Restart game *)

(*--- Sports: Skiing / Snowboarding / Skateboarding
        ---*)

  DIVIRTUAL_SPORTS_SKIING                 = $1D000000;
  DIAXIS_SKIING_TURN                      = $1D008201;  (* left / right *)
  DIAXIS_SKIING_SPEED                     = $1D010202;  (* faster / slower *)
  DIBUTTON_SKIING_JUMP                    = $1D000401;  (* Jump *)
  DIBUTTON_SKIING_CROUCH                  = $1D000402;  (* crouch down *)
  DIBUTTON_SKIING_CAMERA                  = $1D000403;  (* switch camera view *)
  DIBUTTON_SKIING_SPECIAL1                = $1D000404;  (* perform first special move *)
  DIBUTTON_SKIING_SELECT                  = $1D000405;  (* Select *)
  DIBUTTON_SKIING_SPECIAL2                = $1D000406;  (* perform second special move *)
  DIBUTTON_SKIING_MENU                    = $1D0004FD;  (* Show menu options *)

(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_SKIING_GLANCE               = $1D004601;  (* scroll view *)
  DIBUTTON_SKIING_ZOOM                    = $1D004407;  (* Zoom view in / out *)
  DIBUTTON_SKIING_LEFT_LINK               = $1D00C4E4;  (* Fallback turn left button *)
  DIBUTTON_SKIING_RIGHT_LINK              = $1D00C4EC;  (* Fallback turn right button *)
  DIBUTTON_SKIING_FASTER_LINK             = $1D0144E0;  (* Fallback increase speed button *)
  DIBUTTON_SKIING_SLOWER_LINK             = $1D0144E8;  (* Fallback decrease speed button *)
  DIBUTTON_SKIING_DEVICE                  = $1D0044FE;  (* Show input device and controls *)
  DIBUTTON_SKIING_PAUSE                   = $1D0044FC;  (* Start / Pause / Restart game *)

(*--- Sports - Soccer - Offense
      Offense       ---*)

  DIVIRTUAL_SPORTS_SOCCER_OFFENSE         = $1E000000;
  DIAXIS_SOCCERO_LATERAL                  = $1E008201;  (* Move / Aim: left / right *)
  DIAXIS_SOCCERO_MOVE                     = $1E010202;  (* Move / Aim: up / down *)
  DIAXIS_SOCCERO_BEND                     = $1E018203;  (* Bend to soccer shot/pass *)
  DIBUTTON_SOCCERO_SHOOT                  = $1E000401;  (* Shoot the ball *)
  DIBUTTON_SOCCERO_PASS                   = $1E000402;  (* Pass  *)
  DIBUTTON_SOCCERO_FAKE                   = $1E000403;  (* Fake *)
  DIBUTTON_SOCCERO_PLAYER                 = $1E000404;  (* Select next player *)
  DIBUTTON_SOCCERO_SPECIAL1               = $1E000405;  (* Apply special move *)
  DIBUTTON_SOCCERO_SELECT                 = $1E000406;  (* Select special move *)
  DIBUTTON_SOCCERO_MENU                   = $1E0004FD;  (* Show menu options *)

(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_SOCCERO_GLANCE              = $1E004601;  (* scroll view *)
  DIBUTTON_SOCCERO_SUBSTITUTE             = $1E004407;  (* Substitute one player for another *)
  DIBUTTON_SOCCERO_SHOOTLOW               = $1E004408;  (* Shoot the ball low *)
  DIBUTTON_SOCCERO_SHOOTHIGH              = $1E004409;  (* Shoot the ball high *)
  DIBUTTON_SOCCERO_PASSTHRU               = $1E00440A;  (* Make a thru pass *)
  DIBUTTON_SOCCERO_SPRINT                 = $1E00440B;  (* Sprint / turbo boost *)
  DIBUTTON_SOCCERO_CONTROL                = $1E00440C;  (* Obtain control of the ball *)
  DIBUTTON_SOCCERO_HEAD                   = $1E00440D;  (* Attempt to head the ball *)
  DIBUTTON_SOCCERO_LEFT_LINK              = $1E00C4E4;  (* Fallback sidestep left button *)
  DIBUTTON_SOCCERO_RIGHT_LINK             = $1E00C4EC;  (* Fallback sidestep right button *)
  DIBUTTON_SOCCERO_FORWARD_LINK           = $1E0144E0;  (* Fallback move forward button *)
  DIBUTTON_SOCCERO_BACK_LINK              = $1E0144E8;  (* Fallback move back button *)
  DIBUTTON_SOCCERO_DEVICE                 = $1E0044FE;  (* Show input device and controls *)
  DIBUTTON_SOCCERO_PAUSE                  = $1E0044FC;  (* Start / Pause / Restart game *)

(*--- Sports - Soccer - Defense
      Defense       ---*)

  DIVIRTUAL_SPORTS_SOCCER_DEFENSE         = $1F000000;
  DIAXIS_SOCCERD_LATERAL                  = $1F008201;  (* Move / Aim: left / right *)
  DIAXIS_SOCCERD_MOVE                     = $1F010202;  (* Move / Aim: up / down *)
  DIBUTTON_SOCCERD_BLOCK                  = $1F000401;  (* Attempt to block shot *)
  DIBUTTON_SOCCERD_STEAL                  = $1F000402;  (* Attempt to steal ball *)
  DIBUTTON_SOCCERD_FAKE                   = $1F000403;  (* Fake a block or a steal *)
  DIBUTTON_SOCCERD_PLAYER                 = $1F000404;  (* Select next player *)
  DIBUTTON_SOCCERD_SPECIAL                = $1F000405;  (* Apply special move *)
  DIBUTTON_SOCCERD_SELECT                 = $1F000406;  (* Select special move *)
  DIBUTTON_SOCCERD_SLIDE                  = $1F000407;  (* Attempt a slide tackle *)
  DIBUTTON_SOCCERD_MENU                   = $1F0004FD;  (* Show menu options *)

(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_SOCCERD_GLANCE              = $1F004601;  (* scroll view *)
  DIBUTTON_SOCCERD_FOUL                   = $1F004408;  (* Initiate a foul / hard-foul *)
  DIBUTTON_SOCCERD_HEAD                   = $1F004409;  (* Attempt a Header *)
  DIBUTTON_SOCCERD_CLEAR                  = $1F00440A;  (* Attempt to clear the ball down the field *)
  DIBUTTON_SOCCERD_GOALIECHARGE           = $1F00440B;  (* Make the goalie charge out of the box *)
  DIBUTTON_SOCCERD_SUBSTITUTE             = $1F00440C;  (* Substitute one player for another *)
  DIBUTTON_SOCCERD_LEFT_LINK              = $1F00C4E4;  (* Fallback sidestep left button *)
  DIBUTTON_SOCCERD_RIGHT_LINK             = $1F00C4EC;  (* Fallback sidestep right button *)
  DIBUTTON_SOCCERD_FORWARD_LINK           = $1F0144E0;  (* Fallback move forward button *)
  DIBUTTON_SOCCERD_BACK_LINK              = $1F0144E8;  (* Fallback move back button *)
  DIBUTTON_SOCCERD_DEVICE                 = $1F0044FE;  (* Show input device and controls *)
  DIBUTTON_SOCCERD_PAUSE                  = $1F0044FC;  (* Start / Pause / Restart game *)

(*--- Sports - Racquet
      Tennis - Table-Tennis - Squash   ---*)

  DIVIRTUAL_SPORTS_RACQUET                = $20000000;
  DIAXIS_RACQUET_LATERAL                  = $20008201;  (* Move / Aim: left / right *)
  DIAXIS_RACQUET_MOVE                     = $20010202;  (* Move / Aim: up / down *)
  DIBUTTON_RACQUET_SWING                  = $20000401;  (* Swing racquet *)
  DIBUTTON_RACQUET_BACKSWING              = $20000402;  (* Swing backhand *)
  DIBUTTON_RACQUET_SMASH                  = $20000403;  (* Smash shot *)
  DIBUTTON_RACQUET_SPECIAL                = $20000404;  (* Special shot *)
  DIBUTTON_RACQUET_SELECT                 = $20000405;  (* Select special shot *)
  DIBUTTON_RACQUET_MENU                   = $200004FD;  (* Show menu options *)

(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_RACQUET_GLANCE              = $20004601;  (* scroll view *)
  DIBUTTON_RACQUET_TIMEOUT                = $20004406;  (* Call for time out *)
  DIBUTTON_RACQUET_SUBSTITUTE             = $20004407;  (* Substitute one player for another *)
  DIBUTTON_RACQUET_LEFT_LINK              = $2000C4E4;  (* Fallback sidestep left button *)
  DIBUTTON_RACQUET_RIGHT_LINK             = $2000C4EC;  (* Fallback sidestep right button *)
  DIBUTTON_RACQUET_FORWARD_LINK           = $200144E0;  (* Fallback move forward button *)
  DIBUTTON_RACQUET_BACK_LINK              = $200144E8;  (* Fallback move back button *)
  DIBUTTON_RACQUET_DEVICE                 = $200044FE;  (* Show input device and controls *)
  DIBUTTON_RACQUET_PAUSE                  = $200044FC;  (* Start / Pause / Restart game *)

(*--- Arcade- 2D
      Side to Side movement        ---*)

  DIVIRTUAL_ARCADE_SIDE2SIDE              = $21000000;
  DIAXIS_ARCADES_LATERAL                  = $21008201;  (* left / right *)
  DIAXIS_ARCADES_MOVE                     = $21010202;  (* up / down *)
  DIBUTTON_ARCADES_THROW                  = $21000401;  (* throw object *)
  DIBUTTON_ARCADES_CARRY                  = $21000402;  (* carry object *)
  DIBUTTON_ARCADES_ATTACK                 = $21000403;  (* attack *)
  DIBUTTON_ARCADES_SPECIAL                = $21000404;  (* apply special move *)
  DIBUTTON_ARCADES_SELECT                 = $21000405;  (* select special move *)
  DIBUTTON_ARCADES_MENU                   = $210004FD;  (* Show menu options *)

(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_ARCADES_VIEW                = $21004601;  (* scroll view left / right / up / down *)
  DIBUTTON_ARCADES_LEFT_LINK              = $2100C4E4;  (* Fallback sidestep left button *)
  DIBUTTON_ARCADES_RIGHT_LINK             = $2100C4EC;  (* Fallback sidestep right button *)
  DIBUTTON_ARCADES_FORWARD_LINK           = $210144E0;  (* Fallback move forward button *)
  DIBUTTON_ARCADES_BACK_LINK              = $210144E8;  (* Fallback move back button *)
  DIBUTTON_ARCADES_VIEW_UP_LINK           = $2107C4E0;  (* Fallback scroll view up button *)
  DIBUTTON_ARCADES_VIEW_DOWN_LINK         = $2107C4E8;  (* Fallback scroll view down button *)
  DIBUTTON_ARCADES_VIEW_LEFT_LINK         = $2107C4E4;  (* Fallback scroll view left button *)
  DIBUTTON_ARCADES_VIEW_RIGHT_LINK        = $2107C4EC;  (* Fallback scroll view right button *)
  DIBUTTON_ARCADES_DEVICE                 = $210044FE;  (* Show input device and controls *)
  DIBUTTON_ARCADES_PAUSE                  = $210044FC;  (* Start / Pause / Restart game *)

(*--- Arcade - Platform Game
      Character moves around on screen  ---*)

  DIVIRTUAL_ARCADE_PLATFORM               = $22000000;
  DIAXIS_ARCADEP_LATERAL                  = $22008201;  (* Left / right *)
  DIAXIS_ARCADEP_MOVE                     = $22010202;  (* Up / down *)
  DIBUTTON_ARCADEP_JUMP                   = $22000401;  (* Jump *)
  DIBUTTON_ARCADEP_FIRE                   = $22000402;  (* Fire *)
  DIBUTTON_ARCADEP_CROUCH                 = $22000403;  (* Crouch *)
  DIBUTTON_ARCADEP_SPECIAL                = $22000404;  (* Apply special move *)
  DIBUTTON_ARCADEP_SELECT                 = $22000405;  (* Select special move *)
  DIBUTTON_ARCADEP_MENU                   = $220004FD;  (* Show menu options *)
(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_ARCADEP_VIEW                = $22004601;  (* Scroll view *)
  DIBUTTON_ARCADEP_FIRESECONDARY          = $22004406;  (* Alternative fire button *)
  DIBUTTON_ARCADEP_LEFT_LINK              = $2200C4E4;  (* Fallback sidestep left button *)
  DIBUTTON_ARCADEP_RIGHT_LINK             = $2200C4EC;  (* Fallback sidestep right button *)
  DIBUTTON_ARCADEP_FORWARD_LINK           = $220144E0;  (* Fallback move forward button *)
  DIBUTTON_ARCADEP_BACK_LINK              = $220144E8;  (* Fallback move back button *)
  DIBUTTON_ARCADEP_VIEW_UP_LINK           = $2207C4E0;  (* Fallback scroll view up button *)
  DIBUTTON_ARCADEP_VIEW_DOWN_LINK         = $2207C4E8;  (* Fallback scroll view down button *)
  DIBUTTON_ARCADEP_VIEW_LEFT_LINK         = $2207C4E4;  (* Fallback scroll view left button *)
  DIBUTTON_ARCADEP_VIEW_RIGHT_LINK        = $2207C4EC;  (* Fallback scroll view right button *)
  DIBUTTON_ARCADEP_DEVICE                 = $220044FE;  (* Show input device and controls *)
  DIBUTTON_ARCADEP_PAUSE                  = $220044FC;  (* Start / Pause / Restart game *)

(*--- CAD - 2D Object Control
      Controls to select and move objects in 2D  ---*)

  DIVIRTUAL_CAD_2DCONTROL                 = $23000000;
  DIAXIS_2DCONTROL_LATERAL                = $23008201;  (* Move view left / right *)
  DIAXIS_2DCONTROL_MOVE                   = $23010202;  (* Move view up / down *)
  DIAXIS_2DCONTROL_INOUT                  = $23018203;  (* Zoom - in / out *)
  DIBUTTON_2DCONTROL_SELECT               = $23000401;  (* Select Object *)
  DIBUTTON_2DCONTROL_SPECIAL1             = $23000402;  (* Do first special operation *)
  DIBUTTON_2DCONTROL_SPECIAL              = $23000403;  (* Select special operation *)
  DIBUTTON_2DCONTROL_SPECIAL2             = $23000404;  (* Do second special operation *)
  DIBUTTON_2DCONTROL_MENU                 = $230004FD;  (* Show menu options *)

(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_2DCONTROL_HATSWITCH         = $23004601;  (* Hat switch *)
  DIAXIS_2DCONTROL_ROTATEZ                = $23024204;  (* Rotate view clockwise / counterclockwise *)
  DIBUTTON_2DCONTROL_DISPLAY              = $23004405;  (* Shows next on-screen display options *)
  DIBUTTON_2DCONTROL_DEVICE               = $230044FE;  (* Show input device and controls *)
  DIBUTTON_2DCONTROL_PAUSE                = $230044FC;  (* Start / Pause / Restart game *)

(*--- CAD - 3D object control
      Controls to select and move objects within a 3D environment  ---*)

  DIVIRTUAL_CAD_3DCONTROL                 = $24000000;
  DIAXIS_3DCONTROL_LATERAL                = $24008201;  (* Move view left / right *)
  DIAXIS_3DCONTROL_MOVE                   = $24010202;  (* Move view up / down *)
  DIAXIS_3DCONTROL_INOUT                  = $24018203;  (* Zoom - in / out *)
  DIBUTTON_3DCONTROL_SELECT               = $24000401;  (* Select Object *)
  DIBUTTON_3DCONTROL_SPECIAL1             = $24000402;  (* Do first special operation *)
  DIBUTTON_3DCONTROL_SPECIAL              = $24000403;  (* Select special operation *)
  DIBUTTON_3DCONTROL_SPECIAL2             = $24000404;  (* Do second special operation *)
  DIBUTTON_3DCONTROL_MENU                 = $240004FD;  (* Show menu options *)

(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_3DCONTROL_HATSWITCH         = $24004601;  (* Hat switch *)
  DIAXIS_3DCONTROL_ROTATEX                = $24034204;  (* Rotate view forward or up / backward or down *)
  DIAXIS_3DCONTROL_ROTATEY                = $2402C205;  (* Rotate view clockwise / counterclockwise *)
  DIAXIS_3DCONTROL_ROTATEZ                = $24024206;  (* Rotate view left / right *)
  DIBUTTON_3DCONTROL_DISPLAY              = $24004405;  (* Show next on-screen display options *)
  DIBUTTON_3DCONTROL_DEVICE               = $240044FE;  (* Show input device and controls *)
  DIBUTTON_3DCONTROL_PAUSE                = $240044FC;  (* Start / Pause / Restart game *)

(*--- CAD - 3D Navigation - Fly through
      Controls for 3D modeling  ---*)

  DIVIRTUAL_CAD_FLYBY                     = $25000000;
  DIAXIS_CADF_LATERAL                     = $25008201;  (* move view left / right *)
  DIAXIS_CADF_MOVE                        = $25010202;  (* move view up / down *)
  DIAXIS_CADF_INOUT                       = $25018203;  (* in / out *)
  DIBUTTON_CADF_SELECT                    = $25000401;  (* Select Object *)
  DIBUTTON_CADF_SPECIAL1                  = $25000402;  (* do first special operation *)
  DIBUTTON_CADF_SPECIAL                   = $25000403;  (* Select special operation *)
  DIBUTTON_CADF_SPECIAL2                  = $25000404;  (* do second special operation *)
  DIBUTTON_CADF_MENU                      = $250004FD;  (* Show menu options *)

(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_CADF_HATSWITCH              = $25004601;  (* Hat switch *)
  DIAXIS_CADF_ROTATEX                     = $25034204;  (* Rotate view forward or up / backward or down *)
  DIAXIS_CADF_ROTATEY                     = $2502C205;  (* Rotate view clockwise / counterclockwise *)
  DIAXIS_CADF_ROTATEZ                     = $25024206;  (* Rotate view left / right *)
  DIBUTTON_CADF_DISPLAY                   = $25004405;  (* shows next on-screen display options *)
  DIBUTTON_CADF_DEVICE                    = $250044FE;  (* Show input device and controls *)
  DIBUTTON_CADF_PAUSE                     = $250044FC;  (* Start / Pause / Restart game *)

(*--- CAD - 3D Model Control
      Controls for 3D modeling  ---*)

  DIVIRTUAL_CAD_MODEL                     = $26000000;
  DIAXIS_CADM_LATERAL                     = $26008201;  (* move view left / right *)
  DIAXIS_CADM_MOVE                        = $26010202;  (* move view up / down *)
  DIAXIS_CADM_INOUT                       = $26018203;  (* in / out *)
  DIBUTTON_CADM_SELECT                    = $26000401;  (* Select Object *)
  DIBUTTON_CADM_SPECIAL1                  = $26000402;  (* do first special operation *)
  DIBUTTON_CADM_SPECIAL                   = $26000403;  (* Select special operation *)
  DIBUTTON_CADM_SPECIAL2                  = $26000404;  (* do second special operation *)
  DIBUTTON_CADM_MENU                      = $260004FD;  (* Show menu options *)

(*--- Priority 2 controls                            ---*)

  DIHATSWITCH_CADM_HATSWITCH              = $26004601;  (* Hat switch *)
  DIAXIS_CADM_ROTATEX                     = $26034204;  (* Rotate view forward or up / backward or down *)
  DIAXIS_CADM_ROTATEY                     = $2602C205;  (* Rotate view clockwise / counterclockwise *)
  DIAXIS_CADM_ROTATEZ                     = $26024206;  (* Rotate view left / right *)
  DIBUTTON_CADM_DISPLAY                   = $26004405;  (* shows next on-screen display options *)
  DIBUTTON_CADM_DEVICE                    = $260044FE;  (* Show input device and controls *)
  DIBUTTON_CADM_PAUSE                     = $260044FC;  (* Start / Pause / Restart game *)

(*--- Control - Media Equipment
      Remote        ---*)

  DIVIRTUAL_REMOTE_CONTROL                = $27000000;
  DIAXIS_REMOTE_SLIDER                    = $27050201;  (* Slider for adjustment: volume / color / bass / etc *)
  DIBUTTON_REMOTE_MUTE                    = $27000401;  (* Set volume on current device to zero *)
  DIBUTTON_REMOTE_SELECT                  = $27000402;  (* Next/previous: channel/ track / chapter / picture / station *)
  DIBUTTON_REMOTE_PLAY                    = $27002403;  (* Start or pause entertainment on current device *)
  DIBUTTON_REMOTE_CUE                     = $27002404;  (* Move through current media *)
  DIBUTTON_REMOTE_REVIEW                  = $27002405;  (* Move through current media *)
  DIBUTTON_REMOTE_CHANGE                  = $27002406;  (* Select next device *)
  DIBUTTON_REMOTE_RECORD                  = $27002407;  (* Start recording the current media *)
  DIBUTTON_REMOTE_MENU                    = $270004FD;  (* Show menu options *)

(*--- Priority 2 controls                            ---*)

  DIAXIS_REMOTE_SLIDER2                   = $27054202;  (* Slider for adjustment: volume *)
  DIBUTTON_REMOTE_TV                      = $27005C08;  (* Select TV *)
  DIBUTTON_REMOTE_CABLE                   = $27005C09;  (* Select cable box *)
  DIBUTTON_REMOTE_CD                      = $27005C0A;  (* Select CD player *)
  DIBUTTON_REMOTE_VCR                     = $27005C0B;  (* Select VCR *)
  DIBUTTON_REMOTE_TUNER                   = $27005C0C;  (* Select tuner *)
  DIBUTTON_REMOTE_DVD                     = $27005C0D;  (* Select DVD player *)
  DIBUTTON_REMOTE_ADJUST                  = $27005C0E;  (* Enter device adjustment menu *)
  DIBUTTON_REMOTE_DIGIT0                  = $2700540F;  (* Digit 0 *)
  DIBUTTON_REMOTE_DIGIT1                  = $27005410;  (* Digit 1 *)
  DIBUTTON_REMOTE_DIGIT2                  = $27005411;  (* Digit 2 *)
  DIBUTTON_REMOTE_DIGIT3                  = $27005412;  (* Digit 3 *)
  DIBUTTON_REMOTE_DIGIT4                  = $27005413;  (* Digit 4 *)
  DIBUTTON_REMOTE_DIGIT5                  = $27005414;  (* Digit 5 *)
  DIBUTTON_REMOTE_DIGIT6                  = $27005415;  (* Digit 6 *)
  DIBUTTON_REMOTE_DIGIT7                  = $27005416;  (* Digit 7 *)
  DIBUTTON_REMOTE_DIGIT8                  = $27005417;  (* Digit 8 *)
  DIBUTTON_REMOTE_DIGIT9                  = $27005418;  (* Digit 9 *)
  DIBUTTON_REMOTE_DEVICE                  = $270044FE;  (* Show input device and controls *)
  DIBUTTON_REMOTE_PAUSE                   = $270044FC;  (* Start / Pause / Restart game *)

(*--- Control- Web
      Help or Browser            ---*)

  DIVIRTUAL_BROWSER_CONTROL               = $28000000;
  DIAXIS_BROWSER_LATERAL                  = $28008201;  (* Move on screen Pointer *)
  DIAXIS_BROWSER_MOVE                     = $28010202;  (* Move on screen Pointer *)
  DIBUTTON_BROWSER_SELECT                 = $28000401;  (* Select current item *)
  DIAXIS_BROWSER_VIEW                     = $28018203;  (* Move view up/down *)
  DIBUTTON_BROWSER_REFRESH                = $28000402;  (* Refresh *)
  DIBUTTON_BROWSER_MENU                   = $280004FD;  (* Show menu options *)

(*--- Priority 2 controls                            ---*)

  DIBUTTON_BROWSER_SEARCH                 = $28004403;  (* Use search tool *)
  DIBUTTON_BROWSER_STOP                   = $28004404;  (* Cease current update *)
  DIBUTTON_BROWSER_HOME                   = $28004405;  (* Go directly to "home" location *)
  DIBUTTON_BROWSER_FAVORITES              = $28004406;  (* Mark current site as favorite *)
  DIBUTTON_BROWSER_NEXT                   = $28004407;  (* Select Next page *)
  DIBUTTON_BROWSER_PREVIOUS               = $28004408;  (* Select Previous page *)
  DIBUTTON_BROWSER_HISTORY                = $28004409;  (* Show/Hide History *)
  DIBUTTON_BROWSER_PRINT                  = $2800440A;  (* Print current page *)
  DIBUTTON_BROWSER_DEVICE                 = $280044FE;  (* Show input device and controls *)
  DIBUTTON_BROWSER_PAUSE                  = $280044FC;  (* Start / Pause / Restart game *)

(*--- Driving Simulator - Giant Walking Robot
      Walking tank with weapons  ---*)

  DIVIRTUAL_DRIVING_MECHA                 = $29000000;
  DIAXIS_MECHA_STEER                      = $29008201;  (* Turns mecha left/right *)
  DIAXIS_MECHA_TORSO                      = $29010202;  (* Tilts torso forward/backward *)
  DIAXIS_MECHA_ROTATE                     = $29020203;  (* Turns torso left/right *)
  DIAXIS_MECHA_THROTTLE                   = $29038204;  (* Engine Speed *)
  DIBUTTON_MECHA_FIRE                     = $29000401;  (* Fire *)
  DIBUTTON_MECHA_WEAPONS                  = $29000402;  (* Select next weapon group *)
  DIBUTTON_MECHA_TARGET                   = $29000403;  (* Select closest enemy available target *)
  DIBUTTON_MECHA_REVERSE                  = $29000404;  (* Toggles throttle in/out of reverse *)
  DIBUTTON_MECHA_ZOOM                     = $29000405;  (* Zoom in/out targeting reticule *)
  DIBUTTON_MECHA_JUMP                     = $29000406;  (* Fires jump jets *)
  DIBUTTON_MECHA_MENU                     = $290004FD;  (* Show menu options *)

(*--- Priority 2 controls                            ---*)

  DIBUTTON_MECHA_CENTER                   = $29004407;  (* Center torso to legs *)
  DIHATSWITCH_MECHA_GLANCE                = $29004601;  (* Look around *)
  DIBUTTON_MECHA_VIEW                     = $29004408;  (* Cycle through view options *)
  DIBUTTON_MECHA_FIRESECONDARY            = $29004409;  (* Alternative fire button *)
  DIBUTTON_MECHA_LEFT_LINK                = $2900C4E4;  (* Fallback steer left button *)
  DIBUTTON_MECHA_RIGHT_LINK               = $2900C4EC;  (* Fallback steer right button *)
  DIBUTTON_MECHA_FORWARD_LINK             = $290144E0;  (* Fallback tilt torso forward button *)
  DIBUTTON_MECHA_BACK_LINK                = $290144E8;  (* Fallback tilt toroso backward button *)
  DIBUTTON_MECHA_ROTATE_LEFT_LINK         = $290244E4;  (* Fallback rotate toroso right button *)
  DIBUTTON_MECHA_ROTATE_RIGHT_LINK        = $290244EC;  (* Fallback rotate torso left button *)
  DIBUTTON_MECHA_FASTER_LINK              = $2903C4E0;  (* Fallback increase engine speed *)
  DIBUTTON_MECHA_SLOWER_LINK              = $2903C4E8;  (* Fallback decrease engine speed *)
  DIBUTTON_MECHA_DEVICE                   = $290044FE;  (* Show input device and controls *)
  DIBUTTON_MECHA_PAUSE                    = $290044FC;  (* Start / Pause / Restart game *)

(*
 *  "ANY" semantics can be used as a last resort to get mappings for actions
 *  that match nothing in the chosen virtual genre.  These semantics will be
 *  mapped at a lower priority that virtual genre semantics.  Also, hardware
 *  vendors will not be able to provide sensible mappings for these unless
 *  they provide application specific mappings.
 *)
  DIAXIS_ANY_X_1                          = $FF00C201;
  DIAXIS_ANY_X_2                          = $FF00C202;
  DIAXIS_ANY_Y_1                          = $FF014201;
  DIAXIS_ANY_Y_2                          = $FF014202;
  DIAXIS_ANY_Z_1                          = $FF01C201;
  DIAXIS_ANY_Z_2                          = $FF01C202;
  DIAXIS_ANY_R_1                          = $FF024201;
  DIAXIS_ANY_R_2                          = $FF024202;
  DIAXIS_ANY_U_1                          = $FF02C201;
  DIAXIS_ANY_U_2                          = $FF02C202;
  DIAXIS_ANY_V_1                          = $FF034201;
  DIAXIS_ANY_V_2                          = $FF034202;
  DIAXIS_ANY_A_1                          = $FF03C201;
  DIAXIS_ANY_A_2                          = $FF03C202;
  DIAXIS_ANY_B_1                          = $FF044201;
  DIAXIS_ANY_B_2                          = $FF044202;
  DIAXIS_ANY_C_1                          = $FF04C201;
  DIAXIS_ANY_C_2                          = $FF04C202;
  DIAXIS_ANY_S_1                          = $FF054201;
  DIAXIS_ANY_S_2                          = $FF054202;

  DIAXIS_ANY_1                            = $FF004201;
  DIAXIS_ANY_2                            = $FF004202;
  DIAXIS_ANY_3                            = $FF004203;
  DIAXIS_ANY_4                            = $FF004204;

  DIPOV_ANY_1                             = $FF004601;
  DIPOV_ANY_2                             = $FF004602;
  DIPOV_ANY_3                             = $FF004603;
  DIPOV_ANY_4                             = $FF004604;


(****************************************************************************
 *
 *  Definitions for non-IDirectInput (VJoyD) features defined more recently
 *  than the current sdk files
 *
 ****************************************************************************)

(*
 * Flag to indicate that the dwReserved2 field of the JOYINFOEX structure
 * contains mini-driver specific data to be passed by VJoyD to the mini-
 * driver instead of doing a poll.
 *)
  JOY_PASSDRIVERDATA          = $10000000;

(*
 * Informs the joystick driver that the configuration has been changed
 * and should be reloaded from the registery.
 * dwFlags is reserved and should be set to zero
 *)

(*
 * Hardware Setting indicating that the device is a headtracker
 *)
  JOY_HWS_ISHEADTRACKER       = $02000000;

(*
 * Hardware Setting indicating that the VxD is used to replace
 * the standard analog polling
 *)
  JOY_HWS_ISGAMEPORTDRIVER    = $04000000;

(*
 * Hardware Setting indicating that the driver needs a standard
 * gameport in order to communicate with the device.
 *)
  JOY_HWS_ISANALOGPORTDRIVER  = $08000000;

(*
 * Hardware Setting indicating that VJoyD should not load this
 * driver, it will be loaded externally and will register with
 * VJoyD of it's own accord.
 *)
  JOY_HWS_AUTOLOAD            = $10000000;

(*
 * Hardware Setting indicating that the driver acquires any 
 * resources needed without needing a devnode through VJoyD.
 *)
  JOY_HWS_NODEVNODE           = $20000000;

(*
 * Hardware Setting indicating that the device is a gameport bus
 *)
  JOY_HWS_ISGAMEPORTBUS       = $80000000;
  JOY_HWS_GAMEPORTBUSBUSY     = $00000001;

//from older Verion :
(*
 * Hardware Setting indicating that the VxD can be used as
 * a port 201h emulator.
 *)
  JOY_HWS_ISGAMEPORTEMULATOR  = $40000000;


(*
 * Usage Setting indicating that the settings are volatile and
 * should be removed if still present on a reboot.
 *)
  JOY_US_VOLATILE             = $00000008;

(*
 * Poll type in which the do_other field of the JOYOEMPOLLDATA
 * structure contains mini-driver specific data passed from an app.
 *)
  JOY_OEMPOLL_PASSDRIVERDATA  = 7;

var _c_dfDIKeyboard_Objects : array[0..255] of TDIObjectDataFormat;
const
   c_dfDIKeyboard : TDIDataFormat = (
    dwSize        : Sizeof(c_dfDIKeyboard);
    dwObjSize     : Sizeof(TDIObjectDataFormat);
    dwFlags       : DIDF_RELAXIS;
    dwDataSize    : Sizeof(TDIKeyboardState);
    dwNumObjs     : High(_c_dfDIKeyboard_Objects) + 1;
    rgodf         : @_c_dfDIKeyboard_Objects[Low(_c_dfDIKeyboard_Objects)]
  );

  _c_dfDIJoystick_Objects : array[0..43] of TDIObjectDataFormat = (
    (  pguid   : @GUID_XAxis;
       dwOfs   : DIJOFS_X;
       dwType  : $80000000 or DIDFT_AXIS or DIDFT_NOCOLLECTION;
       dwFlags : DIDOI_ASPECTPOSITION),
    (  pguid   : @GUID_YAxis;
       dwOfs   : DIJOFS_Y;
       dwType  : $80000000 or DIDFT_AXIS or DIDFT_NOCOLLECTION;
       dwFlags : DIDOI_ASPECTPOSITION),
    (  pguid   : @GUID_ZAxis;
       dwOfs   : DIJOFS_Z;
       dwType  : $80000000 or DIDFT_AXIS or DIDFT_NOCOLLECTION;
       dwFlags : DIDOI_ASPECTPOSITION),
    (  pguid   : @GUID_RxAxis;
       dwOfs   : DIJOFS_RX;
       dwType  : $80000000 or DIDFT_AXIS or DIDFT_NOCOLLECTION;
       dwFlags : DIDOI_ASPECTPOSITION),
    (  pguid   : @GUID_RyAxis;
       dwOfs   : DIJOFS_RY;
       dwType  : $80000000 or DIDFT_AXIS or DIDFT_NOCOLLECTION;
       dwFlags : DIDOI_ASPECTPOSITION),
    (  pguid   : @GUID_RzAxis;
       dwOfs   : DIJOFS_RZ;
       dwType  : $80000000 or DIDFT_AXIS or DIDFT_NOCOLLECTION;
       dwFlags : DIDOI_ASPECTPOSITION),

    (  pguid   : @GUID_Slider;  // 2 Sliders
       dwOfs   : 24;
       dwType  : $80000000 or DIDFT_AXIS or DIDFT_NOCOLLECTION;
       dwFlags : DIDOI_ASPECTPOSITION),
    (  pguid   : @GUID_Slider;
       dwOfs   : 28;
       dwType  : $80000000 or DIDFT_AXIS or DIDFT_NOCOLLECTION;
       dwFlags : DIDOI_ASPECTPOSITION),

    (  pguid   : @GUID_POV;  // 4 POVs (yes, really)
       dwOfs   : 32;
       dwType  : $80000000 or DIDFT_POV or DIDFT_NOCOLLECTION;
       dwFlags : 0),
    (  pguid   : @GUID_POV;
       dwOfs   : 36;
       dwType  : $80000000 or DIDFT_POV or DIDFT_NOCOLLECTION;
       dwFlags : 0),
    (  pguid   : @GUID_POV;
       dwOfs   : 40;
       dwType  : $80000000 or DIDFT_POV or DIDFT_NOCOLLECTION;
       dwFlags : 0),
    (  pguid   : @GUID_POV;
       dwOfs   : 44;
       dwType  : $80000000 or DIDFT_POV or DIDFT_NOCOLLECTION;
       dwFlags : 0),

    (  pguid   : nil;   // Buttons
       dwOfs   : DIJOFS_BUTTON0;
       dwType  : $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION;
       dwFlags : 0),
    (  pguid   : nil;
       dwOfs   : DIJOFS_BUTTON1;
       dwType  : $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION;
       dwFlags : 0),
    (  pguid   : nil;
       dwOfs   : DIJOFS_BUTTON2;
       dwType  : $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION;
       dwFlags : 0),
    (  pguid   : nil;
       dwOfs   : DIJOFS_BUTTON3;
       dwType  : $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION;
       dwFlags : 0),
    (  pguid   : nil;
       dwOfs   : DIJOFS_BUTTON4;
       dwType  : $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION;
       dwFlags : 0),
    (  pguid   : nil;
       dwOfs   : DIJOFS_BUTTON5;
       dwType  : $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION;
       dwFlags : 0),
    (  pguid   : nil;
       dwOfs   : DIJOFS_BUTTON6;
       dwType  : $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION;
       dwFlags : 0),
    (  pguid   : nil;
       dwOfs   : DIJOFS_BUTTON7;
       dwType  : $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION;
       dwFlags : 0),
    (  pguid   : nil;
       dwOfs   : DIJOFS_BUTTON8;
       dwType  : $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION;
       dwFlags : 0),
    (  pguid   : nil;
       dwOfs   : DIJOFS_BUTTON9;
       dwType  : $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION;
       dwFlags : 0),
    (  pguid   : nil;
       dwOfs   : DIJOFS_BUTTON10;
       dwType  : $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION;
       dwFlags : 0),
    (  pguid   : nil;
       dwOfs   : DIJOFS_BUTTON11;
       dwType  : $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION;
       dwFlags : 0),
    (  pguid   : nil;
       dwOfs   : DIJOFS_BUTTON12;
       dwType  : $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION;
       dwFlags : 0),
    (  pguid   : nil;
       dwOfs   : DIJOFS_BUTTON13;
       dwType  : $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION;
       dwFlags : 0),
    (  pguid   : nil;
       dwOfs   : DIJOFS_BUTTON14;
       dwType  : $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION;
       dwFlags : 0),
    (  pguid   : nil;
       dwOfs   : DIJOFS_BUTTON15;
       dwType  : $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION;
       dwFlags : 0),
    (  pguid   : nil;
       dwOfs   : DIJOFS_BUTTON16;
       dwType  : $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION;
       dwFlags : 0),
    (  pguid   : nil;
       dwOfs   : DIJOFS_BUTTON17;
       dwType  : $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION;
       dwFlags : 0),
    (  pguid   : nil;
       dwOfs   : DIJOFS_BUTTON18;
       dwType  : $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION;
       dwFlags : 0),
    (  pguid   : nil;
       dwOfs   : DIJOFS_BUTTON19;
       dwType  : $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION;
       dwFlags : 0),
    (  pguid   : nil;
       dwOfs   : DIJOFS_BUTTON20;
       dwType  : $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION;
       dwFlags : 0),
    (  pguid   : nil;
       dwOfs   : DIJOFS_BUTTON21;
       dwType  : $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION;
       dwFlags : 0),
    (  pguid   : nil;
       dwOfs   : DIJOFS_BUTTON22;
       dwType  : $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION;
       dwFlags : 0),
    (  pguid   : nil;
       dwOfs   : DIJOFS_BUTTON23;
       dwType  : $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION;
       dwFlags : 0),
    (  pguid   : nil;
       dwOfs   : DIJOFS_BUTTON24;
       dwType  : $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION;
       dwFlags : 0),
    (  pguid   : nil;
       dwOfs   : DIJOFS_BUTTON25;
       dwType  : $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION;
       dwFlags : 0),
    (  pguid   : nil;
       dwOfs   : DIJOFS_BUTTON26;
       dwType  : $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION;
       dwFlags : 0),
    (  pguid   : nil;
       dwOfs   : DIJOFS_BUTTON27;
       dwType  : $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION;
       dwFlags : 0),
    (  pguid   : nil;
       dwOfs   : DIJOFS_BUTTON28;
       dwType  : $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION;
       dwFlags : 0),
    (  pguid   : nil;
       dwOfs   : DIJOFS_BUTTON29;
       dwType  : $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION;
       dwFlags : 0),
    (  pguid   : nil;
       dwOfs   : DIJOFS_BUTTON30;
       dwType  : $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION;
       dwFlags : 0),
    (  pguid   : nil;
       dwOfs   : DIJOFS_BUTTON21;
       dwType  : $80000000 or DIDFT_BUTTON or DIDFT_NOCOLLECTION;
       dwFlags : 0)
  );

  c_dfDIJoystick : TDIDataFormat = (
    dwSize     : Sizeof(c_dfDIJoystick);
    dwObjSize  : Sizeof(TDIObjectDataFormat);  // $10
    dwFlags    : DIDF_ABSAXIS;
    dwDataSize : SizeOf(TDIJoyState);         // $10
    dwNumObjs  : High(_c_dfDIJoystick_Objects) + 1;  // $2C
    rgodf      : @_c_dfDIJoystick_Objects[Low(_c_dfDIJoystick_Objects)]
  );

var  // Set by initialization part -- didn't want to type in another 656 consts...
  _c_dfDIJoystick2_Objects: array[0..$A3] of TDIObjectDataFormat;
  { Elements $00..$2B: exact copy of _c_dfDIJoystick
    Elements $2C..$8B: more "buttons" with nil GUIDs
    remaining elements ($8B..$A2):
     $8C,$8D,$8E: X axis, Y axis, Z axis with dwFlags = $0200
     $8F,$90,$91: rX axis, rY axis, rZ axis with dwFlags = $0200
     $92, $93: Slider with dwFlags = $0200
     --------
     $94,$95,$96: X axis, Y axis, Z axis with dwFlags = $0300
     $97,$98,$99: rX axis, rY axis, rZ axis with dwFlags = $0300
     $9A,$9B: Slider with dwFlags = $0300
     --------
     $9C,$9D,$9E: X axis, Y axis, Z axis with dwFlags = $0400
     $9F, $A0, $A1: rX axis, rY axis, rZ axis with dwFlags = $0400
     $A2, $A3: Slider with dwFlags = $0400
  }
const
  c_dfDIJoystick2 : TDIDataFormat = (
    dwSize     : Sizeof(c_dfDIJoystick2);
    dwObjSize  : Sizeof(TDIObjectDataFormat);
    dwFlags    : DIDF_ABSAXIS;
    dwDataSize : SizeOf(TDIJoyState2);  // $110
    dwNumObjs  : High(_c_dfDIJoystick2_Objects)+1;
    rgodf      : @_c_dfDIJoystick2_Objects[Low(_c_dfDIJoystick2_Objects)]
  );

function DIErrorString(Value : HResult) : string;  
function DIEFT_GETTYPE(n: variant) : byte;
function GET_DIDEVICE_TYPE(dwDevType :  Variant) : Byte;
function GET_DIDEVICE_SUBTYPE(dwDevType : Variant) : Byte;
function DIDFT_MAKEINSTANCE(n: Variant) : LongWord;
function DIDFT_GETTYPE(n: Variant) : Byte;
function DIDFT_GETINSTANCE(n: Variant) : LongWord;
function DIDFT_ENUMCOLLECTION(n: Variant) : LongWord;
function DIMAKEUSAGEDWORD(UsagePage, Usage: Word) : LongWord;
function DIJOFS_SLIDER(n : Variant) : Variant;
function DIJOFS_POV(n : Variant) : Variant;
function DIJOFS_BUTTON(n : Variant) : Variant;
function DIBUTTON_ANY(instance : Variant) : Variant;
function joyConfigChanged(dwFlags : LongWord) : MMRESULT; stdcall;

var

  DirectInput8Create  : function (hinst : THandle; dwVersion : LongWord; const riidltf : TGUID; out ppvOut; punkOuter : IUnknown) : HResult; stdcall;

implementation

uses
  DXCommon;


function DIMAKEUSAGEDWORD(UsagePage, Usage : Word) : LongWord;
begin
  Result := Usage or (UsagePage shl 16);
end;

function DIEFT_GETTYPE(n : Variant) : Byte;
begin
  Result := Byte(n);
end;

function GET_DIDEVICE_TYPE(dwDevType: Variant) : Byte;
begin
  Result := Byte(dwDevType);
end;

function GET_DIDEVICE_SUBTYPE(dwDevType : Variant) : Byte;
begin
  Result := Hi(Word(dwDevType));
end;

function DIDFT_MAKEINSTANCE(n : Variant) : LongWord;
begin
  Result := Word(n) shl 8;
end;

function DIDFT_GETTYPE(n : Variant) : Byte;
begin
  Result := Byte(n);
end;

function DIDFT_GETINSTANCE(n : Variant) : LongWord;
begin
  Result := Word(n) shr 8;
end;

function DIDFT_ENUMCOLLECTION(n : Variant) : LongWord;
begin
  Result := Word(n) shl 8;
end;

function DIJOFS_SLIDER(n : Variant) : Variant;
begin
  Result := n * 4 + 24;
end;

function DIJOFS_POV(n : Variant) : Variant;
begin
  Result := n * 4 + 32;
end;

function DIJOFS_BUTTON(n : Variant) : Variant;
begin
  Result := 48 + n;
end;

function DIBUTTON_ANY(instance : Variant) : Variant;
begin
  Result := $FF004400 or instance;
end;

function DIErrorString(Value: HResult) : String;
begin
  case Value of
    HResult(DI_OK)                        : Result := 'The operation completed successfully.';
    HResult(S_FALSE)                      : Result := '"The operation had no effect." or "The device buffer overflowed and some input was lost." or "The device exists but is not currently attached." or "The change in device properties had no effect."';
//    HResult(DI_BUFFEROVERFLOW)            : Result := 'The device buffer overflowed and some input was lost. This value is equal to the S_FALSE standard COM return value.';
    HResult(DI_DOWNLOADSKIPPED)           : Result := 'The parameters of the effect were successfully updated, but the effect could not be downloaded because the associated device was not acquired in exclusive mode.';
    HResult(DI_EFFECTRESTARTED)           : Result := 'The effect was stopped, the parameters were updated, and the effect was restarted.';
//    HResult(DI_NOEFFECT)                  : Result := 'The operation had no effect. This value is equal to the S_FALSE standard COM return value.';
//    HResult(DI_NOTATTACHED)               : Result := 'The device exists but is not currently attached. This value is equal to the S_FALSE standard COM return value.';
    HResult(DI_POLLEDDEVICE)              : Result := 'The device is a polled device. As a result, device buffering will not collect any data and event notifications will not be signaled until the IDirectInputDevice2::Poll method is called.';
//    HResult(DI_PROPNOEFFECT)              : Result := 'The change in device properties had no effect. This value is equal to the S_FALSE standard COM return value.';
    HResult(DI_SETTINGSNOTSAVED)          : Result := 'The action map was applied to the device, but the settings could not be saved.';
    HResult(DI_TRUNCATED)                 : Result := 'The parameters of the effect were successfully updated, but some of them were beyond the capabilities of the device and were truncated to the nearest supported value.';
    HResult(DI_TRUNCATEDANDRESTARTED)     : Result := 'Equal to DI_EFFECTRESTARTED | DI_TRUNCATED.';
    HResult(DIERR_ACQUIRED)               : Result := 'The operation cannot be performed while the device is acquired.';
    HResult(DIERR_ALREADYINITIALIZED)     : Result := 'This object is already initialized';
    HResult(DIERR_BADDRIVERVER)           : Result := 'The object could not be created due to an incompatible driver version or mismatched or incomplete driver components.';
    HResult(DIERR_BETADIRECTINPUTVERSION) : Result := 'The application was written for an unsupported prerelease version of DirectInput.';
    HResult(DIERR_DEVICEFULL)             : Result := 'The device is full.';
    HResult(DIERR_DEVICENOTREG)           : Result := 'The device or device instance is not registered with DirectInput. This value is equal to the REGDB_E_CLASSNOTREG standard COM return value.';
    HResult(DIERR_EFFECTPLAYING)          : Result := 'The parameters were updated in memory but were not downloaded to the device because the device does not support updating an effect while it is still playing.';
    HResult(DIERR_HASEFFECTS)             : Result := 'The device cannot be reinitialized because there are still effects attached to it.';
    HResult(DIERR_GENERIC)                : Result := 'An undetermined error occurred inside the DirectInput subsystem. This value is equal to the E_FAIL standard COM return value.';
//    HResult(DIERR_HANDLEEXISTS)           : Result := 'The device already has an event notification associated with it. This value is equal to the E_ACCESSDENIED standard COM return value.';
    HResult(DIERR_INCOMPLETEEFFECT)       : Result := 'The effect could not be downloaded because essential information is missing. For example, no axes have been associated with the effect, or no type-specific information has been supplied.';
    HResult(DIERR_INPUTLOST)              : Result := 'Access to the input device has been lost. It must be reacquired.';
    HResult(DIERR_INVALIDPARAM)           : Result := 'An invalid parameter was passed to the returning function, or the object was not in a state that permitted the function to be called. This value is equal to the E_INVALIDARG standard COM return value.';
    HResult(DIERR_MAPFILEFAIL)            : Result := 'An error has occured either reading the vendor-supplied action-mapping file for the device or reading or writing the user configuration mapping file for the device.';
    HResult(DIERR_MOREDATA)               : Result := 'Not all the requested information fitted into the buffer.';
    HResult(DIERR_NOAGGREGATION)          : Result := 'This object does not support aggregation.';
    HResult(DIERR_NOINTERFACE)            : Result := 'The specified interface is not supported by the object. This value is equal to the E_NOINTERFACE standard COM return value.';
    HResult(DIERR_NOTACQUIRED)            : Result := 'The operation cannot be performed unless the device is acquired.';
    HResult(DIERR_NOTBUFFERED)            : Result := 'The device is not buffered. Set the DIPROP_BUFFERSIZE property to enable buffering.';
    HResult(DIERR_NOTDOWNLOADED)          : Result := 'The effect is not downloaded.';
    HResult(DIERR_NOTEXCLUSIVEACQUIRED)   : Result := 'The operation cannot be performed unless the device is acquired in DISCL_EXCLUSIVE mode.';
    HResult(DIERR_NOTFOUND)               : Result := 'The requested object does not exist.';
    HResult(DIERR_NOTINITIALIZED)         : Result := 'This object has not been initialized.';
//    HResult(DIERR_OBJECTNOTFOUND)         : Result := 'The requested object does not exist.';
    HResult(DIERR_OLDDIRECTINPUTVERSION)  : Result := 'The application requires a newer version of DirectInput.';
    HResult(DIERR_OTHERAPPHASPRIO)        : Result := '"The device already has an event notification associated with it." or "The specified property cannot be changed." or "Another application has a higher priority level, preventing this call from succeeding. "';
    HResult(DIERR_OUTOFMEMORY)            : Result := 'The DirectInput subsystem could not allocate sufficient memory to complete the call. This value is equal to the E_OUTOFMEMORY standard COM return value.';
//    HResult(DIERR_READONLY)               : Result := 'The specified property cannot be changed. This value is equal to the E_ACCESSDENIED standard COM return value.';
    HResult(DIERR_UNSUPPORTED)            : Result := 'The function called is not supported at this time. This value is equal to the E_NOTIMPL standard COM return value.';
    HResult(E_PENDING)                    : Result := 'Data is not yet available.';
    HResult(DIERR_REPORTFULL)             : Result := 'More information was requested to be sent than can be sent to the device.';
    HResult(DIERR_UNPLUGGED)              : Result := 'The operation could not be completed because the device is not plugged in.';
    HResult(E_HANDLE)                     : Result := 'The HWND parameter is not a valid top-level window that belongs to the process.';
    HResult(E_Pointer)                    : Result := 'An invalid Pointer, usually NULL, was passed as a parameter.';

    HResult($800405CC)                    : Result := 'No more memory for effects of this kind (not documented)';
    else Result := UnrecognizedError;
  end;
end;

function joyConfigChanged(dwFlags : LongWord) : MMRESULT; external 'WinMM.dll';

procedure Init_c_dfDIKeyboard_Objects;  // XRef: Initialization
var x : Byte;
begin
  for x := 0 to 255 do
  with _c_dfDIKeyboard_Objects[x] do
  begin
    pGuid := @GUID_Key;
    dwOfs := x;
    dwFlags := 0;
    // ? Noch von Erik, woher kommen die $80000000 ?
    dwType := $80000000 or DIDFT_BUTTON or x shl 8;
  end;
end;

procedure Init_c_dfDIJoystick2_Objects;  // XRef: Initialization
var x, y, OfVal : LongWord;
begin
  Move(_c_dfDIJoystick_Objects,_c_dfDIJoystick2_Objects,SizeOf(_c_dfDIJoystick_Objects));
  // all those empty "buttons"
  for x := $2C to $8B do
    Move(_c_dfDIJoystick_Objects[$2B], _c_dfDIJoystick2_Objects[x], SizeOf(TDIObjectDataFormat));
  for x := 0 to 2 do
  begin  // 3 more blocks of X axis..Sliders
    Move(_c_dfDIJoystick_Objects, _c_dfDIJoystick2_Objects[$8C + 8 * x], 8 * SizeOf(TDIObjectDataFormat));
    for y := 0 to 7 do _c_dfDIJoystick2_Objects[$8C + 8 * x + y].dwFlags := (x + 1) shl 8;
  end;
  OfVal := _c_dfDIJoystick2_Objects[$2B].dwOfs + 1;
  for x := $2C to $A3 do
  begin
    _c_dfDIJoystick2_Objects[x].dwOfs := OfVal;
    if x < $8C then Inc(OfVal) else Inc(OfVal, 4);
  end;
end;


initialization
begin
  Init_c_dfDIKeyboard_Objects;  // set kbd GUIDs & flags
  Init_c_dfDIJoystick2_Objects;  // construct Joystick2 from Joystick fmt

  if not IsNTandDelphiRunning then
  begin

    DInput8DLL := LoadLibrary('DInput8.dll');

    if DInput8DLL <> 0 then DirectInput8Create := GetProcAddress(DInput8DLL, 'DirectInput8Create');

  end;
end;


finalization
begin
  FreeLibrary(DInput8DLL);
end;

end.
