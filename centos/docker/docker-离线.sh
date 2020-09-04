#!/bin/bash
set -ex
#1.解压
tar -xf docker-19.03.0.tgz && mv docker/* /usr/bin/ && rm -rf docker*.tgz
#2.添加加速地址
mkdir /etc/docker/ && touch /etc/docker/daemon.json
tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": [
                       "https://docker.mirrors.ustc.edu.cn",
                       "https://dockerhub.azk8s.cn",
                       "https://reg-mirror.qiniu.com",
                       "https://fz5yth0r.mirror.aliyuncs.com"
                        ],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m",
    "max-file": "3",
    "labels": "production_status"
  },
  "storage-driver": "overlay2"
}
EOF

#3.添加docker的service文件
touch /etc/systemd/system/docker.service
tee /etc/systemd/system/docker.service <<-'EOF'
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network-online.target firewalld.service
Wants=network-online.target
  
[Service]
Type=notify
# the default is not to use systemd for cgroups because the delegate issues still
# exists and systemd currently does not support the cgroup feature set required
# for containers run by docker
ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:2375 -H unix://var/run/docker.sock
ExecReload=/bin/kill -s HUP $MAINPID
# Having non-zero Limit*s causes performance problems due to accounting overhead
# in the kernel. We recommend using cgroups to do container-local accounting.
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
# Uncomment TasksMax if your systemd version supports it.
# Only systemd 226 and above support this version.
#TasksMax=infinity
TimeoutStartSec=0
# set delegate yes so that systemd does not reset the cgroups of docker containers
Delegate=yes
# kill only the docker process, not all processes in the cgroup
KillMode=process
# restart the docker process if it exits prematurely
Restart=on-failure
StartLimitBurst=3
StartLimitInterval=60s
  
[Install]
WantedBy=multi-user.target
EOF
#给予执行权限
chmod +x /etc/systemd/system/docker.service
#启动docker
systemctl start docker
#设置docker开机自启动
systemctl enable docker.service 
#安装docker-compose
mv docker-compose  /bin/docker-compose 
chmod +x /bin/docker-compose
