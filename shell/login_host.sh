#!/bin/bash
#在所有主机上创建用户、设置密码
#针对创建的用户初始化免密环境

#
# useradd user1 -p 123456
# ssh-keygen -r rsa
if [ $# -lt 2 ];then 
    echo "Usage: sh $0 user_name user_pass"
    exit 1
fi

# 初始化变量
ROOT_PASS=root
USER_NAME=$1
USER_PASS=$2
HOST_LIST="172.16.100.40 172.16.100.50 172.16.100.60"
SSHPASS="sshpass -p$ROOT_PASS ssh -o StrictHostKeyChecking=no"
#1.管理主机本地创建用户、设置密码
useradd $USER_NAME
echo $USER_PASS |passwd --stdin $USER_NAME

#2.管理主机创建的用户生产密钥对
su - $USER_NAME -c "echo ""| ssh-keygen -t rsa"
PUB_KEY="`cat /home/$USER_NAME/.ssh/id_rsa.pub`"

#3.利用SSH非免密在所有主机创用户
#4.利用SSH非免密将管理主机公钥内容写入所有主机authorized_keys文件
for host in $HOST_LIST;do
    $SSHPASS root@$host "useradd $USER_NAME"
    $SSHPASS root@$host "echo "$USER_PASS" |passwd --stdin $USER_NAME"
    $SSHPASS root@$host "mkdir /home/$USER_NAME/.ssh -pv"
    $SSHPASS root@$host "echo $PUB_KEY >/home/$USER_NAME/.ssh/authorized_keys"
    $SSHPASS root@$host "chmod 600 /home/$USER_NAME/.ssh/authorized_keys"
    $SSHPASS root@$host "chown -R $USER_NAME:$USER_NAME /home/$USER_NAME/.ssh"
done
