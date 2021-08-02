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

## 编程基础

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

