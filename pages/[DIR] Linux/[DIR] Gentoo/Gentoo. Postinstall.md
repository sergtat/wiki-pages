# Gentoo. Postinstall (Tools, X11-Xorg, Fluxbox, Slim (DM), Urxvt, Firefox, Sound, Printer)
<base target='_blank'>
##Установка системных утилит
```bash
emerge -av mc zsh
chsh /bin/zsh
echo 'export PATH="$HOME/bin:$PATH"' >> $HOME/.profile
echo 'export EDITOR="/usr/bin/vim"' >> $HOME/.profile
echo 'export PAGER="/usr/bin/vimmanpager"' >> $HOME/.profile
echo 'source ./.profile' >> $HOME/.zprofile
exit
login: ********
password: ********
# Не забудьте про пользователей

emerge -av gpm sudo; rc-update add gpm default; /etc/init.d/gpm start
sed -i 's/# \(%wheel ALL=(ALL) NOPASSWD: ALL\)/\1/' /etc/sudoers
echo app-editors/vim >> /etc/potage/package.keywords
echo app-editors/vim-core >> /etc/potage/package.keywords
echo app-editors/vim X gpm python vim-pager >> /etc/potage/package.use
emerge -av vim
echo app-arch/unzip natspec >> /etc/potage/package.use
echo net-misc/aria2 bittorrent >> /etc/portage/package.use
emerge -av aria2 fuse simple-mtpfs ntfs3g tmux ccze grc logrotate mmv pinfo psutils hwinfo lshw iptables iproute2 kexec-tools mlocate inotify-tools ncdu sys-process/at htop lynx unzip unrar p7zip sox
rc-update add atd default; /etc/init.d/atd start
```
## Установка инструментов Portage
```bash
emerge -av eix elogv euses euse genlop gentoolkit layman git pfl portage-utils ufed eclean-kernel (portconf ? elog-function ? kernel-cleaner ?) 
# Собрать бинарник
quickpkg --include-config=y ПАКЕТ
```
## Настройка звука (ALSA)
```bash
hwinfo --sound | egrep 'Audio|Model|Driver Modules'
09: PCI 01.1: 0403 Audio device
  Model: "ATI Audio device"
  Driver Modules: "snd_hda_intel"
18: PCI 14.2: 0403 Audio device
  Model: "ATI SBx00 Azalia (Intel HDA)"
  Driver Modules: "snd_hda_intel" # Запомнить 'Driver modules'

# Приводим /etc/modprobe.d/alsa.conf к виду

# --- begin /etc/modprobe.d/alsa.conf
# Alsa kernel modules' configuration file.
#
# ALSA portion
alias char-major-116 snd
alias snd-card-0 snd-hda-intel #Указываем driver modules
# alias snd-card-1 snd-* # Для второй карты
# OSS/Free portion
alias char-major-14 soundcore
alias sound-slot-0 snd-card-0
# alias sound-slot-1 snd-card-1 # Для второй карты
#
# OSS/Free portion - card #1
alias sound-service-0-0 snd-mixer-oss
alias sound-service-0-1 snd-seq-oss
alias sound-service-0-3 snd-pcm-oss
alias sound-service-0-8 snd-seq-oss
alias sound-service-0-12 snd-pcm-oss
##  OSS/Free portion - card #2 (Для второй карты)
## alias sound-service-1-0 snd-mixer-oss
## alias sound-service-1-3 snd-pcm-oss
## alias sound-service-1-12 snd-pcm-oss
#
alias /dev/mixer snd-mixer-oss
alias /dev/dsp snd-pcm-oss
alias /dev/midi snd-seq-oss
#
# Set this to the correct number of cards.
# options snd-hda-intel model=auto probe_mask=1
# options snd cards_limit=1
# --- end /etc/modprobe.d/alsa.conf

cat /proc/asound/cards 
 0 [Generic        ]: HDA-Intel - HD-Audio Generic
                      HD-Audio Generic at 0xfeb44000 irq 40
 1 [SB             ]: HDA-Intel - HDA ATI SB
                      HDA ATI SB at 0xfeb40000 irq 16
grep Codec /proc/asound/card0/codec\#0
Codec: ATI R6xx HDMI
grep Codec /proc/asound/card1/codec\#0 
Codec: Realtek ALC892
```
Включаем нужные драйвера и кодеки, отключаем ненужные:
```bash
Device Drivers  --->
    <M> Sound card support  --->
        [*]   Preclaim OSS device numbers
        <M>   Advanced Linux Sound Architecture  --->
            <M>   Sequencer support
            <M>   OSS Mixer API
            <M>   OSS PCM (digital audio) API
            [*]     OSS PCM (digital audio) API - Include plugin system
            [*]   OSS Sequencer API
            [*]   Dynamic device file minor numbers
            (32)    Max number of sound cards
            [*]   Verbose procfs contents
            [*]   PCI sound devices  --->
                <M>   Intel HD Audio  --->
# Для Sound Card
                    [*]   Build Realtek HD-audio codec support
                    [*]   Build Analog Device HD-audio codec support
# Для HDMI
                    [*]   Build HDMI/DisplayPort HD-audio codec support
# Для веб-камеры
<M> Multimedia support  --->
    [*]   Cameras/video grabbers support
    [*]   Media USB Adapters  --->
        <M>   USB Video Class (UVC)
        [*]     UVC input events device support
```
```bash
cat << EOL >> /etc/portage/make.conf
#SUPPORT_ALSA=1
ALSA_CARDS="hda-intel usb-audio"
ALSA_PCM_PLUGINS="*"
EOL

emerge -av alsa-lib alsa-tools alsa-utils
aplay -l # Запоминаем номер card и device
```
Создаем /etc/asound.conf для многопоточного звука
```bash
cat << EOF > /etc/asound.conf
pcm.!default {
    type plug
    slave.pcm "dmixer"
}
  
pcm.dsp0 {
    type plug
    slave.pcm "dmixer"
}
  
pcm.dmixer {
    type dmix
    ipc_key 1024
    ipc_key_add_uid 0
    ipc_perm 0666
    slave {
        pcm "hw:1,0"      # Здесь #CARD и №DEVICE
        period_time 0
        period_size 1024
        buffer_size 8192
        rate 48000 # or 44100
    }
  }
  
ctl.dmixer {
    type hw
    card 0
}

EOF

# Выставляем уроветь громкости
alsamixer # M - mute/unmute, up/down - +/-, left/right - select chanel

```
## Установка xorg-server со свободными драйверами, KMS и DualHead (ATI и NVidia).
### Настройка xorg
Смотрим информацию об оборудовании
```bash
hwinfo --gfxcard |egrep 'Model|Driver:|Driver Modules' 
  Model: "ATI VGA compatible controller"
  Driver: "radeon"
  Driver Modules: "drm"
```
Включаем нужные драйвера, отключаем ненужные:
Выставляем в make.conf VIDEO_CARDS="radeon" и INPUT_DEVICES="evdev":
```bash
# echo 'VIDEO_CARDS="radeon"' >> /etc/portage/make.conf
# # или для `noveau`
# echo 'VIDEO_CARDS="noveau"' >> /etc/portage/make.conf
echo 'INPUT_DEVICES="evdev"' >> /etc/portage/make.conf
emerge -av xorg-drivers xorg-server
# устанавливаем полезные X-tools
emerge -av xterm xclock xset xdpyinfo xdriinfo xev xfontsel xinput xkill xlsfonts xman xmessage xmodmap xprop xrandr arandr xrdb
```
```bash
Device Drivers  --->
    Graphics support  --->
        <M> Direct Rendering Manager (XFree86 4.1.0 and higher DRI support)
#        <M> ATI Radeon
#        # или
#        <M> Nouveau (nVidia) cards
#        [*]   Support for backlight control (NEW)
        <*> Lowlevel video output switch controls
        {M} Support for frame buffer devices  --->
            [*]   Enable firmware EDID
            [*]   Enable Video Mode Handling Helpers
            [*]   Enable Tile Blitting Support
        [*] Backlight & LCD device support  --->
            {M}   Lowlevel Backlight controls
        Console display driver support  --->
            [*]   Enable Scrollback Buffer in System RAM
                (1024)  Scrollback Buffer Size (in KB)
        [*] Bootup logo  --->
            [*]   Standard 224-color Linux logo
# для radeon
Device Drivers  --->
    Generic Driver Options  --->
        [*] Select only drivers that don`t need compile-time external firmware
        [*] Prevent firmware from being built
        [*]   Include in-kernel firmware blobs in kernel binary
            (radeon/PALM_me.bin radeon/PALM_pfp.bin radeon/SUMO_rlc.bin radeon/SUMO_uvd.bin) External firmware blobs to build into the kernel binary
            (/lib/firmware/) Firmware blobs root directory
        [*] Fallback user-helper invocation for firmware loading
