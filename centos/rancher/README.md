## rancher 
docker run --restart=unless-stopped -d -p 443:443 -v /data/rancher/data:/var/lib/rancher  --name rancher  rancher/rancher:stable

--restart=unless-stopped 不管退出状态码是什么始终重启容器 
