#!/bin/bash
#

HOST_LIST="172.16.100.40 172.16.100.50 172.16.100.60"

function service_status
{
        status_idx=0
        result=0
        while [ $status_idx -lt 3 ];do
                ssh -o StrictHostKeyChecking=no $1 "jps|grep -w Kafka" &> /dev/null
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
                echo "---------Now Begin To start Kafka In Host: $host---------"
                service_status $host
                if [ $? -eq 0 ];then
                        echo "Kafka broker in $host is already Running"
                else
                        echo "Now Kafka broker is STOPPED,Start it...."
                        ssh -o StrictHostKeyChecking=no $host "/opt/source/kafka/bin/kafka-server-start.sh --daemon /opt/source/kafka/config/server.properties" &> /dev/null
                        index=0
                        while [ $index -lt 5 ];do
                                service_status $host
                                if [ $? -ne 0 ];then
                                        index=`expr $index+1`
                                        echo "$index Times: Kafka broker  in $host start failed... Please wait..."
                                        echo "After 3 seconds will check kafka status again..."
                                        sleep 3
                                        continue
                                else
                                        echo "OK...Kafka broker in $host is RUNNING..."
                                        break
                                fi
                        done
                        if [ $index -eq 5 ];then
                                echo "Sorry...Kafka broker Start Failed..Please login $host to check"
                        fi
                fi
        done
}

function service_stop
{
        for host in $HOST_LIST;do
                echo "---------Now Begin To Stop Kafka In Host: $host---------"
                service_status $host
                if [ $? -ne 0 ];then
                        echo "Kafka broker in $host is already STOPPED"
                else
                        echo "Now Kafka broker is RUNNING,Stop it...."
                        ssh -o StrictHostKeyChecking=no $host "/opt/source/kafka/bin/kafka-server-stop.sh" &> /dev/null
                        index=0
                        while [ $index -lt 5 ];do
                                service_status $host
                                if [ $? -eq 0 ];then
                                        index=`expr $index+1`
                                        echo "$index Times: Kafka broker  in $host is stopping... Please wait..."
                                        echo "After 3 seconds will check kafka status again..."
                                        sleep 3
                                        continue
                                else
                                        echo "OK...Kafka broker in $host is STOPPED now..."
                                        break
                                fi
                        done
                        if [ $index -eq 5 ];then
                                echo "Sorry...Kafka broker Stop Failed..Please login $host to check"
                        fi
                fi
        done
}

function usage
{
cat << EOF
sh $0 start             # Start Kafka Process Define IN HOST_LIST
sh $0 stop              # Stop Kafka Process Define IN HOST_LIST
sh $0 status            # Get Kafka Process Define IN HOST_LIST
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
                        echo "---------Now Begin To Detect Kafka Status In Host: $host---------"
                        service_status $host
                        if [ $? -eq 0 ];then
                                echo "Kafka broker in $host is RUNNING"
                        else
                                echo "KAfka broker in $host is STOPPED"
                        fi
                done
                ;;
        *)
                usage
                ;;
esac
# :.,$/s/^/#
# sh -x kafka_tools.sh start
# watch -n 1 -d "jps"
# mv kafka-server-start.sh ../
