#!/usr/bin/bash
hugo && git add . && git commit -m "." && git push  &&  cd public/ && git add . && git commit -m "." && git push origin master:public