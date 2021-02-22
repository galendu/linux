#!/bin/bash
set -ex # -e 遇到执行非零时，退出脚本 -x打印执行过程
cat a.txt |while read -a LINE; #读取文件的每行，并以数组的形式保存在LINE中
do cp a.yaml ${LINE[0]}.yaml && sed -i -e  s%app%${LINE[0]}%g -e  s%port%${LINE[1]}%g ${LINE[0]}.yaml; #替换文件中匹配的项
done

#导出镜像
docker images|awk -F ' ' '{print $1":"$2}' |sed 1d >images/name.txt
cat name.txt |while read -a LINE;do a=`echo $LINE|awk -F '/' '{print $NF}'`&&docker save $LINE -o $a.tar;done
