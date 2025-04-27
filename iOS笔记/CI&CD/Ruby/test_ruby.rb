# ruby XX.rb

# 终端使用 env 命令来查看所有环境变量的列表
$LOAD_PATH << '.' # 让 Ruby 知道必须在当前目录中搜索被引用的文件,如果您不想使用 $LOAD_PATH，那么您可以使用 require_relative 来从一个相对目录引用文件。
require 'trig.rb'

# 双引号字符串允许通过反斜线对字符进行转义，以及对使用#{}嵌入的表达式进行求值。单引号字符串则不对这些进行解释
puts 'Hello world'
puts 'ndl\nyxx'
puts 'ndl' + 'cc' # 拼接
puts 'ndl' * 2 # 字符串重复多次
puts 'ndl', 'cc' # 换行输出

=begin
多行注释
多行注释1
多行注释2
=end

# "Here Document" 是指建立多行字符串
print <<EOF
    ===ndl
    ===cc
    ===jdj
EOF

# 会在程序运行之前被调用
BEGIN {
    puts "===begin run==="
}

# 会在程序的结尾被调用
END {
    puts "===end run==="
}

=begin
Ruby支持的数据类型包括基本的Number、String、Ranges、Symbols，以及true、false和nil这几个特殊值，
同时还有两种重要的数据结构——Array和Hash

数值类型(Number)
整型(Integer)
（数值类型(Number) 0 对应 octal，0x 对应 hex，0b 对应 binary）

字面量（literal）：代码中能见到的值，数值，bool值，字符串等都叫字面量

浮点型
它们是带有小数的数字。浮点数是类 Float 的对象

加减乘除操作符：+-*/；指数操作符为**

字符串类型
Ruby 字符串简单地说是一个 8 位字节序列，它们是类 String 的对象
可以使用序列 #{ expr } 替换任意 Ruby 表达式的值为一个字符串。在这里，expr 可以是任意的 Ruby 表达式。

数组
数组字面量通过[]中以逗号分隔定义，且支持range定义：
（1）数组通过[]索引访问
（2）通过赋值操作插入、删除、替换元素
（3）通过+，－号进行合并和删除元素，且集合做为新集合出现
（4）通过<<号向原数据追加元素
（5）通过*号重复数组元素
（6）通过｜和&符号做并集和交集操作（注意顺序）

哈希类型
哈希是在大括号内放置一系列键/值对，键和值之间使用逗号和序列 => 分隔。尾部的逗号会被忽略

范围类型
一个范围表示一个区间
范围是通过设置一个开始值和一个结束值来表示。范围可使用 s..e 和 s...e 来构造，或者通过 Range.new 来构造
使用 .. 构造的范围从开始值运行到结束值（包含结束值）。使用 ... 构造的范围从开始值运行到结束值（不包含结束值）。当作为一个迭代器使用时，范围会返回序列中的每个值。
=end
puts "==========Number=========="
a=123                  # Fixnum 十进制
puts a
b=1_234                # Fixnum 带有下划线的十进制
puts b
c=-500                 # 负的 Fixnum
d=0377                 # 八进制
e=0xff                 # 十六进制
f=0b1011               # 二进制
g="a".ord # "a" 的字符编码 # 97
h=?\n # 换行符（0x0a）的编码 
puts c, d, e, f, g, h
# puts print 都是向控制台打印字符，其中puts带回车换行符

puts 2**(1/4)#1与4的商为0，然后2的0次方为1 
puts 16**(1/4.0)#1与4.0的商为0.25（四分之一），然后开四次方根

puts 'escape using "\\"'; # escape using "\"
puts 'That\'s right'; # That's right

puts "相乘 : #{24*60*60}";

name="Ruby" 
puts name 
puts "#{name+",ok"}" # Ruby,ok

ary = [ "fred", 10, 3.14, "This is a string", "last element" ]
ary.each do |i|
    puts i
end

hsh = colors = { "red" => 0xf00, "green" => 0x0f0, "blue" => 0x00f }
hsh.each do |key, value|
    print key, " is ", value, "\n"
end

(10..15).each do |n|
    print n, ' '
end

