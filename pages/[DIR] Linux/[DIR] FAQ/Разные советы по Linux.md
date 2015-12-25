#  Разные советы по Linux
##  Разбудить компьютер по таймеру
Эта команда усыпит и разбудит ваш комп ровно в 6:00. (suspend)
```bash
$ rtcwake -m mem -t $(date +%s -d 06:00)
```
Эта команда усыпит и разбудит ваш комп ровно в 6:00. (hibernation)
```bash
$ rtcwake -m disk -t $(date +%s -d 06:00)
```
##  Mediainfo
У mediainfo есть полезный ключ "--Inform". Рекомендую почитать "man mediainfo".

Вот например:
```bash
mediainfo --Inform=file://mediainfo.txt 1.mp4 2.mov
```
medainfo.txt
```
General;\n%FileName%\n  %Format%,%Duration/String3%,%FileSize/String4%,%OverallBitRate/String%
Video;\n    %Format%(%CodecID%),%Width%x%Height%@%FrameRate%,%StreamSize/String5%,%DisplayAspectRatio/String%(%DisplayAspectRatio%),%BitRate/String%(%Bits-(Pixel*Frame)%)
Audio;\n    %Format%,%Channel(s)/String%,%StreamSize/String5%,%BitRate/String%
```

Вывод:
```
1
  MPEG-4,00:01:06.692,64.72 MiB,8 141 Kbps
    AVC(avc1),1920x1080@23.976,63.7 MiB (98%),16:9(1.778),8 000 Kbps(0.161)
    AAC,2 channels,1.02 MiB (2%),128 Kbps
2
  MPEG-4,00:02:20.349,604.6 MiB,36.1 Mbps
    AVC(avc1),1920x1080@23.976,579 MiB (96%),16:9(1.778),34.6 Mbps(0.696)
    PCM,2 channels,25.7 MiB (4%),1 536 Kbps
```
## Список процессов в виде дерева.
```bash
$ ps axf

$ ps -eH

$ ps -e --forest

$ pstree -p

$ htop # И нажать F5
```
