% Определение даты рождения
date_of_birth = '2004-01-27';

% Преобразование даты в последовательный номер
date_serial = datenum(date_of_birth);

% Расчет номера задания m
m = mod(date_serial, 50) + 1;
disp(['Номер задания m: ', num2str(m)]);

% Параметры сигнала
duration = 60; % Длительность сигнала, с
fs = 44100; % Частота дискретизации, Гц
t = 0:1/fs:duration; % Временная шкала
N = length(t); % Количество отсчетов

% ---------------------Гармонический сигнал---------------------------
% Формирование гармонического сигнала
harmonic_signal = zeros(size(t));
for k = 1:10
    F_k = ceil(0.95^m * 10^3 * k);
    A_k = 1 - 0.5 * log10(k);
    harmonic_signal = harmonic_signal + A_k * sin(2*pi*F_k*t);
end

% ---------------------Скользящий тон---------------------------
% Параметры скользящего тона
F_start = ceil(abs(cos(m) + sin(50 - m)) * 10^3 * 3);
F_end = 2 * 10^4 - ceil(abs(cos(m) + sin(50 - m)) * 10^3 * 10);

% Определение закона изменения частоты
law = mod(m, 3);
if law == 0 % линейный
  freq_change = linspace(F_start, F_end, N);
elseif law == 1 % логарифмический
  freq_change = logspace(log10(F_start), log10(F_end), N);
else % квадратичный
  freq_change = linspace(sqrt(F_start), sqrt(F_end), N).^2;
end

% Формирование скользящего тона
phase = cumsum(freq_change * 2 * pi / fs);
sweep_signal = sin(phase);
sweep_signal_amp = 1;
sweep_signal = sweep_signal_amp * sweep_signal;

% ---------------------Белый шум---------------------------
% Формирование белого шума
white_noise = randn(size(t));


% ---------------------Чтение из аудиофайла (пример)---------------------------
% Замените 'audio.wav' на путь к вашему аудиофайлу
[audio_signal, audio_fs] = audioread('C:\Users\Root\Desktop\1.wav');
audio_signal = audio_signal(:, 1); % Берем первый канал (моно)
audio_time = (0:length(audio_signal)-1)/audio_fs;


% ---------------------Мгновенный спектр---------------------------
% Параметры БПФ
fft_length = 1024;
window_type = 'hamming';
window = window(window_type, fft_length);


% Расчет мгновенного спектра для гармонического сигнала
t_idx_harmonic = round(length(t) / 2);
harmonic_seg = harmonic_signal((t_idx_harmonic - floor(fft_length/2) + 1) : (t_idx_harmonic + ceil(fft_length/2)));
harmonic_seg_windowed = harmonic_seg.*window';
harmonic_fft = fft(harmonic_seg_windowed,fft_length);
harmonic_freqs = (0:fft_length/2-1) * audio_fs/fft_length;
harmonic_spectrum = abs(harmonic_fft(1:fft_length/2));


% Расчет мгновенного спектра для скользящего тона
t_idx_sweep = [round(length(t) / 2) round(length(t) / 3) round(length(t) * 2 / 3)];
sweep_spectra = cell(1, 3);

for i = 1:3
    sweep_seg = sweep_signal((t_idx_sweep(i) - floor(fft_length/2) + 1) : (t_idx_sweep(i) + ceil(fft_length/2)));
    sweep_seg_windowed = sweep_seg.*window';
    sweep_fft = fft(sweep_seg_windowed,fft_length);
    sweep_spectra{i} = abs(sweep_fft(1:fft_length/2));
end

% Расчет мгновенного спектра для белого шума
t_idx_noise = [round(length(t) / 2) round(length(t) / 3) round(length(t) * 2 / 3)];
noise_spectra = cell(1, 3);
for i = 1:3
    noise_seg = white_noise((t_idx_noise(i) - floor(fft_length/2) + 1) : (t_idx_noise(i) + ceil(fft_length/2)));
    noise_seg_windowed = noise_seg.*window';
    noise_fft = fft(noise_seg_windowed,fft_length);
    noise_spectra{i} = abs(noise_fft(1:fft_length/2));
end

% ---------------------Текущий спектр---------------------------
%Расчет текущего спектра гармонического сигнала
current_harmonic_fft = fft(harmonic_signal,fft_length);
current_harmonic_spectrum = abs(current_harmonic_fft(1:fft_length/2));
current_harmonic_freqs = (0:fft_length/2-1) * audio_fs/fft_length;

