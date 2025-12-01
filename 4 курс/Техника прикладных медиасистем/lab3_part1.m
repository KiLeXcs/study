try
    cam = webcam(1);
    fprintf('Камера "%s" успешно подключена\n', cam_list{1});
catch ME
    fprintf('Ошибка подключения к камере: %s\n', ME.message);
end

figure('Name', 'Захват кадра', 'NumberTitle', 'off', 'Position', [100 100 800 600]);
fprintf('Захват видео в течение 5 секунд...\n');

start_time = tic;
while toc(start_time) < 5
    img = snapshot(cam);
    imshow(img);
    title(sprintf('Повернутое изображение (180°) - Время: %.1f сек', toc(start_time)));
    drawnow;
    if toc(start_time) >= 4.9
        final_frame = img;
        filename = 'frame_part_1.png';
        pwd = '/Users/kirill/Desktop/Projects/study/4 курс/Техника прикладных медиасистем'
        filepath = fullfile(pwd, filename);
        imwrite(final_frame, filepath);
        info = imfinfo(filename);
        fprintf('Имя файла: %s\n', info.Filename);
        fprintf('Формат: %s\n', info.Format);
        fprintf('Размер изображения: %d x %d пикселей\n', info.Width, info.Height);
        fprintf('Глубина цвета: %d бит\n', info.BitDepth);
        fprintf('Тип изображения: %s\n', info.ColorType);
        fprintf('Размер файла: %d байт (%.2f КБ)\n', info.FileSize, info.FileSize/1024);
    end
end
clear cam;