puts "\n==========类和对象=========="
=begin
类名的首字母应该大写
使用关键字 end 终止一个类。类 中的所有数据成员都是介于类定义和 end 关键字之间。

类中的变量
提供了四种类型的变量：
局部变量：局部变量是在方法中定义的变量。局部变量在方法外是不可用的。局部变量以小写字母或 _ 开始。
实例变量：实例变量可以跨任何特定的实例或对象中的方法使用。这意味着，实例变量可以从对象到对象的改变。实例变量在变量名之前放置符号（@）。
类变量：类变量可以跨不同的对象使用。类变量属于类，且是类的一个属性。类变量在变量名之前放置符号（@@）。
全局变量：类变量不能跨类使用。如果您想要有一个可以跨类使用的变量，您需要定义全局变量。全局变量总是以美元符号（$）开始。

使用 new 方法创建对象
new 方法属于类方法
当您想要声明带参数的 new 方法时，您需要在创建类的同时声明方法 initialize。

函数被称为方法。类中的每个方法是以关键字 def 开始，后跟方法名。
方法名总是以小写字母开头。
=end
class Customer
    @@no_of_customers=0
    def initialize(id, name, addr)
       @cust_id=id
       @cust_name=name
       @cust_addr=addr
    end
    def display_details()
       puts "Customer id #@cust_id" # 显示实例变量的文本和值时，您需要在 puts 语句的变量名前面放置符号（#）.文本和带有符号（#）的实例变量应使用双引号标记。
       puts "Customer name #@cust_name"
       puts "Customer address #@cust_addr"
    end

    def total_no_of_customers()
        @@no_of_customers += 1
        puts "Total number of customers: #@@no_of_customers"
    end
end

cust1=Customer.new("1", "John", "Wisdom Apartments, Ludhiya")
cust1.display_details()
cust1.total_no_of_customers()

class Sample
    def hello
       puts "Hello Ruby!"
    end
end
object = Sample.new
object.hello

puts "\n==========变量=========="
=begin
五种类型的变量:
一般小写字母、下划线开头：变量（Variable）。
$开头：全局变量（Global variable）。
@开头：实例变量（Instance variable）。
@@开头：类变量（Class variable）类变量被共享在整个继承链中
大写字母开头：常数（Constant）

全局变量以 $ 开头。未初始化的全局变量的值为 nil
实例变量以 @ 开头。未初始化的实例变量的值为 nil
类变量以 @@ 开头，且必须初始化后才能在方法定义中使用。

局部变量以小写字母或下划线 _ 开头。局部变量的作用域从 class、module、def 或 do 到相对应的结尾或者从左大括号到右大括号 {}。
当调用一个未初始化的局部变量时，它被解释为调用一个不带参数的方法。
对未初始化的局部变量赋值也可以当作是变量声明。变量会一直存在，直到当前域结束为止。

常量以大写字母开头。定义在类或模块内的常量可以从类或模块的内部访问，定义在类或模块外的常量可以被全局访问。
常量不能定义在方法内。引用一个未初始化的常量会产生错误。

您可以通过在变量或常量前面放置 # 字符，来访问任何变量或常量的值

伪变量:
它们是特殊的变量，有着局部变量的外观，但行为却像常量。您不能给这些变量赋任何值。
self: 当前方法的接收器对象。
true: 代表 true 的值。
false: 代表 false 的值。
nil: 代表 undefined 的值。
__FILE__: 当前源文件的名称。
__LINE__: 当前行在源文件中的编号。
=end
$global_variable = 10
VAR1=120
puts "VAR1 = #VAR1" # VAR1 = #VAR1
puts "VAR1 = #{VAR1}" # VAR1 = 120

puts "\n==========运算符=========="
=begin
大多数运算符实际上是方法调用。例如，a + b 被解释为 a.+(b)，其中指向变量 a 的 + 方法被调用，b 作为方法调用的参数。

**	执行指数计算

假设变量 a 的值为 10，变量 b 的值为 20
<=>	联合比较运算符:
如果第一个操作数等于第二个操作数则返回 0，
如果第一个操作数大于第二个操作数则返回 1，
如果第一个操作数小于第二个操作数则返回 -1。
(a <=> b) 返回 -1

