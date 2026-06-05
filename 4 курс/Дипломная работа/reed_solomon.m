function encoded_msg = rs_encode_bytes(n, k, msg_bytes)
        if n > 255
            error('Параметр n не может быть больше 255.');
        end
        if k >= n || mod(n - k, 2) ~= 0
            error('Параметр k должен быть строго меньше n, а (n-k) четным.');
        end
    
        % 1. Заголовок (4 байта) и данные
        msg_len = length(msg_bytes);
        len_bytes = typecast(uint32(msg_len), 'uint8'); 
        payload = [len_bytes, msg_bytes(:)']; 
        
        % 2. Дополнение нулями до кратности k
        num_blocks = ceil(length(payload) / k);
        padded_len = num_blocks * k;
        payload_padded = [payload, zeros(1, padded_len - length(payload), 'uint8')];
        
        % 3. Матрица: k строк, num_blocks столбцов
        msg_matrix = reshape(payload_padded, k, num_blocks);
        
        % 4. Создаем системный объект кодировщика
        encoder = comm.RSEncoder('CodewordLength', n, 'MessageLength', k);
        
        % 5. Кодируем по одному столбцу за раз (требование MATLAB для векторов)
        code_matrix = zeros(n, num_blocks, 'uint8'); 
        for i = 1:num_blocks
            code_matrix(:, i) = encoder(msg_matrix(:, i));
        end
        
        % 6. Преобразуем обратно в вектор-строку
        encoded_msg = reshape(code_matrix, 1, n * num_blocks);
    end
 


function decoded_msg = rs_decode_bytes(n, k, encoded_msg)
        if mod(length(encoded_msg), n) ~= 0
            error('Длина закодированного сообщения должна быть кратна n.');
        end
        
        num_blocks = length(encoded_msg) / n;
        
        % 1. Матрица: n строк, num_blocks столбцов
        code_matrix = reshape(encoded_msg, n, num_blocks);
        
        % 2. Создаем системный объект декодера
        % ИСПРАВЛЕНИЕ: Убрали 'ErrorCorrectionCapability'. 
        % MATLAB сам вычислит t = (n - k) / 2 на основе n и k.
        decoder = comm.RSDecoder('CodewordLength', n, 'MessageLength', k);
        
        % 3. Декодируем по одному столбцу за раз
        msg_matrix = zeros(k, num_blocks, 'uint8'); 
        for i = 1:num_blocks
            msg_matrix(:, i) = decoder(code_matrix(:, i));
        end
        
        % 4. Преобразуем в вектор-строку
        payload_padded = reshape(msg_matrix, 1, k * num_blocks);
        
        % 5. Считываем длину и проверяем
        len_bytes = payload_padded(1:4);
        original_len = typecast(uint8(len_bytes), 'uint32');
        
        if original_len > (length(payload_padded) - 4)
            error('Ошибка: заголовок длины поврежден.');
        end
        
        % 6. Извлекаем полезные данные
        decoded_msg = payload_padded(5 : 4 + original_len);
    end



data = randi([0, 255], 1, 32768, 'uint8');
    
n = 255;
k = 239;
    
s = 1;
    
tic;
        
encoded_data = rs_encode_bytes(n, k, data);

decode = rs_decode_bytes(n, k, encoded_data);
        
timer = toc;
fprintf("%.6f\n", timer);


if (data == decode)
    fprintf("Yes\n");
end
