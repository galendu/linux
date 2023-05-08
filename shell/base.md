## 基本概念  
SSH是(Secure Shell) 的缩写,安全外壳协议
### 1.测试
```bash
#!/bin/bash
host_list='192.168.3.5 127.0.0.1'
user_name=root
user_pass=redhat

for host in $host_list;
do
    sshpass -p$user_pass ssh -o StrictHostKeyChecking=no  $user_name@$host "$1"
done
```

### 2.免密登录
```bash
ssh-keygen -t rsa 
ssh-copy-id root@node02
ssh -o StrictHostKeyChecking=no root@node02 'df -h'

```

### 3.非免密和免密结合  
第一步: 利用SSH非免密创建免密环境  
第二步: 借组免密环境,用其他自动化运维工具完成应用安装部署  

### 4.跨主机执行指令返回值处理  
获取指令执行状态,并依据结果执行相关动作  
```bash
echo $? #非0,执行失败
netstat -tnlp | grep :3306
echo $?
```

### 5.ssh跨主机执行脚本结果返回值处理  

```bash
#file name test.sh
#远端脚本
cat /etc/fstab
xxxxx
ls /tmp
#如果使用$?查看状态,最后一条命令执行成功就返回0,不适用

```
```bash
sshpass -p$ROOT_PASS ssh -o StrictHostKeyChecking=no 'sh /opt/test.sh'

```

### 6.集群安装  
**安装部署实现步骤拆解**    
- 拷贝安装包到远端主机
- 创建安装目录并解压安装包
- 格式化磁盘挂载数据目录
- 修改服务配置文件
- 启动服务并验证集群运行状态

### 7.基础配置  
```bash
if [ -e ./deploy_kafka.log ] ;then
    rm -rf ./deploy_kafka.log
fi

set -e #遇到错误退出
exec 1>>./deploy_kafka.log 2>&1 #将标准正确输出和标准错误输出重定向到./deploy_kafka.log
```