===	用于测试 case 语句的 when 子句内的相等。	(1...10) === 5 返回 true。
.eql?	如果接收器和参数具有相同的类型和相等的值，则返回 true。	1 == 1.0 返回 true，但是 1.eql?(1.0) 返回 false。

equal?	如果接收器和参数具有相同的对象 id，则返回 true。	
如果 aObj 是 bObj 的副本，那么 aObj == bObj 返回 true，a.equal?bObj 返回 false，但是 a.equal?aObj 返回 true。

并行赋值
a, b, c = 10, 20, 30
并行赋值在交换两个变量的值时也很有用：
a, b = b, c

逻辑运算符:
假设变量 a 的值为 10，变量 b 的值为 20
and	称为逻辑与运算符。如果两个操作数都为真，则条件为真。	(a and b) 为真。
or	称为逻辑或运算符。如果两个操作数中有任意一个非零，则条件为真。	(a or b) 为真。
&&	称为逻辑与运算符。如果两个操作数都非零，则条件为真。	(a && b) 为真。
||	称为逻辑或运算符。如果两个操作数中有任意一个非零，则条件为真。
!	称为逻辑非运算符。用来逆转操作数的逻辑状态。如果条件为真则逻辑非运算符将使其为假。	!(a && b) 为假。
not	称为逻辑非运算符。用来逆转操作数的逻辑状态。如果条件为真则逻辑非运算符将使其为假。	not(a && b) 为假。

三元运算符:
? :	条件表达式	如果条件为真 ? 则值为 X : 否则值为 Y

范围运算符:
..	创建一个从开始点到结束点的范围（包含结束点）	1..10 创建从 1 到 10 的范围
...	创建一个从开始点到结束点的范围（不包含结束点）	1...10 创建从 1 到 9 的范围

defined? 运算符:
defined? 是一个特殊的运算符，以方法调用的形式来判断传递的表达式是否已定义.它返回表达式的描述字符串，如果表达式未定义则返回 nil

:: 是一元运算符，允许在类或模块内定义常量、实例方法和类方法，可以从类或模块外的任何地方进行访问
你可以使用类或模块名称和两个冒号 :: 来引用类或模块中的常量
如果 :: 前的表达式为类或模块名称，则返回该类或模块内对应的常量值；如果 :: 前未没有前缀表达式，则返回主Object类中对应的常量值
=end

foo = 42
t1=defined? foo    # => "local-variable"
t2=defined? $_     # => "global-variable"
t3=defined? bar    # => nil（未定义）
puts t1, t2, t3


puts "\n==========判断=========="
=begin
if...else 语句:
if conditional [then]
      code...
[elsif conditional [then]
      code...]...
[else
      code...]
end
Ruby 使用 elsif，不是使用 else if 和 elif

通常我们省略保留字 then 。若想在一行内写出完整的 if 式，则必须以 then 隔开条件式和程式区块
if a == 4 then a = 7 end

if 修饰符:
code if condition

unless 语句:
unless conditional [then]
   code
[else
   code ]
end
unless式和 if式作用相反，即如果 conditional 为假，则执行 code。如果 conditional 为真，则执行 else 子句中指定的 code。

unless 修饰符:
code unless conditional

case 语句:
case expression
[when expression [, expression ...] [then]
   code ]...
[else
   code ]
end
case先对一个 expression 进行匹配判断，然后根据匹配结果进行分支选择。
它使用 ===运算符比较 when 指定的 expression，若一致的话就执行 when 部分的内容。
通常我们省略保留字 then.若想在一行内写出完整的 when 式，则必须以 then 隔开条件式和程式区块
when a == 4 then a = 7
=end
x=1
if x > 2
   puts "x 大于 2"
elsif x <= 2 and x!=0
   puts "x 是 1"
else
   puts "无法得知 x 的值"
end

$debug=1
print "debug\n" if $debug

x1=1
unless x1>2
   puts "x1 小于 2"
 else
  puts "x1 大于 2"
end

$var10 = false
print "3 -- 这一行输出\n" unless $var10

$age = 5
case $age
when 0 .. 2
    puts "婴儿"
when 3 .. 6
    puts "小孩"
