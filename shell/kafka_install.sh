#!/bin/bash
#

if [ -e ./deploy_kafka.log ] ;then
    rm -rf ./deploy_kafka.log
fi

set -e #遇到错误退出
exec 1>>./deploy_kafka.log 2>&1 #将标准正确输出和标准错误输出重定向到./deploy_kafka.log


# 初始化变量
HOST_LIST="172.16.100.40 172.16.100.50 172.100.60"
CMD_NUM=0
LOCAL_DIR="/opt/tmp"
PACKAGE_DIR="/opt/package"
APP_DIR="/opt/source"
JDK_NAME="jdk-xxx.tar.gz"
ZK_NAME=""
SCALA_NAME=""
KAFKA_NAME=""
# 多主机执行指令函数封装
function remote_execute
{
    for host in $HOST_LIST;do
        CMD_NUM=`expr $CMD_NUM + 1`
        echo "+++++++++++++++++Execute Command < $@ > ON Host: $host+++++++++++++++++"
        ssh -o StrictHostKeyChecking=no root@$host $@
        if [ $? -eq 0 ];then
            echo "$CMD_NUM  Congratulation.Command < $@ > execute success"
        else
            echo "$CMD_NUM Sorry,Command < $@ > execute failed"
        fi
    done
        
}

# 多主机传输文件函数封装
function remote_transfer
{
    SRC_FILE=$1
    DST_DIR=$2
    # 函数必须有2个参数,第一个参数是本地文件或目录,第二个参数为远端主机目录
    if [ $# -lt 2 ];then
        echo "Usage: $0 <file_dir> <dst_dir>"    
        exit 1
    fi
    
    # 判断第一个参数是否存在,如果不存在则直接退出并提示给用户
    if [ ! -e $SRC_FILE ];then
        echo "ERROR - $SRC_FILE is not exist,Please check..."
        exit 1
    fi 
    
    # # 判断第2个参数,远端主机目录是否存在,如果不存在,则创建

    for host in $HOST_LIST;do
        echo "+++++++++++++++++Transfer File to HOST: $host+++++++++++++++++"
        CMD_NUM=`expr $CMD_NUM + 1`
        ssh -o StrictHostKeyChecking=no root@$host "if [ ! -e $DST_DIR ];then mkdir $DST_DIR -p;fi"
        scp -r -o StrictHostKeyChecking=no $SRC_FILE root@$host:$DST_DIR/
        if [ $? -eq 0 ];then
            echo "Remote Host: $host - CMD_NUM - INFO - SCP $SRC_FILE To dir $DST_DIR Success"
        else
            echo "Remote Host: $host - CMD_NUM - INFO - SCP $SRC_FILE To dir $DST_DIR Failed"
        fi
    done
}
# remote_transfer 123456.log /opt/package


#实现: kafka集群安装部署及一键启停

# 第一步: 关闭firewalld和selinux
remote_execute "systemctl stop firewalld"
remote_execute "systemctl disable firewalld"
remote_execute "setenforce 0"
remote_execute "sed -i "/SELINUX=enforcing/SELINUX=disabled/g" /etc/sysconfig/selinux"

# 第二步: 安装配置JDK
remote_transfer "$LOCAL_DIR/$JDK_NAME $PACKAGE_DIR"
remote_execute "if [ ! -d $APP_DIR ];then mkdir -p $APP_DIR;fi"
remote_execute "tar -zxvf $PACKAGE_DIR/$JDK_NAME -C $APP_DIR"

cat >$LOCAL_DIR/java.sh << EOF
export JAVA_HOME=/opt/source/jdk1.8.0_212
export PATH=\$PATH:\$JAVA_HOME/bin:\$JAVA_HOME/jre/bin
export JAVA_HOME PATH
EOF
remote_transfer $LOCAL_DIR/java.sh /etc/profile.d/
remote_execute "java --version"

# 第三步: 安装配置zookeeper,并启动服务
remote_transfer "$LOCAL_DIR/$ZK_NAME $PACKAGE_DIR"
remote_execute "tar -zxvf $PACKAGE_DIR/$ZK_NAME -C $APP_DIR"

remote_execute "if [ -e $APP_DIR/zookeeper ];then rm -f $APP_DIR/zookeeper;fi"
remote_execute "ln -sv $APP_DIR/apache-zookeeper-3.7.0-bin $APP_DIR/zookeeper"

remote_execute "cp $APP_DIR/zookeeper/conf/zoo_sample.cfg $APP_DIR/zookeeper/conf/zoo.cfg"

cat >$LOCAL_DIR/zoo_tmp.conf << EOF
server.1=172.16.100.40:2888:3888
server.1=172.16.100.50:2888:3888
server.1=172.16.100.60:2888:3888
EOF

remote_transfer $LOCAL_DIR/zoo_tmp.conf /tmp
remote_execute "cat /tmp/zoo_tmp.conf >> $APP_DIR/zookeeper/conf/zoo.cfg"

remote_execute "if [ -e /data/zk ];then rm -rf /data/zk;fi"
remote_execute "mkdir -p /data/zk"
remote_execute "sed -i 's/dataDIR=\/tmp\/zookeeper/dataDir=\/data\/zk/g' $APP_DIR/zookeeper/conf/zoo.cfg"

remote_execute 'if [ `hostname` == "node01" ];then echo 1 > /data/zk/myid;fi'
remote_execute 'if [ `hostname` == "node02" ];then echo 2 > /data/zk/myid;fi'
remote_execute 'if [ `hostname` == "node03" ];then echo 3 > /data/zk/myid;fi'

remote_execute "jps | grep QuorumPeerMain |grep -v grep | awk '{print \$1}'>/tmp/zk.pid"
remote_execute 'if [ -s /tmp/zk.pid ];then kill -9 `cat /tmp/zk.pid``;fi'
remote_execute "$APP_DIR/zookeeper/bin/zkServer.sh start"

# 第四步: 安装scale环境
remote_transfer $LOCAL_DIR/$SCALA_NAME $PACKAGE_DIR
remote_execute "tar -zxvf $PACKAGE_DIR/$SCALA_NAME -C $APP_DIR"

cat >$LOCAL_DIR/scala.sh << EOF
export SCALA_HOME=$APP_DIR/scala-2.12.11
expoprt PATH=\$PATH:\$SCALA_HOME/bin
export SCALA_HOME PATH
EOF

remote_transfer $LOCAL_DIR/scala.sh /etc/profile.d/
remote_execute "source /etc/profile.d/scala.sh"
remote_execute "scala --version"

# 第五步: 安装配置kafka,并启动服务

remote_transfer $LOCAL_DIR/$KAFKA_NAME $PACKAGE_DIR
remote_execute "tar -xzvf $PACKAGE_DIR/$KAFKA_NAME -C $APP_DIR"

remote_execute "if [ -e $APP_DIR/kafka ];then rm -rf $APP_DIR/kafka;fi"
remote_execute "ln -sv $APP_DIR/kafka-2.12-2.6.1 $APP_DIR/kafka "

remote_execute "if [ -e /data/kafka/log ];then rm -rf /data/kafka/log;fi"
remote_execute "mkdir -p /data/kafka/log"

remote_execute "sed -i '/zookeeper.connect=localhost:2181/d' $APP_DIR/kafka/config/server.properties"
remote_execute "sed -i '\$azookeeper.connect=172.16.100.40:2181,zookeeper.connect=172.16.100.50:2181,zookeeper.connect=172.16.100.60:2181' $APP_DIR/kafka/config/server.properties"

remote_execute "if [ \`hostname\`=="node01" ];then sed -i 's/broker.id=0/broker.id=100/g' $APP_DIR/kafka/config/server.properties;fi"
remote_execute "if [ \`hostname\`=="node02" ];then sed -i 's/broker.id=0/broker.id=101/g' $APP_DIR/kafka/config/server.properties;fi"
remote_execute "if [ \`hostname\`=="node03" ];then sed -i 's/broker.id=0/broker.id=102/g' $APP_DIR/kafka/config/server.properties;fi"

remote_execute "if [ \`hostname\`=="node01" ];then sed -i '\$a/listeners=PLAINTEXT://172.16.100.40:9092' $APP_DIR/kafka/config/server.properties;fi"
remote_execute "if [ \`hostname\`=="node02" ];then sed -i '\$a/listeners=PLAINTEXT://172.16.100.50:9092' $APP_DIR/kafka/config/server.properties;fi"
remote_execute "if [ \`hostname\`=="node03" ];then sed -i '\$a/listeners=PLAINTEXT://172.16.100.60:9092' $APP_DIR/kafka/config/server.properties;fi"

remote_execute "sed -i 's/log.dirs=\/tmp\/kafka-logs/log.dirs=\/data\/kafka\/log/g' $APP_DIR/kafka/config/server.properties"

remote_execute "jps | grep Kafka | grep -v grep | awk '{print \$1}' >/tmp/kafka.pid"
remote_execute "if [ -s /tmp/kafka.pid ];then kill -9 \`cat /tmp/kafka.pid\`;fi"

remote_execute "$APP_DIR/kafka/bin/kafka-server-start.sh -daemon $APP_DIR/kafka/config/server.properties"

sleep 30

remote_execute "if [ \`hostname\` == "node01" ];then $APP_DIR/kafka/bin/kafka-topics.sh --zookeeper localhost --create --topic test --partitions 5 --replication-factor 2;fi "

sleep 5

remote_execute "if [ \`hostname\` == "node01" ];then $APP_DIR/kafka/bin/kafka-topics.sh --zookeeper localhost --topic test --describe;fi "

# /opt/source/zookeeper/bin/zkServer.sh status
# /opt/source/zookeeper/bin/kafka-topics.sh --zookeeper localhost --create --topic test --partitions 5 --replication-factor=2
# /opt/source/zookeeper/bin/kafka-topics.sh --zookeeper localhost --topic test --describe
