//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USERES("client.res");
USEFORM("clientmain.cpp", mainForm);
USEFORM("verinfo.cpp", vers);
//---------------------------------------------------------------------------
WINAPI WinMain(HINSTANCE, HINSTANCE, LPSTR, int)
{
    try
    {
        Application->Initialize();
        Application->Title = "PC_MAN Client";
        Application->CreateForm(__classid(TmainForm), &mainForm);
        Application->CreateForm(__classid(Tvers), &vers);
        Application->Run();
    }
    catch (Exception &exception)
    {
        Application->ShowException(&exception);
    }
    return 0;
}
//---------------------------------------------------------------------------
