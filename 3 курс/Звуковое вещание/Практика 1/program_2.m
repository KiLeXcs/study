[audio_signal, fs] = audioread('C:\Users\Root\Desktop\3.wav');

duration_avg_sec = 1;
n_samples_avg = duration_avg_sec * fs;
n_intervals = floor(length(audio_signal) / n_samples_avg);

truncated_signal = audio_signal(1:n_intervals * n_samples_avg);

rms_values = zeros(n_intervals, 1);
for i = 1:n_intervals
    segment = truncated_signal((i-1)*n_samples_avg + 1 : i*n_samples_avg);
    rms_values(i) = sqrt(mean(segment.^2));
end

max_rms = max(rms_values);
min_rms = min(rms_values);
avg_rms = mean(rms_values);
dynamic_range = max_rms - min_rms;
peak_factor = max_rms - avg_rms;

time_samples = (0:n_intervals-1) * duration_avg_sec;

disp('Расчетные данные:');
disp(['Максимальный среднеквадратический уровень: ', num2str(max_rms)]);
disp(['Минимальный среднеквадратический уровень: ', num2str(min_rms)]);
disp(['Средний среднеквадратический уровень: ', num2str(avg_rms)]);
disp(['Динамический диапазон (дБ): ', num2str(dynamic_range)]);
disp(['Пик-фактор: ', num2str(peak_factor)]);

figure(1);
plot(time_samples, rms_values);
title('Зависимость среднеквадратического уровня сигнала от времени');
xlabel('Время (с)');
ylabel('Среднеквадратический уровень');
grid on;
hold on;

plot([time_samples(1), time_samples(end)], [avg_rms, avg_rms], 'r--', 'DisplayName', 'Среднее значение');
plot([time_samples(1), time_samples(end)], [max_rms, max_rms], 'g--', 'DisplayName', 'Максимальное значение');
plot([time_samples(1), time_samples(end)], [min_rms, min_rms], 'b--', 'DisplayName', 'Минимальное значение');
legend show;
hold off;

if n_intervals * duration_avg_sec > 5
    fragment_time = 5;
    fragment_intervals = floor(fragment_time / duration_avg_sec);
    fragment_rms_values = rms_values(1:fragment_intervals);
    fragment_time_samples = (0:fragment_intervals-1) * duration_avg_sec;

    figure(2);
    plot(fragment_time_samples, fragment_rms_values);
    title('Зависимость среднеквадратического уровня (5 секунд)');
    xlabel('Время (с)');
    ylabel('Среднеквадратический уровень');
    grid on;
    hold on;

    plot([fragment_time_samples(1), fragment_time_samples(end)], [avg_rms, avg_rms], 'r--', 'DisplayName', 'Среднее значение');
    plot([fragment_time_samples(1), fragment_time_samples(end)], [max_rms, max_rms], 'g--', 'DisplayName', 'Максимальное значение');
    plot([fragment_time_samples(1), fragment_time_samples(end)], [min_rms, min_rms], 'b--', 'DisplayName', 'Минимальное значение');
    legend show;
    hold off;
end
