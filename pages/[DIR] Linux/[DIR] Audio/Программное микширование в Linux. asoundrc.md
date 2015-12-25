# Программное микширование в Linux. asoundrc
##  Задачи
1. Добиться одновременного вывода звука от музыкальных редакторов (jack), Музыкальных и видео програм (alsa), skype и Virtualbox (oss) и игр (sdl).
1. Микширование звука 2to51, 1to21, 2to40 и наоборот.
1. Добавление эффектов звука (реверберация, обрезание частот, эквалайзер).
1. Низкая latency.
##  Исходные данные
Имеется:
1. звуковая карта Realtek ALC1200 8-Channel High Definition Audio CODEC, Optical S/PDIF out port at back I/O, Support Jack Detection and Multi-streaming, DTS Surround Sensation UltraPC
1. USB веб-камера UVC Logitec с микрофоном.

##  Решение:
Наконец, когда вчера у меня в системе появился уже третий звуковой девайс (звуковуха на материнке, на видеокарте и на USB-скайп-мыше), я понял, что система окончательно запуталась в том, что куда выводить. Кроме того, решил разобраться с уже доставшим глюком Skype, когда при наличии на звуковухе дефолтовой оцифровке в 48кГц у него сносит башню и твой голос становится похожим на пропущенный через скрэмблер. Погуглил, поковырялся и... о чудо! Всего минут за 30 экспериментов и тестов:

— Получил полное аппаратное неблокирующее смешение разнокалиберных звуковых источников (от моно до surround 5.1)
— Задействовал лишнюю пару дырок от 7.1 для подключения наушников, пустив туда фронтальную стерео-пару
— Естественно, прозрачное разведение 2.0 в 5.1 для качественного прослушивания музыки, чтобы задействовать сабвуфер и создать псевдообъём.
— Сделал неблокирующийся аналоговый микрофон, разделяемый между любыми девайсами одновременно. Ну и с исправлением Скайп-бага.

Помню, СКОЛЬКО я с этими вопросами в своё время мучился в Windows... Частично они, конечно, решались, но редкостным и мало где работающим шаманством. И только частично. А тут — прямо приятно посмотреть и послушать :D Если кому-то интересно, могу попозже поделиться получившимся .asoundrc (сейчас машину с ним уже вырубил). Воистину, на Linux'е можно творить чудеса, если поймёшь, где крутить :)

Вот, обещанный .asoundrc:
```bash
pcm.!default {
     type plug
     slave.pcm "stereo20"
}

pcm.!stereo20 {
        type asym
        playback.pcm "upmix2to6"
        capture.pcm "dsnooped"
}

pcm.!skype {
        type asym
        playback.pcm "upmix2to6"
        capture.pcm "skype_dsnoop"
}

pcm.!surround51 {
        type asym
        playback.pcm "swmixer"
        capture.pcm "intel_card"
}

pcm.snd_card {
        type plug
    slave.pcm "swmixer"
}

pcm.upmix2to6 {
        type route
        slave.pcm "snd_card"
        slave.channels 6

#ttable.from.to weight

        ttable.0.0 1    # left to left
        ttable.0.2 0.5  # left to back left
        ttable.0.4 0    # left to center

        ttable.1.1 1    # right to right
        ttable.1.3 0.5  # right to back right
        ttable.1.4 0    # right ti center

        ttable.0.5 0.15 # left to SW
        ttable.1.5 0.15 # right to SW
}

pcm.intel_card {
        type hw
        card "Intel"
        device 0
}

pcm.card_usb {
        type hw
        card "default"
        device 0
}

pcm.swmixer {
        type dmix
        ipc_key 1234
        slave {
                pcm "intel_card"
                channels 6
                period_time 0
                period_size 1024
                buffer_size 4096
                rate 48000
        }
}

# software mixing of capture information (needed for new skype)
pcm.dsnooped {
  ipc_key 1026
  type dsnoop
  slave {
        pcm "intel_card"
  }
}

# For Skype (asym duplexes half-duplex plugins like dsnoop and dmix into a full-duplex device)
pcm.duplex {
        type asym
        playback.pcm "upmix2to6"
        capture.pcm "dsnooped"
}

# aoss emulation
# http://forum.skype.com/index.php?showtopic=525851&st=20
pcm.skype {
  type plug
  slave.pcm "duplex"
}
```
- Основная карта у меня имеет hw id = 1,0.
- Скайп работает через устройство "skype". И на вывод и на ввод.
- Вывод стерео идёт через stereo20, и оно же - по умолчанию
- Surround - через surround51
- VLC в настройках он не хочет понимать конкретные девайсы кроме аппаратных. Приходится ручками править ~/.config/vlc/vlcrc: alsa-audio-device=snd_card.
- С smplayer сейчас на память не помню, что ему прописывал. Дома посмотрю.

