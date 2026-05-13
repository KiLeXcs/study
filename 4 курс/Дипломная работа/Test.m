function receive = receive_raw_stream()
    % ⚠️ Параметры кода должны быть заданы явно внутри функции или передаваться аргументами
    n = 255; 
    k = 239;
    
    PIPE_PATH = '/tmp/ffmpeg_stream.h264';
    CHUNK_SIZE = 8192;

    fprintf('⏳ Ожидание подключения FFmpeg к %s...\n', PIPE_PATH);
    fid = fopen(PIPE_PATH, 'rb'); % ⚠️ 'rb' ОБЯЗАТЕЛЕН для бинарных данных!
    if fid == -1
        error('Не удалось открыть pipe. Убедитесь, что FFmpeg запущен.');
    end
    fprintf('✅ Поток открыт. Начинаю чтение.\n');

    % 🔒 Гарантированное закрытие файла при любом выходе из функции (аналог finally)
    cleanupObj = onCleanup(@() fclose(fid));
    
    receive = [];

    try
        while true
            data = fread(fid, CHUNK_SIZE, 'uint8=>uint8');
            if isempty(data)
                fprintf('🛑 Поток завершён.\n');
                break;
            end

            % 1. Байты -> Биты (MSB-first, совместимо со всеми версиями MATLAB)
            numBytes = length(data);
            bits = zeros(8 * numBytes, 1); % double-массив 0 и 1
            for b = 1:8
                bits(b:8:end) = bitget(data, 9 - b);
            end

            % 2. Кодирование
            encoded = rsEncodeBits(bits, n, k);

            % 3. Декодирование с автоматическим удалением padding
            decoded = rsDecodeBits(encoded, n, k, length(bits));

            fprintf('Чанк обработан: %d байт | Всего бит: %d\n', numBytes, length(receive));
        end
    catch ME
        fprintf('⚠️ Ошибка обработки потока: %s\n', ME.message);
    end
    % cleanupObj автоматически выполнит fclose(fid) здесь
end



