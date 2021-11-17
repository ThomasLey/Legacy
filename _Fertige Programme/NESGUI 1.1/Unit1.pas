unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ShellAPI, ComCtrls, shlObj, Registry, CoolTrayIcon, Menus;


type
  TForm1 = class(TForm)
    Button1: TButton;
    StatusBar1: TStatusBar;
    Button3: TButton;
    Button4: TButton;
    Label1: TLabel;
    user: TComboBox;
    Label2: TLabel;
    xmessage: TMemo;
    Tray: TCoolTrayIcon;
    Popup: TPopupMenu;
    Beenden1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    Anzeigen1: TMenuItem;
    Button5: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure userKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TrayDblClick(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1          : TForm1;
  canClose       : Boolean;

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
     canClose := true;
     Close();
end;

procedure TForm1.Button4Click(Sender: TObject);
var
   i: Integer;
begin
     user.text := GetFolder(csidl_NetWork, 'Computer:');
     i := 0;
     while i < user.items.count do begin
         if user.items[i] = user.text then user.items.delete(i);
         inc(i);
     end;
     if user.items.Count = 10 then user.items.delete(9);
     user.items.insert(0, user.text);
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
var
   i: Integer;
   reg: TRegistry;
begin
     canClose := false;
     reg := TRegistry.Create;
     reg.RootKey := HKEY_CURRENT_USER;
     if reg.OpenKey('\Software\Thomas Ley\NESGUI\1.1\', true) then
        For i := 0 to 9 do
            If reg.ReadString('pc' + intToStr(i)) <> '' then
               user.items.add(reg.ReadString('pc' + intToStr(i)));
     reg.Free;
     Button2Click(Sender); // Nachrichtendienst Starten
     Tray.Hint := Form1.Caption;
     Application.Title := Form1.Caption;
     Form1.Icon := Tray.Icon;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
   i: Integer;
   reg: TRegistry;
begin
     If canClose then begin
        reg := TRegistry.Create;
        reg.RootKey := HKEY_CURRENT_USER;
        if reg.OpenKey('\Software\Thomas Ley\NESGUI\1.1\', true) then
           For i := 0 to 9 do
               If user.items.Count >= (i + 1) then
                  reg.WriteString('pc' + intToStr(i), user.items[i])
               else
                  reg.WriteString('pc' + intToStr(i), '');
        reg.Free;
        end
     else begin
        hide();  
        abort();
        end;  

end;

procedure TForm1.TrayDblClick(Sender: TObject);
begin
     Form1.Show();
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
     close();
end;

end.