```
> **При одном мониторе достаточно секций Files и InputClass**

Создаем /etc/X11/xorg.conf.d/01-Files.conf
```bash
cat << EOF > /usr/local/sbin/mkX11-fonts
#!/bin/sh
# Make /etc/X11/xorg.conf.d/01-Files.conf

Green="\033[0;32m"
Yellow="\033[0;33m"
None="\033[0m"
echo -e $Yellow"\nMake /etc/X11/xorg.conf.d/01-Files.conf\n"$None
echo 'Section "Files"' > /etc/X11/xorg.conf.d/01-Files.conf
mkfontdir /usr/share/fonts/misc/
echo '    FontPath    "/usr/share/fonts/misc:unscaled"' >> /etc/X11/xorg.conf.d/01-Files.conf
echo "/usr/share/fonts/misc:unscaled"
mkfontdir /usr/share/fonts/75dpi/
echo '    FontPath    "/usr/share/fonts/75dpi:unscaled"' >> /etc/X11/xorg.conf.d/01-Files.conf
echo "/usr/share/fonts/75dpi:unscaled"
mkfontdir /usr/share/fonts/100dpi/
echo '    FontPath    "/usr/share/fonts/100dpi:unscaled"' >> /etc/X11/xorg.conf.d/01-Files.conf
echo "/usr/share/fonts/100dpi:unscaled"
for i in $(find /usr/share/fonts/ -type d ! -path /usr/share/fonts/ ! -name misc ! -name "*dpi")
do
  mkfontdir "$i"
  echo "    FontPath    \"$i\"" >> /etc/X11/xorg.conf.d/01-Files.conf
  echo "$i"
