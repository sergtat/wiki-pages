# Твики Build.prop.

```conf
# Твики Рендеринга
debug.composition.type=c2d
debug.egl.hw=1
debug.enabletr=true
debug.overlayui.enable=1
debug.qctwa.preservebuf=1
debug.performance.tuning=1
debug.sf.hw=1
dev.pm.dyn_samplingrate=1
hw3d.force=1
ro.config.disable.hw_accel=false
ro.fb.mode=1
ro.sf.compbypass.enable=0
ro.vold.umsdirtyratio=20
persist.sys.composition.type=c2d
persist.sys.ui.hw=1
video.accelerate.hw=1

# Вкл ускорения GPU
debug.sf.hw=1
video.accelerate.hw=1
debug.performance.tuning=1
persist.sys.composition.type=gpu
debug.qc.hardware=true
debug.qctwa.statusbar=1
debug.qctwa.preservebuf=1
debug.egl.profiler=1
debug.egl.hw=1
debug.composition.type=gpu
hw3d.force=1
ro.product.gpu.driver=1
persist.sys.use_16bpp_alpha=1
persist.sampling_profiler=0
hwui.render_dirty_regions=false
hwui.disable_vsync=true

# Увеличение времени работы АКБ, не в ущерб скорости
dalvik.vm.checkjni=false
dalvik.vm.execution-mode=int:jit
pm.sleep_mode=1
power.saving.mode=1
power_supply.wakeup=enable
profiler.force_disable_err_rpt=1
profiler.force_disable_ulog=1
ro.config.hw_fast_dormancy=1
ro.config.hw_power_saving=1
ro.mot.eri.losalert.delay=1000
ro.ril.disable.power.collapse=0
ro.ril.power_collapse=1
ro.vold.umsdirtyratio=20
wifi.supplicant_scan_interval=497

# ВКЛ ADB сервиса
persist.service.adb.enable=1

# Вкл датчика контроля сна
ro.ril.sensor.sleep.control=1

# Ускорение загрузки вкл тел
persist.sys.shutdown.mode=hibernate
ro.config.hw_fast_dormancy=1
ro.config.hw_quickpoweron=true

# Уменьшение времени дозвона
ro.telephony.call_ring.delay=0

# Разрешение на чистку активов для освобождения больше RAM
persist.sys.purgeable_assets=1

# Больше свободной памяти и скорости загрузки приложений
dalvik.vm.dexopt-flags=m=y

# Больше РАМ
#persist.sys.purgeable_assets=1
persist.service.pcsync.enable=0
persist.service.lgospd.enable=0

# Увеличение общей производительности
debug.performance.tuning=1

# Увеличение некоторой производительности
ro.secure=0
persist.sys.use_16bpp_alpha=1
ro.product.gpu.driver=1
ro.min.fling_velocity=8000

# Уменьшить количество времени черного экрана в работе датчика близости
ro.lge.proximity.delay=15
mot.proximity.delay=15
ro.ril.enable.amr.wideband=1

# ТАЧ
touch.presure.scale=0.001

# Быстрее скроллинг и отзывчивость
windowsmgr.max_events_per_sec=150
ro.max.fling_velocity=12000
ro.min.fling_velocity=8000
ro.min_pointer_dur=8

# Плавность интерйефса
persist.service.lgospd.enable=0
persist.service.pcsync.enable=0
ro.ril.enable.a52=1
ro.ril.enable.a53=0

# Улучшалка для фото и видео
ro.media.dec.jpeg.memcap=8000000
ro.media.enc.hprof.vid.bps=8000000
ro.media.enc.hprof.vid.fps=65

# Улучшение вспышки
ro.media.capture.flash=led
ro.media.capture.flashMinV=3300000
ro.media.capture.torchIntensity=40
ro.media.capture.flashIntensity=70
ro.media.capture.maxres=8m
ro.media.capture.fast.fps=4
ro.media.capture.slow.fps=120
ro.media.panorama.defres=3264x1840
ro.media.panorama.frameres=1280x720
ro.camcorder.videoModes=true
ro.media.enc.hprof.vid.fps=65

# Увеличение шагов регулировки громкости во время вызова
ro.config.vc_call_steps=20

# Улучшение качества звука во время разговора
ro.ril.enable.amr.wideband=1

# Форсим Launcher в память
ro.HOME_APP_ADJ=1

# Откл проверки байткода
dalvik.vm.verify-bytecode=false
dalvik.vm.dexopt-flags=m=y,v=n,o=v
#dalvik.vm.dexopt-flags=m=y,v=n,o=v,u=n

# Улучшает камеру и видео
ro.media.panorama.defres=3264x1840
ro.media.panorama.frameres=1280x720
ro.camcorder.videoModes=true
ime_extend_row_keyboard=true
ime_onehand_keyboard=true
ime_split_keyboard=true
ime_vibration_pattern=0:60

# Кач-во JPG 100%
ro.media.enc.jpeg.quality=100

# Выкл лог и репорт ошибок
profiler.force_disable_err_rpt=1
profiler.force_disable_ulog=1

# Откл отправка сообщеений об использовании данных
ro.config.nocheckin=1

# Фиксит некоторый FC
ro.kernel.android.checkjni=0

# Разные твики для скорости
ro.config.hw_menu_unlockscreen=false
persist.sys.use_dithering=0
persist.sys.purgeable_assets=1
dalvik.vm.dexopt-flags=m=y
ro.mot.eri.losalert.delay=1000

# Лучший броузинг и скорость закачки
net.tcp.buffersize.default=4096,87380,256960,4096, 16384,256960
net.tcp.buffersize.wifi=4096,87380,256960,4096,163 84,256960
net.tcp.buffersize.umts=4096,87380,256960,4096,163 84,256960
net.tcp.buffersize.gprs=4096,87380,256960,4096,163 84,256960
net.tcp.buffersize.edge=4096,87380,256960,4096,163 84,256960
net.tcp.buffersize.hspa=6144,87380,524288,6144,163 84,262144
net.tcp.buffersize.lte=524288,1048576,2097152,5242 88,1048576,2097152
net.tcp.buffersize.hsdpa=6144,87380,1048576,6144,8 7380,1048576
net.tcp.buffersize.evdo_b=6144,87380,1048576,6144, 87380,1048576

# Твики медиачасти и видеостриминга
media.stagefright.enable-player=true
media.stagefright.enable-meta=true
media.stagefright.enable-scan=true
media.stagefright.enable-http=true
media.stagefright.enable-aac=true
media.stagefright.enable-qcp=true
media.stagefright.enable-record=true

# Твики 3G
ro.ril.hsxpa=2
ro.ril.gprsclass=10
ro.ril.hep=1
ro.ril.enable.dtm=1
ro.ril.hsdpa.category=10
ro.ril.enable.a53=1
ro.ril.enable.3g.prefix=1
ro.ril.htcmaskw1.bitmask=4294967295
ro.ril.htcmaskw1=14449
ro.ril.hsupa.category=7
ro.ril.hsdpa.category=10
ro.ril.enable.a52=1
ro.ril.set.mtu1472=1
persist.cust.tel.eons=1
ro.config.hw_fast_dormancy=1

# GOOGLE DNS
net.dns1=8.8.8.8
net.dns2=8.8.4.4
net.rmnet0.dns1=8.8.8.8
net.rmnet0.dns2=8.8.4.4
net.ppp0.dns1=8.8.8.8
net.ppp0.dns2=8.8.4.4
net.wlan0.dns1=8.8.8.8
net.wlan0.dns2=8.8.4.4
net.eth0.dns1=8.8.8.8
net.eth0.dns2=8.8.4.4
net.gprs.dns1=8.8.8.8
net.gprs.dns2=8.8.4.4

# CRT твики
persist.sys.screen_off=crt
persist.sys.screen_on=none

# Поддержка для IPV4 и IPV6
persist.telephony.support.ipv6=1
persist.telephony.support.ipv4=1

# Еще че то
ro.com.google.locationfeatures=1
ro.com.google.networklocation=1
htc.audio.alt.enable=0
htc.audio.hac.enable=0

# Твики Wi Fi и беспроводных модулей
net.ipv4.ip_no_pmtu_disc=0
net.ipv4.route.flush=1
net.ipv4.tcp_ecn=0
net.ipv4.tcp_fack=1
net.ipv4.tcp_mem=187000 187000 187000
net.ipv4.tcp_moderate_rcvbuf=1
net.ipv4.tcp_no_metrics_save=1
net.ipv4.tcp_rfc1337=1
net.ipv4.tcp_rmem=4096 39000 187000
net.ipv4.tcp_sack=1
net.ipv4.tcp_timestamps=1
net.ipv4.tcp_window_scaling=1
net.ipv4.tcp_wmem=4096 39000 18700
wifi.supplicant_scan_interval=180

# Ускорение видео
video.accelerate.hw=1
debug.sf.hw=1
debug.performance.tuning=1
debug.egl.profiler=1 # Measure rendering time in adb shell dumpsys gfxinfo
debug.egl.hw=1
debug.composition.type=gpu # Disable hardware overlays and use GPU for screen compositing

# Выкл логкат
logcat.live=disable

# Улучшает качво изобравжения
persist.sys.use_dithering=1

# Твики Qualcom
com.qc.hardware=1
debug.qc.hardware=true
debug.qctwa.preservebuf=1
debug.qctwa.statusbar=1

# Игро-твики
persist.sys.NV_FPSLIMIT=60
persist.sys.NV_POWERMODE=1
persist.sys.NV_PROFVER=15
persist.sys.NV_STEREOCTRL=0
persist.sys.NV_STEREOSEPCHG=0
persist.sys.NV_STEREOSEP=20
persist.sys.purgeable_assets=1

# Уменьшает время загрузки
ro.config.hw_quickpoweron=true

# добавляет ротацию на 270 градусов
windowsmgr.support_rotation_270=true

# Мульти юзер
fw.max_users=30
fw.show_multiuserui=1

# Бас аудио для Лоллипоп
tunnel.decode=false
lpa.use-stagefright=false
persist.sys.media.use-awesome=1
sys.keep_app_1=com.bel.android.dspmanager
ro.audio.samplerate=48000
ro.audio.pcm.samplerate=48000
af.resampler.quality=255
af.resample=52000

# Аудио твики
persist.audio.fluence.mode=endfire
persist.audio.hp=true
persist.audio.vr.enable=false
persist.audio.handset.mic=digital
persist.audio.lowlatency.rec=false

# Моды ZRAM
persist.service.zram=0
ro.zram.default=0

# Твики интерфейса
persist.sys.ui.hw=1
view.scroll_friction=10
debug.composition.type=gpu
debug.performance.tuning=1
```
