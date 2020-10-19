#!/bin/bash
DATE=`date -d "30 days ago" +%Y.%m.%d` # 30天前
ip=`ifconfig ens33 | grep "\binet\b"|awk '{print $2}'`
curl -s  -XGET "http://$ip:9200/_cat/indices?v"| grep $DATE | awk -F '[ ]+' '{print $3}' >/tmp/elk.log
for elk in `cat /tmp/elk.log`
do
        curl  -XDELETE  "http://$ip:9200/$elk"
done
#echo "#每天凌晨1点定时清理elk索引"  >>/var/spool/cron/root 
#echo "00 01 * * * bash /scripts/delete-elk.log &>/dev/null" >>/var/spool/cron/root
