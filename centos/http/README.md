## shell脚本中curl取得HTTP返回的状态码
curl -I -m 10 -o /dev/null -s -w %{http_code} www.baidu.com
```bash
-I 仅测试HTTP头
-m 10 最多查询10s
-o /dev/null 屏蔽原有输出信息
-s silent 模式，不输出任何东西
-w %{http_code} 控制额外输出
```
