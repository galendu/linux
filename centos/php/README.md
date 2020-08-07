## 访问info.php，发现Loaded Configuration File为空。
## 安装strace
```bash
strace /usr/local/sbin/php-fpm -i 2>1.log
```
找到php.ini文件指定的位置  
将php.ini文件复制到对应的位置即可
