
postgresql 安装卸载

```bash

#安装
apt install postgresql postgresql-contrib -y

echo "host    all            all                192.168.0.1/24        trust">>/etc/postgresql/11/main/pg_hba.conf
echo "listen_addresses = '*'">>/etc/postgresql/11/main/postgresql.conf
systemctl restart postgresql
#默认端口 5432
#卸载

apt-get remove --purge postgresql

apt-get remove --purge postgresql

 dpkg --configure -a
 apt-get -f install
 apt-get update && sudo apt-get upgrade
 
 apt-get --purge remove postgresql\*
```
