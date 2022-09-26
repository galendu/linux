#!/bin/bash


rpms=`yum list all --disablerepo="*" --enablerepo="epel" | grep -Ev "Loaded|Loading|Installed" | awk '{print $1}'`

echo ${rpms}
mkdir  -p  yum

for rpm  in ${rpms}

do

  repotrack  ${rpm}  -p  yum

done

createrepo  -v  yum 
tar -zcf  /opt/yum.tar.gz  yum
