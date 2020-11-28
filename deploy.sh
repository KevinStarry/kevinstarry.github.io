#!/usr/bin/bash

export http_proxy=http://127.0.0.1:10809

export https_proxy=http://127.0.0.1:10809

hugo && git add . && git commit -m "." && git push  &&  cd public/ && git add . && git commit -m "." && git push origin master:public
