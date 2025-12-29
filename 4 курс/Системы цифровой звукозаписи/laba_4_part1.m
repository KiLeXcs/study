clear; 
clc;

wavFiles = {
    '/Users/kirill/Desktop/Projects/study/4 курс/Системы цифровой звукозаписи/1.wav',
    '/Users/kirill/Desktop/Projects/study/4 курс/Системы цифровой звукозаписи/2_16.wav',
    '/Users/kirill/Desktop/Projects/study/4 курс/Системы цифровой звукозаписи/2_24.wav',
    '/Users/kirill/Desktop/Projects/study/4 курс/Системы цифровой звукозаписи/2_32.wav',
    '/Users/kirill/Desktop/Projects/study/4 курс/Системы цифровой звукозаписи/3_3.wav',
    '/Users/kirill/Desktop/Projects/study/4 курс/Системы цифровой звукозаписи/3_4.wav',
    '/Users/kirill/Desktop/Projects/study/4 курс/Системы цифровой звукозаписи/3_5.wav',
    '/Users/kirill/Desktop/Projects/study/4 курс/Системы цифровой звукозаписи/3_6.wav',
    '/Users/kirill/Desktop/Projects/study/4 курс/Системы цифровой звукозаписи/4_192000_unsigned.wav'
};

for idx = 1:numel(wavFiles)
    fname = wavFiles{idx};
    
    fid = fopen(fname, 'rb', 'l');
    cleanup = onCleanup(@() fclose(fid));
    
    chunkID = char(fread(fid, 4, 'uchar')');
    chunkSize = fread(fid, 1, 'uint32');
    format = char(fread(fid, 4, 'uchar')');
    subchunk1ID = char(fread(fid, 4, 'uchar')');
    subchunk1Size = fread(fid, 1, 'uint32');
    audioFormat = fread(fid, 1, 'uint16');
    numChannels = fread(fid, 1, 'uint16');
    sampleRate = fread(fid, 1, 'uint32');
    byteRate = fread(fid, 1, 'uint32');
    blockAlign = fread(fid, 1, 'uint16');
    bitsPerSample = fread(fid, 1, 'uint16');
    
    if subchunk1Size > 16
        fread(fid, subchunk1Size - 16, 'uint8');
    end
    
    subchunk2ID = '';
    subchunk2Size = 0;
    while true
        id = char(fread(fid, 4, 'uchar')');
        sz = fread(fid, 1, 'uint32');
        if strcmp(id, 'data')
            subchunk2ID = id;
            subchunk2Size = sz;
            break;
        end
        fseek(fid, sz, 'cof');
    end
    
    fprintf('\n>>> Файл: %s\n', fname);
    
    fprintf('Идентификатор файла  : "%s"\n', chunkID);
    fprintf('Размер файла (-8)    : %d байт\n', chunkSize);
    fprintf('Формат               : "%s"\n', format);
    fprintf('\n');
    
    fprintf('ID подблока "fmt"    : "%s"\n', subchunk1ID);
    fprintf('Размер блока "fmt"   : %d байт\n', subchunk1Size);
    fprintf('Аудиоформат          : %d (1=PCM)\n', audioFormat);
    fprintf('Количество каналов   : %d\n', numChannels);
    fprintf('Частота дискретизации: %d Гц\n', sampleRate);
    fprintf('Байт-рейт            : %d байт/сек\n', byteRate);
    fprintf('Размер сэмпла (всех к.): %d байт\n', blockAlign);
    fprintf('Разрядность          : %d бит\n', bitsPerSample);
    fprintf('\n');
    
    fprintf('ID подблока "data"   : "%s"\n', subchunk2ID);
    fprintf('Размер данных        : %d байт\n', subchunk2Size);
    fprintf('%s\n', repmat('-', 1, 50));

    nSamp = floor(subchunk2Size / blockAlign);
    
    switch bitsPerSample
        case 8
            audio = double(fread(fid, [numChannels, nSamp], 'uint8'));
        case 16
            audio = fread(fid, [numChannels, nSamp], 'int16');
        case 32
            audio = fread(fid, [numChannels, nSamp], 'int32');
        case 24
            totalBytes = nSamp * blockAlign;
            rawBytes = fread(fid, totalBytes, 'uint8');
            byteMatrix = reshape(rawBytes, blockAlign, nSamp);
            audio = zeros(numChannels, nSamp);
            for ch = 1:numChannels
                startIdx = (ch-1)*3 + 1;
                endIdx = ch*3;
                chanBytes = byteMatrix(startIdx:endIdx, :);
                padded = [chanBytes; zeros(1, nSamp, 'uint8')];
                asInt32 = typecast(padded(:), 'int32');
                audio(ch, :) = bitshift(bitshift(asInt32, 8), -8);
            end
    end
    
    t = (0:nSamp-1)' / sampleRate;
    if bitsPerSample == 8
        normAudio = (audio - 128) / 128;
    else
        normAudio = audio / (2^(bitsPerSample - 1));
    end
    
    figure('Name', fname);
    plot(t, normAudio');
    xlabel('Время, сек.'); 
    ylabel('Амплитуда');
    title({fname, 'Signal waveform'});
    grid on;
    if t(end) > 0.05
        xlim([0 0.01]);
        title({fname, 'Форма сигнала'});
    end
end