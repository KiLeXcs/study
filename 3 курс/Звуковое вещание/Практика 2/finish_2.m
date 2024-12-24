pkg load signal;

% Установка шрифта и его размера ГОСТ для графиков
set(0, "defaultaxesfontsize", 14);
set(0, "defaultaxesfontname", "Times New Roman");
set(0, "defaultlinelinewidth", 1);

% 1) Расчет варианта задания
date = datenum([2004 11 21]);
m = mod(date, 50) + 1;

% Частота дискретизации
Fs = 48000;
% Длительность сигнала
T = 60;
% Последовательность отсчетов времени
t = 0:1/Fs:T-1/Fs;

% 2) Формирование амплитуд и частот синусоидальных составляющих
Fk = zeros(1, 10);
Ak = zeros(1, 10);
for k = 1:10
    Fk(k) = k * ceil(0.95^m * 10^3);
    Ak(k) = 1 - 0.5 * log10(k);
end

% Создание сигнала из 10 синусоидальных составляющих
x = zeros(10, length(t));
for i = 1:10
    x(i, :) = Ak(i) * sin(2 * pi * Fk(i) * t);
end
signal_1 = sum(x);

% 3) Начальное и конечное частоты скользящего тона
f_start = 3 * ceil(abs(cos(m) + sin(50 - m)) * 10^3);
f_stop = 2 * 10^4 - 10 * ceil(abs(cos(m) + sin(50 - m)) * 10^3);
% Создание сигнала скользящего тона
signal_2 = chirp(t, f_start, T, f_stop, 'quadratic');

% 4) Формирование белого шума
signal_3 = randn(1, length(t));

% 5) Чтение значений отсчетов и частоты дискретизации из аудиофайлов
[signal_4, fs1] = audioread('C:\Users\Root\Desktop\1.wav');
[signal_5, fs2] = audioread('C:\Users\Root\Desktop\2.wav');
[signal_6, fs3] = audioread('C:\Users\Root\Desktop\3.wav');

% 6) Расчет мгновенных спектров
N = 16384; % Размер окна
win = hann(N)'; % Прямоугольное окно
M = Fs * T;
L = ceil(M / N);
M_L = L * N;

% Функция для расчета спектра
function S = calculateSpectrum(signal, N, win)
    M = length(signal);
    L = ceil(M / N);
    S = zeros(L, N / 2);

    for l = 1:L
        index = (l - 1) * N + 1;
        if index + N - 1 <= M % Проверка на выход за пределы
            viborka = signal(index:index + N - 1);
            viborka_win = viborka .* win;
            spectrum = abs(fft(viborka_win, N));
            S(l, :) = spectrum(1:N/2);
        end
    end
end

% Расчет спектров для сигналов
S_1 = calculateSpectrum(signal_1, N, win);
S_2 = calculateSpectrum(signal_2, N, win);
S_3 = calculateSpectrum(signal_3, N, win);
S_4 = calculateSpectrum(signal_4, N, win);
S_5 = calculateSpectrum(signal_5, N, win);
S_6 = calculateSpectrum(signal_6, N, win);

% 7) Расчет текущего спектра
S1_T = mean(S_1, 1);
S2_T = mean(S_2, 1);
S3_T = mean(S_3, 1);
S4_T = mean(S_4, 1);
S5_T = mean(S_5, 1);
S6_T = mean(S_6, 1);

% 8) Расчет энергетического спектра
S1_RMS = sqrt(mean(S_1 .^ 2, 1));
S2_RMS = sqrt(mean(S_2 .^ 2, 1));
S3_RMS = sqrt(mean(S_3 .^ 2, 1));
S4_RMS = sqrt(mean(S_4 .^ 2, 1));
S5_RMS = sqrt(mean(S_5 .^ 2, 1));
S6_RMS = sqrt(mean(S_6 .^ 2, 1));

% Расчет значений амплитуд спектральных составляющих в dBFS
S1_T_dBFS = 20 * log10(S1_T);
S1_RMS_dBFS = 20 * log10(S1_RMS);
S2_T_dBFS = 20 * log10(S2_T);
S2_RMS_dBFS = 20 * log10(S2_RMS);
S3_T_dBFS = 20 * log10(S3_T);
S3_RMS_dBFS = 20 * log10(S3_RMS);
S4_T_dBFS = 20 * log10(S4_T);
S4_RMS_dBFS = 20 * log10(S4_RMS);
S5_T_dBFS = 20 * log10(S5_T);
S5_RMS_dBFS = 20 * log10(S5_RMS);
S6_T_dBFS = 20 * log10(S6_T);
S6_RMS_dBFS = 20 * log10(S6_RMS);

