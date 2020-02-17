## gitlab
### 1.gitlab搭建
### 2.gitlab-runner安装
```bash
wget -O /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64 \
&& chmod +x /usr/local/bin/gitlab-runner 

useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash 
gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner 
gitlab-runner start

gitlab-runner register

https://os4.top
令牌
zkFkyXsCxda_hkpxhRs4

yum -y install git maven
```
### 3.为gitlab-runner用户授权
```
usermod -aG docker gitlab-runner
gpasswd -a gitlab-runner root
```
### 4.配置需要操作目录的权限，比如你的 runner 要在 gaming 目录下操作：
```
chmod 775 gaming
```
删除注册信息：

gitlab-ci-multi-runner unregister --name "名称"
查看注册列表：

gitlab-ci-multi-runner list

### 3.gitlab-ci/cd脚本编写


