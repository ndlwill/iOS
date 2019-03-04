#!/bin/sh

# http://www.reddragonfly.org/abscn/index.html


# 127返回码对应的Bash错误码为命令未发现"command not found"
# "true" 是内建命令
#
# export命令将会使得被export的变量在所运行脚本(或shell)的所有子进程中都可用
# export命令的一个重要的用法就是使用在启动文件中, 启动文件用来初始化和设置环境变量, 这样, 用户进程才能够访问环境变量
#
# 使用"let"命令来做算术运算
#
# read从stdin中"读取"一个变量的值, 和键盘进行交互, 来取得变量的值
#
# 内部命令与内建命令 http://www.reddragonfly.org/abscn/internal.html#EXPORTREF
#
# cd -将会回到先前的工作目录
# ~+ 当前工作目录
# ~- 先前的工作目录
#
# 如果条件测试结构两边中的任意一边结果为true的话, ||操作就会返回0(代表执行成功)
# 
# 在脚本中, 使用RE的是命令和工具 -- 比如sed和awk -- 这些工具能够解释RE

# shell命令
# wc命令用于计算文件的Byte数、字数、或是列数，若不指定文件名称、或是所给予的文件名为"-"，则wc指令会从标准输入设备读取数据
#
# ln它的功能是为某一个文件在另外一个位置建立一个同步的链接.当我们需要在不同的目录,用到相同的文件时，我们不需要在每一个需要的目录下都放一个必须相同的文件，我们只要在某个固定的目录，放上该文件，然后在 其它的目录下用ln命令链接（link）它就可以，不必重复的占用磁盘空间
# ln [参数][源文件或目录][目标文件或目录]
# 可以在 /usr/local/bin/ 目录下建立软连接，就可以直接使用 PlistBuddy 命令了ln -s /usr/libexec/PlistBuddy /usr/local/bin/PlistBuddy
# Linux文件系统中，有所谓的链接(link)，我们可以将其视为档案的别名，而链接又可分为两种 : 硬链接(hard link)与软链接(symbolic link)，硬链接的意思是一个档案可以有多个名称，而软链接的方式则是产生一个特殊的档案，该档案的内容是指向另一个档案的位置。硬链接是存在同一个文件系统中，而软链接却可以跨越不同的文件系统。
# 不论是硬链接或软链接都不会将原本的档案复制一份，只会占用非常少量的磁碟空间
# 
# find命令用来在指定目录下查找文件
# -name name, -iname name : 文件名称符合 name 的文件。iname 会忽略大小写
#
# defaults  /usr/bin/defaults
#
# iconutil  /usr/bin/iconutil


# 通配(globbing)
# Bash本身并不会识别正则表达式. 在脚本中, 使用RE的是命令和工具 -- 比如sed和awk -- 这些工具能够解释RE.
# Bash仅仅做的一件事是文件名扩展filename globbing这就是所谓的通配(globbing) -- 但是这里所使用的并不是标准的RE, 而是使用通配符
# ^用来表示取反匹配
# 包含*的字符串不能匹配以"点"开头的文件
# a.1 b.1 c.1 t2.sh test1.txt
# ls -l t?.sh -> t2.sh
# ls -l [ab]* -> a.1 b.1
# ls -l [a-c]* -> a.1 b.1 c.1
# ls -l [^ab]* -> c.1 t2.sh test1.txt
# ls -l {b*,c*,*est*} -> b.1 c.1 test1.txt
# 能够匹配以"点"开头的文件, 但是, 你必须在模式字符串中明确的写上"点"(.), 才能够扩展 ~/.[b]ashrc    #  可以扩展成~/.bashrc


# if
# if/then结构用来判断命令列表的退出状态码是否为0(因为在UNIX惯例, 0表示"成功")
# "if COMMAND"结构将会返回COMMAND的退出状态码

# diff
# 文件比较工具. 这个工具将会以一行接一行的形式来比较目标文件

# 字符(" ' \)可以用来转义

# /dev/null属于字符特殊文件，它属于空设备，是一个特殊的设备文件
# 所有写入它的内容都会永远丢失. 而如果想从它那读取内容, 则什么也读不到
# file /dev/null
# 一般标准输出和标准错误输出都是屏幕，因此错误信息还是会在屏幕上输出。
# 0：表示标准输入流（stdin）
# 1：表示标准输出（stdout）
# 2：表示标准错误输出（stderr）
# cat test.txt 2>/dev/null  
# 将标准错误输出重定向到/dev/null，所以屏幕上不会再显示错误提示了（如果没有test.txt）
# 禁用stdout和stderr  cat $filename 2>/dev/null >/dev/null

