clear; 
clc;

outputFile = '/Users/kirill/Desktop/Projects/study/4 курс/Системы цифровой звукозаписи/1_matlab.wav';

channelFrequencies = [1500, 500, 50, 1000, 2000, 200];      
channelAmplitudes  = [0.7, 0.9, 0.5, 0.8, 0.95, 0.7];      

numChannels = 6;
bitDepth = 8;
sampleRate = 192000;
duration = 1;

t = (0 : 1/sampleRate : duration - 1/sampleRate)';
audio = zeros(length(t), numChannels);

for ch = 1:numChannels
    freq = channelFrequencies(ch);
    amp = channelAmplitudes(ch);
    audio(:, ch) = amp * sin(2 * pi * freq * t);
end

fid = fopen(outputFile, 'wb', 'l');

numSamples = size(audio, 1);
blockAlign = numChannels * bitDepth / 8;
byteRate = sampleRate * blockAlign;
dataSize = numSamples * blockAlign;
dataSize = round(dataSize);
chunkSize = 36 + dataSize;

fwrite(fid, 'RIFF', 'char');
fwrite(fid, uint32(chunkSize), 'uint32');
fwrite(fid, 'WAVE', 'char');
fwrite(fid, 'fmt ', 'char');
fwrite(fid, uint32(16), 'uint32');
fwrite(fid, uint16(1), 'uint16');
fwrite(fid, uint16(numChannels), 'uint16');
fwrite(fid, uint32(sampleRate), 'uint32');
fwrite(fid, uint32(byteRate), 'uint32');
fwrite(fid, uint16(blockAlign), 'uint16');
fwrite(fid, uint16(bitDepth), 'uint16');
fwrite(fid, 'data', 'char');
fwrite(fid, uint32(dataSize), 'uint32');

if bitDepth == 8
    clipped = max(-1, min(1, audio));
    samples8 = uint8(round((clipped + 1) * 127.5));
    interleaved = reshape(samples8.', 1, []);
    fwrite(fid, interleaved, 'uint8');
    
elseif bitDepth == 16
    maxVal16 = 2^15 - 1;
    clipped = max(-1, min(1, audio));
    samples16 = int16(clipped * maxVal16);
    interleaved = reshape(samples16.', 1, []);
    fwrite(fid, interleaved, 'int16');
    
elseif bitDepth == 32
    maxVal32 = 2^31 - 1;
    clipped = max(-1, min(1, audio));
    samples32 = int32(clipped * maxVal32);
    interleaved = reshape(samples32.', 1, []);
    fwrite(fid, interleaved, 'int32');
    
elseif bitDepth == 24
    maxVal24 = 2^23 - 1;
    clipped = max(-1, min(1, audio));
    samples32_full = int32(clipped * maxVal24);
    rawData = zeros(numSamples * numChannels * 3, 1, 'uint8');
    for i = 1:numSamples
        for ch = 1:numChannels
            val = samples32_full(i, ch);
            bytesAll = typecast(uint32(typecast(val, 'uint32')), 'uint8');
            idx = (i - 1) * numChannels * 3 + (ch - 1) * 3 + (1:3);
            rawData(idx) = bytesAll(1:3);
        end
    end
    fwrite(fid, rawData, 'uint8');
end

fclose(fid);
fprintf('\nФайл сохранён: %s\n', outputFile);