## mysql
### mysql搭建
```shell
docker run -itd --name mysql57  -p 3306:3306 -e MYSQL_ROOT_PASSWORD="123456" mysql:5.7
```
### 配置文件配置

```bash
# For advice on how to change settings please see
# http://dev.mysql.com/doc/refman/5.7/en/server-configuration-defaults.html

[mysqld]
#pid-file    = /var/run/mysqld/mysqld.pid
#socket      = /var/run/mysqld/mysqld.sock
#datadir     = /var/lib/mysql
#log-error  = /var/log/mysql/error.log
# By default we only accept connections from localhost
bind-address   = 0.0.0.0
datadir=/home/mysql/data
socket=/home/mysql/data/mysql.sock
# Disabling symbolic-links is recommended to prevent assorted security risks
#symbolic-links=0

sql_mode=STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION
max_connections=2000
default-time_zone='+8:00'
character-set-server=utf8
lower_case_table_names=1 #忽略大小写敏感
log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid
symbolic-links=0
port=13306
query_cache_type = 1
query_cache_size = 8M
query_cache_limit = 2M
# 数据缓冲区buffer pool大小，建议使用物理内存的 75%
innodb_buffer_pool_size = 8G
innodb_buffer_pool_instances = 4
##开启慢查询日志
slow_query_log = 1
##超出次设定值的SQL即被记录到慢查询日志
long_query_time = 2
```

### 基础操作
```sql
-- 授权允许远程连接
grant all privileges on *.* to 'root@%' identified by '123456' with grant option;
flush privileges;

-- 查看mysql最大连接数
show variables like '%max_connections%';
-- 设置最大连接数
set GLOBAL max_connections = 200;
-- 查看当前所有用户的连接
show full processlist;
-- 查看状态
show status;
show status like '%下面变量%'; 
-- Aborted_clients                由于客户没有正确关闭连接已经死掉，已经放弃的连接数量。 
-- Aborted_connects            尝试已经失败的MySQL服务器的连接的次数。 
-- Connections                     试图连接MySQL服务器的次数。 
-- Created_tmp_tables          当执行语句时，已经被创造了的隐含临时表的数量。 
-- Delayed_insert_threads     正在使用的延迟插入处理器线程的数量。 
-- Delayed_writes                用INSERT DELAYED写入的行数。 
-- Delayed_errors                用INSERT DELAYED写入的发生某些错误(可能重复键值)的行数。 
-- Flush_commands            执行FLUSH命令的次数。 
-- Handler_delete                 请求从一张表中删除行的次数。 
-- Handler_read_first          请求读入表中第一行的次数。 
-- Handler_read_key           请求数字基于键读行。 
-- Handler_read_next           请求读入基于一个键的一行的次数。 
-- Handler_read_rnd           请求读入基于一个固定位置的一行的次数。 
-- Handler_update              请求更新表中一行的次数。 
-- Handler_write                 请求向表中插入一行的次数。 
-- Key_blocks_used            用于关键字缓存的块的数量。 
-- Key_read_requests         请求从缓存读入一个键值的次数。 
-- Key_reads                      从磁盘物理读入一个键值的次数。 
-- Key_write_requests         请求将一个关键字块写入缓存次数。 
-- Key_writes                      将一个键值块物理写入磁盘的次数。 
-- Max_used_connections    同时使用的连接的最大数目。 
-- Not_flushed_key_blocks   在键缓存中已经改变但是还没被清空到磁盘上的键块。 
-- Not_flushed_delayed_rows      在INSERT DELAY队列中等待写入的行的数量。 
-- Open_tables                  打开表的数量。 
-- Open_files                     打开文件的数量。 
-- Open_streams               打开流的数量(主要用于日志记载） 
-- Opened_tables              已经打开的表的数量。 
-- Questions                     发往服务器的查询的数量。 
-- Slow_queries                要花超过long_query_time时间的查询数量。 
-- Threads_connected       当前打开的连接的数量。 
-- Threads_running          不在睡眠的线程数量。 
-- Uptime                        服务器工作了多少秒。
```

### mysql备份

### mysql恢复

### mysql操作

```sql
-- 创建表
CREATE TABLE `user` (
    `id` BIGINT(20) NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(20) DEFAULT '',
    `age` INT(11) DEFAULT '0',
    PRIMARY KEY(`id`)
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

-- 插入数据
insert into user(name,age) values ("wangwu",20);
insert into user(name,age) values ("小王",12);
insert into user(name,age) values ("小明",21);
insert into user(name,age) values ("小花",22);
-- 删除数据
-- 数据查询
select id,name,age from user;
select id,name,age from user where id>2;
`````