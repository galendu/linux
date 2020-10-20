#!/bin/bash
num=7
backup_dir=/back/mysqlbackup
dd=`date +%Y-%m-%d-%H-%M-%S`
tool=mysqldump
username=root
password=123456
if [ ! -d $backup_dir ]; 
then     
    mkdir -p $backup_dir; 
fi
$tool -u $username -p$password -A > $backup_dir/$dd.sql
echo "create $backup_dir/$dd.dupm" >> $backup_dir/log.txt
delfile=`ls -l -crt  $backup_dir/*.sql | awk '{print $9 }' | head -1`
count=`ls -l -crt  $backup_dir/*.sql | awk '{print $9 }' | wc -l`
if [ $count -gt $num ]
then
  rm $delfile
  echo "delete $delfile" >> $backup_dir/log.txt
fi
