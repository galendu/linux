## 服务端  

https://blog.csdn.net/vic_qxz/article/details/80607801


## 客户端
centos 
- 1.运行 yum install -y ppp pptp pptp-setup 安装软件包。   
- 2.运行 pptpsetup --create test --server IP --username 用户名 --password 密码 --encrypt --start 连接 VPN 服务端。  
- 3.运行 ip route replace default dev ppp0 增加默认路由  
