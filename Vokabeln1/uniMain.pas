unit uniMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, ADODB, StdCtrls, ExtCtrls, DBCtrls, Grids, DBGrids, Menus,
  CoolTrayIcon, ImgList, Registry;

const cString1 = 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=';  // Connectionstring Teil1
      cString2 = ';Mode=ReadWrite;Persist Security Info=False';    // Connectionstring Teil2

type
  TfrmMain = class(TForm)
    ADOTable: TADOTable;
    ADOConnection: TADOConnection;
    TableList: TListBox;
    TableGrid: TDBGrid;
    DBNavigator: TDBNavigator;
    DataSource: TDataSource;
    MainMenu1: TMainMenu;
    Datei1: TMenuItem;
    ffnen1: TMenuItem;
    OpenDialog: TOpenDialog;
    TrayIcon: TCoolTrayIcon;
    Beenden1: TMenuItem;
    btnHide: TButton;
    PopupTray: TPopupMenu;
    neueVokabel1: TMenuItem;
    N2: TMenuItem;
    ffnen2: TMenuItem;
    IconList: TImageList;
    N3: TMenuItem;
    Beenden2: TMenuItem;
    Schlieen1: TMenuItem;
    beiLEOnachschlagen1: TMenuItem;
    Button1: TButton;
    Button2: TButton;
    Neu1: TMenuItem;
    N1: TMenuItem;
    Schlieen2: TMenuItem;
    ppmTabellen: TPopupMenu;
    Umbenennen1: TMenuItem;
    Tabellelschen1: TMenuItem;
    Tabellelschen2: TMenuItem;
    procedure ffnen1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TableListDblClick(Sender: TObject);
    procedure btnHideClick(Sender: TObject);
    procedure ffnen2Click(Sender: TObject);
    procedure neueVokabel1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Beenden2Click(Sender: TObject);
    procedure beiLEOnachschlagen1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Schlieen2Click(Sender: TObject);
    procedure Neu1Click(Sender: TObject);
    procedure Tabellelschen1Click(Sender: TObject);
    procedure Umbenennen1Click(Sender: TObject);
    procedure Tabellelschen2Click(Sender: TObject);
  private
    reg      :    TRegistry;
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frmMain: TfrmMain;

implementation

uses uniAddEntry, uniSearchLEO, uniDatabaseFunctions;

{$R *.DFM}

procedure connectDatabase(conString: String);
begin
  with frmMain do begin
     ADOConnection.Connected := false;
     ADOTable.Active := false;
     ADOConnection.ConnectionString := conString;
     ADOTable.ConnectionString := conString;
     ADOConnection.Connected := true;
     ADOConnection.GetTableNames(TableList.Items, false);
     IconList.GetIcon(1, frmMain.Icon);
     TableList.Visible := true;
     Caption := Application.Title + ' - ' + OpenDialog.FileName;
  end;
end;

procedure showTable(stable: String);
begin
  with frmMain do begin
     ADOTable.Active := false;
     ADOTable.TableName := stable;
     IconList.GetIcon(2, frmMain.Icon);
     ADOTable.Active := true;
     TableList.Visible := true;
     TableGrid.Visible := true;
     DBNavigator.Visible := true;
     Caption := Application.Title + ' - ' + OpenDialog.FileName + '#' + stable;
  end;
end;

procedure unshowTable();
begin
  with frmMain do begin
     ADOTable.Active := false;
     TableGrid.Visible := false;
     DBNavigator.Visible := false;
     Caption := Application.Title + ' - ' + OpenDialog.FileName;
  end;
end;

procedure disconnectDatabase();
begin
  with frmMain do begin
     ADOTable.Active := false;
     ADOConnection.Connected := false;
     IconList.GetIcon(0, frmMain.Icon);
     TableGrid.Visible := false;
     TableList.Visible := false;
     DBNavigator.Visible := false;
     Caption := Application.title;
  end;
end;

procedure TfrmMain.ffnen1Click(Sender: TObject);
begin
     If OpenDialog.Execute then begin
        connectDatabase(cString1 + OpenDialog.FileName + cString2);
     end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
   mdbTable  : String;
begin
     IconList.GetIcon(0, frmMain.Icon);
     reg := TRegistry.Create;
     reg.RootKey := HKEY_CURRENT_USER;
     if reg.OpenKey('\Software\Thomas Ley\vokabeln\0.1\', false) then begin
        OpenDialog.FileName := reg.ReadString('Datenbank');
        mdbTable  := reg.ReadString('Tabelle');

        connectDatabase(cString1 + OpenDialog.FileName + cString2);
        showTable(mdbTable);
     end else begin // keine Standartdatenbank
     end;
     OpenDialog.InitialDir := ExtractFileDir(ParamStr(0));
end;

procedure TfrmMain.TableListDblClick(Sender: TObject);
begin
     showTable(TableList.Items[TableList.ItemIndex]);
end;

procedure TfrmMain.btnHideClick(Sender: TObject);
begin
     frmMain.hide();
end;

procedure TfrmMain.ffnen2Click(Sender: TObject);
begin
     frmMain.show();
end;

procedure TfrmMain.neueVokabel1Click(Sender: TObject);
begin
     frmAddEntry.Show();
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     reg.Free;
     ADOTable.Active := false;
     ADOConnection.Connected := false;
end;

procedure TfrmMain.Beenden2Click(Sender: TObject);
begin
     close();
end;

procedure TfrmMain.beiLEOnachschlagen1Click(Sender: TObject);
begin
     frmSearch.show();
end;

procedure TfrmMain.Button1Click(Sender: TObject);
begin
     reg.RootKey := HKEY_CURRENT_USER;
     reg.OpenKey('\Software\Thomas Ley\vokabeln\0.1\', true);
     reg.WriteString('Datenbank', OpenDialog.FileName);
     reg.WriteString('Tabelle', ADOTable.TableName);
end;

procedure TfrmMain.Button2Click(Sender: TObject);
begin
     reg.RootKey := HKEY_CURRENT_USER;
     reg.DeleteKey('\Software\Thomas Ley\vokabeln\0.1\');
end;

procedure TfrmMain.Schlieen2Click(Sender: TObject);
begin
     disconnectDatabase();
end;

procedure TfrmMain.Neu1Click(Sender: TObject);
var
   sName      : String;
begin
     sName := InputBox('Geben Sie einen Tabellennamen an', 'Tabelle erstellen...', '');
     if sname = '' then exit;
     if createTable(ADOConnection, sname) then begin
        ADOConnection.GetTableNames(frmMain.TableList.Items, false);
     end;
end;

procedure TfrmMain.Tabellelschen1Click(Sender: TObject);
var
   sName      : String;
begin
     sName := InputBox('Geben Sie einen Tabellennamen an', 'Tabelle löschen...', '');
     if sname = '' then exit;
     if dropTable(ADOConnection, sname) then begin
        ADOConnection.GetTableNames(frmMain.TableList.Items, false);
     end;
end;

procedure TfrmMain.Umbenennen1Click(Sender: TObject);
var
   sName, dname      : String;
begin
     if TableList.ItemIndex < 0 then abort;
     sName := TableList.Items[TableList.ItemIndex];
     dName := InputBox('Geben Sie den Zieltabellennamen an', 'Tabelle umbenennen...', '');
     if sname = '' then exit;
     if renameTable(ADOConnection, sname, dname) then begin
        ADOConnection.GetTableNames(frmMain.TableList.Items, false);
     end;
end;

procedure TfrmMain.Tabellelschen2Click(Sender: TObject);
begin
     dropTable(ADOConnection, TableList.Items[TableList.ItemIndex]);
end;

end.
