## LVS

#### 简介


#### 常用命令
```shell
# 日志 /var/log/message
# 查看转发配置
ipvsadm -ln
# 查看连接流量统计
ipvsadm -L --stats
# 查看当前连接
ipvsadm -Lnc
```