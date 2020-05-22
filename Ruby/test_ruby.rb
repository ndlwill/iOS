# ruby XX.rb

# 终端使用 env 命令来查看所有环境变量的列表

# 双引号字符串允许通过反斜线对字符进行转义，以及对使用#{}嵌入的表达式进行求值。单引号字符串则不对这些进行解释
puts 'Hello world'
puts 'ndl\nyxx'
puts 'ndl' + 'cc'
puts 'ndl' * 2 # 字符串重复多次
puts 'ndl', 'cc'

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
（数值类型(Number) 0 对应 octal，0x 对应 hex，0b 对应 binary）
=end
puts "==========Number=========="
a=123                  # Fixnum 十进制
puts a
b=1_234                # Fixnum 带有下划线的十进制
puts b

puts "ndl\nyxx"

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