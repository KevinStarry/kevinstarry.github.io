---
title: "V2ray配置"
date: 2020-12-09T21:41:53+08:00
Description: ""
Tags: []
Categories: []
DisableComments: false
---
v2ray网站伪装的一些关键性配置文件示例  

之所以记录下这些来，目的是为了如果万一脚本无法使用的时候，可以自己手动配置，不过概率应该不高，记录下来做个参考，里面的域名隐私信息都已近清楚了，当然其他的一些配置也可能需要手动修改，如用UUID生成器生成自己的ID，而location/afe99760/ 主要用于重定向，不能用来处理正常的请求，应该是随便写一个，但是保证一致性即可。

首先是三个路径:   
1. /etc/nginx/conf/conf.d/v2ray.conf 这个路径下的文件是nginx服务器伪装配置，称为文件1。
2. /etc/v2ray/config.json 这个是v2ray服务器端的文件地址，称为文件2。
3. D:\Program Files\v2rayN-Core\config.json 本地文件配置地址，称为文件3。

直接展示三个文件的内容：

文件1 nginx
~~~ 
    server {
	listen 443 ssl http2;
        ssl_certificate       /data/v2ray.crt;
        ssl_certificate_key   /data/v2ray.key;
        ssl_protocols         TLSv1.3;
        ssl_ciphers           TLS13-AES-256-GCM-SHA384:TLS13-CHACHA20-POLY1305-SHA256:TLS13-AES-128-GCM-SHA256:TLS13-AES-128-CCM-8-SHA256:TLS13-AES-128-CCM-SHA256:EECDH+CHACHA20:EECDH+CHACHA20-draft:EECDH+ECDSA+AES128:EECDH+aRSA+AES128:RSA+AES128:EECDH+ECDSA+AES256:EECDH+aRSA+AES256:RSA+AES256:EECDH+ECDSA+3DES:EECDH+aRSA+3DES:RSA+3DES:!MD5;
	server_name example.com; #此处改为伪装域名地址
        index index.html index.htm;
        root  /home/wwwroot/3DCEList;
        error_page 400 = /400.html;
	location /afe99760/
        {
        proxy_redirect off;
	proxy_pass http://127.0.0.1:25792;
        proxy_http_version 1.1;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $http_host;
        }
}
    server {
        listen 80;
	server_name example.com; #此处改为伪装域名地址
	return 301 https://example.com$request_uri; #此处改为伪装域名地址
    }

~~~

文件2 服务器端
~~~
{
  "log": {
        "access": "/var/log/v2ray/access.log",
        "error": "/var/log/v2ray/error.log",
        "loglevel": "warning"
    },
  "inbounds": [
    {
    "port":25792,
      "listen": "127.0.0.1", 
      "tag": "vmess-in", 
      "protocol": "vmess", 
      "settings": {
        "clients": [
          {
	  "id":"33e0f314-8589-4a7f-9524-f2e9af3beb54",
	  "alterId":4
          }
        ]
      }, 
      "streamSettings": {
        "network": "ws", 
        "wsSettings": {
	  "path":"/afe99760/"
        }
      }
    }
  ], 
  "outbounds": [
    {
      "protocol": "freedom", 
      "settings": { }, 
      "tag": "direct"
    }, 
    {
      "protocol": "blackhole", 
      "settings": { }, 
      "tag": "blocked"
    }
  ], 
  "dns": {
    "servers": [
      "https+local://1.1.1.1/dns-query",
	  "1.1.1.1",
	  "1.0.0.1",
	  "8.8.8.8",
	  "8.8.4.4",
	  "localhost"
    ]
  },
  "routing": {
    "domainStrategy": "AsIs",
    "rules": [
      {
        "type": "field",
        "inboundTag": [
          "vmess-in"
        ],
        "outboundTag": "direct"
      }
    ]
  }
}
~~~

