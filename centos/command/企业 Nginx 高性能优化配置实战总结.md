## nginx优化
![nginx](https://www.lgstatic.com/i/image3/M01/66/37/CgpOIF5FJ5mAVRPiAABbkiJwxcQ434.png "nginx")
### 1.基础配置优化主要包括：
- CPU亲和性优化；
- Nginx 模型优化；
- Nginx 传输方式优化；
- Nginx 文件压缩优化。
  - CPU亲和性
  ![](https://www.lgstatic.com/i/image3/M01/66/38/Cgq2xl5FJ6eARXPfAACAxakE-So430.png cpu亲和性)
  - IO 流事件模型
   ![](https://www.lgstatic.com/i/image3/M01/66/37/CgpOIF5FJ72ARWG4AAB82n3NOT0111.png 零拷贝)
  Nginx 基础配置优化的最后一项是文件压缩，我们希望做到 Nginx 服务端往客户端发送的数据越小，占用的延迟越低用户体验便会越好。所以往往在代理或 Nginx 中会设置文件压缩，我们主要通过 gzip 方式进行设置，主要的设置项如下：

  gzip on 负责打开后端的压缩功能；

  gzip_buffer 16 8k  表示设置 Nginx 在处理文件压缩时的内存空间；

  gzip_comp_level 6 表示 Nginx 在处理压缩时的压缩等级，通常等级越高它的压缩比就越大，但并不是说压缩比越大越好，还是需要根据实际情况来选择合适的压缩比，压缩比太大影响性能，压缩比太小起不到应有的效果，一般来说推荐你设置成 6 就比较合适；

  gzip_http_version 1.1 表示只对 HTTP 1.1 版本的协议进行压缩；

  gzip_min_length 256 表示只有大于最小的 256 字节长度时才进行压缩，如果小于该长度就不进行压缩；

  gzip_proxied any 代表 Nginx 作为反向代理时依据后端服务器时返回信息设置一些 gzip 压缩策略；

  gzip_vary on 表示是否发送 Vary：Accept_Encoding 响应头字段，实现通知接收方服务端作了 gzip 压缩；

  application/vnd.ms-fontobject image/x-icon;  gip 压缩类型；

  gzip_disable “msie6”;  关闭 IE6 的压缩。

  最后这两项表示设置 zip 的压缩类型及是否关闭 客户端使用 IE6 浏览器请求过来的压缩，以上就是对文件压缩的典型配置，你可以根据具体情况做一些细节上的调整。
  
