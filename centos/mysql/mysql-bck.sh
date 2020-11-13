#!/bin/bash
find /bck/data/ -name *.tar.gz -mtime 30 |xargs rm
mysqldump -h 192.168.0.x -P 13306 -uroot -p'123456' --all-databases |gzip >/bck/data/dev-k8s-`date +%Y%m%d%H%M`.tar.gz
#数据恢复
#gunzip < *.tar.gz |mysql -hlocalhost -uroot -pxxxxx
