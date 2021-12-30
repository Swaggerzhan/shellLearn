
## 0x00 一些常用的命令，但是经常忘记其参数意义

### 1. tar命令

直接上打包和解压命令

```shell
tar -zcvf 输出名 目录名/*
# 例如
tar -zcvf my.tar.gz test_src/*
# 将test_src中的全部文件打包压缩至my.tar.gz中
#---------解压----------
tar -zxvf my.tar.gz
```
参数意义：

__-z :__ 表示有压缩，格式为gzip。

__-v :__ 表示显示压缩过程。

__-f :__ 表示文件名，后必须跟一个文件名，压缩时表示压缩完成后输出文件名，解压时表示需要解压的文件名。

__-x :__ 表示解压。

__-c :__ 表示压缩。

__-j :__ 表示其他格式的压缩，为bzip2压缩格式。

一般而言常用的就这几种：

```shell
tar -zvcf out.tar.gz target/* # 将target文件夹以gzip压缩为out.tar.gz
tar -jvcf out.tar.bz2 target/* # 将target文件夹以bzip2压缩为out.tar.bz2
tar -zvxf out.tar.gz  # 将文件解压，解压格式gzip
tar -jvxf out.tar.bz2 # 将文件解压，解压格式bzip2
```
 
### 2. 通过shell返回父目录

首先理解一下NF和$NF，其中 __NF表示有几个Field(列)__ ， __$NF则表示最后那个(Field)的值__ 。

那么返回父目录就很简单了：

```shell
pwd | awk -F "/" '{print $NF}' # 返回父目录
pwd | awk -F "/" '{print NF}' # 表示几个列，也就是从/根目录到当前目录需要进多少次目录
```

### 3. shell输入窗口一些快捷键

删除从当前光标开始后所有字符：

```shell
$ 11111111111111112333333333333333333
#                 ^
```

当前光标指向1和2中间的位置，使用`ctrl + k`可以将光标之后的3全部删除掉(包括2)。
使用`ctrl + u`可与将光标前到都删除(所有1，Mac上的Shell不可用)。

`ctrl + a`可以将光标移动最前面(常用)。

`ctrl + e`可与将光标移动到最后面(常用)。

### 4. chmod命令

__u :__ 表示拥有者

__g :__ 表示所在组

__o :__ 表示所有人

所以命令也就为：

```shell
chmod ugo+r targetFile # 将targetFile设置为所有人都可以读
chmod go+r targetFile #  将targetFile设置为拥有组和所有人可读
```

当然也可以用数字的方式来记录，`4->读`，`2->写`，`1->执行`，`0->无权限`。

```shell
chmod 777 targetFile # 全部权限
chmod 666 targetFile # 可以读写，不可执行
```

### 5. 拒绝某些用户登陆

```shell
usermod -s /sbin/nologin swagger # 拒绝swagger登陆
# 也可：
usermod -s /sbin/false swagger
```

### 6. 修改主机名

```shell
hostname # 获得主机名
sudo hostnamectl set-hostname <newhostname> # 临时修改主机名
```

想要永久修改，可以将以下命令增加到/etc/hosts中。

```shell
hostname <newhostname>
```