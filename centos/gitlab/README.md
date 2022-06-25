## gitlab
### 1.gitlab搭建
```yaml
version: '3.6'
services:
  web:
    image: 'gitlab/gitlab-ce:latest'
    restart: always
    hostname: 'gitlab.example.com'
    environment:
      GITLAB_OMNIBUS_CONFIG: |
        external_url 'https://gitlab.example.com'
        # Add any other gitlab.rb configuration here, each on its own line
    ports:
      - '80:80'
      - '443:443'
      - '22:22'
    volumes:
      - '$GITLAB_HOME/config:/etc/gitlab'
      - '$GITLAB_HOME/logs:/var/log/gitlab'
      - '$GITLAB_HOME/data:/var/opt/gitlab'
    shm_size: '256m'
---
version: '3.6'
services:
  web:
    image: 'gitlab/gitlab-ce:latest'
    restart: always
    hostname: 'gitlab.example.com'
    environment:
      GITLAB_OMNIBUS_CONFIG: |
        external_url 'http://gitlab.example.com:8929'
        gitlab_rails['gitlab_shell_ssh_port'] = 2224
    ports:
      - '8929:8929'
      - '2224:22'
    volumes:
      - '$GITLAB_HOME/config:/etc/gitlab'
      - '$GITLAB_HOME/logs:/var/log/gitlab'
      - '$GITLAB_HOME/data:/var/opt/gitlab'
    shm_size: '256m'
```
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
useradd docker
usermod -aG docker gitlab-runner
gpasswd -a gitlab-runner root
```
### 4.配置需要操作目录的权限，比如你的 runner 要在 gaming 目录下操作：
```
chmod 775 gaming
```
查看注册列表：
gitlab-runner list

删除注册信息：

gitlab-runner unregister --name "名称"

### 5.开启runner并发
设置并发数：
```
vim /etc/gitlab-runner/config.toml
concurrent = 1 #默认是1
```
### 6.安装相关软件
- yarn
```
npm install -g yarn --registry=https://registry.npm.taobao.org
yarn config set registry https://registry.npm.taobao.org -g
yarn config set sass_binary_site http://cdn.npm.taobao.org/dist/node-sass -g
```
- cnmp
```
npm install -g cnpm --registry=https://registry.npm.taobao.org
```

### 7.配置gitlab-runner用户使用sudo权限不输出密码
```bash
#visudo 
gitlab-runner ALL=(ALL) NOPASSWD: ALL
```
