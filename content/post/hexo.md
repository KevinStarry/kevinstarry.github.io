---
title: "Hexo"
date: 2020-11-28T22:11:47+08:00
Description: ""
Tags: ["hexo"]
Categories: []
DisableComments: false
---

GithubPage+Hexo搭建个人博客:(windows)<!--more-->  
<https://hexo.io/>   
<https://www.cnblogs.com/shwee/p/11421156.html> 
1. 注册Github账号.安装 Nodejs 和 Git (国内两个都用淘宝镜像速度快).Hexo 基于 Nodejs.下载 Nodejs 和 Git 程序并安装(注意Add to Path)，一路点 “下一步” 按默认配置完成安装。安装完成后，Win+R 输入 cmd 并打开.依次输入 node -v;npm -v ;和 git --version; 并回车,出现版本号即安装成功.

2. 执行命令: npm install -g hexo-cli (安装hexo) ;echo 'PATH="$PATH:./node_modules/.bin"' >> ~/.profile (添加node_modules到环境中);hexo init blog (初始化);cd blog ; nmp install (命令运行后会有 _config.yml 网站配置文件)

3. 本地预览:hexo server启动服务器,地址栏输入localhost:4000.

4. 更改npm配置文件：npm config set registry URL  换国内源如http://registry.npm.taobao.org ,加速访问.

5. 在Github中建立新仓库,仓库名为:用户名.github.io(固定写法).用户名为创建账户的用户名.如kevinstarry.github.io. 在Git bash中配置个人信息 git config --global user.name "你的GitHub用户名" ;git config --global user.email "你的GitHub注册邮箱" ;git config --list(查看是否生效);

6. (生成密钥) ssh-keygen -t rsa -C "youremail" (期间一路回车);系统会提示生成了ssh.正常应该是在用户目录.ssh文件夹下有id_rsa和id_rsa.pub.将公钥上传到github的密钥管理中.私钥放在电脑上.部署完密钥后,就再Git bash中输入:ssh -T git@github.com;ssh连接GitHub.会提示连接成功.

7. 最后部署到GitHub:找到之前说的_config.yml文件,打开并找到deploy项目,照下面格式写.yml语法严格:号后面有空格;repo:后面为项目地址链接最好用ssh链接不要用https协议.
    deploy:
        type: git
        repo: https://github.com/kevinstarry/kevinstarry.github.io
        branch: master
8. npm install hexo-deployer-git --save(安装部署);hexo clean;hexo generate;hexo deploy(清缓存,生成,部署到GitHub,都可以缩写如:hexo d);部署的时候可能需要输入你的GitHub用户名(邮箱地址)和密码.

提高:https://www.cnblogs.com/shwee/p/11421156.html (不错的文章)

写文章:在博客根目录下右键打开git bash，安装一个扩展npm i hexo-deployer-git。然后输入hexo new post "article title"或者hexo n "博客名字"，新建一篇文章。然后打开_posts的目录，可以发现下面多了一个文件夹和一个.md文件，一个用来存放你的图片等数据，另一个就是你的文章文件啦。你可以会直接在vscode里面编写markdown文件，可以实时预览，也可以用用其他编辑md文件的软件的工具编写。编写完markdown文件后，根目录下输入hexo g生成静态网页，然后输入hexo s可以本地预览效果，最后输入hexo d上传到github上。这时打开你的github.io主页就能看到发布的文章啦。
    
Error:  
1.nodejs安装失败.  以管理员身份运行cmd命令,在cmd窗口输入下载的node.js安装包所在位置（例：msiexec /package D：\node-v8.11.3-x64.msi）  

2.npm命令无效.手动安装npm (下载npm 的安装包,解压到nodejs下面的node_modules)windows应该在C:\Program Files\Nodejs,配置npm 的环境变量.  

3.hexo命令无效,请在Git bash中使用,能Git bash的都在Git bash中使用.
  