when 7 .. 12
    puts "child"
when 13 .. 18
    puts "少年"
else
    puts "其他年龄段的"
end

# 当case的"表达式"部分被省略时，将计算第一个when条件部分为真的表达式。
foo1 = false
bar1 = true
quu1 = false
case
when foo1 then puts 'foo is true'
when bar1 then puts 'bar is true'
when quu1 then puts 'quu is true'
end

puts "\n==========循环=========="
=begin
while 语句:
while conditional [do]
   code
end
或者
while conditional [:]
   code
end
语法中 do 或 : 可以省略不写。但若要在一行内写出 while 式，则必须以 do 或 : 隔开条件式或程式区块

while 修饰符:
code while condition
或者
begin 
  code 
end while conditional
当 conditional 为真时，执行 code

until 语句:
until conditional [do]
   code
end

until 修饰符:
code until conditional
或者
begin
   code
end until conditional

for 语句:
for variable [, variable ...] in expression [do]
   code
end
for...in 循环几乎是完全等价于：
(expression).each do |variable[, variable...]| code end

break 语句:
终止最内部的循环。如果在块内调用，则终止相关块的方法（方法返回 nil）。

next 语句:
跳到循环的下一个迭代。如果在块内调用，则终止块的执行（yield 表达式返回 nil）。

redo 语句:
重新开始最内部循环的该次迭代，不检查循环条件。如果在块内调用，则重新开始 yield 或 call。
=end
$n = 0
$num = 5
while $n < $num  do
   puts("在循环语句中 i = #$n" )
   $n +=1
end

$ii = 0
$num1 = 5
begin
   puts("在循环语句中 i = #$ii" )
   $ii +=1
end while $ii < $num1

$ij = 0
$num2 = 5
until $ij > $num2  do
   puts("在循环语句中 i = #$ij" )
   $ij +=1;
end

for k in 0..5
    puts "局部变量的值为 #{k}"
end

(0..5).each do |i|
    puts "局部变量的值为 #{i}"
end

for i in 0..5
    if i > 2 then
       break
    end
    puts "局部变量的值为 #{i}"
end

for i in 0..5
    if i < 2 then
       next
    end
    puts "局部变量的值为 #{i}"
end

puts "\n==========Method=========="
=begin
方法
方法名应以小写字母开头。如果您以大写字母作为方法名的开头，Ruby 可能会把它当作常量，从而导致不正确地解析调用。
方法应在调用之前定义，否则 Ruby 会产生未定义的方法调用异常。
def method_name [( [arg [= default]]...[, * arg [, &expr ]])]
   expr..
end
def method_name 
   expr..
end
定义一个接受参数的方法：
def method_name (var1, var2)
   expr..
end

您可以为参数设置默认值，如果方法调用时未传递必需的参数则使用默认值：
def method_name (var1=value1, var2=value2)
   expr..
end

当您要调用方法时，只需要使用方法名即可：
method_name
当您调用带参数的方法时，您在写方法名时还要带上参数：
method_name 25, 30

方法返回值：
Ruby 中的每个方法默认都会返回一个值。这个返回的值是最后一个语句的值

