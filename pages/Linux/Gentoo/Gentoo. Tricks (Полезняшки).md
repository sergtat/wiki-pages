# Gentoo. Tricks (Полезняшки)
```bash
# первая сборка toolchain
emerge linux-headers glibc binutils gcc-config gcc

# выбрать новый gcc если он установился в новый слот
gcc-config имя_или_номер_нового_gcc
# см. "gcc-config -l"
source /etc/profile

# компиляция toolchain с созданием бинарных пакетов
emerge -b glibc binutils gcc portage
# не компилить glibc, binutils и gcc
emerge -bke system
# не компилить предыдущие пакеты (включая system)
emerge -bke world
# пересборка дров после обновления иксов
emerge -1 $(qlist -I -C x11-drivers/)

# посмотреть какие файлы в /usr/portage/distfiles уже не будут использоваться
eclean -p distfiles
# очистить distfiles от устаревших исходников
eclean distfiles
# Чтобы перенести из distfiles все устаревшие исходники
mv `eclean -p -q -C distfiles` /somedir/distfiles-old/

# чистка памяти от кеша
echo 3 > /proc/sys/vm/drop_caches

# вывод списка всего что установленно из оверлеев
eix -Jc

# проверка мира
emaint --check world

# Перенос пакета из installed в world:
emerge —noreplace <package>

# Проверка portage на наличие ошибок (broken deps, удаленные из дерева но существующие в системе пакеты, испорченная metadata или manifest и т.д.):
emaint —check all

# Удаление старых distfiles (версии, не установленные в системе):
eclean distfiles

# Удаление старых бинарных пакетов:
eclean packages

# Пересборка пакетов, собранных со старыми версиями библиотек:
emerge @preserved-rebuild

# Добавление пакета в систему без установки (обман зависимостей, опасно):
echo «=category/package-version» >> /etc/portage/package.provided

# Отобразить все пакеты wold, пропутсив system (только нестабильный portage):
emerge -av @installed-@system

# Сбросить историю (—resume):
emaint cleanresume
```
