## awk

### 概念

### 格式
`awk options 'selection _criteria {action }' input-file > output-file`

### 选项


### 实例

NR 行号

awk 'NR>19&&NR<31' ett.txt
awk 'NR==31' ett.txt

cat > employee.txt <<-eof
ajay manager account 45000
sunil clerk account 25000
varun manager sales 50000
amit manager account 47000
tarun peon sales 15000
deepak clerk sales 23000
sunil peon sales 13000
satvik director purchase 80000 
eof

NR 行号

awk 'NR>19&&NR<31' ett.txt awk 'NR==31' ett.txt
