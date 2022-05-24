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
### 4.常用模块
#### 4.1 sticky 回话保持模块

```nginx.conf
upstream www_web_com {
#   ip_hash;
   sticky expires=1h domain=web.com path=/;
   server 10.0.0.16:8080;
   server 10.0.0.17:8080;
}

# 参数，解析

sticky [name=route] [domain=.foo.bar] [path=/] [expires=1h] 
       [hash=index|md5|sha1] [no_fallback] [secure] [httponly];
复制代码
[name=route]　　　　　　　设置用来记录会话的cookie名称
[domain=.foo.bar]　　　　设置cookie作用的域名
[path=/]　　　　　　　　  设置cookie作用的URL路径，默认根目录
[expires=1h] 　　　　　　 设置cookie的生存期，默认不设置，浏览器关闭即失效，需要是大于1秒的值
[hash=index|md5|sha1]   设置cookie中服务器的标识是用明文还是使用md5值，默认使用md5
[no_fallback]　　　　　　 设置该项，当sticky的后端机器挂了以后，nginx返回502 (Bad Gateway or Proxy Error) ，而不转发到其他服务器，不建议设置
[secure]　　　　　　　　  设置启用安全的cookie，需要HTTPS支持
[httponly]　　　　　　　  允许cookie不通过JS泄漏，没用过
```


