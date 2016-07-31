#!/bin/bash
set -e

cd ..
git pull
git add .
git commit -m 'Update'
git push
ssh www@server "cd ~/repo/sites/nnm_wiki2/public && git pull"
