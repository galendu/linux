## tcpdump

`tcpdump -i ens192 port 80 -w ./0304.pcap`

### ex1
```bash
# 容器抓包
docker pull nginx
docker run -itd --name web -p 80:80 nginx
container_pid=`docker inspect --format "{{.State.Pid}}" web`
nsenter -n -t ${container_pid}
container_ip=`ifconfig|grep inet|grep -v "127.0.0.1"|awk -F " " '{print $2}'`
container_port=80
tcpdump -i eth0 host ${container_ip} and port ${container_port} -s 0 -w test.pcap
exit
tcpdump -r test.pcap
docker rm -f web
```
