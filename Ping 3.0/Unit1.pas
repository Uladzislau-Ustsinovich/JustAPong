unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, jpeg, StdCtrls, Buttons, ComCtrls, ToolWin;

type
  TForm1 = class(TForm)
    Image1: TImage;
    Rock1: TImage;
    Ball: TShape;
    time: TTimer;
    Rock2: TImage;
    Time2: TTimer;
    Timer1: TLabel;
    time3: TTimer;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure timeTimer(Sender: TObject);
    procedure Time2Timer(Sender: TObject);
    procedure time3Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  pop,timer:Integer; //Счётчик очков
  dx, dy,rs1,rs2 : Integer; //dx и dy - скорость шарика, rs1-скорость ракетки


implementation

uses Unit2, Unit4;

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  time.Enabled:=false;
  time2.Enabled:=false;
  Button1.Enabled:=true;
  rs1:=10;
  rs2:=11;
  pop:=1;
  dx := 2;  // Начальная скорость по оси OX
  dy := 2;  // Начальная скорость по оси OY
  form1.DoubleBuffered:=Enabled;   //Плавное перемещение
  form1.KeyPreview := true;     //Подлючение глобальных клавиш для удобного управления
  end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;  //Подключение клавиш для управления ракеткой
  Shift: TShiftState);
  begin
    Case key of            //При нажатии кнопки "NUM_PAD_8" ракетка будет двигаться вверх со скорость 10 п/c
    VK_NUMPAD8:
      begin
       if (Rock1.Top >= 75) then
        Rock1.Top := Rock1.Top - rs1;
        Exit;
      end;
    VK_NUMPAD5:           //При нажатии кнопки "NUM_PAD_5" ракетка будет двигаться вниз со скорость 10 п/c
      begin
       if (Rock1.Top <= 303) then
        Rock1.Top := Rock1.Top  + rs1;
        Exit;
      end;
    end;
end;
procedure TForm1.timeTimer(Sender: TObject); //Основной цикл в котором описывается алгоритм программы
var
  s:string;
  i,button2:Integer;
  b:Boolean;
  button:string;
  F : TextFile;
