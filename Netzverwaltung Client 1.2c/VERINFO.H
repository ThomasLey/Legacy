//---------------------------------------------------------------------------
#ifndef verinfoH
#define verinfoH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
//---------------------------------------------------------------------------
class Tvers : public TForm
{
__published:	// Komponenten, die von der IDE verwaltet werden
    TMemo *verMemo;
    TButton *verOK;
    void __fastcall verOKClick(TObject *Sender);
private:	// Benutzerdeklarationen
public:		// Benutzerdeklarationen
    __fastcall Tvers(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE Tvers *vers;
//---------------------------------------------------------------------------
#endif
