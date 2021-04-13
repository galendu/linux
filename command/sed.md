sed 命令
seq 100 >ett.txt
cat ett.txt | head -30|tail -11

sed -n '20,30'p ett.txt

