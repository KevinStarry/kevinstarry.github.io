#!/usr/bin/bash
# 注释部分
read -p "输入本次提交的注释:" commit
if [ ! -n "$commit" ]; then
commit="."
fi
# 推送hugo项目
hugo  && git add .  && git commit -m "$commit"  && git push
# 推送生成的public文件
cd public/ && git commit -m "." && git push origin master:public
