## 监控java线程
```bash
entrypoint: java -Dcom.sun.management.jmxremote.port=29112 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Djava.rmi.server.hostname=192.168.0.xx -Dcom.sun.management.jmxremote.rmi.port=29112 -Xmx768m -Xms256m -Djava.security.egd=file:/dev/./urandom -jar /usr/local/bin/app.jar
```
## 分析工具 jmap jstack jstat
yum -y install java-1.8.0-openjdk-devel
