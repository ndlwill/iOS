'''

我们在导入一个包时，实际上是导入了它的__init__.py文件
这样我们可以在__init__.py文件中批量导入我们所需要的模块，而不再需要一个一个的导入

__init__.py的第一个作用就是package的标识.如果没有该文件，该目录就不会认为是package

Root目录->Pack1目录(->Pack1Class.py),Pack2目录(->Pack2Class.py)

Python中的包和模块有两种导入方式：精确导入和模糊导入：

精确导入：
from Root.Pack1 import Pack1Class
import Root.Pack1.Pack1Class

模糊导入：
from Root.Pack1 import *

模糊导入中的*中的模块是由__all__来定义的，__init__.py的另外一个作用就是定义package中的__all__，用来模糊导入，如__init__.py：
__all__ = ["Pack1Class","Pack1Class1"]


=======================
# __init__.py
import re
import urllib
import sys
import os

# a.py
import package
print(package.re, package.urllib, package.sys, package.os)
注意这里访问__init__.py文件中的引用文件，需要加上包名。

可以被import语句导入的对象是以下类型：
模块文件（.py文件）
C或C++扩展（已编译为共享库或DLL文件）
包（包含多个模块）
内建模块（使用C编写并已链接到Python解释器中）

========================
导入包：
多个相关联的模块组成一个包，以便于维护和使用，同时能有限的避免命名空间的冲突。一般来说，包的结构可以是这样的：

package
  |- subpackage1
      |- __init__.py
      |- a.py
  |- subpackage2
      |- __init__.py
      |- b.py
有以下几种导入方式：

import subpackage1.a # 将模块subpackage.a导入全局命名空间，例如访问a中属性时用subpackage1.a.attr
from subpackage1 import a #　将模块a导入全局命名空间，例如访问a中属性时用a.attr_a
from subpackage.a import attr_a # 将模块a的属性直接导入到命名空间中，例如访问a中属性时直接用attr_a
使用from语句可以把模块直接导入当前命名空间，from语句并不引用导入对象的命名空间，而是将被导入对象直接引入当前命名空间

'''


'''
py文件名全部小写，类名大写开头

'''