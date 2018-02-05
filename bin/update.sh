#!/bin/bash
set -e

cd ..
git pull
git add .
git commit -m 'Update'
git push
# ssh www@server "cd ~/repo/sites/wiki/public && git pull"
# ssh serg@server "sudo systemctl reload nginx.service"
