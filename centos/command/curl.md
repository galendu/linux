## curl测试网站打开速度
curl -o /dev/null -s -w %{time_namelookup}:%{time_connect}:%{time_starttransfer}:%{time_total} http://www.baidu.com