% Расчет текущего спектра скользящего тона
current_sweep_fft = fft(sweep_signal, fft_length);
current_sweep_spectrum = abs(current_sweep_fft(1:fft_length/2));

% Расчет текущего спектра белого шума
current_noise_fft = fft(white_noise, fft_length);
current_noise_spectrum = abs(current_noise_fft(1:fft_length/2));

% ---------------------Энергетический спектр---------------------------
% Расчет энергетического спектра гармонического сигнала
energy_harmonic_spectrum = abs(current_harmonic_fft(1:fft_length/2)).^2;

% Расчет энергетического спектра скользящего тона
energy_sweep_spectrum = abs(current_sweep_fft(1:fft_length/2)).^2;

% Расчет энергетического спектра белого шума
energy_noise_spectrum = abs(current_noise_fft(1:fft_length/2)).^2;

% ---------------------Построение графиков---------------------------
% Создание графического окна
figure(1);

% Координатная плоскость 1: Мгновенные спектры
subplot(2, 1, 1);

% Гармонический сигнал
semilogx(harmonic_freqs, harmonic_spectrum, 'LineWidth', 1.5);
hold on;

% Скользящий тон
plot_colors = ['r','g','b'];
for i=1:3
    semilogx(harmonic_freqs, sweep_spectra{i}, 'LineWidth', 1.5, 'Color',plot_colors(i));
end


% Белый шум
for i=1:3
    semilogx(harmonic_freqs, noise_spectra{i}, 'LineWidth', 1.5, 'Color',plot_colors(i));
end
hold off;

title('Мгновенные спектры сигналов');
xlabel('Частота (Гц)');
ylabel('Амплитуда');
grid on;
legend('Гармонический сигнал (T/2)','Скользящий тон (T/2)', 'Скользящий тон (T/3)', 'Скользящий тон (2T/3)', 'Белый шум (T/2)', 'Белый шум (T/3)', 'Белый шум (2T/3)');


% Координатная плоскость 2: Текущий и энергетический спектры
subplot(2, 1, 2);

% Текущий спектр
semilogx(current_harmonic_freqs, current_harmonic_spectrum, 'LineWidth', 1.5);
hold on;
semilogx(current_harmonic_freqs, current_sweep_spectrum, 'LineWidth', 1.5);
semilogx(current_harmonic_freqs, current_noise_spectrum, 'LineWidth', 1.5);

% Энергетический спектр
semilogx(current_harmonic_freqs, energy_harmonic_spectrum, 'LineWidth', 1.5);
semilogx(current_harmonic_freqs, energy_sweep_spectrum, 'LineWidth', 1.5);
semilogx(current_harmonic_freqs, energy_noise_spectrum, 'LineWidth', 1.5);
hold off;

title('Текущий и энергетический спектры сигналов');
xlabel('Частота (Гц)');
ylabel('Амплитуда/Энергия');
grid on;
legend('Текущий гарм.', 'Текущий скользящий', 'Текущий шум', 'Энергия гарм.', 'Энергия скользящего', 'Энергия шум.');


% ---------------- -----Построение спектрограммы---------------------------
figure(2);
[S,F,T,P] = spectrogram(harmonic_signal, window, 0, fft_length, fs, 'yaxis');
subplot(3, 1, 1);
surf(T, F, 10*log10(P), 'edgecolor','none');
axis tight;
view(0,90);
title('Спектрограмма гармонического сигнала');
xlabel('Время (с)');
ylabel('Частота (Гц)');
colorbar;

[S,F,T,P] = spectrogram(sweep_signal, window, 0, fft_length, fs, 'yaxis');
subplot(3, 1, 2);
surf(T, F, 10*log10(P), 'edgecolor','none');
axis tight;
view(0,90);
title('Спектрограмма скользящего тона');
xlabel('Время (с)');
ylabel('Частота (Гц)');
colorbar;

[S,F,T,P] = spectrogram(white_noise, window, 0, fft_length, fs, 'yaxis');
subplot(3, 1, 3);
surf(T, F, 10*log10(P), 'edgecolor','none');
axis tight;
view(0,90);
title('Спектрограмма белого шума');
xlabel('Время (с)');
ylabel('Частота (Гц)');
colorbar;
