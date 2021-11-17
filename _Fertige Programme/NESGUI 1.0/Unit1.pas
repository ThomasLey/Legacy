unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ShellAPI, ComCtrls, shlObj;


type
  TForm1 = class(TForm)
    Button1: TButton;
    user: TEdit;
    xmessage: TEdit;
    StatusBar1: TStatusBar;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure userKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
var
   mymessage:pchar;
begin
     If not ((xMessage.Text = '') or (user.text = '')) then begin
        mymessage := PCHAR('send ' + user.text + ' ' + xmessage.text);
        ShellExecute(0, 'open', 'c:\winnt\system32\net.exe', mymessage, 'c:\winnt\system32',SW_HIDE);
        xmessage.text := '';
        user.SetFocus();
        user.SelectAll();
     end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
     ShellExecute(0, 'open', 'c:\winnt\system32\net.exe', 'net start nachrichtendienst', 'c:\winnt\system32',SW_HIDE);
end;

function GetFolder(root: Integer; Caption: String): String;
var
   bi:TBrowseInfo;
   lpBuffer: PChar;
   pidlPrograms,
   pidlBrowse: PItemIDList;
begin
     if (not succeeded(shgetspecialfolderlocation(getactivewindow, root, pidlprograms))) then exit;
     lpBuffer := stralloc(max_path);
     bi.hwndOwner := getactivewindow;
     bi.pidlRoot := pidlprograms;
     bi.pszDisplayName := lpbuffer;
     bi.lpszTitle := pChar(caption);
     bi.ulFlags := BIF_BrowseForComputer;
     bi.lpfn := nil;
     bi.lParam := 0;

     pidlbrowse := shbrowseforfolder(bi);
     if (pidlbrowse <> nil) then begin
        result := lpbuffer;
     end else begin
         result := Form1.user.Text;
     end;;
     strdispose(lpbuffer);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
     close();
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
     user.text := GetFolder(csidl_NetWork, 'Folder:');
     xMessage.SetFocus();
     xMessage.SelectAll();
end;

procedure TForm1.userKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     If Key=VK_Return then begin
        Key := VK_Shift;
        xMessage.SetFocus();
        xMessage.SelectAll();
     end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
     Button2Click(Sender);
end;

end.