begin
  b:=False;            // Переменная b будет отвечать за подключение и отключения модуля "Time"
    Ball.left := Ball.Left + dx;
    Ball.Top := Ball.Top + dy;
      Button1.Enabled:=false;
      if Ball.Top <=Image1.Top + 50  then         //Настройка осткока мяча от стенок
        dy :=dy*-1;
      if Ball.Top >=Image1.Top + 334 then
        dy :=dy*-1;
         //Настройка осткока мяча от ракеток
      if ((Ball.left = (Rock2.left - 12)) and ((Ball.top >(Rock2.top-12))) and (Ball.top <(Rock2.top + Rock2.Height+2))) then //Условия для 2 ракетки (правая ракетка)
        dx:= dx * -1; //При достижении мячом координаты равной стороны ракетки - мяч меняет направление по оси OX На противоположное
      if ((Ball.left = (Rock1.left + 11)) and ((Ball.top >(Rock1.top-12))) and (Ball.top <(Rock1.top + Rock1.Height+2))) then  //Условия для 1 ракетки (левая ракетка)
        dx:= dx * -1;
      if (Ball.left <= Rock1.left + 10) and ((Ball.Top = (Rock1.Top + Rock1.Height)) or (Ball.Top = (Rock1.Top-11))) then //Условия для 1 ракетки (левая ракетка)
        dy:= dy * -1;//При достижении мячом координаты равной стороны ракетки - мяч меняет направление по оси OX На противоположное
      if (Ball.left >= Rock2.left - 12) and ((Ball.Top = (Rock2.Top + Rock2.Height)) or (Ball.Top = (Rock2.Top-11))) then //Условия для 2 ракетки (правая ракетка)
          dy:= dy * -1;
       //конец настроек отскока
          If (Ball.left >= Image1.Left + 580) and (Ball.left <= Image1.Left + 605)  then  //Попадание мяча в зону проигрыша 2 игрока
        begin
          time.Enabled:=b;      //При попадании мяча в зону проигрыша модули "Time1" и "Time2" приобретают значение "False", тем самым игра останавливается
          time2.Enabled:=b;
        end;
          If (Ball.left <= Image1.Left + 5) and (Ball.left <= Image1.Left - 10) then //Попадание мяча в зону проигрыша 2 игрока
        begin
          time.Enabled:=b;
          time2.Enabled:=b;
          Button1.Enabled:=true;
          dec(Pop);
        end;
         s:=form4.StringGrid1.Cells[2,6];
         if pop=0 then
       if timer>StrToInt(Form4.StringGrid1.Cells[2,6]) then
          begin
            button := InputBox('Игра окончена', 'Ваш рекорд: '+inttostr(timer), 'Введите ваше имя');
             while length(button) > 10 do
             begin
              button := InputBox('Ошибка', 'Длина имени не может превышать 9 символов', 'Введите ваше имя');
             while button = '' do
              button := InputBox('Ошибка', 'В поле имени не было введено имя', 'Введите ваше имя');
             end;
                Form4.stringgrid1.cells[1,6]:='';
                Form4.stringgrid1.cells[2,6]:='';
                Form4.stringgrid1.cells[1,6]:=button;
                Form4.stringgrid1.cells[2,6]:=inttostr(timer);
                AssignFile(F, 'Scores.txt');
                Rewrite(F);
                For I := 0 to Form4.StringGrid1.RowCount - 1 do
                Writeln(F,Form4.StringGrid1.Cells[1,I] +','+Form4.StringGrid1.Cells[2,I]);
                CloseFile(F);
            If button <> '' then Form1.Close;
            if not (Assigned(Form4)) then
              Form4:=TForm4.Create(self);
                Form4.Show;
          end
       else
        begin
         button2:=MessageDlg('Игра окончена',mtCustom,[mbRetry,mbCancel], 0);
          if button2 = mrCancel then Form1.Close;
          if button2 = mrRetry then Button1.Click;
        end;
  end;

procedure TForm1.Button1Click(Sender: TObject);     //Кнопка Start
begin
  if getasynckeystate(VK_SPACE)<>0 then
    Button1.click;
      Ball.top:=216;
        Ball.Left:=314;
          time.Enabled:=true;
            time2.Enabled:=true;
              Timer:=0;
                time.Interval:=18;
                  rs1:=10;
                    rs2:=11;
                      pop:=1;
end;

procedure TForm1.Time2Timer(Sender: TObject);    //Подключение таймера
begin
Inc(timer);
timer1.Caption:=FloatToStr(timer);
  if (timer = 5) then time.Interval:=15;
  if (timer = 10) then timer1.left:=311;
  if (timer = 15) then time.Interval:=1;
  if (timer = 30) then   rs1:=5;
  if (timer = 45) then   rs1:=3;
  if (timer = 55) then   rs1:=2;
  if (timer = 75) then   rs1:=1;
end;


procedure TForm1.time3Timer(Sender: TObject);
  begin
   if (Rock2.Top> ClientHeight - Rock2.Height - 40) then
    Rock2.Top:=Rock2.Top
   else
    if Ball.Top>Rock2.Top then
      Rock2.Top:=(Ball.Top+Rock2.Width);
    if Ball.Top<Rock2.Top then
      Rock2.Top:=(Ball.Top - Rock2.Width+rs2);
  end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Rock1.Top:=194;
  rs1:=10;
  rs2:=11;
  pop:=1;
  Ball.top:=216;
  Ball.Left:=314;
  Timer:=0;
  Timer1.Caption:='0';
  time.Interval:=18;
  rs1:=10;
  rs2:=11;
  dx := 2;
  dy := 2;
  Button1.Enabled:=true;
  time.Enabled:=false;
  time2.Enabled:=false;
  form2.Visible:=true;
  Form2.show;
end;

end.
