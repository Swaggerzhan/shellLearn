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

# 编程基础

## 变量

#### 变量的创建

shell中的变量赋值不能使用空格
```shell
var = "value" # 错误，这是编程中的双等于操作
var="value" # 正确
```

输出变量可以在前面加上 $符号，这点类似php。

```shell
echo $var 
echo ${var}
```

当然也可以加上`{}`，最好是加上`{}`，因为这样可以用于区分是否是不是变量，况且shell是通过空格来区分变量结束的，如果你想使用变量又不想加入空格，那么你只能添加`{}`。

```shell
language=Java
echo "this language is $JavaScript" # shell将整个看作变量，则找不到对应变量
echo "this language is ${Java}Script"
```

这里还需要扯到一个`''`和`""`的区别。

对于单引号，shell在解析其中的字符的时候是真的把它当成字符串， __不会去解析任何东西__ 。

对于双引号，shell将 __先解析出双引号中的变量__ ，之后才会将整个双引号扩起来的对象看成字符串。

```shell
name=Swagger
echo 'Hello $name' # Hello $name
echo "Hello $name" # Hello Swagger
```

我们还可以将一个命令的结果，作为一个变量的初始化值。其语法为`key=$(cammand)`

```shell
file_list=$(ls)
echo "in this dir, we got file: ${file_list}"

# 第二种语法
file_list=`ls`
```

#### 变量的相加

对于数字形的字符串可以进行相加，建议使用`expr`命令进行相加。

```shell
# 基本语法 key=`expr 变量 + 变量` 其中需要空格隔开符号+
key=`expr 1 + 2`
key=`expr $value1 + $value2`
```

其中运算符号有很多，比如`-`，`/`，`\*`，等等，其中乘运算符号需要加上反斜杠去掉原来意思，还有一个`=`运算符号，当`变量 = 变量2`中有空格时，`=`为比较符号，即编程语言中的`==`符号， __以上都是在expr这个命令的前提下__ 。

#### 变量的后续操作

跟其他语言一样，变量创建后，我们可以对其进行修改。

```shell
key=1
key=2 # key修改为2
```

同时，变量也存在只读变量，通过readonly，我们将变量设置为只读，后续对其进行修改将有错误信息，但不会中断整个操作流程。

```shell
key='this value cant be change'
readonly key
```

既然变量创建了，那么我们也可以将其销毁，使用`unset`将变量进行销毁。

```shell
key='this value has init....'
unset key
```

#### 变量的特殊操作

写过C的应该都知道其主函数

```C
int main(int argc, char* argv);
```

shell中也有类似的参数，用于获取传递给脚本的参数

* $$ 当前文件的进程ID
* $0 表示本文件名字
* $# 表示本文件运行时获取的参数的数量
* $n n表示某个数字，意思为某个参数的索引，类似C中argv[n]这个操作
* $? 则表示上个命令的推出状态，也可作为函数返回值

```shell
echo "this file name call $0"
echo "recv $# args"
echo "argv 1 call $1"
```

#### 变量中的替换

前文提到的单引号和双引号的区别就在于此，单引号不会进行替换，而双引号会将字符串先进行变量解析和替换才会将其视为变量值，其中`\r\n这种也是属于可替换的符号，只不过需要使用-e进行指定`

```shell
echo 'Hello World\n' # 输出就为Hello World\n
echo "Hello World\n" # 输出就为Hello World\n
echo -e 'Hello World\n' # 输出就为Hello World + 换行符
echo -e "Hello World\n" # 输出就为Hello World + 换行符
```

#### 变量中字符串的一些操作

获取字符串长度，#一般在shell中都表示长度的意思，不管是`${#key}`，还是`$#`。

```shell
#!/bin/bash
length=13445667788
echo $length
echo ${#length} # 11
```

提取子字符串，类似于切片，语法为${key:起始索引:长度}

```shell
str="0123456789"
echo ${str:3:4} # 3456
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
echo ${#array[n]} # 打印某个数组元素的长度
```

除此之外，还有关联数组，就是类似Redis的key-value数组

```shell
declare -A array # 声明关联数组
array[apple]=1000
array[orange]=2000
# 其他使用方式和普通数组一致
```

## 流程控制

其中的代表就是if语句，shell中的if语句语法

```shell
if [ 条件 ]
then
    条件为true需要执行的内容
else 
    条件为false需要执行的内容
if
```

其中嵌套的还有

```shell
if [ 条件 ]
then 
    条件为true需要执行的
elif [ 条件2 ]
then
    条件2为true需要执行的内容
else
    其余
fi
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




