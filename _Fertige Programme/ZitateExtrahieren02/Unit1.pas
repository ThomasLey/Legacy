unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    OpenDialog: TOpenDialog;
    Memo2: TMemo;
    Edit1: TEdit;
    SaveDialog: TSaveDialog;
    procedure Button1Click(Sender: TObject);
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
   i: Integer;
   bneu: Boolean;
begin
     Memo1.Clear();
     Memo2.Clear();
     If OpenDialog.Execute then begin
        bneu := false;
        Memo1.Lines.LoadFromFile(OpenDialog.FileName);

        i := 0;
        While i < Memo1.Lines.Count do begin
            If not (Memo1.Lines[i] = '') then begin
               If not (Copy(Memo1.Lines[i], 1, 5) = '-----') then begin
                  If bneu then begin
                     edit1.text := Memo1.Lines[i];
                     inc(i);
                     bneu := false;
                  end else begin
                      Memo2.Lines.Add(Memo1.Lines[i] + '#' + Edit1.Text);
                  end;
               end else bneu := true;
            end;
            inc(i);
            Application.ProcessMessages();
        end;
        If SaveDialog.Execute then
           Memo2.Lines.SaveToFile(OpenDialog.FileName);
     end;
end;

end.
