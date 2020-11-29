#!/usr/bin/bash
echo "显示工作目录和暂存区的状态"
git status
echo "==============================="
read -p "输入本次提交的注释:" commit
if [ ! -n "$commit" ]; then
commit="."
fi
# 推送hugo项目
hugo  && git add .  && git commit -m "$commit"  && git push
# 推送生成的public文件
cd public/ && git add . && git commit -m "." && git push origin master:public
