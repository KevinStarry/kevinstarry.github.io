#!/usr/bin/bash

#删除原来的public
rm -rf public

#写注释的部分
read -p "输入本次提交的注释（如果为空则默认为.) ：" commit
if [ ! -n "$commit" ]; then
commit="."
fi
echo "提交hugo项目"
hugo  && git add .  && git commit -m "$commit"  && git push
echo "hugo项目提交完毕"
echo "====================================================="
echo "把生成的public文件部署到网站上去"
# 强制推送，会覆盖原有的项目 
cd public/ && git init && git remote add origin git@github.com:KevinStarry/kevinstarry.github.io.git && git add . && git commit -m "." && git push -f origin master:master
echo "命令执行完毕"