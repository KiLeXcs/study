%Расчет номера вариант
l=datenum(2004,11,21);
b=mod(l,50);
m=b+1;
%Формирование испытательного сигнал(амплитуда и его частота)
k=1:10;
t=0:60;
Fk=k*floor((0.95)^(m)*10^(3));
Ak=1-(0.5*log10(k));
xk=zeros(size(t)); % Инициализация сигнала
for i=1:length(Fk)
    xk=xk+Ak(i)*sin(2*pi*Fk(i)*t);
end
%Формирование испытательного сигнал скользящего тона
Fstart=3*floor(abs(cos(m)+sin(50-m))*10^(3));
Fend=(2*10^(4))-(10*floor(abs(cos(m)+sin(50-m))*10^(3)));
a=mod(m,3);
t1=60;
r=chirp(t,Fstart,t1,Fend,'quadratic');
%Формирование сигнала белого шума
w=randn(1,length(t));
%Чтение аудиофайлов
[x,Fs]=audioread('C:\Users\Root\Desktop\Lame 3.98.4\6.wav');
%Чтение аудиофайлов
[y,Fs1]=audioread('C:\Users\Root\Desktop\Lame 3.98.4\20.wav');
%Чтение аудиофайлов
[z,Fs2]=audioread('C:\Users\Root\Desktop\Lame 3.98.4\40.wav');
%Длина БПФ
N=16384;
%Формирование массив значений отсчета частоты
f=1:N;
%Быстрое преобразование Фурье
XK=fft(xk,N);
%Выделение амплитуд спектральных составляющих
W=abs(XK/N);
%Расчет набора многвенных спектров испытательного сигнала
WdB=20*log10(W);
%Формирование массива
rec=rectwin(N).';
%Умножение массива
xkrec=rec(length(xk)).*xk;
%Расчет текущего спектра
for j=1:length(t)
  start=1;
  konez=length(t);
  Sl=xkrec(start:konez);
  St=Sl./t;
end
%Расчет энергетического спектра
for o=1:length(t)
  start=1;
  konez=length(t);
  Sl=xkrec(start:konez);
  Srms=sqrt((Sl.^2)./t);
end
%Расчет текущего и энергетического спектра в dBSF
StdBSF=20*log10(St);
SrmsdBFS=20*log10(Srms);
%Быстрое преобразование Фурье
R=fft(r,N);
%Выделение амплитуд спектральных составляющих
W1=abs(R/N);
%Расчет набора многвенных спектров испытательного сигнала
WdB1=20*log10(W1);
%Умножение массива
rrec=rec(length(r)).*r;
%Расчет текущего спектра
for j=1:length(t)
  start=1;
  konez=length(t);
  Sl1=rrec(start:konez);
  St1=Sl1./t;
end
%Расчет энергетического спектра
for o=1:length(t)
  start=1;
  konez=length(t);
  Sl1=rrec(start:konez);
  Srms1=sqrt((Sl1.^2)./t);
end
%Расчет текущего и энергетического спектра в dBSF
StdBSF1=20*log10(St1);
SrmsdBFS1=20*log10(Srms1);
%Быстрое преобразование Фурье
Wb=fft(w,N);
%Выделение амплитуд спектральных составляющих
W2=abs(Wb/N);
%Расчет набора многвенных спектров испытательного сигнала
WdB2=20*log10(W2);
%Умножение массива
wrec=rec(length(w)).*w;
%Расчет текущего спектра
for j=1:length(t)
  start=1;
  konez=length(t);
  Sl2=wrec(start:konez);
  St2=Sl2./t;
end
%Расчет энергетического спектра
for o=1:length(t)
  start=1;
  konez=length(t);
  Sl2=wrec(start:konez);
  Srms2=sqrt((Sl2.^2)./t);
end
%Расчет текущего и энергетического спектра в dBSF
StdBSF2=20*log10(St2);
SrmsdBFS2=20*log10(Srms2);
%Вычисление БПФ для входного сигнала
X=fft(x,N).';
%Выделение амплитуд спектральных составляющих
W3=abs(X/N);
%Расчет набора многвенных спектров испытательного сигнала
WdB3=20*log10(W3);
%Умножение массива
xrec=rec(length(t)).*x.';
%Расчет текущего спектра
for j=1:length(t)
  start=1;
  konez=length(t);
  Sl3=xrec(start:konez);
  St3=Sl3./t;
