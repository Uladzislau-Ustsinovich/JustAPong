unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, StdCtrls, Grids;

type
  TForm4 = class(TForm)
    Image1: TImage;
    Button1: TButton;
    StringGrid1: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

uses Unit2;

{$R *.dfm}

procedure TForm4.Button1Click(Sender: TObject);
begin
close;
end;

procedure TForm4.FormClose(Sender: TObject; var Action: TCloseAction);
begin
form2.Visible:=true;
Form2.Show;
end;

procedure TForm4.FormActivate(Sender: TObject);
var
  i,j:Integer;
  s:string;
  L : TStringList;
  pr:boolean;
  F : TextFile;
  m:array[1..3] of string;
  begin
    L := TStringList.Create;
    L.LoadFromFile('scores.txt');
    for i:=1 to 6 do
    begin
      StringGrid1.Cells[1,i] := Copy(L[i],1,Pos(',',L[i])-1);
      StringGrid1.Cells[2,i] := Copy(L[i],Pos(',',L[i])+1,Length(L[i]));
    end;
   L.Free;
   repeat
    pr:=true;
    for i:=1 to 5 do
        if StrToInt(StringGrid1.Cells[2,i])<StrToInt(StringGrid1.Cells[2,i+1]) then
           begin
             pr:=false;
              for j:=1 to 3 do
                 m[j]:=StringGrid1.Cells[j-1,i];
             for j:=0 to 2 do
                 begin
                   StringGrid1.Cells[j,i]:=StringGrid1.Cells[j,i+1];
                   StringGrid1.Cells[j,i+1]:=m[j+1];
                 end;
           end;
  until pr;
  StringGrid1.Cells[0,0]:='Место';
  StringGrid1.Cells[1,0]:='Имя';
  StringGrid1.Cells[2,0]:='Время';
    for i:=1 to 6 do
  StringGrid1.Cells[0,i]:=IntToStr(i);
  AssignFile(F, 'Scores.txt');
  Rewrite(F);
  For I := 0 to StringGrid1.RowCount - 1 do
  Begin
    Writeln(F,StringGrid1.Cells[1,I] +','+StringGrid1.Cells[2,I])
  end;
    CloseFile(F);
  end;

end.