done
if [[ -d /usr/lib64/xorg/modules  ]]
then
  echo '    ModulePath "/usr/lib64/xorg/modules/"' >> /etc/X11/xorg.conf.d/01-Files.conf
  echo "ModulePath /usr/lib64/xorg/modules/"
  echo  'EndSection' >> /etc/X11/xorg.conf.d/01-Files.conf
fi
echo -e $Green"\nSuccess\n"$None
EOF

chmod +x /usr/local/sbin/mkX11-fonts
/usr/local/sbin/mkX11-fonts
```
Создаем /etc/X11/xorg.conf.d/20-InputClass.conf
```bash
cat << EOF > /etc/X11/xorg.conf.d/20-InputClass.conf
Section "InputClass"
        Identifier "evdev pointer catchall"
        MatchIsPointer "on"
        MatchDevicePath "/dev/input/event*"
        Driver "evdev"
EndSection

Section "InputClass"
        Identifier "evdev keyboard catchall"
        MatchIsKeyboard "on"
        MatchDevicePath "/dev/input/event*"
        Driver "evdev"
        Option  "XkbModel" "pc105"
        Option  "XkbLayout" "us,ru(winkeys)"
        Option  "XkbOptions" "grp:caps_toggle,grp:rwin_switch,grp_led:scroll,terminate:ctrl_alt_bksp,compose:ralt"
EndSection
EOF
```
> **Далее для тонкой настройки Xorg**

Создаем /etc/X11/xorg.conf.d/05-ServerFlags.conf
```bash
cat << EOF > /etc/X11/xorg.conf.d/05-ServerFlags.conf
Section "ServerFlags"
  Option  "DefaultServerLayout"     "Layout0"
  #Option "DontVTSwitch"            "off" # Ctrl+Alt+Fn
  #Option "DontZap"                 "off" # Ctrl+Alt+Backspace
  #Option "DontZoom"                "off" # Ctrl+Alt+Keypad-Plus and Ctrl+Alt+Keypad-Minus
  Option  "DisableVidModeExtension" "off" # disables the parts of the VidMode extension
  #Option "AllowNonLocalXvidtune"   "off" # to connect from another host
  #Option "AllowMouseOpenFail"      "off" # allows the server to start up even if the mouse does not work
  Option  "BlankTime"               "10"  # screensaver time
  Option  "StandbyTime"             "30"  # DPMS time
  Option  "SuspendTime"             "60"  # suspend time
  Option  "OffTime"                 "120" # PowerOff time
  #Option "Pixmap"                  "24"  # pixmap format to use for depth 24
  #Option "NoPM"                    "on"  # Disables something to do with power management events
  #Option "Xinerama"                "on"  # Xinerama
  #Option "AIGLX"                   "on"  # AIGLX (default: on)
  #Option "DRI2"                    "on"  # enable or disable DRI2. DRI2 is disabled by default
  Option  "UseDefaultFontPath"      "on"  # Include the default font path even if other paths are specified in xorg.conf
  Option  "AutoAddDevices"          "on"  # add udev devices
  Option  "AutoEnableDevices"       "on"  # enable udev devices
  Option  "AutoAddGPU"              "on"  # If this option is disabled, then no GPU devices will be added from the udev backend
