#!/usr/bin/bash
echo "输入文章名称："
read aritcal
type="post"
echo "输入文章类型：1.技术教程 2.个人情绪"
read num 
if ((2==${num}))
then
    type="emotion"
fi

if [ -n "$aritcal" ]
then
    echo "======================================"
    hugo new ${type}/${aritcal}.md
    echo "新文章名称（new post name is)：$aritcal"
fi
