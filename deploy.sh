#!/usr/bin/bash
read -p "输入本次提交的注释:" commit
if [ ! -n "$commit" ]; then
commit="."
fi

hugo  && git add .  && git commit -m "$commit"  && git push

cd public/ && git commit -m "." && git push origin master:master
