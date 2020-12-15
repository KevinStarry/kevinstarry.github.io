#!/usr/bin/bash
git status

read -p "输入本次提交的注释:" commit
if [ ! -n "$commit" ]; then
    commit="."
fi
echo "==============================="
hugo  && git add .  && git commit -m "$commit"  && git push
echo "==============================="
cd public/ && git add . && git commit -m "." && git push origin master:public
