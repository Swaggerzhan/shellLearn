# SHELL

## 开始

先写一个最简单的shell

```shell
#!/bin/bash
# 第一行表示使用bash来运行
pwd # 打印当前目录
```

```shell
# 运行shell可以直接使用bash来运行
bash myScript.sh
# 或者将其看成一个可执行文件
chmod 755 myScript.sh
./myScript.sh
```

* echo

```shell
echo "字符串"
# 输出 字符串
echo '字符串'
# 输出 字符串
# 以上两种不同的是使用双引号需要在特殊字符串前使用反斜杠
echo "字符串！" # 错误，没有使用反斜杠
echo "字符串\!" # 正确
echo '字符串!' # 正确，单引号不需要

# echo出的字符串也能设置颜色
# 使用 -e 加上 \e[1;对应的颜色码m 来进行设置
# 使用 \e[0m 结束，其中0表示结束颜色显示
# 例如
echo -e "\e[1;42m 这个是绿色的 \e[0m"
# 以上将输出绿色字符串
# 红色41 绿色42 黄色43 蓝色44 白色47
```

* printf

```shell
# 和C语言中的printf一样
printf "字符串"
printf "字符串: %s" 测试
# 输出 字符串: 测试
```

#### 环境变量

使用当前shell运行的脚本都将获得对应的环境变量。

```shell
env # 获取当前环境变量
cat /proc/$PID/environ # 查看对应pid运行的环境变量
```

tr命令

```shell
# tr命令将传来的字符串进行修改
cat /proc/$PID/environ | tr '\0' '\n'
# tr命令将对应的字符串中的\0修改成\n
```

也可以手动引入环境变量

```shell
HTTP_PROXY=127.0.0.1:8888
export HTTP_PROXY
```

$PATH变量，这是一个包含当前环境变量的变量，打印它可以得到环境变量，我们可以通过特定手段改变它的变量值

```shell
#!/bin/bash
echo $PATH
export PATH="/new" # 添加环境变量
echo $PATH
```

`$SHELL`变量和 `$0`变量，它们都代表当前使用的是那种shell。
`$UID`变量表示当前运行的id号，0为root。
`$?` 变量表示上一条命令执行完后的返回值，正常为0

## 编程基础

#### 变量

shell中的变量赋值不能使用空格
```shell
var = "value" # 错误，这是编程中的双等于操作
var="value" # 正确
```

输出变量可以在前面加上 $符号，这点类似php。当然也可以加上{}

```shell
echo $var
echo ${var}
```

```shell
#!/bin/bash

fruit=apple
count=5
echo "we have $count $fruit s" # 这里的$fruit不能和s和在一起
# shell使用空格来区分变量，或者需要使用{}将变量扩起来
echo "we have $count ${fruit}s"
```

获取字符串长度

```shell
#!/bin/bash
length=13445667788
echo $length
echo ${#length} # 11
```

变量的相加和改变

```shell
num1=4
num2=5
let res=num1+num2 # 在let命令下不加$符号
let num1++ # 自增
let num1+=6 # 增6
res=$[ num1 + num2 ] # 在[]情况下要家$符号
```

#### 数组

Bash从4.0开始才支持数组，数组的定义: 

```shell
array=(test1 test2 test3 test4) # 这是一种定义方法
array[0]=test1
array[1]=test2
array[2]=test3
array[3]=test4 # 这也是一种方法
```

打印

```shell
# chapter01/1.8.sh 例子
echo ${array[1]} # 打印索引值为1的值
echo ${array[*]} # 打印数组中全部值
echo ${#array[*]} # 打印数组长度
```

除此之外，还有关联数组，就是类似Redis的key-value数组

```shell
declare -A array # 声明关联数组
array[apple]=1000
array[orange]=2000
# 其他使用方式和普通数组一致
```

#### 时间

```shell
date # 获得当前时间
date +%s # 获得时间戳
date -d "时间" +%s # 将指定时间转换成时间戳
```

#### 函数

定义函数的方式有许多种

```shell
# 第一种
function f1()
{
    函数内容
}

# 第二种
f1() {

}
```

当然函数也有其参数等等，从调用者来讲，我们需要传入参数，从函数角度来讲，我们需要使用参数

```shell
# chapter01/1.9.sh 例子
# 调用函数直接使用函数名即可，比如有一个函数名为f1的函数，则:
f1 # 调用函数

# 函数传参
f1 参数1 参数2 参数3 ... # 使用这种方式传入参数

# 函数内部使用参数
f1()
{
    $0 # 表示脚本名
    $1 # 第一个参数
    $2 # 第二个参数 以此类推
    $@ # 表示所有参数

}
```


## 重定向

`>`符号将使得某个字符串输入到文件中，如:

```shell
# 将this is test string重定向到目标文件中
echo "this is test string" > target.txt 
# > 符号会将原来存在于target.txt的内容清空，之后再加入对应字符串
```

`>>` 符号将使得某个字符串追加到文件中，如: 

```shell
echo "this is test string" >> target.txt
# >> target.txt原先内容不会被清空，this is test string 会被追加到后面
```

##### 重定向错误信息

使用 `2>` 来进行重定向错误信息

```shell
ls + # 这是一个错误的命令，会产生错误信息
ls + 2> err.txt # 将产生的错误信息重定向到err.txt文件中
```

实际上，Linux shell使用`0`, `1`, `2`,分别来代表标准输入，标准输出，标准错误，所以，我们可以使用如下方法来重定向标准输出: 

```shell
echo "test" > target.txt # 重定向标准输出
echo "test" 1> target.txt # 同样也是重定向标准输出
# 以上的方法都会导致输出前清空target.txt文件!
```

按照上面的方法，我们可以举一反三的出追加重定向的方法:

```shell
echo "test" >> target.txt
echo "test" 1>> target.txt
ls + 2>> target.txt # 错误追加重定向
```

我们也可以分开重定向不同的输出

```shell
# cmd 代表某种命令
cmd 2> err.txt 1> out.txt
# 将错误输出到err.txt，将标准输出重定向到out.txt
```

又或者合并输出

```shell
cmd &> out.txt # 将标准错误和标准输出都重定向到out.txt文件中
```

如果你想无视任何到输出，则只需要重定向到文件 `/dev/null`，中即可，这个是Linux系统中的 "无底洞"。

<font color=F0000> tee 命令 </font>

有时我们不只想要重定向数据到某个文件中，同时也需要使用管道将某些数据作为另外一个程序的输入，使用tee命令可以做到这个。

```shell
# chapter01/1.6.sh 例子
# cmd和cmd2为某种命令
cmd | tee out.txt | cmd2
```

上方的做法使得cmd命令的输出重定向到文件out.txt中，并且又将其cmd的输出作为cmd2命令的输入。

__严格来讲，`|`也是某种重定向，但还有一个重定向，即`<`符号__ 。

```shell
cmd < file.txt # 将file.txt中的数据重定向到cmd命令中去
# 例如
grep test < file.txt # 将file.txt中的文件传输到命令中去，选出"test"字符串
```

<font color=F0000> 文件描述符，shell跟C/C++一样，也有文件描述符，之前讲到的 `1>` '2>' 就使用了文件描述符的方法，当然我们可以自定义创建文件描述符，只不过跟默认的有些许不同。 </font>

```shell
# chapter01/1.7.sh 例子
exec 3> target.txt # 创建文件描述符3，它指向target.txt
echo "test" >&3 # 将数据写入文件描述符3中，即target.txt
# 注意: 默认文件描述符使用 2> 或者 1> 的方式，自创建使用 >&3 的方式
# 如果是追加模式只需要将>换成>>即可
```




