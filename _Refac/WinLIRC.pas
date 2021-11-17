unit WinLIRC;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, uLIRCSocket;

type
  TDataReceive = procedure (Sender: TObject; RC, Key: ShortString) of Object;
  TWinLIRC = class(TComponent)
//    FOnDataReceive : TDataReceive;
    FOnDataReceive : TNotifyEvent;
  private
    { Private-Deklarationen }
  protected
    { Protected-Deklarationen }
  public
    procedure showInfobox;
    { Public-Deklarationen }
  published
//    property OnDataReceive: TDataReceive read FOnDataReceive write FOnDataReceive;
    property OnDataReceive: TNotifyEvent read FOnDataReceive write FOnDataReceive;
    { Published-Deklarationen }
  end;

procedure Register;

implementation

procedure TWinLIRC.showInfobox;
begin
     LIRCSocketForm := TLIRCSocketForm.Create(nil);
     try
        LIRCSocketForm.ShowModal;
     finally
        LIRCSocketForm.Free();
     end;
end;



procedure Register;
begin
  RegisterComponents('Neue', [TWinLIRC]);
end;

end.
 