# 圆括号中的命令列表( command1; command2; command3; ... )将会运行在一个子shell中
# 子shell中的变量对于子shell之外的代码块来说, 是不可见的. 当然, 父进程也不能访问这些变量, 父进程指的是产生这个子shell的shell. 事实上, 这些变量都是局部变量

# echo
# echo命令需要-e参数来打印转义字符  echo -e "\n\n"
# 每个echo命令都会在终端上新起一行, 但是-n参数会阻止新起一行

# $
# $* 所有的位置参数都被看作为一个单词 "$*"必须被引用起来
# $@ 与$*相同, 但是每个参数都是一个独立的引用字符串 "$@"应该被引用起来
# $_ 这个变量保存之前执行的命令的最后一个参数的值
# $? 命令, 函数, 或者是脚本本身的退出状态码


# 命令替换
# 命令替换的典型用法形式, 是使用后置引用(`...`)
# `command`结构可以将命令的输出赋值到一个变量中去
# 命令替换可能会引起单词分割
# COMMAND `echo a b`     # 两个参数: a and b
# COMMAND "`echo a b`"   # 1个参数: "a b"
# COMMAND `echo`         # 无参数
# COMMAND "`echo`"       # 一个空参数

# 变量替换
# 变量前面加上$用来引用这个变量的值
# 被一对双引号(" ")括起来的变量替换是不会被阻止的. 所以双引号被称为部分引用, 有时候又被称为"弱引用". 
# 但是如果使用单引号的话(' '), 那么变量替换就会被禁止了, 变量名只会被解释成字面的意思, 不会发生变量替换. 所以单引号被称为全引用, 有时候也被称为"强引用",全引用的作用将会导致"$"被解释为单独的字符
# $variable事实上只是${variable}的简写形式

# 参数替换 处理和(或)扩展变量
# ${parameter}与$parameter相同, 也就是变量parameter的值
# 把变量和字符串组合起来 var=ndl echo ${var}-will
# echo "Old \$PATH = $PATH"
# PATH=${PATH}:/opt/bin  #在脚本的生命周期中, /opt/bin会被添加到$PATH变量中.
# echo "New \$PATH = $PATH"
# (赋值null属于没被设置)
# ${parameter-default} -- 如果变量parameter没被声明, 那么就使用default默认值
# ${parameter:-default} -- 如果变量parameter没被设置, 那么就使用default默认值 
# ${parameter=default} -- 如果变量parameter没声明, 那么就把它的值设为default
# ${parameter:=default} -- 如果变量parameter没设置, 那么就把它的值设为default
# ${parameter+alt_value} -- 如果变量parameter被声明了, 那么就使用alt_value, 否则就使用null字符串
# ${parameter:+alt_value} -- 如果变量parameter被设置了, 那么就使用alt_value, 否则就使用null字符串
# ${parameter?err_msg} -- 如果parameter已经被声明, 那么就使用设置的值, 否则打印err_msg错误消息
# ${parameter:?err_msg} -- 如果parameter已经被设置, 那么就使用设置的值, 否则打印err_msg错误消息
# ${variablename?}结构也能够检查脚本中变量的设置情况
# ${#var}字符串长度(变量$var得字符个数). 对于array来说, ${#array}表示的是数组中第一个元素的长度.
# ${#*}和${#@}表示位置参数的个数 对于数组来说, ${#array[*]}和${#array[@]}表示数组中元素的个数
#
# ${var#Pattern}, ${var##Pattern}从变量$var的开头删除最短或最长匹配$Pattern的子串. (一个"#"表示匹配最短, "##"表示匹配最长.)
# var1=abcd-1234-defg   echo ${var1#*-*}
# strip_leading_zero () #  去掉从参数中传递进来的,可能存在的开头的0(也可能有多个0)
# {                     
# 	return=${1#0}       #  "1"表示的是"$1" -- 传递进来的参数.
# }  
# ${var%Pattern}, ${var%%Pattern}从变量$var的结尾删除最短或最长匹配$Pattern的子串. (一个"%"表示匹配最短, "%%"表示匹配最长.)
# 变量扩展/子串替换
# ${var:pos} 变量var从位置pos开始扩展(也就是pos之前的字符都丢弃)
# ${var:pos:len} 变量var从位置pos开始, 并扩展len个字符
# ${var/Pattern/Replacement} 使用Replacement来替换变量var中第一个匹配Pattern的字符串.如果省略Replacement, 那么第一个匹配Pattern的字符串将被替换为空, 也就是被删除了
# ${var//Pattern/Replacement} 全局替换. 所有在变量var匹配Pattern的字符串, 都会被替换为Replacement.如果省略Replacement, 那么所有匹配Pattern的字符串, 都将被替换为空, 也就是被删除掉
# ${var/#Pattern/Replacement} 如果变量var的前缀匹配Pattern, 那么就使用Replacement来替换匹配到Pattern的字符串
# v0=abc1234zip1234abc  echo ${v0/#abc/ABCDEF}
# ${var/%Pattern/Replacement} 如果变量var的后缀匹配Pattern, 那么就使用Replacement来替换匹配到Pattern的字符串
# ${!varprefix*}, ${!varprefix@} 匹配所有之前声明过的, 并且以varprefix开头的变量


