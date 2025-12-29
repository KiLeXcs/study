clc;
clear;

%% === 1. НАСТРОЙКИ СИМУЛЯЦИИ ===
fdo = 1e7; % Частота "аналогового" моделирования
T = 1.2; % Время сигнала
to = 0 : 1/fdo : T;

% Частоты гармоник
f1 = 150; f2 = 3300; f3 = 11000; f4 = 4900;

% === ПОЛНЫЕ СПИСКИ ПАРАМЕТРОВ ===
Fs_list = [44100, 48000, 96000, 192000];
R_list = [10, 16, 24];

% Все сигналы
signals = { ...
    @(t) sin(2 * pi * f1 * t), "150 Гц"; ...
    @(t) sin(2 * pi * f2 * t), "3300 Гц"; ...
    @(t) sin(2 * pi * f3 * t), "11000 Гц"; ...
    @(t) sin(2 * pi * f1 * t) + sin(2 * pi * f2 * t), "150+3300 Гц"; ...
    @(t) sin(2 * pi * f1 * t) + sin(2 * pi * f2 * t) + sin(2 * pi * f3 * t), "150+3300+11000 Гц"; ...
    @(t) sin(2 * pi * f1 * t) + sin(2 * pi * f4 * t) + sin(2 * pi * f3 * t), "150+4900+11000 Гц" ...
};

% === НАСТРОЙКИ ТЗ: РИД-СОЛОМОН И ПЕРЕМЕЖЕНИЕ ===
Matrix_Size = 224;
Total_Bits = Matrix_Size * Matrix_Size; % 50176 бит

% Кодер Рида-Соломона (Укороченный)
% (255,251) -> Укорачиваем до выхода 224 бита (28 байт)
N_full = 255; K_full = 251;
N_short = 28; K_short = 24;
Bits_Per_Block_In = K_short * 8; % 192 бита
Bits_Input_Needed = Matrix_Size * Bits_Per_Block_In; % 43008 бит

base_ber = 0;
scenarios_list = 0:9;

rs_enc = comm.RSEncoder(N_full, K_full, 'BitInput', true, 'ShortMessageLength', K_short);
rs_dec = comm.RSDecoder(N_full, K_full, 'BitInput', true, 'ShortMessageLength', K_short);

results_table = table('Size', [0 9], ...
'VariableTypes', {'double','double','string','string','string','double','double','double','double'}, ...
'VariableNames', {'Fs_Hz','Bits','Signal','Scenario_Desc','Interleaving','Bursted_Blocks','Base_BER','SNR_dB','Residual_BER'});

fprintf('Запуск моделирования (исправленная версия)...\n');

%% === 2. ОСНОВНОЙ ЦИКЛ ===
for Fs = Fs_list
for R = R_list
for s = 1:length(signals)
sig_func = signals{s,1};
sig_name = signals{s,2};

