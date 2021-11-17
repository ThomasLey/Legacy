{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


Author:       François PIETTE
Object:       How to use TSMTPClient
EMail:        francois.piette@ping.be   francois.piette@rtfm.be
WebSite:      http://www.rtfm.be/fpiette
Creation:     09 october 1997
Version:      1.03
Support:      Use twsocket@rtfm.be mailing list. See website for details.
Legal issues: Copyright (C) 1997 by François PIETTE <francois.piette@ping.be>

              This software is provided 'as-is', without any express or
              implied warranty.  In no event will the author be held liable
              for any  damages arising from the use of this software.

              Permission is granted to anyone to use this software for any
              purpose, including commercial applications, and to alter it
              and redistribute it freely, subject to the following
              restrictions:

              1. The origin of this software must not be misrepresented,
                 you must not claim that you wrote the original software.
                 If you use this software in a product, an acknowledgment
                 in the product documentation would be appreciated but is
                 not required.

              2. Altered source versions must be plainly marked as such, and
                 must not be misrepresented as being the original software.

              3. This notice may not be removed or altered from any source
                 distribution.

Updates:
Oct 26, 1997  V1.00 Released
Jan 10, 1998  V1.01 Added a Port property
Feb 15, 1998  V1.02 Added file attachement support
Mar 06, 1998  V1.03 Check for DisplayMemo overflow (100 lines allowed)


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit smtptst1;

interface

uses
  WinTypes, WinProcs, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, SmtpCli, StdCtrls, Wait, ExtCtrls;

const
    SmtpTestVersion = 103;

type
  TSmtpTestForm = class(TForm)
    SmtpClient: TSmtpClient;
    MsgMemo: TMemo;
    DisplayMemo: TMemo;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Subject: TLabel;
    Label4: TLabel;
    Wait1: TWait;
    HostEdit: TEdit;
    FromEdit: TEdit;
    ToEdit: TEdit;
    ConnectButton: TButton;
    MailButton: TButton;
    SubjectEdit: TEdit;
    DisconnectButton: TButton;
    SignOnEdit: TEdit;
    PortEdit: TEdit;
    Label5: TLabel;
    Panel2: TPanel;
    Label6: TLabel;
    FileAttachMemo: TMemo;
    Panel3: TPanel;
    Label7: TLabel;
    ClearDisplayButton: TButton;
    CloseTimer: TTimer;
    procedure ConnectButtonClick(Sender: TObject);
    procedure MailButtonClick(Sender: TObject);
    procedure SmtpClientDisplay(Sender: TObject; Msg: String);
    procedure DisconnectButtonClick(Sender: TObject);
    procedure SmtpClientGetData(Sender: TObject; LineNum: Integer;
      MsgLine: PChar; MaxLen: Integer; var More: Boolean);
    procedure SmtpClientHeaderLine(Sender: TObject; Msg: PChar;
      Size: Integer);
    procedure FormCreate(Sender: TObject);
    procedure ClearDisplayButtonClick(Sender: TObject);
    procedure CloseTimerTimer(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  SmtpTestForm: TSmtpTestForm;
  Dateien: String;
implementation

{$R *.DFM}

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TSmtpTestForm.ConnectButtonClick(Sender: TObject);
begin
    SmtpClient.Host := HostEdit.Text;
    SmtpClient.Port := PortEdit.Text;
    SmtpClient.Connect;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TSmtpTestForm.MailButtonClick(Sender: TObject);
begin
    SmtpClient.RcptName.Clear;
    SmtpClient.RcptName.Add(ToEdit.Text);
    SmtpClient.HdrFrom         := FromEdit.Text;
    SmtpClient.HdrTo           := ToEdit.Text;
    SmtpClient.HdrSubject      := SubjectEdit.Text;
    SmtpClient.SignOn          := SignOnEdit.Text;
    SmtpClient.FromName        := FromEdit.Text;
    SmtpClient.EmailFiles      := FileAttachMemo.Lines;
    SmtpClient.Host            := HostEdit.Text;
    SmtpClient.Port            := PortEdit.Text;
    SmtpClient.Mail;
// Exit this program
    CloseTimer.Enabled := true;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TSmtpTestForm.SmtpClientDisplay(Sender: TObject; Msg: String);
begin
    { Memo boxes are not unlimited...}
    if DisplayMemo.Lines.Count > 100 then
        DisplayMemo.Clear;
    DisplayMemo.Lines.Add(Msg);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TSmtpTestForm.DisconnectButtonClick(Sender: TObject);
begin
    SmtpClient.Quit;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TSmtpTestForm.SmtpClientGetData(
    Sender  : TObject;
    LineNum : Integer;
    MsgLine : PChar;
    MaxLen  : Integer;
    var More: Boolean);
var
    Len : Integer;
begin
    if LineNum > MsgMemo.Lines.count then
        More := FALSE
    else begin
        Len := Length(MsgMemo.Lines[LineNum - 1]);
        { Truncate the line if too long (should wrap to next line) }
        if Len >= MaxLen then
            StrPCopy(MsgLine, Copy(MsgMemo.Lines[LineNum - 1], 1, MaxLen - 1))
        else
            StrPCopy(MsgLine, MsgMemo.Lines[LineNum - 1]);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TSmtpTestForm.SmtpClientHeaderLine(Sender: TObject; Msg: PChar;
  Size: Integer);
begin
    { This demonstrate how to add a line to the message header              }
    { Just detect one of the header lines and add text at the end of this   }
    { line. Use #13#10 to form a new line                                   }
    { Here we check for the From: header line and add a Comments: line      }
    if StrLIComp(Msg, 'From:', 5) = 0 then
        StrCat(Msg, #13#10 + 'Comments: by Garmhausen GmbH');
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TSmtpTestForm.FormCreate(Sender: TObject);
var
   f: textfile;
   Temp: String;
begin
    Dateien := ParamStr(1);
    FileAttachMemo.Clear;
    MsgMemo.Clear;
    DisplayMemo.Clear;
    If not (Dateien = '') then begin
       AssignFile(f, Dateien + '.dat');
       {$i-}Reset(f){$i+};
       If IOResult = 0 then begin
          Readln(f, Temp);
          HostEdit.Text := Temp;
          Readln(f, Temp);
          PortEdit.Text := Temp;
          Readln(f, Temp);
          FromEdit.Text := Temp;
          Readln(f, Temp);
          ToEdit.Text := Temp;
          Readln(f, Temp);
          SubjectEdit.Text := Temp;
       end;
       MsgMemo.Lines.LoadFromFile(Dateien + '.emo');
       FileAttachMemo.Lines.LoadFromFile(Dateien + '.att');
       SmtpTestForm.ConnectButtonClick(SmtpTestForm);
       SmtpTestForm.MailButtonClick(SmtpTestForm);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TSmtpTestForm.ClearDisplayButtonClick(Sender: TObject);
begin
    DisplayMemo.Clear;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

procedure TSmtpTestForm.CloseTimerTimer(Sender: TObject);
begin
     If not (Dateien = '') then begin
        DisplayMemo.Lines.SaveToFile(Dateien + '.log');
     end;
     SmtpTestForm.Close;
end;

end.

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
