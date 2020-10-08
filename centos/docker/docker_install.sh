#!/bin/bash
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo  https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum install -y docker-ce-19.03.9-3.el7
mkdir -p /etc/docker
tee /etc/docker/daemon.json <<-'EOF'
{ 
  "registry-mirrors": [
                       "https://iuj3d0uh.mirror.aliyuncs.com",
                       "http://hub-mirror.c.163.com",
                       "https://docker.mirrors.ustc.edu.cn",
                       "https://dockerhub.azk8s.cn",
                       "https://reg-mirror.qiniu.com",
                       "https://fz5yth0r.mirror.aliyuncs.com"
                        ],
  "graph": "/data/docker",
  "log-driver": "json-file",
  "log-opts": {
  "max-size": "100m" },
  "storage-driver": "overlay2"
}
EOF
systemctl daemon-reload
systemctl start docker
systemctl enable docker