end
%Расчет энергетического спектра
for o=1:length(t)
  start=1;
  konez=length(t);
  Sl3=xrec(start:konez);
  Srms3=sqrt((Sl3.^2)./t);
end
%Расчет текущего и энергетического спектра в dBSF
StdBSF3=20*log10(St3);
SrmsdBFS3=20*log10(Srms3);
%Вычисление БПФ для входного сигнала
Y=fft(y,N).';
%Выделение амплитуд спектральных составляющих
W4=abs(Y/N);
%Расчет набора многвенных спектров испытательного сигнала
WdB4=20*log10(W4);
%Умножение массива
yrec=rec(length(t)).*y.';
%Расчет текущего спектра
for j=1:length(t)
  start=1;
  konez=length(t);
  Sl4=yrec(start:konez);
  St4=Sl4./t;
end
%Расчет энергетического спектра
for o=1:length(t)
  start=1;
  konez=length(t);
  Sl4=yrec(start:konez);
  Srms4=sqrt((Sl4.^2)./t);
end
%Расчет текущего и энергетического спектра в dBSF
StdBSF4=20*log10(St4);
SrmsdBFS4=20*log10(Srms4);
%Вычисление БПФ для входного сигнала
Z=fft(z,N).';
%Выделение амплитуд спектральных составляющих
W5=abs(Z/N);
%Расчет набора многвенных спектров испытательного сигнала
WdB5=20*log10(W5);
%Умножение массива
zrec=rec(length(t)).*z.';
%Расчет текущего спектра
for j=1:length(t)
  start=1;
  konez=length(t);
  Sl5=zrec(start:konez);
  St5=Sl5./t;
end
%Расчет энергетического спектра
for o=1:length(t)
  start=1;
  konezkas=length(t);
  Sl5=zrec(start:konez);
  Srms5=sqrt((Sl5.^2)./t);
end
%Расчет текущего и энергетического спектра в dBSF
StdBSF5=20*log10(St5);
SrmsdBFS5=20*log10(Srms5);
%Сформирование графическое окно и координатные оси
figure
hold on
%Построение графиков мгновенных спектров исптытательного сигнала
subplot(3,1,1)
semilogx(t,xkrec,"k",t,rrec,"m",t,wrec,"c",t,xrec(1:61),"r",t,yrec(1:61),"g",t,zrec(1:61),"b");
title("Мгновенные спектры испытательного сигнала")
%axis([10^(0) 10^(2.3) -300 0])
xlabel("Частота")
ylabel("Амплитуда")
legend('испытательный сигнал','сигнал скользящего тона','белый шум','спокойный голос','шепот','эмоциональный голос')
grid on
%Построение графиков текущих спектров сигналов
subplot(3,1,2)
semilogx(t,StdBSF,t,StdBSF1,t,StdBSF2);
title("Текущие спектры сигналов")
xlabel("Частота")
ylabel("Амплитуда")
legend('Испытательный сигнал','Скользящий тон','белый шум')
grid on
%Построение графиков энергетических спектров сигналов
subplot(3,1,3)
semilogx(t,SrmsdBFS,t,SrmsdBFS1,t,SrmsdBFS2);
title("Энергетические спектры сигналов")
xlabel("Частота")
ylabel("Амплитуда")
legend('Испытательный сигнал','Скользящий тон','Белый шум')
grid on
%Сформирование графическое окно и координатные оси
figure
hold on
%Спектрограмма звукового сигнала
subplot(3,1,1)
specgram(xrec,N)
title("Спектрограмма звукового сигнала со спокойным голосом")
colormap;
colorbar;
xlabel("Массив, содержащий отсчеты синусодального сигнала")
ylabel("Длина БПФ")
grid on
subplot(3,1,2)
specgram(yrec,N)
title("Спектрограмма звукового сигнала с шепотом")
colormap;
colorbar;
xlabel("Массив, содержащий отсчеты синусодального сигнала")
ylabel("Длина БПФ")
grid on
subplot(3,1,3)
specgram(zrec,N)
title("Спектрограмма звукового сигнала с эмоциональным голосом")
colormap;
colorbar;
xlabel("Массив, содержащий отсчеты синусодального сигнала")
ylabel("Длина БПФ")
grid on
