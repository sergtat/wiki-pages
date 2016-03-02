# Если висит куча соединений TIME_WAIT
```bash
# echo 1 > /proc/sys/net/ipv4/tcp_tw_recycle
```
можно воспользоваться cutter [port]: он грохает открытые сокеты.
```bash
$ cutter 127.0.0.1 1234
```
