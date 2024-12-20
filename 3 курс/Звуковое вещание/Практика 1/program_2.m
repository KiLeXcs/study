% Укажите путь к вашему аудиофайлу
audio_file_path = 'C:\Users\Root\Desktop\Lame 3.98.4\6.wav';

% 1) Чтение аудиофайла
[y, fs] = audioread(audio_file_path);

% 2) Формирование массива отсчетов времени
t = (0:length(y)-1) / fs; % время в секундах

% 3) Построение графиков в разных окнах
% График 1: Зависимость амплитуды сигнала от времени для всей длительности
figure;
plot(t, y);
title('График 1: Зависимость амплитуды сигнала от времени');
xlabel('Время (с)');
ylabel('Амплитуда');
grid on;
axis([0 max(t) min(y) max(y)]); % установим диапазон осей

% График 2: Зависимость амплитуды сигнала от времени для отрывка длительностью 5 секунд
duration_5s = 5; % длительность отрывка в секундах
if length(y) / fs > duration_5s
    t_5s = t(t <= duration_5s);
    y_5s = y(1:length(t_5s));
else
    disp('Сигнал короче 5 секунд.');
    t_5s = t;
    y_5s = y;
end

figure;
plot(t_5s, y_5s);
title('График 2: Зависимость амплитуды сигнала от времени (5 секунд)');
xlabel('Время (с)');
ylabel('Амплитуда');
grid on;
axis([0 duration_5s min(y_5s) max(y_5s)]); % установим диапазон осей

% График 3: Зависимость амплитуды сигнала от отсчетов для отрывка длительностью 5 мс
duration_5ms = 0.005; % длительность отрывка в секундах
if length(y) / fs > duration_5ms
    num_samples_5ms = round(duration_5ms * fs);
    t_5ms = t(1:num_samples_5ms);
    y_5ms = y(1:num_samples_5ms);
else
    disp('Сигнал короче 5 миллисекунд.');
    t_5ms = t;
    y_5ms = y;
end

figure;
stem(t_5ms, y_5ms, 'filled'); % использование функции stem для дискретных отсчетов
title('График 3: Зависимость амплитуды сигнала от отсчетов (5 мс)');
xlabel('Время (с)');
ylabel('Амплитуда');
grid on;
axis([0 duration_5ms min(y_5ms) max(y_5ms)]); % установим диапазон осей

