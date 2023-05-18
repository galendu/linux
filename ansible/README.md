## 安装

### 1.yum安装

```bash
yum replolist
yum list all | grep ansible
yum install epel-release -y
yum makecache
yum search ansible

```
### 2.源码编译安装  
依赖包  
```text
python-simplejson
python-paramiko
python-ecdsa
python-markupsafe
python-yaml
python-jinja2
python-pycrypto
python-setuptools
```

## 使用  

### 1.ansible配置账号密码管理远程主机  
```bash
#192.168.3.11 ansible_ssh_user=root ansible_ssh_pass=123456
#192.168.3.12 ansible_ssh_user=root ansible_ssh_pass=123456
#192.168.3.13 ansible_ssh_user=root ansible_ssh_pass=123456
```
### 2.Host 
`ansible all -m ping`  
**Host Inventory 支持的变量**
|  变量   | 含义  |
|  ----  | ----  |
| ansible_ssh_user  | SSH账户名 |
| ansible_ssh_pass  | SSH账户对应的密码 |
| ansible_ssh_host  | 将要连接的远程主机名 |
| ansible_ssh_port  | SSH端口号 |


### 3.配置  

ssh-keygen -t rsa
```bash
vi /etc/ansible/ansible.cfg
[defaults]
forks          = 8           #执行时并发数
host_key_checking = False    #不检测host key
```

### 4.ansible执行流程  



`ansible -i /etc/ansible/hosts all -m copy -a 'src=/root/inittab dest=/tmp/' -vvv`


### 5.ansible目录结构

- 配置文件目录: /etc/ansible/
- 可执行程序目录: /usr/bin/
- 模块文件目录: /usr/lib/python2.7/site-packages/ansible/
- HELP文档目录: /usr/share/doc/ansible-2.9.25/
- MAN文档目录: /usr/share/man/man1/


### 6.ansible配置文件加载顺序  

**当前目录ansible.cfg-->家目录.ansible.cfg -->/etc/ansible/ansible.cfg**

### 7.ansible命令参数  
- `-i 指定使用的主机清单文件` 
- `-m 指定模块`
- `-a 指定模块使用的参数`
- `-v 打印详细日志`
- `-f 指定fork开启同步进程个数`
- `-u ssh连接的用户名`
- `-k 提示输入ssh登录密码`
- `--list-hosts 列出执行的主机清单`

### 8.ansible命令格式  
命令格式: `ansible 主机 -m 模块 -a 参数`  

`ansible -i /opt/hosts 192.168.3.13 -m ping -vvv`  


### 9.ansible command模块  
**ansible默认模块**  
- 主要用于远程主机执行Linux命令
- 缺陷: 不支持变量、重定向、管道等  
  
**常用参数** 

|  参数   | 含义  |
|  ----  | ----  |
| chdir  | 执行指令前,先切换目录 |
| creates  | 文件存在时,不执行后续指令 |
| removes  | 文件不存在时,不执行后续指令 |
```bash
ansible all -m command -a 'uptime'
ansible all -m command -a 'chdir=/opt ls'
#creates 如果存在不执行
ansible all -m command -a 'creates=/opt/hosts touch /opt/hosts'
#removes 如果不存在不执行
ansible all -m command -a 'removes=/opt/hosts rm -rf /opt/hosts'
ansible all -m command -a 'removes=/usr/sbin/nginx systemctl start nginx'
```

### 10.shell模块  
- 主要用于在远程主机执行Linux命令
- 支持变量、重定向、管道等
- 缺陷：shell注入风险、非幂等性
  
```bash
ansible all -m shell -a 'chdir=/tmp ls'
ansible all -m shell -a 'creates=/opt/hosts touch /opt/hosts'
ansible all -m shell -a 'removes=/usr/sbin/nginx systemctl start nginx'
ansible all -m shell -a 'dir=/tmp ls $dir'
ansible all -m shell -a 'ip a|grep inet>/tmp/interface.log'
```
### 11.copy模块  
- 主要用于在拷贝文件到远程主机上  

|  参数   | 含义  |
|  ----  | ----  |
| src  | 本地需拷贝的文件或目录 |
| dest  | 远程主机目标目录 |
| content  | 不指定src时,可以使用content参数填充文件内容;src和content必选其一,否则报错 |
| force  | 拷贝文件和远程主机内容不一致时,是否强制覆盖表;默认yes表示覆盖,设置为no表示不覆盖 |
| backup  | 目标路径存在同名文件且与anisble主机中的文件内容不同时,是否对远程主机的文件进行备份,可选值有yes和no,当设置为yes是,会先别发远程主机中的文件,然后再将ansible主机中的文件拷贝到远程主机 |
| owner  | 指定文件拷贝到远程主机后的属主,当时远程主机上必须有对应的用户,否则会报错 |
| group  | 指定文件拷贝到远程主机后的属组,但是远程主机上必须有对应的组,否则会报错 |
| mode  | 指定文件拷贝到远程主机后的权限 |