# 转义
# 转义是一种引用单个字符的方法. 一个前面放上转义符 (\)的字符就是告诉shell这个字符按照字面的意思进行解释, 就是这个字符失去了它的特殊含义.
# 在某些特定的命令和工具中, 比如echo和sed, 转义符往往会起到相反效果 - 它反倒可能会引发出这个字符的特殊含义
# \$ 表示$本身子面的含义(跟在\$后边的变量名将不能引用变量的值) echo "\$variable01"  # 结果是$variable01
# \" 表示引号字面的意思   echo "\"Hello\", he said."    # "Hello", he said.
# \\ 表示反斜线字面的意思  echo "\\"  # 结果是\
# echo \z               #  z
# echo \\z              # \z
# echo '\z'             # \z
# echo '\\z'            # \\z
# echo "\z"             # \z
# echo "\\z"            # \z

# :
# 空命令
# 使用参数替换来评估字符串变量
# : ${HOSTNAME?} ${USER?} ${MAIL?}
# 如果一个或多个必要的环境变量没被设置的话,就打印错误信息
#
# 在与>重定向操作符结合使用时, 将会把一个文件清空, 但是并不会修改这个文件的权限. 如果之前这个文件并不存在, 那么就创建这个文件
# : > data.xxx   # 文件"data.xxx"现在被清空了    与cat /dev/null >data.xxx 的作用相同
# 在与>>重定向操作符结合使用时, 将不会对预先存在的目标文件(: >> target_file)产生任何影响. 如果这个文件之前并不存在, 那么就创建它

# 双圆括号结构(( ))
# 扩展并计算在(( ))中的整数表达式.
# 与let命令很相似, ((...))结构允许算术扩展和赋值
# 双圆括号结构也被认为是在Bash中使用C语言风格变量操作的一种处理机制 (( a = 23 ))  # C语言风格的变量赋值, "="两边允许有空格
# a=$(( 5+3 )) 
#
# (( a = 23 ))
# echo $a
# 
# (( ))结构扩展并计算一个算术表达式的值. 如果表达式的结果为0, 那么返回的退出状态码为1, 或者是"假". 而一个非零值的表达式所返回的退出状态码将为0, 或者是"true"
# Exit status
# (( 0 )) # 结果为0,退出状态码为1
# (( 1 )) # 0
# (( 5 > 4 )) # true(0)
# (( 5 > 9 )) # 1
# (( 5 - 5 )) # 结果为0,退出状态码为1
# (( 5 / 4 )) # 0


# 算术比较 返回退出状态码 当它们所测试的算术表达式的结果为非零的时候, 将会返回退出状态码0
# let "1<2" returns 0 (as "1<2" expands to "1")
# (( 0 && 1 )) returns 1 (as "0 && 1" expands to "0")

# =
# =既可以用做条件测试操作, 也可以用于赋值操作


# let
# 使用'let'赋值  let a=16+5

# 重定向
# scriptname >filename 重定向scriptname的输出到文件filename中. 如果filename存在的话, 那么将会被覆盖.
# command &>filename 重定向command的stdout和stderr到filename中.
# command >&2 重定向command的stdout到stderr中
# scriptname >>filename 把scriptname的输出追加到文件filename中. 如果filename不存在的话, 将会被创建


# -
# 用于重定向stdin或stdout


# ()
# 1.命令组
# (a=hello; echo $a)
# 2.初始化数组
# Array=(element1 element2 element3)

# []
# 使用-n 在[]结构中测试必须要用""把变量引起来.习惯于使用""来测试字符串是一种好习惯
# 使用[[]]条件判断结构, 而不是[], 能够防止脚本中的许多逻辑错误. 比如, &&, ||, <, 和> 操作符能够正常存在于[[ ]]条件判断结构中, 但是如果出现在[ ]结构中的话, 会报错


