#!/bin/bash
#############################################
#File Name: es_clean.sh
#Version: V1.0
#Author: os4top16
#Created Time: 2020-12-06 15:27:20
#Description: 
##############################################
DATE=`date -d "3 days ago" +%Y.%m.%d`
ip='192.168.0.x'
curl -s -H "Authorization:"token"  -XGET "http://$ip:9200/_cat/indices?v"|grep $DATE | awk -F '[ ]+' '{print $3}' >/tmp/elk.log
for elk in `cat /tmp/elk.log`
do 
    curl -H "Authorization:"token" -XDELETE "http://$ip:9200/$elk"
done
