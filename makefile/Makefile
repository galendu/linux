# 第一个目标文件是我的最终目标

hello:hello.o
    gcc hello.o -o hello

hello.o:hello.S
    gcc -c hello.S -o hello.o

hello.S:hello.i
    gcc -S hello.i -o hello.S

hello.i:hello.c #hello.i 目标文件，hello.c 依赖文件
    gcc -E hello.c -o hello.i
.PHONY:
x:
    rm -rf hello.o hello.S hello.i hello
xx:
    rm -rf hello.o hello.S hello.i