```bash
ansible all -m copy -a 'src=/etc/sysconfig/selinux dest=/tmp'
ansible all -m copy -a 'src=/opt/selinux force=yes backup=yes  dest=/tmp'
ansible all -m copy -a 'content="hello shell\nhello go" dest=/tmp/test.txt'

```

### 12.解决ansible拷贝整个文件夹慢问题  

```bash
ansible all -m copy -a 'src=/etc dest=/tmp'
ansible all -m copy -a 'src=/etc/ dest=/tmp'

```
**Synchronize模块** 


|  参数   | 含义  |
|  ----  | ----  |
| src  | 本地需拷贝的文件或目录 |
| dest  | 远程主机目标目录或文件 |
| exclude  | 用于定义排除单独的文件夹河文件 |
| exclude-from  | 用于定义排除多个文件夹和文件 |
| owner  | 指定文件拷贝到远程主机后的属主,但是远程主机上必须有对应的用户,否则会报错 |
| group  | 指定文件拷贝到远程主机后的属组,但是远程主机上必须有对应的组,否则会报错 |
| perms  | 保留文件的权限 |

```bash
yum -y install rsync
ansible all -m synchronize -a 'src=/etc dest=/tmp'
```

### 13.ansible核心模块file  
**主要用于完成文件基本操作**  
**创建文件或目录、删除或目录、修改文件权限**  

|  参数   | 含义  |
|  ----  | ----  |
| path  | 操作对象，可以是目录或文件 |
| state  | 文件状态。值可以为{directory|touch|file|absent|link|hard} |
| owner  | 指定文件属主 |
| group  | 指定文件属组 |
| mode  | 指定文件权限 |
| recurse  | 递归操作目录 |
| src  | 指定链接源 |
```bash
ansible all -m file -a 'path=/tmp/test.log state=touch'
ansible all -m file -a 'path=/tmp/logs state=directory'
ansible all -m file -a 'path=/tmp/logs state=absent'
ansible all -m file -a 'path=/tmp/nginx state=link src=/tmp/nginx-1.12.0'
ansible all -m file -a 'path=/tmp/etc owner=test group=test-g mode=777'

```

### 14.lineinfile模块

模块功能  
确保文件中存在特定行,或者使用反向引用正则表达式替换现有的行

常用参数  
|  参数   | 含义  |
|  ----  | ----  |
| path  | 指定要操作的文件 |
| line  | 行内容信息 |
| regexp  | 正则表达式匹配 |
| state  | 文件状态，值可以为{absent|present}，默认值为present |
| insertbefore  | 插入“指定行”之前 |
| insertafter  | 插入“指定行”之后 |
| backup  | 是否备份原文件 |
| backrefs  | 是否开启后向引用 |


应用场景  
**配置文件变更**  
- 添加行信息到配置文件中
- 删除配置文件中匹配行信息
- 有匹配行则替换，无匹配行则追加到末尾
- 有匹配行则替换，无匹配行则不做任何处理
- 匹配行前面添加
- 匹配行后面添加


```bash
ansible all -m lineinfile -a 'path=/tmp/hosts line="192.168.3.21 node21"'
ansible all -m lineinfile -a 'path=/tmp/hosts regexp="192.168.3.21" state=absent'
ansible all -m copy -a 'src=/tmp/selinux dest=/tmp/'
ansible all -m lineinfile -a 'path=/tmp/selinux regexp="^SELINUX=" line="SELINUX=disabled"'
ansible all -m lineinfile -a 'path=/tmp/selinux regexp="^selinux=" line="aaabb" backrefs=yes'
ansible all -m lineinfile -a 'path=/tmp/selinux regexp="^selinux=" line="ccccdddd" backrefs=yes'
ansible all -m lineinfile -a 'path=/tmp/my.cnf regexp="^datadir=" line="datadir=/data/mysql"'
ansible all -m lineinfile -a 'path=/tmp/selinux  insertbefore="^SELINUX=" line="SELINUX=permissive"'
ansible all -m lineinfile -a 'path=/tmp/selinux  insertafter="^SELINUX=" line="SELINUX=permissive"'
```

### 15.yum和service模块  

**基于yum源完成软件包安装、卸载、更新**  
|  参数   | 含义  |
|  ----  | ----  |
| name  | 软件包名 |
| state  | 目标状态：present|installed|latest|absent|removed |
| disable_gpg_check  | 禁用对rpm包的公钥验证，默认no |
| enablerepo  | 使用指定YUM源安装 |
| disablerepo  | 安装时不使用特定YUM源 |

**service服务的管理：启动、停止、重启、开机自启** 

|  参数   | 含义  |
|  ----  | ----  |
| name  | 服务名 |
| state  | started|stopped|restarted|reloaded |
| enabled  | 开机自启动设置：yes|no |

```bash
ansible all -m yum -a 'name=nginx state=installed'
ansible all -m service -a 'name=nginx state=started'
ansible all -m service -a 'name=nginx state=restarted'
ansible all -m service -a 'name=nginx state=stopped'
ansible all -m yum -a 'name=nginx state=removed'
```