文件3 本地配置
~~~
{
  "policy": {
    "system": {
      "statsInboundUplink": true,
      "statsInboundDownlink": true
    }
  },
  "log": {
    "access": "",
    "error": "",
    "loglevel": "warning"
  },
  "inbounds": [
    {
      "tag": "proxy",
      "port": 10808,
      "listen": "0.0.0.0",
      "protocol": "socks",
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      },
      "settings": {
        "auth": "noauth",
        "udp": true,
        "ip": null,
        "address": null,
        "clients": null,
        "decryption": null
      },
      "streamSettings": null
    },
    {
      "tag": "api",
      "port": 9211,
      "listen": "127.0.0.1",
      "protocol": "dokodemo-door",
      "sniffing": null,
      "settings": {
        "auth": null,
        "udp": false,
        "ip": null,
        "address": "127.0.0.1",
        "clients": null,
        "decryption": null
      },
      "streamSettings": null
    }
  ],
  "outbounds": [
    {
      "tag": "proxy",
      "protocol": "vmess",
      "settings": {
        "vnext": [
          {
            "address": "example.com", #此处改为伪装域名地址
            "port": 443,
            "users": [
              {
                "id": "33e0f314-8589-4a7f-9524-f2e9af3beb54",
                "alterId": 4,
                "email": "t@t.tt",
                "security": "auto",
                "encryption": null,
                "flow": null
              }
            ]
          }
        ],
        "servers": null,
        "response": null
      },
      "streamSettings": {
        "network": "ws",
        "security": "tls",
        "tlsSettings": {
          "allowInsecure": false,
          "serverName": "example.com" #此处改为伪装域名地址
        },
        "tcpSettings": null,
        "kcpSettings": null,
        "wsSettings": {
          "connectionReuse": true,
          "path": "/afe99760/",
          "headers": {
            "Host": "example.com" #此处改为伪装域名地址
          }
        },
        "httpSettings": null,
        "quicSettings": null,
        "xtlsSettings": null
      },
      "mux": {
        "enabled": false,
        "concurrency": -1
      }
    },
    {
      "tag": "direct",
      "protocol": "freedom",
      "settings": {
        "vnext": null,
        "servers": null,
        "response": null
      },
      "streamSettings": null,
      "mux": null
    },
    {
      "tag": "block",
      "protocol": "blackhole",
      "settings": {
        "vnext": null,
        "servers": null,
        "response": {
          "type": "http"
        }
      },
      "streamSettings": null,
      "mux": null
    }
  ],
  "stats": {},
  "api": {
    "tag": "api",
    "services": [
      "StatsService"
    ]
  },
  "dns": null,
  "routing": {
    "domainStrategy": "IPIfNonMatch",
    "rules": [
      {
        "type": "field",
        "port": null,
        "inboundTag": [
          "api"
        ],
        "outboundTag": "api",
        "ip": null,
        "domain": null
      },
      {
        "type": "field",
        "port": null,
        "inboundTag": null,
        "outboundTag": "proxy",
        "ip": null,
        "domain": [
          "geosite:google",
          "geosite:github",
          "geosite:netflix",
          "geosite:steam",
          "geosite:telegram",
          "geosite:tumblr",
          "geosite:speedtest",
          "geosite:bbc",
          "domain:gvt1.com",
          "domain:textnow.com",
          "domain:twitch.tv",
          "domain:wikileaks.org",
          "domain:naver.com",
          "domain:twitter.com",
          "domain:onedrive.live.com"
        ]
      },
      {
        "type": "field",
        "port": null,
        "inboundTag": null,
        "outboundTag": "proxy",
        "ip": [
          "91.108.4.0/22",
          "91.108.8.0/22",
          "91.108.12.0/22",
          "91.108.20.0/22",
          "91.108.36.0/23",
          "91.108.38.0/23",
          "91.108.56.0/22",
          "149.154.160.0/20",
          "149.154.164.0/22",
          "149.154.172.0/22",
          "74.125.0.0/16",
          "173.194.0.0/16",
          "172.217.0.0/16",
          "216.58.200.0/24",
          "216.58.220.0/24",
          "91.108.56.116",
          "91.108.56.0/24",
          "109.239.140.0/24",
          "149.154.167.0/24",
          "149.154.175.0/24"
        ],
        "domain": null
      },
      {
        "type": "field",
        "port": null,
        "inboundTag": null,
        "outboundTag": "direct",
        "ip": null,
        "domain": [
          "domain:12306.com",
          "domain:51ym.me",
          "domain:52pojie.cn",
          "domain:8686c.com",
          "domain:abercrombie.com",
          "domain:adobesc.com",
          "domain:air-matters.com",
          "domain:air-matters.io",
          "domain:airtable.com",
          "domain:akadns.net",
          "domain:apache.org",
          "domain:api.crisp.chat",
          "domain:api.termius.com",
          "domain:appshike.com",
          "domain:appstore.com",
          "domain:aweme.snssdk.com",
          "domain:bababian.com",
          "domain:battle.net",
          "domain:beatsbydre.com",
          "domain:bet365.com",
          "domain:bilibili.cn",
          "domain:ccgslb.com",
          "domain:ccgslb.net",
          "domain:chunbo.com",
          "domain:chunboimg.com",
          "domain:clashroyaleapp.com",
          "domain:cloudsigma.com",
          "domain:cloudxns.net",
          "domain:cmfu.com",
          "domain:culturedcode.com",
          "domain:dct-cloud.com",
          "domain:didialift.com",
          "domain:douyutv.com",
          "domain:duokan.com",
          "domain:dytt8.net",
          "domain:easou.com",
          "domain:ecitic.net",
          "domain:eclipse.org",
          "domain:eudic.net",
          "domain:ewqcxz.com",
          "domain:fir.im",
          "domain:frdic.com",
          "domain:fresh-ideas.cc",
          "domain:godic.net",
          "domain:goodread.com",
          "domain:haibian.com",
          "domain:hdslb.net",
          "domain:hollisterco.com",
          "domain:hongxiu.com",
          "domain:hxcdn.net",
          "domain:images.unsplash.com",
          "domain:img4me.com",
          "domain:ipify.org",
          "domain:ixdzs.com",
          "domain:jd.hk",
          "domain:jianshuapi.com",
          "domain:jomodns.com",
          "domain:jsboxbbs.com",
          "domain:knewone.com",
          "domain:kuaidi100.com",
          "domain:lemicp.com",
          "domain:letvcloud.com",
          "domain:lizhi.io",
          "domain:localizecdn.com",
          "domain:lucifr.com",
          "domain:luoo.net",
          "domain:mai.tn",
          "domain:maven.org",
          "domain:miwifi.com",
          "domain:moji.com",
          "domain:moke.com",
          "domain:mtalk.google.com",
          "domain:mxhichina.com",
          "domain:myqcloud.com",
          "domain:myunlu.com",
          "domain:netease.com",
          "domain:nfoservers.com",
          "domain:nssurge.com",
          "domain:nuomi.com",
          "domain:ourdvs.com",
          "domain:overcast.fm",
          "domain:paypal.com",
          "domain:paypalobjects.com",
          "domain:pgyer.com",
          "domain:qdaily.com",
          "domain:qdmm.com",
          "domain:qin.io",
          "domain:qingmang.me",
          "domain:qingmang.mobi",
          "domain:qqurl.com",
          "domain:rarbg.to",
          "domain:rrmj.tv",
          "domain:ruguoapp.com",
          "domain:sm.ms",
          "domain:snwx.com",
          "domain:soku.com",
          "domain:startssl.com",
          "domain:store.steampowered.com",
          "domain:symcd.com",
          "domain:teamviewer.com",
          "domain:tmzvps.com",
          "domain:trello.com",
          "domain:trellocdn.com",
          "domain:ttmeiju.com",
          "domain:udache.com",
          "domain:uxengine.net",
          "domain:weather.bjango.com",
          "domain:weather.com",
          "domain:webqxs.com",
          "domain:weico.cc",
          "domain:wenku8.net",
          "domain:werewolf.53site.com",
          "domain:windowsupdate.com",
          "domain:wkcdn.com",
          "domain:workflowy.com",
          "domain:xdrig.com",
          "domain:xiaojukeji.com",
          "domain:xiaomi.net",
          "domain:xiaomicp.com",
          "domain:ximalaya.com",
          "domain:xitek.com",
          "domain:xmcdn.com",
          "domain:xslb.net",
          "domain:xteko.com",
          "domain:yach.me",
          "domain:yixia.com",
          "domain:yunjiasu-cdn.net",
          "domain:zealer.com",
          "domain:zgslb.net",
          "domain:zimuzu.tv",
          "domain:zmz002.com",
          "domain:samsungdm.com",
          "domain:spotify.com"
        ]
      },
      {
        "type": "field",
        "port": null,
        "inboundTag": null,
        "outboundTag": "block",
        "ip": null,
        "domain": [
          "geosite:category-ads-all"
        ]
      },
      {
        "type": "field",
        "port": null,
        "inboundTag": null,
        "outboundTag": "direct",
        "ip": [
          "geoip:private"
        ],
        "domain": null
      },
      {
        "type": "field",
        "port": null,
        "inboundTag": null,
        "outboundTag": "direct",
        "ip": [
          "geoip:cn"
        ],
        "domain": null
      },
      {
        "type": "field",
        "port": null,
        "inboundTag": null,
        "outboundTag": "direct",
        "ip": null,
        "domain": [
          "geosite:cn"
        ]
      }
    ]
  }
}
~~~