return 语句
Ruby 中的 return 语句用于从 Ruby 方法中返回一个或多个值。
return [expr[`,' expr...]]
如果给出超过两个的表达式，包含这些值的数组将是返回值。如果未给出表达式，nil 将是返回值

可变数量的参数

类方法
当方法定义在类的外部，方法默认标记为 private。另一方面，如果方法定义在类中的，则默认标记为 public。
方法默认的可见性和 private 标记可通过模块（Module）的 public 或 private 改变。
当你想要访问类的方法时，您首先需要实例化类。然后，使用对象，您可以访问类的任何成员。
Ruby 提供了一种不用实例化即可访问方法的方式。让我们看看如何声明并访问类方法：

alias 语句:
alias 方法名 方法名
alias 全局变量 全局变量
alias foo bar
alias $MATCH $&
我们已经为 bar 定义了别名为 foo，为 $& 定义了别名为 $MATCH。

undef 语句:
这个语句用于取消方法定义。
undef 方法名
=end
def test(a1="Ruby", a2="Perl")
    puts "编程语言为 #{a1}"
    puts "编程语言为 #{a2}"
end

def test1
    i = 100
    j = 10
    k = 0
end
# 在调用这个方法时，将返回最后一个声明的变量 k
puts test1

def test2
    i = 100
    j = 200
    k = 300
 return i, j, k
 end
 var = test2
 puts var

 # 可变参数的方法定义
def sample (*test)
    puts "参数个数为 #{test.length}"
    for i in 0...test.length
       puts "参数值为 #{test[i]}"
    end
end
sample "Mac", "36", "M", "MCA"
sample(1, 2, 6)

# 至少需要指定一个参数的方法
def meth(arg, *agrs)
    [arg, agrs]
end
p meth(1)
p meth(1, 2, 3)

class Accounts
    def reading_charge
    end

    def Accounts.return_date
    end
end
Accounts.return_date # 如需访问该方法，您不需要创建类 Accounts 的对象。

# 不带参数的方法
def function_name
    puts "function_name"
end
function_name
function_name()

# 带参数的方法定义
def function_name1(param1, param2)
    puts "function_name1 #{param1} #{param2}"
end
function_name1(12, 88)
function_name1 14, 66

# 关键字参数的方法定义
# 除了参数名外，使用“参数名 : 值”这样的形式还可以指定参数的默认值
def areas(x: 12, y: 20)
    puts "#{x} #{y}"
end
areas # 12, 20
areas(x: 20) # 20, 20
areas(x: 10, y: 30) # 10, 30
# 可以用散列作为实参传递给方法的关键字参数
hashArgs={x: 2, y: 5}
areas(hashArgs) # 2, 5 

# 带块的方法定义
def myloop
    while true
        yield # 执行块
    end
end
countNumber= 1 # 初始化num
myloop do
    puts "countNumber is #{countNumber}" # 输出num
    break if countNumber > 100 # num超过100时跳出循环
    countNumber *= 2  # num乘2
end
# 方法的调用可以省略小括号()

puts "\n==========Block=========="
=begin
块由大量的代码组成。
您需要给块取个名称。
块中的代码总是包含在大括号 {} 内。
块总是从与其具有相同名称的函数调用。这意味着如果您的块名称为 test，那么您要使用函数 test 来调用这个块。
您可以使用 yield 语句来调用块

block_name{
   statement1
   statement2
   ..........
}

如果您想要传递多个参数:
yield a, b
test {|a, b| statement}
参数使用逗号分隔。

块和方法
您通常使用 yield 语句从与其具有相同名称的方法调用块

如果方法的最后一个参数前带有 &，那么您可以向该方法传递一个块，且这个块可被赋给最后一个参数。
如果 * 和 & 同时出现在参数列表中，& 应放在后面。
=end

def test3
    puts "在 test 方法内"
    yield
    puts "你又回到了 test 方法内"
    yield
end
test3 {puts "你在块内"}

# 也可以传递带有参数的 yield 语句
# yield 语句后跟着参数。您甚至可以传递多个参数
# 在块中，您可以在两个竖线之间放置一个变量来接受参数
def test4
    yield 5
    puts "在 test 方法内"
    yield 100
 end
 test4 {|i| puts "你在块 #{i} 内"}

def test5
    yield
end
test5 { puts "Hello world"}
# 使用 yield 语句调用 test 块

def test6(&block)
    block.call
 end
test6 { puts "Hello World!"}

puts "\n==========模块（Module）=========="
=begin
模块（Module）是一种把方法、类和常量组合在一起的方式。模块（Module）为您提供了两大好处。
模块提供了一个命名空间和避免名字冲突。
模块实现了 mixin 装置。

模块（Module）定义了一个命名空间，相当于一个沙盒，在里边您的方法和常量不会与其他地方的方法常量冲突。
模块类似与类，但有以下不同：
模块不能实例化
模块没有子类
模块只能被另一个模块定义
module Identifier
   statement1
   statement2
   ...........
end
模块常量命名与类常量命名类似，以大写字母开头。方法定义看起来也相似：模块方法定义与类方法定义类似。
通过类方法，您可以在类方法名称前面放置模块名称和一个点号来调用模块方法，您可以使用模块名称和两个冒号来引用一个常量。

require 语句:
require 语句类似于 C 和 C++ 中的 include 语句以及 Java 中的 import 语句。如果一个第三方的程序想要使用任何已定义的模块，则可以简单地使用 Ruby require 语句来加载模块文件：
require filename
文件扩展名 .rb 不是必需的

include 语句:
您可以在类中嵌入模块。为了在类中嵌入模块，您可以在类中使用 include 语句：
include modulename
如果模块是定义在一个单独的文件中，那么在嵌入模块之前就需要使用 require 语句引用该文件。

Ruby 没有真正实现多重继承机制，而是采用成为mixin技术作为替代品
将模块include到类定义中，模块中的方法就mix进了类中
=end

testTrig=Trig.sin(Trig::PI)

class Decade
include Trig
    no_of_yrs=10
    def no_of_months
        puts Trig::PI
        number=10*12
        puts number
    end
end
d1=Decade.new
puts Trig::PI
Trig.sin(1)
d1.no_of_months

puts "\n==========迭代器=========="
=begin
迭代(iterate)指的是重复做相同的事，所以迭代器(iterator)就是用来重复多次相同的事。
迭代器是集合支持的方法。存储一组数据成员的对象称为集合。在 Ruby 中，数组(Array)和哈希(Hash)可以称之为集合。
迭代器返回集合的所有元素，一个接着一个。在这里我们将讨论两种迭代器，each 和 collect

each 迭代器:
each 迭代器返回数组或哈希的所有元素。
collection.each do |variable|
   code
end

collect 迭代器:
collect 迭代器返回集合的所有元素。
collection = collection.collect
collect 方法返回整个集合，不管它是数组或者是哈希。
=end
ary1 = [1,2,3,4,5]
ary1.each do |i|
   puts i
end

aaa = [1,2,3,4,5]
bbb = Array.new
bbb = aaa.collect{ |x| x*10 }
puts bbb

puts "\n==========字符串（String）=========="
=begin
Ruby 字符串分为单引号字符串（'）和双引号字符串（"），区别在于双引号字符串能够支持更多的转义字符
如果您需要在单引号字符串内使用单引号字符，那么需要在单引号字符串使用反斜杠(\)，这样 Ruby 解释器就不会认为这个单引号字符是字符串的终止符号：
反斜杠也能转义另一个反斜杠，这样第二个反斜杠本身不会解释为转义字符

双引号字符串:
在双引号字符串中我们可以使用 #{} 井号和大括号来计算表达式的值：

Ruby 中还支持一种采用 %q 和 %Q 来引导的字符串变量，%q 使用的是单引号引用规则，而 %Q 是双引号引用规则，
后面再接一个 (! [ { 等等的开始界定符和与 } ] ) 等等的末尾界定符。
跟在 q 或 Q 后面的字符是分界符.分界符可以是任意一个非字母数字的单字节字符.如:[,{,(,<,!等,字符串会一直读取到发现相匹配的结束符为止.

字符编码:
Ruby 的默认字符集是 ASCII，字符可用单个字节表示。如果您使用 UTF-8 或其他现代的字符集，字符可能是用一个到四个字节表示。
您可以在程序开头使用 $KCODE 改变字符集：
$KCODE = 'u'

编码	描述
a	ASCII （与 none 相同）。这是默认的。
e	EUC。
n	None （与 ASCII 相同）。
u	UTF-8。

=end
single='Won\'t you read O\'Reilly\'s book?'
puts single

name11 = "Joe"
name22 = "Mary"
puts "你好 #{name11}, #{name22} 在哪?"

xxx=12
yyy=11
puts "x + y 的值为 #{ xxx + yyy }"

desc1 = %Q{Ruby 的字符串可以使用 '' 和 ""。}
desc2 = %q|Ruby 的字符串可以使用 '' 和 ""。|
puts desc1
puts desc2

myStr = String.new("THIS IS TEST")
myStrDownCase = myStr.downcase

puts "\n==========数组（Array）=========="
=begin
数组是任何对象的有序整数索引集合
数组的索引从 0 开始
一个负数的索相对于数组的末尾计数的，也就是说，索引为 -1 表示数组的最后一个元素，-2 表示数组中的倒数第二个元素
数组可存储诸如 String、 Integer、 Fixnum、 Hash、 Symbol 等对象，甚至可以是其他 Array 对象。
数组不需要指定大小，当向数组添加元素时，Ruby 数组会自动增长。

数组 names 的大小或长度为 20 个元素。您可以使用 size 或 length 方法返回数组的大小
也可以使用带有 new 的块，每个元素使用块中的计算结果来填充

数组内建方法:
我们需要有一个 Array 对象的实例来调用 Array 方法。下面是创建 Array 对象实例的方式：
Array.[](...) [or] Array[...] [or] [...]
=end
names = Array.new
names1 = Array.new(20) 

names2 = Array.new(4, "mac")
puts "#{names2}"

nums111 = Array.new(10) { |e| e = e * 2 }
nums222 = Array.[](1, 2, 3, 4,5)
nums333 = Array[1, 2, 3, 4,5]

digits = Array(0..9)
num555 = digits.at(6)

puts "\n==========哈希（Hash）=========="
=begin
哈希（Hash）是类似 "key" => "value" 这样的键值对集合。哈希类似于一个数组，只不过它的索引不局限于使用数字。
Hash 的索引（或者叫"键"）几乎可以是任何对象。
Hash 的元素没有特定的顺序

通过 new 类方法创建一个空的哈希：
months = Hash.new

也可以使用 new 创建带有默认值的哈希，不带默认值的哈希是 nil：
months = Hash.new( "month" )
或
months = Hash.new "month"

您可以使用任何的 Ruby 对象作为键或值，甚至可以使用数组:
[1,"jan"] => "January"
=end
months = Hash.new( "month" )
puts "#{months[0]}"
puts "#{months[72]}"

H = Hash["a" => 100, "b" => 200]
puts "#{H['a']}"
puts "#{H['b']}"

monthss = {"1" => "January", "2" => "February"}

puts "\n==========other=========="
puts "ndl\nyxx"

# gets 语句可用于获取来自名为 STDIN 的标准屏幕的用户输入.gets方法得到的字符串包含一个“\n”回车符，所以我们需要继续使用chomp方法把"\n"回车符去掉

# 负数的索引代表从数组的末尾开始
# Ruby中字符是整数
word = "jdj"
puts word[0] #j
puts word[0, 2] #jd
puts word[-2,2] #dj
puts word[0..2] #jdj
puts word[-2..-1] #dj

ary = [1, 2, "3"]
puts ary + ["foo", "bar"]
puts ary * 2
puts ary.join(":")

hash = {1 => 2, "2" => "4"}
puts hash
puts hash[1]
puts hash["2"]
puts hash[3]
hash[3] = "11"
hash.delete 1
puts hash

# 2..5是一个表达式，它表示2到5的范围(包括2和5)
i = 8
case i
when 1, 2..5
    puts "1..5"
when 6..10
    puts "6..10"
end

for elt in ary
    puts "for-in: #{elt}"
end

ary.each { |element|
    puts "each: #{element}"
}

optionssss={"a"=>123}
nilvar=optionssss[:abc]
puts nilvar.nil? # true

puts "==========Symbol=========="
=begin
Symbol 表示“名字”，比如字符串的名字，标识符的名字。
创建一个 Symbol 对象的方法是在名字或者字符串前面加上冒号
每一个对象都有唯一的对象标识符（Object Identifier）
字符串就是字符串，干吗还有字符串的名字？这是因为在 Ruby 中字符串也是一种对象，即 String 对象。无论其结构还是操作和 Symbol 对象都是不同的。

除了可以采用一般的字符串，还可以使用操作符（例如+, -, *, /），变量，常量，方法甚至类的名字来创建 Symbol 对象

名字相同，则Symbol 相同

Symbol 对象一旦定义将一直存在，直到程序执行退出。所有 Symbol 对象存放在 Ruby 内部的符号表中，
可以通过类方法 Symbol.all_symbols 得到当前 Ruby 程序中定义的所有 Symbol 对象，该方法返回一个 Symbol 对象数组
=end
puts :xyz

# https://blog.csdn.net/besfanfei/article/details/7966850
# 创建一个 Symbol 对象的方法是在名字或者字符串前面加上冒号
# 创建 Symbol 对象的字符串中不能含有’\0’字符，而 String 对象是可以的
puts :ndl.class # Symbol
puts :jdj # jdj

# Ruby 中每一个对象都有唯一的对象标识符（Object Identifier）
puts :foo.object_id # 1057948
puts :foo.object_id # 1057948
puts :"foo".object_id # 1057948
# 前三行语句中的 :foo （或者 :"foo"）都是同一个 Symbol 对象

puts "foo".object_id # 70270002025960
puts "foo".object_id # 70270002021740
puts "foo".object_id # 70270002021540
# 而后三行中的字符串”foo”都是不同的对象

# 每个 String 对象都是不同的，即便他们包含了相同的字符串内容
# 而对于 Symbol 对象，一个名字（字符串内容）唯一确定一个 Symbol 对象。

puts "=====Test====="
# 类名、常量名和方法名都是 Test
class Test
    puts :Test.object_id
    Test=100
    puts :Test.object_id

    def Test
        puts :Test.object_id
    end
end

ttt=Test.new
ttt.Test

puts Symbol.all_symbols.size
puts Symbol.all_symbols[0..9]

testStr="testStr"
puts testStr
testStr[0]="n"
puts testStr

testSym=:testSymbol
puts testSym

# Symbol 转化为 String
# 使用 to_s 或 id2name 方法将 Symbol 转化为一个 String 对象
# 每个 String 对象都是唯一的，因此对一个 Symbol 调用多次将产生多个 String 对象。
puts :symbolid.id2name
puts :symbolid.to_s
puts :"i am ndl".to_s

# String 转化为 Symbol
# 除了在字符串前面加冒号，还可以使用 to_sym 或 intern 方法将 String 转化为 Symbol ，如果该 Symbol 已经存在，则直接返回
var111 = "varsym".to_sym
puts var111
var222 = "varsym".intern
puts var222
puts var111 == var222

# 使用 Symbol
# Ruby 内部一直在使用 Symbol ，比如 Ruby 程序中的各种名字，Symbol本质上是 Ruby 符号表中的东西。使用 Symbol 处理名字可以降低 Ruby 内存消耗，提高执行速度
# 那么 Symbol 对我们有什么用呢？当然也是内存。使用 String 的开销太大了，因为每一个String 都是一个对象。想想前边的例子，一个字符串每出现一次 Ruby 就会创建一个 String 对象。
=begin
当你面临 String 还是 Symbol 的选择时，可以参考以下标准：
如果使用字符串的内容，这个内容可能会变化，使用 String
如果使用固定的名字或者说是标识符，使用 Symbol

那么什么时候我们会用到名字呢？很多时候都会，比如枚举值、关键字（哈希表关键字、方法的参数）等等

作为哈希表的 key

哈希参数
通常我们定义的函数的参数的个数和顺序是写死的，调用函数的时候要确保参数的个数、顺序匹配，有时候这样很不方便，使用哈希参数可以解决这个问题。
=end
hosts = {:beijing=>'machine1', :shanghai=>'machine2', :guangzhou=>'machine3', :tianjin=>'machine4', :shenzhen=>'machine5'}
puts "#{hosts}"

# 使用哈希参数的方法可以如下定义，前半部分为固定参数，后面为可变参数，或者干脆全采用哈希参数：
def my_method1(para1, options={})
    puts "para1 = #{para1} options = #{options}"
end
 
def my_method2(options={})

end


my_method1 "cc", {"ndl"=>"yxx"}

# 如果你希望设定一些默认参数，并允许调用者更改这些参数，可以使用哈希对象的 merge! 方法
# hsh.merge!( other_hash )。该方法将other_hash里内容加到hsh中，如果other_hash与hsh有重复的key，则key在other_hash中的value覆盖hsh中对应key的value。
def my_method(opts={})
  default_opts={:arg1 => 10, :arg2 => "abc"}
  default_opts.merge!(opts)
  default_opts.each{|key,value| puts "#{key} is #{value}"}
end

my_method(:arg1=>5, :arg3=>"def")