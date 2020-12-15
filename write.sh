#!/usr/bin/bash
echo "文章名称："
read aritcal

echo "文章类型：1.技术教程 2.个人情绪"
read type
if [ ! -n "$type" ];then
    type="post"
fi
if ((${type}=="2"));then
    type="emotion"
else
    type="post"
fi

if [ -n "$aritcal" ]
then
    echo "======================================"
    hugo new ${type}/${aritcal}.md
fi
