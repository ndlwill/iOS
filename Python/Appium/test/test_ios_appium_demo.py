# coding=utf-8

from appium import webdriver

from time import sleep

import pytest
import unittest

import copy
import os

import sys
import traceback

from selenium.common.exceptions import WebDriverException

'''
中文编码:
# -*- coding: UTF-8 -*- 或者 # coding=utf-8

Python 标识符:
以单下划线开头 _foo 的代表不能直接访问的类属性，需通过类提供的接口进行访问，不能用 from xxx import * 而导入。以单下划线开头的表示的是 protected 类型的变量，即保护类型只能允许其本身与子类进行访问
以双下划线开头的 __foo 代表类的私有成员，只能是允许这个类本身进行访问了。
以双下划线开头和结尾的 __foo__ 代表 Python 里特殊方法专用的标识，如 __init__() 代表类的构造函数。

Numbers（数字）
String（字符串）
List（列表）
Tuple（元组） 元组不能二次赋值，相当于只读列表。
Dictionary（字典）

搜索路径:
当你导入一个模块，Python 解析器对模块位置的搜索顺序是：
1、当前目录
2、如果不在当前目录，Python 则搜索在 shell 变量 PYTHONPATH 下的每个目录。
3、如果都找不到，Python会察看默认路径。UNIX下，默认路径一般为/usr/local/lib/python/。
模块搜索路径存储在 system 模块的 sys.path 变量中。

Python中的包:
包就是文件夹，但该文件夹下必须存在 __init__.py 文件, 该文件的内容可以为空。__init__.py 用于标识当前文件夹是一个包

如果要给函数内的全局变量赋值，必须使用 global 语句
global VarName 的表达式会告诉 Python， VarName 是一个全局变量，这样 Python 就不会在局部命名空间里寻找这个变量了。

Python 面向对象:
类(Class): 用来描述具有相同的属性和方法的对象的集合。它定义了该集合中每个对象所共有的属性和方法。对象是类的实例。
类变量：类变量在整个实例化的对象中是公用的。类变量定义在类中且在函数体之外。类变量通常不作为实例变量使用。
数据成员：类变量或者实例变量, 用于处理类及其实例对象的相关的数据。
方法重写：如果从父类继承的方法不能满足子类的需求，可以对其进行改写，这个过程叫方法的覆盖（override），也称为方法的重写。
局部变量：定义在方法中的变量，只作用于当前实例的类。
实例变量：在类的声明中，属性是用变量来表示的。这种变量就称为实例变量，是在类声明的内部但是在类的其他成员方法之外声明的。
继承：即一个派生类（derived class）继承基类（base class）的字段和方法。继承也允许把一个派生类的对象作为一个基类对象对待。例如，有这样一个设计：一个Dog类型的对象派生自Animal类，这是模拟"是一个（is-a）"关系（例图，Dog是一个Animal）。
实例化：创建一个类的实例，类的具体对象。
方法：类中定义的函数。
对象：通过类定义的数据结构实例。对象包括两个数据成员（类变量和实例变量）和方法。

Python内置类属性:
__dict__ : 类的属性（包含一个字典，由类的数据属性组成）
__doc__ :类的文档字符串
__name__: 类名
__module__: 类定义所在的模块（类的全名是'__main__.className'，如果类位于一个导入模块mymod中，那么className.__module__ 等于 mymod）
__bases__ : 类的所有父类构成元素（包含了一个由所有父类组成的元组）
'''

'''
py.test

def func(x):
    return x + 1

def test_demo():
    assert func(3) == 5
'''

# 模拟器
IOS_BASE_CAPS = {
    "platformName": "iOS",
    "platformVersion": "14.5",
    "deviceName": "iPhone 12",
    "automationName": "XCUITest",
    "app": os.path.abspath('../../../../TestAppium.app')
}

# 真机
REAL_IOS_DEVICE_BASE_CAPS = {
    "platformName": "iOS",
    "platformVersion": "14.6",
    "deviceName": "iPhone SE",
    "automationName": "XCUITest",
    # "app": os.path.abspath('../../../../TestAppium.app')
    "bundleId": "com.test.TestAppium",
    "udid": "00008030-001D744A0183802E",
    # 下面两个不写也能正常执行
    "xcodeSigningId": "iPhone Developer",
    "xcodeOrgId": "N82WKSN6R7"
}

REAL_IOS_DEVICE_MY_BASE_CAPS = {
    "platformName": "iOS",
    "platformVersion": "14.7.1",
    "deviceName": "iPhone 7",
    "automationName": "XCUITest",
    # "app": os.path.abspath('../../../../TestAppium.app')
    "bundleId": "com.test.TestAppium",
    "udid": "",
    # 下面两个不写也能正常执行
    # "xcodeSigningId": "iPhone Developer",
    # "xcodeOrgId": "N82WKSN6R7"
}

EXECUTOR = 'http://127.0.0.1:4723/wd/hub'

# self 不是 python 关键字, 换成instance也可以
class TestIOSCreateSession(unittest.TestCase):
    '测试'

    def setUp(self) -> None:
        print('===setUp===')
        caps = copy.copy(REAL_IOS_DEVICE_BASE_CAPS)
        caps['name'] = self.id()

        self.driver = webdriver.Remote(
            command_executor=EXECUTOR,
            desired_capabilities=caps
        )
        self.driver.implicitly_wait(30)

    def tearDown(self) -> None:
        print('===tearDown===')
        self.driver.quit()
        sleep(3)

        print("========")
        with self.assertRaises(WebDriverException) as excinfo:
            self.driver.find_element_by_class_name('XCUIElementTypeApplication')
        # A session is either terminated or not started
        print(str(excinfo.exception.msg))

    def test_create_ios_session(self):
        print("test_create_ios_session")
        app_element = self.driver.find_element_by_class_name('XCUIElementTypeApplication')
        self.assertEqual('TestAppium', app_element.get_attribute('name'))
        sleep(3)

    def test_button1_click(self):
        print("test_button1_click")
        button1_element = self.driver.find_element_by_accessibility_id("accIdentifier")
        sleep(3)
        button1_element.click()
        sleep(3)
        button1_element.click()
        sleep(3)


'''
self.assertTrue(
    'has already finished' in str(excinfo.exception.msg) or
    'Unhandled endpoint' in str(excinfo.exception.msg)
)
'''

if __name__ == '__main__':
    unittest.main()
