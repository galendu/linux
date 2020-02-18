## nginx配置
### 1.普通网站配置
### 2.负载均衡配置（5种模式）
### 3.nginx基础优化配置参数
```bash
gzip on #负责打开后端的压缩功能；
gzip_buffer 16 8k  #表示设置 Nginx 在处理文件压缩时的内存空间；

gzip_comp_level 6  #表示 Nginx 在处理压缩时的压缩等级，通常等级越高它的压缩比就越大，但并不是说压缩比越大越好，还是需要根据实际情况来选择合适的压缩比，压缩比太大影响性能，压缩比太小起不到应有的效果，一般来说推荐你设置成 6 就比较合适；

gzip_http_version 1.1 #表示只对 HTTP 1.1 版本的协议进行压缩；

gzip_min_length 256 #表示只有大于最小的 256 字节长度时才进行压缩，如果小于该长度就不进行压缩；

gzip_proxied any # 代表 Nginx 作为反向代理时依据后端服务器时返回信息设置一些 gzip 压缩策略；

gzip_vary on # 表示是否发送 Vary：Accept_Encoding 响应头字段，实现通知接收方服务端作了 gzip 压缩；

application/vnd.ms-fontobject image/x-icon;  #gip 压缩类型；

gzip_disable "msie6";  #关闭 IE6 的压缩。
```
