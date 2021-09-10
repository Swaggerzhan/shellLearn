# Linux中的一些命令


### wc命令

记word count，即数量统计类

```shell
wc test_file.txt
# 行数 单词数 字节数
# -l for line  行
# -w for word  单词数
# -c for count 字节
```

### cut命令

主要用于提取每一个行中的具体字符，有其对应的筛选方法

```shell
-b index,index2,index3 # 通过bytes来区分，截取每行中以index为下标的字符
-c index,index2,index3 # 通过字符来区分，同上
```

其中-c表示的字符，主要是用来区分不同编码下的，比如文本文件为中文，但是使用了`-b 10`来取第10个位置的bytes，一般都会出现错误代码(中文需要几个bytes联合显示)，而`-c 10`则不会。

例如有一个文件

```
this is line1
this is line2
this is line3
```

对于以上文件使用cut命令

```shell
cut -b 1 test_file.txt
# t
# t
# t
```

还有一个`-d`和`-f`进行配合的，`-d`用来指定义分割符，-f表示field，也就是索引。

```
hello:world
Swagger:linux
C++:Java
```

```shell
cut -d ":" -f 1 test_file2.txxt
# hello
# Swagger
# C++
```

对于单空格，可以用cut来进行区分，但是对于多空格，cut就不好使用了。

# Linux三剑客

## awk

其主要格式是

```shell
awk [options] 'script' file.data
```

对于这个格式，先看一个比较简单的格式

```shell
awk 'BEGIN{} PATTERN{} END{}' file.data
```

BEGIN对应初始化，只会执行一次，END对应结尾，也是只会执行一次，而PATTERN中的指令执行次数则取决于输入行数。

假设一个文件

```
Swagger 100
0xmodN 200
Bob 300
Alice 20
Linux 40
Windows 20
C++ 300
```

使用对应的脚本

```shell
cat data.file | awk -F " " '{sum+=$2} END{print sum}'
```

其中指令部分的`{}`，一定要用单引号来扩起，这里跟shell的语法刚好相反。其中`$`同样表示特殊变量，其变量不像shell中的所有变量一样都需要使用`$`，只有特殊变量需要用到，其余都不需要，就像上例中的`sum`。上例中的`-F`则是对应的`[options]`的选项，`-F`为field，后面跟对应的域，表示的是区分的方法，`-F " "`，则表示用空格区分列，`-F ":"`则表示用`:`区分列。


