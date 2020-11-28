---
title: "google_blogger"
date: 2020-11-28T22:19:38+08:00
Description: ""
Tags: ["google blogger"]
Categories: []
DisableComments: false
---
一些关于Google Blogger的学习心得<!--more-->  
域名部分:  
Blogger不支持裸域名重定向(二级域名),可以使用www.a.com这种,如果要a.com定向到www.a.com,要在dns中按照Google提示加四个解析ip对应四个该二级域名的三级域名,但是国内Google被屏蔽.  

DNS解析中@两个域名一个是Google服务地址,另一个估计是验证域名所有权的.

优化国内访问:  
[主要参考](https://blog.iljw.me/2016/09/blogger.html)  
[备用参考](https://www.williamlong.info/cat/webmaster.html)

1. 禁用 Blogger 模板 CSS 样式文件加载
```
<html b:css='false'  b:version='2' class='v2' expr:dir='data:blog.languageDirection' expr:lang='data:blog.locale' xmlns='http://www.w3.org/1999/xhtml' xmlns:b='http://www.google.com/2005/gml/b' xmlns:data='http://www.google.com/2005/gml/data' xmlns:expr='http://www.google.com/2005/gml/expr'>
```
2. 继续屏蔽 CSS、JS 文件加载  
   
将 </head> 替换为  &lt;/head&gt;&lt;!--</head>--&gt;  
将 </body> 替换为  &lt;!--</body>--&gt;&lt;/body&gt;  
从而屏蔽
```
<script src='https://apis.google.com/js/plusone.js' type='text/javascript'></script>
<script type="text/javascript" src="https://www.blogger.com/static/v1/widgets/2657172006-widgets.js"></script>
```
3. 删除 Quickedit 按钮  

我们以博主身份访问我们的博客时，对于一些模板，会出现网页一些区域会出现一个小扳手或者铅笔的图标，方便我们调整博客的外观。在我们修改模板后，无论是谁访问网站都会看到上面的小扳手，它提供调整功能十分有限，删除快速编辑按钮还能进一步提高博客打开速度，所以我建议把去掉。在模板文件里，找到 <b:include name='quickedit'/> 删去即可。  

4. 将所需要的 CSS、JS、图片文件资源等放在国内空间.主要是存储博客的图片、Javascript、CSS 文件及外链调用。  

5. 静态资源 CDN 加速。  
静态资源 CDN 公共库是指一些服务商将我们常用的 JavaScript 库存放到网上，方便开发者直接调用，并且还对其提供 CDN 加速，这样一来可以让用户加速访问这些资源，二来还可节约自己服务器的流量.如果你有些 JS 文件，如 jquery.js 库，你可以引用他们的链接，而不必上传到自己的存储空间中了。  

6. 评论系统  
Blogger 自带的评论自然无法正常使用,Gitalk评论插件项目托管在Github.https://blog.iljw.me/2019/02/blogger-gitalk.html  

Blogger设置:
1.站点图标切回到blogger旧版本找到布局里面有.挑选一个喜欢的主题。  
<http://www.mybloggerthemes.com/>   
<https://newbloggerthemes.com/>    
<https://btemplates.com/>   
<https://gooyaabitemplates.com/>  

BloggerSEO优化:  
在Blogger模版的HTML代码，搜索下面这行文字.
```
<title><data:blog.pageTitle/></title>
```
然后搜索到的HTML代码，使用下面的这段HTML码替换，然后保存主题。
```
<title>
<b:if cond='data:blog.url == data:blog.homepageUrl'>
<data:blog.pageTitle/>
<b:else/>
<data:blog.pageName/>-<data:blog.title/>
</b:if>
</title>
```
Blogger问题:  
1.上述修改会有一些副作用，一个副作用是“布局”功能会出现显示异常，将第一步修改恢复回去之后会正常。其次对于某些模板会出现内容不居中的情况，可以在“布局”里添加HTML/JavaScript组件，写入如下代码:
```
    <style type="text/css">
    body {max-width: 960px;margin: auto;}
    .column-center-outer,.column-left-outer,.column-right-outer{position:relative;float:left;_display:inline;_overflow:hidden}
    .column-center-outer{width:100%}
    .column-left-outer{margin-left:-100%}
    </style>
```
BloggerInit设置:  
找到设置->博文:关闭评论;语言和格式:稍微调整下;搜索偏好设置优化下SEO;用户设置启用草稿模式.



