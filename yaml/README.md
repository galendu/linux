## yaml语法  
### 它的基本语法规则如下。
- 大小写敏感
- 使用缩进表示层级关系
- 缩进时不允许使用Tab键，只允许使用空格。
- 缩进的空格数目不重要，只要相同层级的元素左侧对齐即可
### YAML 支持的数据结构有三种。
- 对象：键值对的集合，又称为映射（mapping）/ 哈希（hashes） / 字典（dictionary）
```yaml
animal: pets
hash: { name: Steve, foo: bar }
```
- 数组：一组按次序排列的值，又称为序列（sequence） / 列表（list）
```yaml
$一组连词线开头的行，构成一个数组。
- Cat
- Dog
- Goldfish

$数据结构的子成员是一个数组，则可以在该项下面缩进一个空格。
-
 - Cat
 - Dog
 - Goldfish

$数组也可以采用行内表示法。
animal: [Cat, Dog]

$对象和数组可以结合使用，形成复合结构。
languages:
 - Ruby
 - Perl
 - Python 
websites:
 YAML: yaml.org 
 Ruby: ruby-lang.org 
 Python: python.org 
 Perl: use.perl.org 
```
- 纯量（scalars）：单个的、不可再分的值

$纯量是最基本的、不可再分的值。以下数据类型都属于 JavaScript 的纯量
```yaml
字符串
布尔值
整数
浮点数
Null
时间
日期
```
