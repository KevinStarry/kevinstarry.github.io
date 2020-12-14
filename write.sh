#!/usr/bin/bash
echo "输入文章名称："
read aritcal
if [ -n "$aritcal" ]
then
    hugo new post/${aritcal}.md
    echo "新文章名称（new post name is)：$aritcal"
fi