EndSection
EOF
```
Создаем /etc/X11/xorg.conf.d/10-Module.conf
```bash
cat << EOF > /etc/X11/xorg.conf.d/10-Module.conf
Section "Module"
  #Load "extmod"
  #Load "glx" # 3D layer
  #Load "dbe" # Double-Buffering Extension
  #Load "dri" # direct rendering
  #Load "dri2"
  #Load "drm"
  SubSection "extmod"
    Option "omit xfree86-dga"
  EndSubSection
  Load "freetype"
  Load "type1"
  #Load "record"
  #Load "v4l"
EndSection
EOF
```
Создаем  /etc/X11/xorg.conf.d/15-Extensions.conf
```bash
cat << EOF > /etc/X11/xorg.conf.d/15-Extensions.conf
Section "Extensions"
    Option        "Composite" "Enable"
    Option        "RENDER"    "Enable"
    Option        "RandR"     "Enable"
EndSection
EOF
```
Создаем /etc/X11/xorg.conf.d/25-Device_radeon.conf
```bash
cat << EOF > /etc/X11/xorg.conf.d/25-Device_radeon.conf
Section "Device"
    Identifier  "Device0"
    Driver      "radeon"
    Chipset     "AMD Radeon HD 6310 Graphics"
    ChipID      0x9802
    VendorName  "ATI"
    BusID       "PCI:00:01:0"
    VideoRam    65536
    Screen      0
    Option      "ZaphodHeads" "HDMI-0,HDMI-1,VGA-0"
    Option      "AccelMethod" "glamor"
EndSection

Section "Device"
    Identifier  "Device1"
    Driver      "radeon"
    Chipset     "AMD Radeon HD 6310 Graphics"
    ChipID      0x9802
    VendorName  "ATI"
    BusID       "PCI:00:01:0"
    VideoRam    65536
    Screen      0
    Option      "ZaphodHeads" "HDMI-0,HDMI-1,VGA-0"
    Option      "AccelMethod" "glamor"
EndSection
EOF
```
Создаем /etc/X11/xorg.conf.d/30-Monitor.conf
```bash
cat << EOF > /etc/X11/xorg.conf.d/30-Monitor.conf
Section "Monitor"
    Identifier  "Monitor0"
    VendorName  "BenQ"
    ModelName   "V2200Eco"
    HorizSync   24.0 - 83.0
    VertRefresh 50.0 - 76.0
    DisplaySize 475 270
    Gamma       1.0 1.0 1.0
    UseModes    "Modes0"
    Option      "DPMS"        "true"
    #Option      "Primary"     "true"
EndSection

Section "Monitor"
    Identifier  "Monitor1"
    VendorName  "LG"
    ModelName   "l1753s"
    HorizSync   30.0 - 83.0
    VertRefresh 56.0 - 75.0
    DisplaySize 338 270
    Gamma       2.0 2.0 2.0
    UseModes    "Modes0"
    Option      "DPMS"        "true"
    #Option      "Primary"     "false"
    #Option      "RightOf"     "Monitor0"
EndSection
EOF
```
создаем /etc/X11/xorg.conf.d/35-Modes.conf
```bash
cat << EOF > /etc/X11/xorg.conf.d/35-Modes.conf
Section "Modes"
  Identifier "Modes0"
  Modeline "1920x1080"   148.50 1920 2008 2052 2200  1080 1084 1089 1125 +hsync +vsync
  Modeline "1600x900"    118.96 1600 1696 1864 2128  900  901  904  932  -hsync +vsync
  Modeline "1280x1024"   108.00 1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync
  Modeline "1280x960"    108.00 1280 1376 1488 1800  960  961  964  1000 +hsync +vsync
  Modeline "1280x720"    74.44  1280 1336 1472 1664  720  721  724  746  -hsync +vsync
  Modeline "1280x720"    74.25  1280 1390 1430 1650  720  725  730  750  +hsync +vsync
  Modeline "1024x768"    65.00  1024 1048 1184 1344  768  771  777  806  -hsync -vsync
  Modeline "1024x576"    46.97  1024 1064 1168 1312  576  577  580  597  -hsync +vsync
  Modeline "640x480"     25.20  640  656  752  800   480  490  492  525  -hsync -vsync
