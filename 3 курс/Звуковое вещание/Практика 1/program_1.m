audio_file_path = 'C:\Users\Root\Desktop\2.wav';

[y, fs] = audioread(audio_file_path);

t = (0:length(y)-1) / fs;

figure;
plot(t, y);
title('График 1: Зависимость амплитуды сигнала от времени');
xlabel('Время (с)');
ylabel('Амплитуда');
grid on;
axis([0 max(t) min(y) max(y)]);

duration_5s = 5;
length(y) / fs > duration_5s
 t_5s = t(t <= duration_5s);
 y_5s = y(1:length(t_5s));

figure;
plot(t_5s, y_5s);
title('График 2: Зависимость амплитуды сигнала от времени (5 секунд)');
xlabel('Время (с)');
ylabel('Амплитуда');
grid on;
axis([0 duration_5s min(y_5s) max(y_5s)]);


duration_5ms = 0.005;
length(y) / fs > duration_5ms
num_samples_5ms = round(duration_5ms * fs);
t_5ms = t(1:num_samples_5ms);
y_5ms = y(1:num_samples_5ms);

figure;
stem(t_5ms, y_5ms, 'filled');
title('График 3: Зависимость амплитуды сигнала от отсчетов (5 мс)');
xlabel('Время (с)');
ylabel('Амплитуда');
grid on;
axis([0 duration_5ms min(y_5ms) max(y_5ms)]);