% 9) Построение графиков
% Расчет значений амплитуд спектральных составляющих в dBFS
t_target = [30, 20, 30, 2 * 40/3, 2 * 40/3, 2 * 40/3]; % Временные точки для фреймов
spectra_dBFS = cell(1, 6);

for i = 1:6
    frame_index = floor(t_target(i) * Fs / N) + 1;
    start_idx = (frame_index - 1) * N + 1;
    end_idx = start_idx + N - 1;

    if i == 1
        frame = signal_1(start_idx:end_idx);
    elseif i == 2
        frame = signal_2(start_idx:end_idx);
    elseif i == 3
        frame = signal_3(start_idx:end_idx);
    elseif i == 4
        frame = signal_4(start_idx:end_idx);
    elseif i == 5
        frame = signal_5(start_idx:end_idx);
    elseif i == 6
        frame = signal_6(start_idx:end_idx);
    end

    spectrum = abs(fft(frame, N));
    spectrum_dBFS = 20 * log10(spectrum(1:N/2));
    spectra_dBFS{i} = spectrum_dBFS;
end

% Формирование массива значений отсчета частоты
f_bpf = Fs/N:Fs/N:(N/2-1)*(Fs/N);

% Графики мгновенного спектра
figure;
subplot(2, 1, 1);
hold on;
for i = 1:6
    semilogx(f_bpf, spectra_dBFS{i}(1:length(f_bpf)), 'DisplayName', ['S', num2str(i)]);
end
title('Cпектр');
xlabel('Частота, Гц');
ylabel('Амплитуда (дБ)');
legend show;
grid on;

% Графики энергетического и текущего спектра
subplot(2, 1, 2);
hold on;
semilogx(S1_RMS_dBFS, 'DisplayName', 'S1_RMS');
semilogx(S1_T_dBFS, 'DisplayName', 'S1_T');
semilogx(S2_RMS_dBFS, 'DisplayName', 'S2_RMS');
semilogx(S2_T_dBFS, 'DisplayName', 'S2_T');
semilogx(S3_RMS_dBFS, 'DisplayName', 'S3_RMS');
semilogx(S3_T_dBFS, 'DisplayName', 'S3_T');
semilogx(S4_RMS_dBFS, 'DisplayName', 'S4_RMS');
semilogx(S4_T_dBFS, 'DisplayName', 'S4_T');
semilogx(S5_RMS_dBFS, 'DisplayName', 'S5_RMS');
semilogx(S5_T_dBFS, 'DisplayName', 'S5_T');
semilogx(S6_RMS_dBFS, 'DisplayName', 'S6_RMS');
semilogx(S6_T_dBFS, 'DisplayName', 'S6_T');
title('Энергетический и текущий спектр (dBFS)');
xlabel('Гармоника, k');
ylabel('Амплитуда (дБ)');
legend show;
grid on;

% 10) Построение спектрограмм
figure;
specgram(signal_1(1:Fs*20), N, Fs, rectwin(N), 0);
title('Спектрограмма для сигнала из 10 синусоидальных составляющих');
colorbar();

figure;
specgram(signal_2(1:Fs*20), N, Fs, rectwin(N), 0);
title('Спектрограмма для сигнала скользящего тона');
colorbar();

figure;
specgram(signal_3(1:Fs*20), N, Fs, rectwin(N), 0);
title('Спектрограмма для сигнала белого шума');
colorbar();

figure;
specgram(signal_4(1:Fs*20), N, Fs, rectwin(N), 0);
title('Спектрограмма для спокойного речевого сигнала');
colorbar();

figure;
specgram(signal_5(1:Fs*20), N, Fs, rectwin(N), 0);
title('Спектрограмма для сигнала шепота');
colorbar();

figure;
specgram(signal_6(1:Fs*20), N, Fs, rectwin(N), 0);
title('Спектрограмма для эмоционального речевого сигнала');
colorbar();

printf("gg");