EndSection

Section "Modes"
  Identifier "Modes1"
  Modeline "1280x1024"  108.00 1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync
  Modeline "1024x768"   65.00  1024 1048 1184 1344  768  771  777  806  -hsync -vsync
  Modeline "800x600"    40.00  800  840  968  1056  600  601  605  628  +hsync +vsync
  Modeline "640x480"    25.20  640  656  752  800   480  490  492  525  -hsync -vsync
EndSection
EOF
```
Создаем /etc/X11/xorg.conf.d/40-Screen.conf
```bash
cat << EOF > /etc/X11/xorg.conf.d/40-Screen.conf
Section "Screen"
    Identifier    "Screen0"
    Device        "Device0"
    Monitor       "Monitor0"
    DefaultDepth  24
    SubSection    "Display"
        Depth     24
        Modes     "1920x1080"
    EndSubSection
EndSection

Section "Screen"
    Identifier    "Screen1"
    Device        "Device1"
    Monitor       "Monitor1"
    DefaultDepth  24
    SubSection    "Display"
        Depth     24
        Modes     "1280x1024"
    EndSubSection
EndSection
EOF
```
Создаем /etc/X11/xorg.conf.d/45-ServerLayout.conf
```bash
cat << EOF > /etc/X11/xorg.conf.d/45-ServerLayout.conf 
Section "ServerLayout"
  Identifier  "Layout0"
  Screen      "Screen0"
  Screen      "Screen1" RightOf "Screen0"
EndSection
EOF
```
Создаем /etc/X11/xorg.conf.d/50-DRI.conf
```bash
cat << EOF > /etc/X11/xorg.conf.d/50-DRI.conf 
Section "DRI"
  Mode   0666
EndSection
EOF
```
Запускаем `startx`, проверяем log на ошибки, исправляем, добиваемся запуска.
```bash
startx
# Не запустился или Ctrl-D (из 1 терминала)
tail -n +16 /var/log/Xorg.0.log | egrep 'EE|WW'
```
### Установка fluxbox
```bash
emerge -av fluxbox fbpanel
echo 'XSESSION="fluxbox"' > /etc/env.d/90xsession
echo "exec startfluxbox" > $HOME/.xinitrc
```
### Установка Slim
```bash
emerge -av slim
```
Редактируем следующие строчки в /etc/slim.conf
```bash
session         fluxbox
default_user    serg
focus_password  yes
#auto_login      yes # По желанию
```
Меняем строчку в /etc/conf.d/xdm
```bash
DISPLAYMANAGER="slim"
```
```bash
rc-update add xdm default
```
Перезагрузка
### Установка firefox
```bash
emerge -av firefox
emerge -av adobe-flash
```
Устанавливаем addons:

- Восстановление паролей и закладок: `lastpass, xmarks`
- Безопасность: `adblock plus, AB+ pop--up addon, AB+ element hiding helper, noscript, redirect cleaner`
- Web-developing: `firebug, css usage, firebug autocompleter, firefinder, fire rainbow, firestylus, grasemonkey, stylish`
- Удобство работы: `manager session, vimperator, add to search bar, flash video downloader, evernote web-clipper, feedly, mega, gmail notifier, russian hunspell, Quick Translator
### Установка libreoffice
```bash
myuse media-libs/harfbuzz icu
emerge -av app-office/libreoffice-bin
or
emerge -av app-office/libreoffice
```
### Установка просмотрщиков
```bash
emerge -av app-text/fbreader # FB2, epub, html, rtf, txt
emerge -av app-text/zathura
emerge -av app-text/zathura-djvu # djvu
emerge -av app-text/zathura-pdf-poppler # pdf
emerge -av app-text/zathura-ps # PostScript
emerge -av media-gfx/gqview # jpeg png gif 
```
### Установка nodejs
```bash
emerge -av nodejs
```
### Настройка печати
```bash
emerge -av cups cups-filters
```
Для Samsung
```bash
emerge -av splix
```
Устанавливаем принтер