text

        % --- Генерация сигнала ---
        t = 0 : 1/Fs : T;
        S = sig_func(t);
        Sn = S / max(abs(S)); % Нормировка (строка 1xN)

        % АЦП -> Биты
        Sq = uencode(Sn, R, 1, 'signed');
        Sq_p = int32(Sq) + 2^(R-1);
        Sq_b = logical(reshape(de2bi(Sq_p, R, 'left-msb')', 1, []));

        % Подготовка пакета
        if length(Sq_b) < Bits_Input_Needed
            repeats = ceil(Bits_Input_Needed / length(Sq_b));
            temp = repmat(Sq_b, 1, repeats);
            bits_clean = temp(1:Bits_Input_Needed);
        else
            bits_clean = Sq_b(1:Bits_Input_Needed);
        end

        % --- Кодирование ---
        encoded_stream = rs_enc(bits_clean'); 
        encoded_stream = encoded_stream'; 

        % --- Цикл по сценариям ---
        for scen_id = scenarios_list
            switch scen_id
                case 0, desc = "BER"; n_burst = 0;
                case 1, desc = "1 Блок"; n_burst = 1;
                case 2, desc = "2 Блока р."; n_burst = 2;
                case 3, desc = "3 Блока р."; n_burst = 3;
                case 4, desc = "4 Блока р."; n_burst = 4;
                case 5, desc = "5 Блоков р."; n_burst = 5;
                case 6, desc = "2 Блока п."; n_burst = 2;
                case 7, desc = "3 Блока п."; n_burst = 3;
                case 8, desc = "4 Блока п."; n_burst = 4;
                case 9, desc = "5 Блоков п."; n_burst = 5;
            end

            % --- Цикл: Перемежение ---
            for use_int = [0, 1]
                if use_int
                    int_str = "Да";
                    mat = reshape(encoded_stream, Matrix_Size, Matrix_Size);
                    tx_bits = reshape(mat', 1, []); 
                else
                    int_str = "Нет";
                    tx_bits = encoded_stream;
                end

                % --- КАНАЛ ---
                noisy_bits = bsc(tx_bits, base_ber);
                block_len = 224; 
                damaged_bits = noisy_bits;
                target_blocks = [];
                start_idx = 20;

                if scen_id >= 1 && scen_id <= 5
                    for k = 0:(n_burst-1), target_blocks = [target_blocks, start_idx + k*40]; end
                elseif scen_id >= 6 && scen_id <= 9
                    for k = 0:(n_burst-1), target_blocks = [target_blocks, start_idx + k]; end
                elseif scen_id == 1
                    target_blocks = start_idx;
                end
                
                for b_idx = target_blocks
                    i_start = (b_idx-1)*block_len + 1;
                    i_end   = b_idx*block_len;
                    damaged_bits(i_start : i_end) = 0; 
                end

                % --- ПРИЕМ ---
                if use_int
                    mat_rx = reshape(damaged_bits, Matrix_Size, Matrix_Size);
                    rx_stream = reshape(mat_rx', 1, []);
                else
                    rx_stream = damaged_bits;
                end

                decoded_bits = rs_dec(rx_stream');
                decoded_bits = decoded_bits';

                % --- Оценка ---
                bit_errs = sum(decoded_bits ~= bits_clean);
                res_ber = bit_errs / length(bits_clean);

                n_samp = floor(length(decoded_bits) / R);
                bits_used = decoded_bits(1 : n_samp*R);
                rec_int = bi2de(reshape(bits_used, R, n_samp)', 'left-msb') - 2^(R-1);
                Z = udecode(int32(rec_int), R, 1, 'saturate');
                
                % === ИСПРАВЛЕНИЕ ОШИБКИ С РАЗМЕРНОСТЯМИ ===
                Z = double(Z(:));                 % Принудительно в столбец
                ref_Sn = double(Sn(1:length(Z))); % Берем срез эталона
                ref_Sn = ref_Sn(:);               % Принудительно в столбец
                
                if length(Z) < 2
                    snr_val = -Inf;
                else
                    Ps = sum(abs(Z).^2);
                    Pn = sum(abs(Z - ref_Sn).^2); % Теперь размеры совпадают (N x 1)
                    snr_val = 10*log10(Ps / (Pn + eps));
                    disp("Fs=" + num2str(Fs) + " Hz, R=" + num2str(R) + " бит, Сигнал: " + sig_name + ...
                    ", Ошибка: " + desc + ", Перемежение: " + int_str + ", SNR=" + num2str(snr_val) + " дБ")
                end

                results_table = [results_table; table(Fs, R, sig_name, desc, int_str, n_burst, base_ber, snr_val, res_ber, ...
                    'VariableNames', {'Fs_Hz','Bits','Signal','Scenario_Desc','Interleaving','Bursted_Blocks','Base_BER','SNR_dB','Residual_BER'})];

            end 
        end 
    end
    fprintf('Просчитано: Fs=%d, R=%d\n', Fs, R);
end 
end

% === 3. ГРАФИКИ ===
disp('Построение графиков...');
unique_signals = unique(results_table.Signal, 'stable');
unique_scens = unique(results_table.Scenario_Desc, 'stable');

for s_idx = 1:length(unique_signals)
curr_sig = unique_signals(s_idx);
figure('Name', ['Анализ: ' char(curr_sig)], 'Position', [50, 50, 1400, 900]);
sgtitle(['Сигнал: ' char(curr_sig)], 'FontSize', 16, 'FontWeight', 'bold');

text

plot_idx = 1;
for r_val = R_list
    for fs_val = Fs_list
        subplot(3, 4, plot_idx);
        mask = (results_table.Fs_Hz == fs_val) & (results_table.Bits == r_val) & (results_table.Signal == curr_sig);
        data_sub = results_table(mask, :);

        snr_no = zeros(1, length(unique_scens));
        snr_yes = zeros(1, length(unique_scens));
        for i = 1:length(unique_scens)
            sc = unique_scens(i);
            v_n = data_sub.SNR_dB(data_sub.Scenario_Desc == sc & data_sub.Interleaving == "Нет");
            v_y = data_sub.SNR_dB(data_sub.Scenario_Desc == sc & data_sub.Interleaving == "Да");
            if ~isempty(v_n), snr_no(i) = v_n(1); end
            if ~isempty(v_y), snr_yes(i) = v_y(1); end
        end

        b = bar(1:length(unique_scens), [snr_no; snr_yes]', 'grouped');
        b(1).FaceColor = [1 0 0];
        b(2).FaceColor = [0 0 1];

        grid on; title(sprintf('Частота дискретизации = %d kHz, R = %d', fs_val/1000, r_val), 'FontSize', 10);
        ylim([0, 10]);

        xticks(1:length(unique_scens));
        xticklabels(unique_scens);
        xtickangle(45);

        if mod(plot_idx, 4) == 1, ylabel('SNR (дБ)'); end
        plot_idx = plot_idx + 1;
    end
end
L = legend({'Без перемежения', 'С перемежением'}, 'Orientation', 'horizontal');
L.Position = [0.4 0.02 0.2 0.03];
end
disp('Готово.');
