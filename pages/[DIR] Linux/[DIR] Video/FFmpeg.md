#  FFmpeg
##  Основные ключи
|Ключ           |Пример             |Описание                             |
|---------------|-------------------|-------------------------------------|
|-i             |-i movie.avi       |Путь/имя входного файла              |
|-target <type> |-target ntsc-dvd   |тип целевого файла                   |
|-aspect aspect |-aspect 16:9       |Видео пропорции дисплея              |
|-f <format>    |-f mkv             |Формат входного/выходного файла      |
|-r <fps>       |-r 23.976          |Количество кадров в секунду          |
|-ss <position> |-ss 00:10:50       |Начальная позиция кодирования        |
|-t <position>  |-t 00:15:10        |Конечная позиция кодирования         |
|-vframes <n>   |-vframes 1000      |Задаем количество кадров кодирования |
|-y             |-y                 |Разрешить перезапись выходного файла |
|-vcodec codec  |-vcodec libx264    |Кодек кодирования видео              |
|-acodec codec  |-acodec libmp3lame |Кодек кодирования аудио              |
|-vn            |-vn                |Не кодировать видео                  |
|-an            |-an                |Не кодировать аудио                  |
|-sn            |-sn                |Не использовать субтитры             |
|-vlang code    |-vlang eng         |Выбираем язык видео                  |
|-alang code    |-alang jpn         |Выбираем язык аудио                  |
|-slang code    |-slang rus         |Выбираем язык субтитров              |
|-sameq         |-sameq             |Сохранить видео в том же качестве    |
|-s <size>      |-s 720×400         |Размер видео кадра                   |
|-deinterlace   |-deinterlace       |Включаем деинтерляцию.               |
|-b bitrate     |-b 2000k           |Видео битрейт                        |
|-ab bitrate    |-ab 64k            |Аудио битрейт                        |
|-ar freq       | -ar 44100         |                                     |
|-mbd mode      |-mbd 2             |Соотношение сигнал/шум               |
|-trellis       |-trellis 2         |                                     |
|-cmp n         |-cmp 2             |Исползовать многопроцессорность      |
|-subcmp n      |-subcmp 2          |Исползовать многопроцессорность      |


##  FFmpeg на каждый день
- Извлечение информации из видеофайла: `ffmpeg -i sample.avi`
- Склеивание» изображений в видеоряд: `ffmpeg -f image2 -i image%d.jpg video.mpg` Все картинки из текущей директории с именами файлов image1.jpg, image2.jpg и т.д. будут преобразованы в один ролик video.mpg.
- Разложение видеоряда на кадры: `ffmpeg -i video.mpg image%d.jpg` Будут сгенерированы файлы image1.jpg, image2.jpg и т.д… Поддерживаемые графические форматы: PGM, PPM, PAM, PGMYUV, JPEG, GIF, PNG, TIFF, SGI.
- Кодирование видеоряда для Apple iPod/iPhone: `ffmpeg -i source_video.avi input -acodec aac -ab 128kb -vcodec mpeg4 -b 1200kb -mbd 2 -flags +4mv+trell -aic 2 -cmp 2 -subcmp 2 -s 320x180 -title X final_video.mp4`
- Для Sony PSP: `ffmpeg -i source_video.avi -b 300 -s 320x240 -vcodec xvid -ab 32 -ar 24000 -acodec aac final_video.mp4`
- Извлечение звука из видеофайла с последующим сохранением в формате MP3: `ffmpeg -i source_video.avi -vn -acodec copy sound.mp3 `
- Преобразование WAV в MP3: `ffmpeg -i son_original.avi -vn -ar 44100 -ac 2 -ab 192 -f mp3 son_final.mp3`
- AVI в MPG: `ffmpeg -i video_original.avi video_final.mpg`
- MPG в AVI: `ffmpeg -i video_original.mpg video_final.avi`
- Конвертация AVI-файла в несжатый анимированный GIF: `ffmpeg -i video_original.avi gif_anime.gif`
- Смешение аудио- и видеопотока в один результирующий файл: `ffmpeg -i son.wav -i video_original.avi video_final.mpg`
- Преобразование AVI в FLV: `ffmpeg -i video_original.avi -ab 56 -ar 44100 -b 200 -r 15 -s 320x240 -f flv video_final.flv`
- FLV в AVI: `ffmpeg -i video_original.flv -ab 56 -ar 44100 -b 200 -s 320x240 video_final.avi`
- FLAC в MP3: `ffmpeg -i audio_original.flac -ab 320k -ac 2 -ar 48000 audio_final.mp3`

