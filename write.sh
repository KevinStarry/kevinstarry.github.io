#!/usr/bin/bash
echo "输入文章名称："
read aritcal
if [ ! -n "$aritcal" ]; then
exit
else 
    hugo new post/"$artical".md
fi
echo "文章名是：$artical"