# "STRING"将会阻止(解释)STRING中大部分特殊的字符
# 'STRING'将会阻止STRING中所有特殊字符的解释

# 字符串比较
# = 等于 if [ "$a" = "$b" ]
# == 等于 if [ "$a" == "$b" ] 与=等价
#
# ==比较操作符在双中括号对和单中括号对中的行为是不同的
# [[ $a == z* ]]    # 如果$a以"z"开头(模式匹配)那么结果将为真
# [[ $a == "z*" ]]  # 如果$a与z*相等(就是字面意思完全一样), 那么结果为真.
# [ $a == z* ]      # 文件扩展匹配(file globbing)和单词分割有效. 
# [ "$a" == "z*" ]  # 如果$a与z*相等(就是字面意思完全一样), 那么结果为真.
# <
# 小于, 按照ASCII字符进行排序
# if [[ "$a" < "$b" ]]
# if [ "$a" \< "$b" ] # "<"使用在[ ]结构中的时候需要被转义

# 函数
# 一个函数就是一个子程序
# function_name () { } 只需要简单的调用函数名, 函数就会被调用
# 函数可以处理传递给它的参数, 并且能返回它的退出状态码给脚本 function_name $arg1 $arg2
# 函数返回一个值, 被称为退出状态码. 退出状态码可以由return命令明确指定, 也可以由函数中最后一条命令的退出状态码来指定(如果成功则返回0, 否则返回非0值)

set -- "ndl" "88" "will"

echo "==============="
echo "OLDPWD = $OLDPWD" # 之前你所在的目录
echo "PWD = $PWD"
echo "PATH = $PATH"
echo "BASH = $BASH" # Bash的二进制程序文件的路径
echo "BASH_VERSION = $BASH_VERSION"
echo "UID = $UID" # $UID为0的时候,用户才具有root用户的权限
echo "GROUPS = $GROUPS" # 目前用户所属的组
echo "HOME = $HOME" # 用户的home目录
echo "LINENO = $LINENO"
echo "SECONDS = $SECONDS" # 这个脚本已经运行的时间(以秒为单位)
echo "IFS = #$IFS#" # 特殊变量$IFS用来做一些输入命令的分隔符, 默认情况下是空白(空白包含空格, tab, 空行, 或者是它们之间任意的组合体)


ARGS=3         # 这个脚本需要3个参数
if [ $# -ne "$ARGS" ] # $# 命令行参数或者位置参数的个数 (-ne不等于)
then
	echo "传递给脚本的参数个数不对"
fi

if [ ! -n "$1" ]; then # -n 字符串不为"null"
	echo "param1 = null"
fi


index=1
echo "Listing args with \"\$*\":"
for arg in "$*"
do
	echo "Arg #$index = $arg"
	let "index+=1" # index+=1 两者不一样
done 
echo
index=1
echo "Listing args with \"\$@\":"
for arg in "$@"
do
	echo "Arg #$index = $arg"
	let "index+=1"
done

# C风格的for循环
for val in 1 2 3 4
do
	echo "$val"
done
echo
LIMIT=10
for ((a=1; a<=LIMIT; a++)) # 双圆括号, 并且"LIMIT"变量前面没有"$"
do
	echo "$a"
done

# 命令替换
sh_list=`ls *.sh`
echo $sh_list
sh_list1=$(ls *.sh) # 这是命令替换的另一种形式
echo $sh_list1


# xcode
echo "SRCROOT = ${SRCROOT}" # echo "SRCROOT = $SRCROOT"
echo "PROJECT_DIR = ${PROJECT_DIR}"
echo "INFOPLIST_FILE = ${INFOPLIST_FILE}"
echo "CONFIGURATION = $CONFIGURATION"
echo "CONFIGURATION_BUILD_DIR = ${CONFIGURATION_BUILD_DIR}"
echo "UNLOCALIZED_RESOURCES_FOLDER_PATH = ${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
echo "PODS_ROOT = ${PODS_ROOT}"
echo "PODS_PODFILE_DIR_PATH = ${PODS_PODFILE_DIR_PATH}"
echo "EXECUTABLE_NAME = ${EXECUTABLE_NAME}"
echo "PRODUCT_BUNDLE_IDENTIFIER = ${PRODUCT_BUNDLE_IDENTIFIER}"
echo "PRODUCT_NAME = ${PRODUCT_NAME}"
echo "INFOPLIST_PATH = ${INFOPLIST_PATH}"
echo "==============="