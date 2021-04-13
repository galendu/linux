## 加密mysql密码
```bash
mysql_config_editor set --login-path=mydb --host=127.0.0.1 --port=13306 --user=root --password
```

## 使用密文连接mysql

```bash
mysql --login-path=mydb
```

## 数据库备份

```bash
mysqldump  --login-path=mydb  --all-databases  --single-transaction --set-gtid-purged=OFF |gzip >/bck/data/xx-`date +%Y%m%d%H%M`.tar.gz
```

## 数据库恢复

```bash

gunzip < *.tar.gz |mysql --login-path=mydb 
```
