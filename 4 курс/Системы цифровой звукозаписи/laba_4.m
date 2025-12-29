clear;
clc;

[y, fs, bits, ch] = read_wav_manual('/Users/kirill/Desktop/Projects/study/4 курс/Системы цифровой звукозаписи/500Hz_stereo.wav');

if ch == 1
    mode = 'моно';
else
    mode = 'стерео';
end

fprintf('======== Информация о WAV-файле ========\n');
fprintf('Частота дискретизации (Fs): %d Гц\n', fs);
fprintf('Бит на семпл:               %d бит\n', bits);
fprintf('Количество каналов:         %d (%s)\n', ch, mode);
fprintf('Длительность:               %.3f сек\n', size(y, 1) / fs);
fprintf('Диапазон амплитуд:          [%.3f, %.3f]\n', min(y(:)), max(y(:)));
fprintf('========================================\n');

function [y, fs, bits, channels] = read_wav_manual(filename)

    fid = fopen(filename, 'r', 'ieee-le');
    if fid == -1
        error('Не удалось открыть файл %s', filename);
    end
    
    chunkID = char(fread(fid, 4, 'char')');
    if ~strcmp(chunkID, 'RIFF')
        error('Неверный формат: не найден RIFF заголовок');
    end
    fileSize = fread(fid, 1, 'uint32');
    format = char(fread(fid, 4, 'char')');
    if ~strcmp(format, 'WAVE')
        error('Файл не в формате WAVE');
    end
    
    fmtChunkID = char(fread(fid, 4, 'char')');
    if ~strcmp(fmtChunkID, 'fmt ')
        error('Неверный fmt chunk ID');
    end
    fmtSize = fread(fid, 1, 'uint32');
    audioFormat = fread(fid, 1, 'uint16');
    if audioFormat ~= 1
        error('Поддерживается только PCM (audioFormat = 1)');
    end
    channels = fread(fid, 1, 'uint16');
    fs = fread(fid, 1, 'uint32');
    byteRate = fread(fid, 1, 'uint32');
    blockAlign = fread(fid, 1, 'uint16');
    bits = fread(fid, 1, 'uint16');
    
    if fmtSize > 16
        fread(fid, fmtSize - 16, 'uint8');
    end
    
    dataChunkID = char(fread(fid, 4, 'char')');
    if ~strcmp(dataChunkID, 'data')
        error('Неверный data chunk ID');
    end
    dataSize = fread(fid, 1, 'uint32');
    numSamples = dataSize / (channels * bits/8);
    
    if bits == 16
        rawData = fread(fid, [channels, numSamples], 'int16');
        y = double(rawData)' / 32768; 
    elseif bits == 8
        rawData = fread(fid, [channels, numSamples], 'uint8');
        y = double(rawData)' / 128 - 1;
    else
        error('Поддерживаются только 8 или 16 бит');
    end
    
    fclose(fid);
end