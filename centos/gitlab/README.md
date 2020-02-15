## gitlab
### 1.gitlab搭建
### 2.gitlab-runner安装
```bash
wget -O /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64 \
&& chmod +x /usr/local/bin/gitlab-runner 

useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash 
usermod -aG docker gitlab-runner 
gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner 
gitlab-runner start

gitlab-runner register

https://os4.top
令牌
zkFkyXsCxda_hkpxhRs4

yum -y install git maven
```
### 3.gitlab-ci/cd脚本编写
