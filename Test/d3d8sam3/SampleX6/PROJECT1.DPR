program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  DX8GFX in '..\DX8GFX.PAS',
  D3D8Math in '..\D3D8MATH.PAS',
  LMGen in '..\LMGen.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