P.S. Поменял жёсткую привязку хардверных ID на имена карт. А то при втыкании USB-скайпо-мышки нумерация ID едет.

----
## Про mplayer
Ну а фильмы я обычно смотрю через mplayer через такой скрипт:
/usr/local/bin/mpl
```bash
#!/bin/bash

AUDIO_CH=$(mediainfo "$1"|grep 'Channel(s)'|grep -v Front|sort -r|head -n1|sed -r 's/^.*: (\w)+.*/\1/') #'
if [[ "$AUDIO_CH" == "" ]]; then
AUDIO_CH=$(avinfo "$1"|grep audio|sort -r|head -n1|sed -r 's/^.*KHz//'|cut -d' ' -f 4)
fi
echo AUDIO_CH=$AUDIO_CH

FLAGS="-vsync -double"

if [ -e VIDEO_TS ]; then
    FLAGS="$FLAGS -dvd-device $(pwd)"
    WIDTH="768"
else
    WIDTH=$(mplayer "$1" -vo null -ao null -frames 0|grep VIDEO:|cut -d' ' -f5|cut -d'x' -f1)
    echo WIDTH=${WIDTH}

    if [ "${WIDTH}." == "." ]; then echo "Can't get width"; exit; fi
fi

case "${AUDIO_CH}" in
    6) FLAGS="${FLAGS} -channels 6 -ao alsa:device=surround51";;
    Stereo) FLAGS="${FLAGS} -channels 2 -ao alsa:device=stereo20";;
    Mono) FLAGS="${FLAGS} -channels 2 -ao alsa:device=mono10";;
    *) FLAGS="${FLAGS} -channels 2 -ao alsa:device=stereo20";;
esac

if [[ ($(basename "$1" .mov) == "$1.mov") || ($(basename "$1" .MOV) == "$1.MOV") ]]
then
    FLAGS="${FLAGS} -demuxer mov"
fi

if [[ $WIDTH -lt 720 ]]; then
    FLAGS="$FLAGS -vf pp=lb -autoq 100"
fi

if [ "$WIDTH" -ge 1280 ]; then
    FLAGS="$FLAGS -cache 2000 -vfm ffmpeg -lavdopts fast=1:skiploopfilter=all:threads=5 -cache-min 1 -cache-seek-min 1 -vc ffwmv3vdpau,ffvc1vdpau,ffh264vdpau,ffmpeg12vdpau"
fi

if [[ $(xvinfo | grep 'X-Video Extension version'|wc -l) == 0 ]]; then
    FLAGS="$FLAGS -vo x11"
fi

echo ===============================================================================
echo mplayer $FLAGS "$1" $2 $3 $4 $5 $6 $7 $8 $9 ${10} ${11} ${12}
echo -------------------------------------------------------------------------------

export DISPLAY=:0.0
mplayer $FLAGS "$1" $2 $3 $4 $5 $6 $7 $8 $9 ${10} ${11} ${12}
```
