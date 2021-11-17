library CDInfo;

uses
  SysUtils,
  Classes,
  Forms,
  uniCDSelect in 'uniCDSelect.pas' {frmCDSelect},
  uniNewCD in 'uniNewCD.pas' {frmNewCD},
  uniSelectDrive in 'uniSelectDrive.pas' {frmSelDrive};

{$R *.RES}

// Gibt die ID aus der "CDPlayer.ini" zurück
function openCD(Application: TApplication): String; stdcall;
begin
     frmCDSelect := TfrmCDSelect.Create(Application);
     try
        frmCDSelect.ShowModal();
     finally
        result := frmCDSelect.INIContents.Text;
        frmCDSelect.Free;
     end;
end;
// Erstellt eine neue CD in der "CDPlayer.ini"
procedure newCD(Application: TApplication); stdcall;
begin
     frmNewCD := TfrmNewCD.Create(Application);
     try
        frmNewCD.ShowModal();
     finally
        frmNewCD.Free;
     end;
end;
// Gibt einen Laufwerksbuchstaben zurück
function getDrive(Application: TApplication): Char; stdcall;
begin
     frmSelDrive := TfrmSelDrive.Create(Application);
     try
        frmSelDrive.ShowModal();
     finally
        result := frmSelDrive.laufwerk;
        frmSelDrive.Free;
     end;
end;

exports
       openCD,
       newCD,
       getDrive;

begin
end.
