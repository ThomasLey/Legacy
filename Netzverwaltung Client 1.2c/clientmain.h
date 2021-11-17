//---------------------------------------------------------------------------
#ifndef clientmainH
#define clientmainH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <ExtCtrls.hpp>
#include <ScktComp.hpp>
#include <Psock.hpp>
#include "Decode.h"

//---------------------------------------------------------------------------
class TmainForm : public TForm
{
__published:	// Komponenten, die von der IDE verwaltet werden
    TClientSocket *Client;
    TDecode *Decode1;
    TLabel *Label1;void __fastcall ClientConnect(TObject *Sender,
          TCustomWinSocket *Socket);
    void __fastcall ClientDisconnect(TObject *Sender,
          TCustomWinSocket *Socket);
    void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
    void __fastcall FormCreate(TObject *Sender);
    
    
    
    void __fastcall FormCloseQuery(TObject *Sender, bool &CanClose);
    void __fastcall ClientRead(TObject *Sender, TCustomWinSocket *Socket);
    
    
    
    
    
private:	// Benutzerdeklarationen
public:		// Benutzerdeklarationen
    __fastcall TmainForm(TComponent* Owner);
    void __fastcall WMQueryEndSession(TWMQueryEndSession& msg);
    BEGIN_MESSAGE_MAP
    MESSAGE_HANDLER(WM_QUERYENDSESSION,TWMQueryEndSession,WMQueryEndSession)
    END_MESSAGE_MAP(TForm)



};
//---------------------------------------------------------------------------
extern PACKAGE TmainForm *mainForm;
//---------------------------------------------------------------------------
#endif
