---
title: "hugo"
date: 2020-11-27T22:16:02+08:00
Description: ""
Tags: []
Categories: []
DisableComments: false
---
极客精神大概就是一种折腾吧，之前使用Hexo搭建的网站，总觉得使用node.js显得十分麻烦，兜兜转转发现了Hugo。<!--more--> 网上教程很多，但是对于一个概念都没有树立的人来说，有些显而易见的东西实际上对于没有概念的人而言就有些难了。  
在参考<https://gohugo.io/getting-started/quick-start/>官方教程进行创建中卡在了主题部分，虽然现在也不确定是不是像我这样子使用，但是至少我应该算是摸到了些门路。[主题的链接](https://themes.gohugo.io/theme/anatole/)。
# Hugo配置使用
1. Windows10系统，在GitHub，Hugo项目上直接下载Hugo.zip压缩包，里面只有一个hugo.exe，剩下的两个文件没有用到。我把hugo.exe的目录添加到了系统环境变量path中，以方便power shell 终端使用。  
2. hugo new site quickstart。在Git Bash窗口下执行这个命令就会在当前路径下生成一个quickstart文件夹，里面包含很多空文件夹，也就是目录结构。其中有一个themes（主题）文件夹。在这个文件夹下，去hugo官网主题下找喜欢的主题，拷贝到目录下即可。一般在该主题文件中会有exampleSite文件夹。我的做法是把这个文件夹里的文件全部复制到quickstart目录下，覆盖原来的文件夹。
3. hugo。主题找好以后回到quickstart目录下，执行hugo，这时候会生成一个public文件夹。这个文件夹就是我们要放到GitHub上的展示页面的，换句话说，quickstart文件夹是整个项目，而public文件夹下则是生成的静态文件，也就是我们的网站。
4. hugo new post/first-post.md。在quickstart目录下，执行命令，这个命令会在content文件夹下的post文件夹下创建一个first-post.md文件，这就是创建文件的方式了，如果该主题的content文件夹下是posts目录那么命令自然也就改为hugo new posts/first-post.md。
# Git的频繁使用
在整个学习探索使用的过程中，频繁的使用到的Git命令。
在quickstart目录下  
git init  
git remote add origin git@github.com:KevinStarry/kevinstarry.github.io.git  
git add -A   这是旧的命令，新版本的Git可以使用git add .这种方式使用。
git commit -m "."  
git push -u origin master  
命令形式：git push <远程主机名> <本地分支名>:<远程分支名> 。解释说明：1.将本地仓库的文件推送到远程分支 2.如果远程仓库没有这个分支，会新建一个同名的远程分支。3.如果省略远程分支名，则表示两者同名。 git push origin master:master   
***
在生成的public目录下
git init  
git remote add origin git@github.com:KevinStarry/kevinstarry.github.io.git    
git add -A   
git commit -m "."   
git push origin master:public 这里master和public之间不能有空格   
这样的目的是在GitHub项目中的master分支保存的是整个项目文件，而分支public则是作为页面展示。在GitHub Pages设置中将public设置为Page页面。 
# 其他问题
晚上睡觉的时候都还记得有几个问题，但是醒来就全忘了，那就这样吧。新电脑先把远程的master和public仓库拉取到本地，不然直接提交是会报错的。 因为每次提交都很麻烦，所以写了一组命令，在quickstart目录下写了一个deploy.sh的脚本，内容如下：
```bash
hugo && git add . && git commit -m "." && git push  &&  cd public/ && git add . && git commit -m "." && git push origin master:public
```
