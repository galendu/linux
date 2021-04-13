sed 流编辑器

```bash
sed -i 's#80#08#g' ett.txt

s 查找替换
g 与s联用,表示全局匹配替换
-n 取消默认输出,-i 修改文件内容,-e 允许多项编辑

seq 100 >ett.txt
cat ett.txt | head -30|tail -11

sed -n '20,30'p ett.txt

```
