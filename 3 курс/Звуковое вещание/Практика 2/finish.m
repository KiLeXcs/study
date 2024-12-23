pkg load signal;

% Импорт аудиофайлов
[signal_4, fs1] = audioread('C:\Users\Root\Desktop\1.wav');
[signal_5, fs2] = audioread('C:\Users\Root\Desktop\2.wav');
[signal_6, fs3] = audioread('C:\Users\Root\Desktop\3.wav');

% Считываем дату рождения и считаем m
disp('Введите вашу дату рождения в формате YYYY-MM-DD:');
user_input = input('', 's');
birth_date = datenum(user_input);
m = mod(birth_date, 50) + 1;
fprintf('Ваш вариант: %d\n', m);

% Параметры
Fs = 48000;          % Частота дискретизации
T = 60;              % Длительность сигнала
t = 0:1/Fs:T-1/Fs;   % Вектор временной оси для сигнала
N = 16384;            % Размер окна
win = hann(N)';   % Параметр окна
M = Fs * T;          % Общее количество отсчетов
L = ceil(M / N);     % Число окон для анализа

% Массивы
frequencies = zeros(1, 10);
amplitudes = zeros(1, 10);

for k = 1:10
    frequencies(k) = k * ceil(0.95^m * 10^3);
    amplitudes(k) = 1 - 0.5 * log10(k);
end

% Создаем сигнал, состоящий из десяти синусоид
signal_1 = zeros(1, length(t));
for i = 1:10
    signal_1 = signal_1 + amplitudes(i) * sin(2 * pi * frequencies(i) * t);
end

% Скользящий тон
f_start = 3 * ceil(abs(cos(m) + sin(50 - m)) * 10^3);
f_stop = 2 * 10^4 - 10 * ceil(abs(cos(m) + sin(50 - m)) * 10^3);
signal_2 = chirp(t, f_start, T, f_stop, 'quadratic');

% белый шум
signal_3 = randn(1, length(t));

% Функция для расчета спектра
function S = computeSpectrum(signal, win, N, L)
    M_L = L * N;
    signal_L = zeros(1, M_L);
    signal_L(1:length(signal)) = signal;
    S = zeros(L, N / 2);
    for l = 1:L
        index = (l - 1) * N + 1;
        viborka = signal_L(index:index + N - 1);
        viborka_win = viborka .* win;
        spectrum = abs(fft(viborka_win, N));
        S(l, :) = spectrum(1:N/2);
    end
end

% Спектры
S_1 = computeSpectrum(signal_1, win, N, L);
S_2 = computeSpectrum(signal_2, win, N, L);
S_3 = computeSpectrum(signal_3, win, N, L);
M2 = length(signal_4);
L2 = ceil(M2 / N);
M2_L = L2 * N;
S_4 = computeSpectrum(signal_4, win, N, L2);
S_5 = computeSpectrum(signal_5, win, N, L2);
S_6 = computeSpectrum(signal_6, win, N, L2);

% Средние спектры
S1_T = mean(S_1, 1);
S2_T = mean(S_2, 1);
S3_T = mean(S_3, 1);
S4_T = mean(S_4, 1);
S5_T = mean(S_5, 1);
S6_T = mean(S_6, 1);

% Энергетические спектры
S1_RMS = sqrt(mean(S_1 .^ 2, 1));
S2_RMS = sqrt(mean(S_2 .^ 2, 1));
S3_RMS = sqrt(mean(S_3 .^ 2, 1));
S4_RMS = sqrt(mean(S_4 .^ 2, 1));
S5_RMS = sqrt(mean(S_5 .^ 2, 1));
S6_RMS = sqrt(mean(S_6 .^ 2, 1));

% Спектры в dBFS
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

% Построение графиков
freq_bins = Fs / N:Fs / N:(N/2 - 1) * (Fs / N);

% Мгновенный спектр
figure;
subplot(2, 1, 1);
hold on;
semilogx(freq_bins, S1_T_dBFS(1:length(freq_bins)), 'DisplayName', 'S1(f)');
semilogx(freq_bins, S2_T_dBFS(1:length(freq_bins)), 'DisplayName', 'S2(f)');
semilogx(freq_bins, S3_T_dBFS(1:length(freq_bins)), 'DisplayName', 'S3(f)');
semilogx(freq_bins, S4_T_dBFS(1:length(freq_bins)), 'DisplayName', 'S4(f)');
semilogx(freq_bins, S5_T_dBFS(1:length(freq_bins)), 'DisplayName', 'S5(f)');
semilogx(freq_bins, S6_T_dBFS(1:length(freq_bins)), 'DisplayName', 'S6(f)');
title('Спектр сигналов');
xlabel('Частота, Гц');
ylabel('Амплитуда (дБ)');
legend show;
grid on;

% Энергетический и текущий спектр
subplot(2, 1, 2);
hold on;
semilogx(S1_RMS_dBFS, 'DisplayName', 'S1_R_M_S(k)');
semilogx(S1_T_dBFS, 'DisplayName', 'S1_T(k)');
semilogx(S2_RMS_dBFS, 'DisplayName', 'S2_R_M_S(k)');
semilogx(S2_T_dBFS, 'DisplayName', 'S2_T(k)');
semilogx(S3_RMS_dBFS, 'DisplayName', 'S3_R_M_S(k)');
semilogx(S3_T_dBFS, 'DisplayName', 'S3_T(k)');
semilogx(S4_RMS_dBFS, 'DisplayName', 'S4_R_M_S(k)');
semilogx(S4_T_dBFS, 'DisplayName', 'S4_T(k)');
semilogx(S5_RMS_dBFS, 'DisplayName', 'S5_R_M_S(k)');
semilogx(S5_T_dBFS, 'DisplayName', 'S5_T(k)');
semilogx(S6_RMS_dBFS, 'DisplayName', 'S6_R_M_S(k)');
semilogx(S6_T_dBFS, 'DisplayName', 'S6_T(k)');
title('Энергетический и текущий спектр (dBFS)');
xlabel('Гармоника, k');
ylabel('Амплитуда (дБ)');
legend('location', 'eastoutside');
grid on;

% Спектрограммы
figure;
specgram(signal_1(1:Fs*20), N, Fs, parzenwin(N), 0);
title('Спектрограмма: 10 синусоид');
colorbar();
figure;
specgram(signal_2(1:Fs*20), N, Fs, parzenwin(N), 0);
title('Спектрограмма: Скользящий тон');
colorbar();
figure;
specgram(signal_3(1:Fs*20), N, Fs, parzenwin(N), 0);
title('Спектрограмма: Белый шум');
colorbar();
figure;
specgram(signal_4(1:Fs*20), N, Fs, parzenwin(N), 0);
title('Спектрограмма: Спокойный речевой сигнал');
colorbar();
figure;
specgram(signal_5(1:Fs*20), N, Fs, parzenwin(N), 0);
title('Спектрограмма: Шёпот');
colorbar();
figure;
specgram(signal_6(1:Fs*20), N, Fs, parzenwin(N), 0);
title('Спектрограмма: Эмоциональный речевой сигнал');
colorbar();

