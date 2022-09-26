#!/bin/bash

yum -y install repotrack
rpms=`yum list all --disablerepo="*" --enablerepo="epel" | grep -Ev "Loaded|Loading|Installed" | awk '{print $1}'`

mkdir  -p  yum

for rpm  in ${rpms}

do

  repotrack  ${rpm}  -p  yum

done

creatrepo  -v  yum 
tar -zcf  /opt/yum.tar.gz  yum
