#!/usr/bin/bash
# 在空文件夹下Git Bash窗口执行下面的这句 克隆命令。完成后执行当前文件，即./init.sh
# git clone git@github.com:KevinStarry/kevinstarry.github.io.git ./

cd public/ && git init && git remote add origin git@github.com:KevinStarry/kevinstarry.github.io.git && git pull origin public
