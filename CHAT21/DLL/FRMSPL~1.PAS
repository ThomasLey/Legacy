unit frmSplashForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  TCopyright = class(TForm)
    btnOK: TBitBtn;
    lblfirm: TLabel;
    lblProgramm: TLabel;
    lblVersion: TLabel;
    Shape1: TShape;
    tmrEnde: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

function GetFirm: ShortString; stdcall; external 'csutil21.dll';
function GetVersion: ShortString; stdcall; external 'csutil21.dll';
function GetProgrammer: ShortString; stdcall; external 'csutil21.dll';

var
  Copyright: TCopyright;

implementation

{$R *.DFM}

procedure TCopyright.FormCreate(Sender: TObject);
var circle: HRGN;
begin
     ShowWindow(GetWindow(handle, GW_Owner), SW_Hide);
     circle := CreateEllipticRgn(1, -1, Width - 1, Height);
     SetWindowRgn(handle, circle, true);
     lblFirm.caption := GetFirm;
     lblVersion.caption := GetVersion;
end;

procedure TCopyright.btnOKClick(Sender: TObject);
begin
     Copyright.Hide;
end;

end.
