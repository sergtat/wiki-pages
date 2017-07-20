#  FFmpeg

##  Основные ключи

|Ключ           |Пример             |Описание                             |
|---------------|-------------------|-------------------------------------|
|-i <path>      |-i movie.avi       |Путь/имя входного файла              |
|-target <type> |-target ntsc-dvd   |тип целевого файла                   |
|-aspect aspect |-aspect 16:9       |Видео пропорции дисплея              |
|-f <format>    |-f mkv             |Формат входного/выходного файла      |
|-r <fps>       |-r 23.976          |Количество кадров в секунду          |
|-ss <position> |-ss 00:10:50       |Начальная позиция кодирования        |
|-t <position>  |-t 00:15:10        |Конечная позиция кодирования         |
|-vframes <n>   |-vframes 1000      |Задаем количество кадров кодирования |
|-y             |-y                 |Разрешить перезапись выходного файла |
|-vcodec <codec>|-vcodec libx264    |Кодек кодирования видео              |
|-acodec <codec>|-acodec libmp3lame |Кодек кодирования аудио              |
|-vn            |-vn                |Не кодировать видео                  |
|-an            |-an                |Не кодировать аудио                  |
|-sn            |-sn                |Не использовать субтитры             |
|-vlang <code>  |-vlang eng         |Выбираем язык видео                  |
|-alang <code>  |-alang jpn         |Выбираем язык аудио                  |
|-slang <code>  |-slang rus         |Выбираем язык субтитров              |
|-sameq         |-sameq             |Сохранить видео в том же качестве    |
|-s <size>      |-s 720×400         |Размер видео кадра                   |
|-deinterlace   |-deinterlace       |Включаем деинтерляцию.               |
|-b <bitrate>   |-b 2000k           |Видео битрейт                        |
|-ab <bitrate>  |-ab 64k            |Аудио битрейт                        |
|-ar <freq>     |-ar 44100          |                                     |
|-mbd <mode>    |-mbd 2             |Соотношение сигнал/шум               |
|-trellis <n>   |-trellis 2         |                                     |
|-cmp <n>       |-cmp 2             |Использовать многопроцессорность     |
|-subcmp <n>    |-subcmp 2          |Использовать многопроцессорность     |

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

## Библиотека ffmpeg и обработка видео

Библиотека с открытым исходным кодом ffmpeg скорее всего уже установлена на вашей операционной системе. Если же нет, установите его штатной программой управления пакетами, это не займет много времени.

**Конвертировать один формат аудио и видео файлов в другой**

    ffmpeg -i file.<old_extension> [options] file.<new_extension>

**Уменьшаем видео, записанное на фотоаппарате:**

    ffmpeg -i MVI_4703.MOV MVI_4703.avi

**То же самое, но с контролем качества.**

    ffmpeg -i MVI_4703.MOV -q:v 4 MVI_4703.avi

Размер изображения уменьшился более чем в 5 раз без ощутимой потери качества. Опция -qscale:v n, сокращенно -q:v n позволяет установить уровень качества генерируемого видеопотока, где n принимает значения в интервале от 1 до 31. Значение 1 соответствует самому лучшему качеству, а 31 — самому худшему.

    -rw-r--r-- 1 mig users 124M июл 18 23:29 foto/MVI_4703.avi
    -rw-r--r-- 1 mig users 686M июн 27 21:38 foto/MVI_4703.MOV

**Указать кодек**

Для того, чтобы выбрать нужный нам кодек используем ключи -c:a <codec> -c:v <codec>.

    ffmpeg -i video.mp4 -c:v vp9 -c:a libvorbis video.mkv

Увидеть все поддерживаемые кодеки можно командой ffpmeg -codecs.

**Поменять контейнер файла**

Возьмем теперь такой юзкейс случай. Встроенный плеер вашего телевизора поддерживает формат mkv, но не поддерживает m4v. Для того, чтобы поменять контейнер воспользуемся следующей командой.

    ffmpeg -i video.m4v -c:av copy video.mkv

**Если же нужно поменять только звук, а видео оставить как есть, запускаем эту команду. Почему-то телевизоры Филипс понимают только форматы звука AAC/AC3.**

    ffmpeg -i video.m4v -c:v copy -c:a aac video.mkv

**Добавить звуковую дорожку**

Просто перечисляем файлы ввода и задаем вывод.

    ffmpeg -i video.mp4 -i audio.ogg video_sound.mp4


**Извлечь звуковую дорожку**

Если нужно просто извлечь звук, то можно так.

    ffmpeg -i video.MOV -vn audio.ogg

**Задаем формат извлекаемой звуковой дорожки.**

    ffmpeg -i video.MOV -vn -c:a flac audio.flac

**Указывает приемлемый битрейт, по умолчанию будет записано 128k.**

    ffmpeg -i video.MOV -vn -c:a flac -b:a 192k audio.flac

**Делаем слайд-шоу из картинок**

Тот самый случай, когда гладко было на бумаге. На практике приходится ходить по граблям, продираясь через разнобой форматов, кодеков, размеров и ориентации фотографий.

    ffmpeg -r .3 -pix_fmt rgba -s 1280x720 -pattern_type glob -i "*.JPGЭ video.mkv

_**Требуются некоторые пояснения.**_

    -r number — частота кадров в секунду.
    -pix_fmt — Пиксельный формат, список из команды ffmpeg -pix_fmts. Не со всему форматами получается выставить нужный размер кадра.
    -pattern_type glob — Для того, чтобы использовать совпадение по шаблону как в командной оболочке. Альтернативой является использование формата C printf, например image%03d.png для всех image0001.png, image0002.png и т. д.

**Изменить видеопоток**

Допустим, вам нужен не весь видео файл, а лишь часть его. Данная команда вырежет 10 секунд видео, начиная с первой минуты.

    ffmpeg -i video_full.m4v -c:av copy -ss 00:01:00 -t 10 video_short.m4v

**Как повысить качество потоков аудио или видео? Для этого используется ключ битрейта -b.**

    ffmpeg - video.webm -c:a copy -c:v vp9 -b:v 2M final.mkv

**Захват экрана**

Для захвата экрана используется устройство x11grab, а ffmpeg должен быть собран с опцией --enable-x11grab.

    ffmpeg -f x11grab -framerate 25 -video_size 4cif -i :0.0 out.mpg

    -video_size word — Размер захвата, cif = 352x288, 4cif = 704x576. Подробнее в info ffmpeg-utils.

**Бонусная дорожка**

Для автоматической обработки фотографий удобно работать с программой ImageMagick. Поменять размер всех фотографий в папке.

    mogrify -resize 60% *.png

## Ссылки по теме

- [Хабрапост про ffmpeg](https://habrahabr.ru/post/171213/), много полезных команд, однако синтаксис для большинства уже успел поменяться.
- [A quick guide to using FFmpeg to convert media files](https://opensource.com/article/17/6/ffmpeg-convert-media-file-formats)
- [Настройка качества кодировки в FFmpeg: переменный и постоянный битрейт для Mpeg4](https://webhamster.ru/mytetrashare/index/mtb0/1477848708553fw5o8cv)
