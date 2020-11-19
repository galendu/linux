#!/bin/bash
# auth os4top16
# redis 三节点高可用 vip自动绑定到redis master节点
# 卸载 yum -y remove   redis epel-release remi &&  rm -rf /etc/redis* && rm -rf /var/lib/redis
PASSWD='1234Qwer#('
MASTERIP='192.168.0.42'
REDISPORT='6379'  #
REDISDIR='/etc/redis.conf'
SENTINELPORT='26379' #sentinel
SENTINELDIR='/etc/redis-sentinel.conf'
INTERFACE='eth0'
REDIS_IP=`ip -4 -o addr show dev eth0| grep -v secondary| awk '{split($4,a,"/");print a[1]}'`

   
REDIS_VIP='192.168.0.46'
SENTINEL_FAILOVER='/var/lib/redis/failover.sh'
# ip addr add 192.168.0.46/24 dev eth0
echo "开始安装epel-release redis"
yum -y install epel-release
yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum --enablerepo=remi install -y redis

echo -e """#!/bin/bash
MASTER_IP=\${6}
MY_IP='${REDIS_IP}'   # 本机ip
VIP='${REDIS_VIP}'     # VIP
NETMASK='24'          # Netmask
INTERFACE='${INTERFACE}'      # 网卡
if [ \${MASTER_IP} = \${MY_IP} ]; then
        sudo /sbin/ip addr add \${VIP}/\${NETMASK} dev \${INTERFACE}
        sudo /sbin/arping -q -c 3 -A \${VIP} -I \${INTERFACE}
        exit 0
else
        sudo /sbin/ip addr del \${VIP}/\${NETMASK} dev \${INTERFACE}
        exit 0
fi
exit 1
""">${SENTINEL_FAILOVER}

chmod 755 ${SENTINEL_FAILOVER}
chown redis:  ${SENTINEL_FAILOVER}

echo -e """
bind 0.0.0.0
protected-mode no
port ${REDISPORT}
tcp-backlog 511
timeout 0
tcp-keepalive 300
daemonize no
supervised no
pidfile /var/run/redis_${REDISPORT}.pid
loglevel notice
logfile /var/log/redis/redis.log
databases 16
always-show-logo yes
save 900 1
save 300 10
save 60 10000
stop-writes-on-bgsave-error yes
rdbcompression yes
rdbchecksum yes
dbfilename dump.rdb
rdb-del-sync-files no
dir /var/lib/redis
masterauth ${PASSWD}
replica-serve-stale-data yes
replica-read-only yes
repl-diskless-sync no
repl-diskless-sync-delay 5
repl-diskless-load disabled
repl-disable-tcp-nodelay no
replica-priority 100
acllog-max-len 128
requirepass ${PASSWD}
lazyfree-lazy-eviction no
lazyfree-lazy-expire no
lazyfree-lazy-server-del no
replica-lazy-flush no
lazyfree-lazy-user-del no
oom-score-adj no
oom-score-adj-values 0 200 800
appendonly no
appendfilename \"appendonly.aof\"
appendfsync everysec
no-appendfsync-on-rewrite no
auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 64mb
aof-load-truncated yes
aof-use-rdb-preamble yes
lua-time-limit 5000
slowlog-log-slower-than 10000
slowlog-max-len 128
latency-monitor-threshold 0
notify-keyspace-events \"\"
hash-max-ziplist-entries 512
hash-max-ziplist-value 64
list-max-ziplist-size -2
list-compress-depth 0
set-max-intset-entries 512
zset-max-ziplist-entries 128
zset-max-ziplist-value 64
hll-sparse-max-bytes 3000
stream-node-max-bytes 4096
stream-node-max-entries 100
activerehashing yes
client-output-buffer-limit normal 0 0 0
client-output-buffer-limit replica 256mb 64mb 60
client-output-buffer-limit pubsub 32mb 8mb 60
hz 10
dynamic-hz yes
aof-rewrite-incremental-fsync yes
rdb-save-incremental-fsync yes
jemalloc-bg-thread yes
replicaof ${MASTERIP} ${REDISPORT} 

""">${REDISDIR}



echo -e """
# bind 127.0.0.1 192.168.1.1
#
protected-mode no

# port <sentinel-port>
port ${SENTINELPORT}

daemonize yes

pidfile /var/run/redis-sentinel.pid


logfile /var/log/redis/sentinel.log

#
# sentinel announce-ip 1.2.3.4

dir /tmp


sentinel monitor mymaster ${MASTERIP} ${REDISPORT} 2

# sentinel auth-pass <master-name> <password>
sentinel auth-pass mymaster ${PASSWD}
sentinel down-after-milliseconds mymaster 10000

# requirepass <password>
requirepass ${PASSWD}
sentinel parallel-syncs mymaster 1
masterauth ${PASSWD}

sentinel failover-timeout mymaster 60000



#sentinel deny-scripts-reconfig yes
sentinel client-reconfig-script  mymaster ${SENTINEL_FAILOVER}
""">${SENTINELDIR}

chmod 640 ${REDISDIR} ${SENTINELDIR} 
chown -R redis:  ${REDISDIR} ${SENTINELDIR} 


echo -e "redis\tALL=(ALL)\tNOPASSWD:/sbin/ip,NOPASSWD:/sbin/arping" > /etc/sudoers.d/redis
sed -i "s/Defaults.*requiretty/#Defaults\trequiretty/" /etc/sudoers
chmod 440 /etc/sudoers.d/redis
systemctl enable redis && systemctl enable redis-sentinel

if [ ${REDIS_IP} = ${MASTER_IP} ] ;then
    echo "本机为master节点"
    sed -i "s/replicaof ${MASTERIP} ${REDISPORT}/#replicaof ${MASTERIP} ${REDISPORT}/g"  ${REDISDIR} && echo "成功注释master信息在redis.conf中的配置"
    ip addr add ${REDIS_VIP}\/24 dev ${INTERFACE}
    systemctl restart redis && systemctl restart redis-sentinel
 
else
    systemctl restart redis && systemctl restart redis-sentinel 

fi
