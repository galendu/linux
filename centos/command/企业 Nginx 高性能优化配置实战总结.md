## nginx优化
![nginx](https://www.lgstatic.com/i/image3/M01/66/37/CgpOIF5FJ5mAVRPiAABbkiJwxcQ434.png "nginx")
### 1.基础配置优化主要包括：
- CPU亲和性优化；
  - CPU亲和性
  ![](https://www.lgstatic.com/i/image3/M01/66/38/Cgq2xl5FJ6eARXPfAACAxakE-So430.png cpu亲和性)
  - IO 流事件模型
   
- Nginx IO事件模型；
    Nginx 第二个基础配置优化项是 IO 流事件模型，我们经常可以在 Nginx 下面看到的 events 配置模块中默认设置了 use epoll，表示 Nginx 使用 epoll 这个 IO 流事件模型，那为什么 Nginx 会选择使用 epoll 呢？这是因为 epoll 有以下这些得天独厚的优势。我们来详细讲解一下：
    首先，Linux 系统下一切皆文件，比如我们打开一个设备，它便会产生一个文件描述符。在产生一个进程时，这个进程便需要一个进程描述符，这个进程描述符也是一个文件。所以在 Nginx 处理请求的时候，每一个请求都会产生处理请求的描述符。
    其次，在 Nginx 处理大规模请求的时候，为了提高并发效率需要采用异步非阻塞模型，这又和 epoll 有什么关系呢？epoll 本身是以异步非阻塞模型来处理请求流中的事件流。
    这里还需要注意一点，并不是所有的 Linux 操作系统都可以使用 epoll，它是在 kernel 2.6 版本以后提出的，早期内核使用的 select\poll 模型，select 模型比 epoll 模型性能要低很多，有经验的运维同学一定深有体会。
    通过上面的背景铺垫，我们再来详细介绍下 epoll 相比于 select 模型具备的优势：
    epoll 处理事件流模型是线程安全的；
    epoll 跟 select 模型相比调用 fd 文件描述符时使用了 mmap 共享用户和内核的部分空间，提高了效率；
    epoll 是基于事件驱动的，相比 select 需要扫描整个文件描述符的相关状态，epoll 基于事件驱动避免频繁扫描文件描述符，可以直接调用 callback 回调函数，效率更高；
    取消了 select 模型里面单个进程能够监视的文件描述符的数量存在的最大限制（1024），如果你有使用过早期的 Apache 版本的，它使用的select 模型，当请求超过 1000 以后就会出现延迟或者请求错误，而改用 Nginx 的话性能会得到明显的改善。
    另外补充下，在 events{} 配置中还涉及一个优化的地方就是 worker_connections，这个也是在 events 里面来进行设置的，通过上面的学习我们知道了 worker 线程作用，那每一个 work线程所支持的连接是有限的，这里会默认设置成 1024，而我们在处理高并发的场景时，单个 worker 线程设置成 1024 的话往往偏低，这里建议你将 worker_connections 调大一些，你可以参考实际业务所需 Nginx 处理最大峰值来调大这个设置值。

- Nginx 传输方式优化；
  - 零拷贝

    第三个基础配置优化是零拷贝，所谓零拷贝的配置是在 Nginx 中的 HTTP 配置模块中添加一个 sendfile on 配置项，它便是一个零拷贝，所谓零拷贝并不代表不拷贝了，而是说它做到了文件的内核态到用户态的零拷贝。
    [](https://www.lgstatic.com/i/image3/M01/66/37/CgpOIF5FJ72ARWG4AAB82n3NOT0111.png)
    如图所示，我们先来看下没有零拷贝时文件传输是什么样子的？首先 Nginx 在处理文件时，会将文件传入操作系统内核态的 Buffer Cache，然后传递到操作系统上层的用户态，经用户态的 Buffer Cache 再传回内核态中，最后通过 Socket 将文件转发出去。
    这个时候你会发现一个问题，对于静态文件并不需要流转到用户态中，直接通过内核态效率更高，所以这时我们就需要在 Nginx 中开启 sendfile on，这样静态文件就可以通过红色的路径在内核态中完成转发，而不用再去绕道用户态，提高了效率。
- Nginx 文件压缩优化。
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
  
  
