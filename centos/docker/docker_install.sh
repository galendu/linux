#!/bin/bash
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo  https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum install -y docker-ce-19.03.9.ce-3.el7 
mkdir -p /etc/docker
tee /etc/docker/daemon.json <<-'EOF'
{
  "graph": "/data/docker",
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
  "max-size": "100m" },
  "storage-driver": "overlay2"
}
EOF
systemctl daemon-reload

systemctl enable docker
