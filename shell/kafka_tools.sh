#!/bin/bash
#

HOST_LIST="172.16.100.40 172.16.100.50 172.16.100.60"

# STATUS_CMD="jps|grep -w Kafka"
# START_CMD="/opt/source/kafka/bin/kafka-server-start.sh --daemon /opt/source/kafka/config/server.properties"
# STOP_CMD="/opt/source/kafka/bin/kafka-server-stop.sh"
# SERVICE_NAME="Kafka broker"

# STATUS_CMD="jps|grep -w QuorumPeerMain"
# START_CMD="/opt/source/zookeeper/bin/zkServer.sh start"
# STOP_CMD="/opt/source/zookeeper/bin/zkServer.sh stop"
# SERVICE_NAME="ZK Server"

SLEF_PID=$$
STATUS_CMD="ps -ef|grep nginx|grep -v grep|grep -v $SLEF_PID"
START_CMD="/usr/sbin/nginx"
STOP_CMD="/usr/sbin/nginx -s stop"
SERVICE_NAME="Nginx"

# :.,$/s/^/#
# sh -x kafka_tools.sh start
# watch -n 1 -d "jps"
# mv kafka-server-start.sh ../

function service_status
{
        status_idx=0
        result=0
        while [ $status_idx -lt 3 ];do
                ssh -o StrictHostKeyChecking=no $1 $STATUS_CMD &> /dev/null
                if [ $? -eq 0 ];then
                        result=`expr $result + 1`
                fi
                status_idx=`expr $status_idx + 1`
        done
        
        if [ $? -eq 3 ];then
                return
        fi
        return 99
}

function service_start
{
        for host in $HOST_LIST;do
                echo "---------Now Begin To start $SERVICE_NAME In Host: $host---------"
                service_status $host
                if [ $? -eq 0 ];then
                        echo "$SERVICE_NAME in $host is already Running"
                else
                        echo "Now $SERVICE_NAME is STOPPED,Start it...."
                        ssh -o StrictHostKeyChecking=no $host $START_CMD &> /dev/null
                        index=0
                        while [ $index -lt 5 ];do
                                service_status $host
                                if [ $? -ne 0 ];then
                                        index=`expr $index+1`
                                        echo "$index Times: $SERVICE_NAME  in $host start failed... Please wait..."
                                        echo "After 3 seconds will check $SERVICE_NAME status again..."
                                        sleep 3
                                        continue
                                else
                                        echo "OK...$SERVICE_NAME in $host is RUNNING..."
                                        break
                                fi
                        done
                        if [ $index -eq 5 ];then
                                echo "Sorry...$SERVICE_NAME Start Failed..Please login $host to check"
                        fi
                fi
        done
}

function service_stop
{
        for host in $HOST_LIST;do
                echo "---------Now Begin To Stop $SERVICE_NAME In Host: $host---------"
                service_status $host
                if [ $? -ne 0 ];then
                        echo "$SERVICE_NAME in $host is already STOPPED"
                else
                        echo "Now $SERVICE_NAME is RUNNING,Stop it...."
                        ssh -o StrictHostKeyChecking=no $host $STOP_CMD &> /dev/null
                        index=0
                        while [ $index -lt 5 ];do
                                service_status $host
                                if [ $? -eq 0 ];then
                                        index=`expr $index+1`
                                        echo "$index Times: $SERVICE_NAME  in $host is stopping... Please wait..."
                                        echo "After 3 seconds will check $SERVICE_NAME status again..."
                                        sleep 3
                                        continue
                                else
                                        echo "OK...$SERVICE_NAME in $host is STOPPED now..."
                                        break
                                fi
                        done
                        if [ $index -eq 5 ];then
                                echo "Sorry...$SERVICE_NAME Stop Failed..Please login $host to check"
                        fi
                fi
        done
}

function usage
{
cat << EOF
sh $0 start             # Start $SERVICE_NAME Process Define IN HOST_LIST
sh $0 stop              # Stop $SERVICE_NAME Process Define IN HOST_LIST
sh $0 status            # Get $SERVICE_NAME Process Define IN HOST_LIST
EOF
}
case $1 in
        start)
                service_start
                ;;
        stop)
                service_stop
                ;;
        status)
                for host in $HOST_LIST;do
                        echo "---------Now Begin To Detect $SERVICE_NAME Status In Host: $host---------"
                        service_status $host
                        if [ $? -eq 0 ];then
                                echo "$SERVICE_NAME in $host is RUNNING"
                        else
                                echo "$SERVICE_NAME in $host is STOPPED"
                        fi
                done
                ;;
        *)
                usage
                ;;
esac
