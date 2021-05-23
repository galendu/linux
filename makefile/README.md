## 注释 // /* */
## 第一层: 显示规则

## 目标文件:依赖文件

## 第二层：变量 =（替换） += （追加）  := （恒等于）

```Makefile
TAR = test //变量   //第二层练习文件
OBJ = circle.o cube.o main.o .
CC:=gcc  // 常量

$(TAR):$(OBJ)
    $(CC) $(OBJ) -o $(TAR)

circle.o:circle.c
    $(CC) -c circle.c -o circle.o

cube.o : cube.c
    $(CC) -c cube.c -o cube.o

main.o:main.c
    $(CC) -c main.c -o main.o

PHONY :
clearall :
    rm -rf $(OBJ) $(TAR)
clear :
    rm -rf $(0BJ)
```


## 第三层 隐含规则 %.c %.o 任意的.c或者任意的.o文件  *.c *.o 所有的.c .o 文件

```Makefile  //第三层练习
TAR = test
OBJ = circle.io cube.o main.o
CC := gcc

$(TAR):$(OBJ)
    $(CC) $(OBJ) -o $(TAR)

%.o:%.c
    $(CC) -c %.c -o %.o

.PHONY:
clearall:
    rm -rf $(OBJ) $(TAR)
clear:
    rm -rf $(OBJ)

```

## 第四层 通配符 $^ 所有的依赖文件  $@ 所有的目标文件 $< 第一个依赖文件的名称  

```Makefile   //第四层练习
TAR = test
OBJ = circle.io cube.o main.o
CC := gcc
RMRF := rm -rf 

$(TAR):$(OBJ)
    $(CC) $^ -o $@
%.o:%.c
    $(CC) -c $^ -o $@

.PHONY:
clearall:
    $(RMRF) $(OBJ) $(TAR)
clear:
    $(RMRF) $(OBJ)

```
