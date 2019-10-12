unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, StdCtrls, Buttons;

type
  TForm2 = class(TForm)
    Image1: TImage;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses Unit1, Unit4;

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
var
L : TStringList;
I:integer;
begin
if not (Assigned(Form1)) then
Form1:=TForm1.Create(self);
Form1.Show;
form2.Visible:=false;
L := TStringList.Create;
    L.LoadFromFile('scores.txt');
    for i:=1 to 6 do
    begin
      Form4.StringGrid1.Cells[1,i] := Copy(L[i],1,Pos(',',L[i])-1);
      Form4.StringGrid1.Cells[2,i] := Copy(L[i],Pos(',',L[i])+1,Length(L[i]));
    end;
   L.Free;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
if not (Assigned(Form4)) then
Form4:=TForm4.Create(self);
Form4.Show;
form2.Visible:=false;
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
close;
end;

end.