function decodedBits = rsDecodeBits(encodedBits, n, k, originalLen)
% RSDECODEBITS Декодирование потока битов кодом Рида-Соломона (n, k)
%   decodedBits = rsDecodeBits(encodedBits, n, k)
%   decodedBits = rsDecodeBits(encodedBits, n, k, originalLen)
%
%   ВХОДНЫЕ ПАРАМЕТРЫ:
%     encodedBits - вектор закодированных битов (0 и 1)
%     n, k        - параметры кода Рида-Соломона
%     originalLen - (опционально) длина исходного потока до кодирования.
%                   Если указана, хвостовые нули (padding) будут автоматически удалены.
%
%   ВЫХОДНЫЕ ПАРАМЕТРЫ:
%     decodedBits - восстановленный поток битов (столбец)
%
%   ПРИМЕЧАНИЯ:
%     1. Требуется Communications Toolbox.
%     2. Корректирующая способность кода: t = floor((n-k)/2) символов на блок.
%     3. При обнаружении неисправимых ошибок функция выбросит предупреждение 
%        и вернет результат попытки декодирования.

    % --- Валидация ---
    if nargin < 3
        error('Требуется минимум 3 аргумента: encodedBits, n, k');
    end
    encodedBits = encodedBits(:);
    if isempty(encodedBits)
        decodedBits = []; return;
    end
    if any(encodedBits ~= 0 & encodedBits ~= 1)
        error('encodedBits должен содержать только 0 и 1.');
    end
    if n <= k || k <= 0 || floor(n)~=n || floor(k)~=k
        error('n и k должны быть целыми положительными числами, n > k.');
    end
    if ~exist('rsdec', 'file') || ~exist('gf', 'file')
        error('Функция требует наличия Communications Toolbox.');
    end

    % --- Параметры ---
    m = ceil(log2(n + 1));
    if mod(length(encodedBits), n*m) ~= 0
        error('Длина encodedBits (%d) не кратна n*m = %d. Данные повреждены или обрезаны.', ...
              length(encodedBits), n*m);
    end

    % --- 1. Биты -> Символы (MSB-first, как в кодере) ---
    numSymbols = length(encodedBits) / m;
    bitMatrix = reshape(encodedBits, m, numSymbols)';
    weights = 2.^(m-1:-1:0);
    encSymbols = sum(bitMatrix .* weights, 2);

    % --- 2. Группировка в кодовые слова длины n ---
    numCodewords = numSymbols / n;
    cwMatrix = reshape(encSymbols, n, numCodewords)'; % [numCodewords x n]

    % --- 3. Декодирование Рида-Соломона ---
    cwGF = gf(cwMatrix, m);
    [msgGF, numerr, ~] = rsdec(cwGF, n, k);
    
    % Проверка на неисправимые ошибки
    uncorr = sum(numerr == -1);
    if uncorr > 0
        warning('rsDecodeBits:UncorrectableErrors', ...
                '%d блоков содержат неисправимые ошибки (>t=%d символов). Результат может быть неверным.', ...
                uncorr, floor((n-k)/2));
    end

    % --- 4. Символы -> Биты ---
    msgSym = double(msgGF.x); % [numCodewords x k]
    decBits = zeros(numCodewords, k * m);
    for b = 1:m
        % Извлечение битов MSB-first
        decBits(:, b:m:end) = bitget(msgSym, m - b + 1);
    end

    % --- 5. Удаление padding (если указана исходная длина) ---
    decodedBits = reshape(decBits', [], 1);
    if nargin >= 4 && ~isempty(originalLen)
        if originalLen <= 0 || originalLen > length(decodedBits)
            error('originalLen должна быть в диапазоне [1, %d].', length(decodedBits));
        end
        decodedBits = decodedBits(1:originalLen);
    end
end



function encodedBits = rsEncodeBits(bitStream, n, k)
% RSENCODEBITS Кодирование потока битов кодом Рида-Соломона (n, k)
%   encodedBits = rsEncodeBits(bitStream, n, k)
%
%   ВХОДНЫЕ ПАРАМЕТРЫ:
%     bitStream - вектор битов (0 и 1)
%     n         - длина кодового слова в символах
%     k         - длина сообщения в символах
%
%   ВЫХОДНЫЕ ПАРАМЕТРЫ:
%     encodedBits - столбец закодированных битов
%
%   ПРИМЕЧАНИЯ:
%     1. Требуется Communications Toolbox.
%     2. Размер символа m определяется автоматически: m = ceil(log2(n+1)).
%     3. Биты упаковываются в символы старшим битом вперёд (MSB-first).
%     4. Если длина потока не кратна k*m, в конец добавляются нули.
%     5. Используется систематическое кодирование с контрольными символами в конце.

    % Проверка входных аргументов
    if nargin ~= 3
        error('Требуется ровно 3 аргумента: bitStream, n, k');
    end
    bitStream = bitStream(:);
    if isempty(bitStream)
        encodedBits = []; return;
    end
    if any(bitStream ~= 0 & bitStream ~= 1)
        error('bitStream должен содержать только 0 и 1.');
    end
    if n <= k || k <= 0 || floor(n)~=n || floor(k)~=k
        error('n и k должны быть целыми положительными числами, n > k.');
    end
    
    % Проверка наличия необходимых функций
    if ~exist('rsenc', 'file') || ~exist('gf', 'file')
        error('Функция требует наличия Communications Toolbox.');
    end

    % 1. Определяем размер символа m
    m = ceil(log2(n + 1));
    if n > 2^m - 1
        error('n превышает максимальную длину кодового слова для GF(2^%d).', m);
    end

    % 2. Дополняем поток нулями до кратности k*m бит
    L = length(bitStream);
    padLen = mod(-L, k*m);
    if padLen > 0
        bitStream = [bitStream; zeros(padLen, 1)];
    end

    % 3. Преобразуем биты в символы (по m бит на символ, MSB-first)
    numSymbols = length(bitStream) / m;
    bitMatrix = reshape(bitStream, m, numSymbols)';      % [numSymbols x m]
    weights = 2.^(m-1:-1:0);
    symbols = sum(bitMatrix .* weights, 2);              % [numSymbols x 1]

    % 4. Группируем символы в сообщения длины k
    numMessages = numSymbols / k;
    msgMatrix = reshape(symbols, k, numMessages)';       % [numMessages x k]

    % 5. Кодирование Рида-Соломона
    msgGF = gf(msgMatrix, m);                            % Преобразование в поле Галуа
    encGF = rsenc(msgGF, n, k);                          % Кодирование
    encSymbols = double(encGF.x);                        % Извлечение целых значений [numMessages x n]

    % 6. Преобразуем закодированные символы обратно в биты
    encBits = zeros(numMessages, n * m);
    for b = 1:m
        % bitget(A, bit) извлекает bit-й бит (1=LSB). 
        % Для порядка MSB-first используем сдвиг m-b+1
        encBits(:, b:m:end) = bitget(encSymbols, m - b + 1);
    end

    % Возвращаем результат в виде столбца
    encodedBits = reshape(encBits', [], 1);
end



% 1. Получение потока данных
data = receive_raw_stream()