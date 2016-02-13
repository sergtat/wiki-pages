# Запуск Node.js на 80 или 443 порту.

- sudo apt-get install libcap2-bin
- sudo setcap cap_net_bind_service=+ep /usr/local/bin/node
- Ta da! This allows your node app to run on port 80 without complaining.
