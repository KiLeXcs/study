% 1. Задание даты рождения
dob = '2004-11-21'; % Замените на вашу дату рождения в формате ГГГГ-ММ-ДД

% 2. Преобразование даты рождения в последовательный номер даты
date_vector = datevec(dob); % Преобразуем дату в вектор [Год, Месяц, День]
serial_date_number = datenum(date_vector); % Преобразуем в последовательный номер даты

% 3. Расчет номера задания m
m = mod(serial_date_number, 50) + 1;

% 4. Формирование испытательного сигнала длительностью 60 секунд
fs = 48000; % Частота дискретизации
T = 60; % Длительность сигнала
t = 0:1/fs:T-1/fs; % Временной вектор

signal = zeros(size(t)); % Инициализация сигнала

for k = 1:10
    F_k = ceil(k * (0.95^m * 10^3)); % Частота
    A_k = 1 - 0.5 * log10(k); % Амплитуда
    signal = signal + A_k * sin(2 * pi * F_k * t); % Формирование сигнала
end

% 5. Формирование сигнала скользящего тона
F_start = ceil(3 * abs(cos(m + sin(50 - m)) * 10^3)); % Начальная частота
F_end = ceil(2 * 10^4 - 10 * abs(cos(m + sin(50 - m)) * 10^3)); % Конечная частота

% Способ изменения частоты
if mod(m, 3) == 0
    freq_change = linspace(F_start, F_end, length(t)); % Линейный
elseif mod(m, 3) == 1
    freq_change = logspace(log10(F_start), log10(F_end), length(t)); % Логарифмический
else
    freq_change = F_start + ((0:(length(t)-1)).^2 * ((F_end - F_start) / (length(t)-1))); % Квадратичный
end

% Формирование сигнала скользящего тона
sweep_signal = sin(2 * pi * cumtrapz(freq_change) / fs);

% 6. Генерация белого шума
white_noise = randn(size(t));

% 7. Чтение аудиофайла
[audio_signal_1, audio_fs_1] = audioread('C:\Users\Root\Desktop\1.wav'); % Замените на путь к файлу
[audio_signal_2, audio_fs_2] = audioread('C:\Users\Root\Desktop\1.wav'); % Замените на путь к файлу
[audio_signal_3, audio_fs_3] = audioread('C:\Users\Root\Desktop\1.wav'); % Замените на путь к файлу



n = 256;
Fs = 48000;
% Выбор окна
window = hann(n);
% Длина БПФ




% Вычисление и построение спектрограммы
[s, f, t] = specgram(audio_signal_1, n, Fs, window, 0);

% Построение спектрограммы
imagesc(t, f, 10*log10(abs(s))); % Логарифм амплитуды
axis xy;
xlabel('Время (с)');
ylabel('Частота (Гц)');
title('Спектрограмма');
colorbar;







