grep 
-B -A -C
-v 排除
-A 除了显示匹配的一行之外,并显示该行之后的num行
grep 20 -A 10 ett.txt

-B除了显示匹配的一行之外,并显示该行之前的num行
grep 30 -B 10 ett.txt

-C 除了显示匹配的一行之外,并显示该行之前后各num行
grep 25 -C 5 ett.txt
