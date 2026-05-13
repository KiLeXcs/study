function receive_raw_stream()
    PIPE_PATH = '/tmp/ffmpeg_stream.h264';
    CHUNK_SIZE = 8192; % Оптимально для баланса задержки и накладных расходов
    
    len = 0;

    fprintf('⏳ Ожидание подключения FFmpeg к %s...\n', PIPE_PATH);
    fid = fopen(PIPE_PATH, 'r', 'n', 'UTF-8'); % 'n' = native byte order
    if fid == -1
        error('Не удалось открыть pipe. Убедитесь, что FFmpeg запущен.');
    end
    fprintf('✅ Поток открыт. Начинаю чтение.\n');

    try
        while true
            % Читаем чанк сырых байтов (uint8)
            data = fread(fid, CHUNK_SIZE, 'uint8=>uint8');
            
            if isempty(data)
                fprintf('🛑 Поток завершён.\n');
                break;
            end

            % =========================================================
            % 🧩 ЗДЕСЬ ВАША ЛОГИКА НАЛОЖЕНИЯ ИЗБЫТОЧНОСТИ
            % =========================================================
            % data - вектор uint8 размера [N x 1]
            % Пример структуры:
            % redundant_data = add_redundancy(data);
            % send_to_next_stage(redundant_data);
            % =========================================================

            % Для отладки: раскомментируйте строку ниже
            fprintf('Получено %d байт | Первый байт: 0x%02X\n', length(data), data(1));
            len = len + length(data);
        end
        disp(len);
    catch ME
        fprintf('⚠️ Ошибка чтения: %s\n', ME.message);
    finally
        fclose(fid);
        fprintf('🔌 Соединение закрыто.\n');
    end
end