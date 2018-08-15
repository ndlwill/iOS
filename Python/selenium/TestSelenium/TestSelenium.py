# coding = utf-8

from selenium import webdriver
import time
import os

browser = webdriver.Chrome()

browser.maximize_window() # 将浏览器最大化显示
# browser.set_window_size(1920, 1080)



time.sleep(1)

url = "http://www.baidu.com"
nextUrl = "http://news.baidu.com"
localFilePath = "file:///" + os.path.abspath("findElements.html")

# =====test baidu=====
# print("===now access to %s" % (url))
# browser.get(url)
# print(browser.title)

inputText = "python"
# for http://www.baidu.com
#########百度输入框的定位方式##########
# browser.find_element_by_id("kw").send_keys("selenium") # id
# browser.find_element_by_name("wd").send_keys("python") # name
# browser.find_element_by_tag_name("input").send_keys("python") # tag_name
# browser.find_element_by_class_name("s_ipt").send_keys(inputText) # class_name

# =====css selector=====
# browser.find_element_by_css_selector("#kw").send_keys(inputText) # css_selector

# <a class="mnav">
# browser.find_element_by_css_selector("a.mnav").click()

# XML Path Language (XPath) XPath是一种在XML文档中定位元素的语言 因为HTML可以看做XML的一种实现
# browser.find_element_by_xpath("//input[@id='kw']").send_keys(inputText) # xpath 属性
# browser.find_element_by_xpath("//input").send_keys("google") # 位置

# 视频
# browser.find_element_by_xpath("//a[@href='http://v.baidu.com']").click()
# browser.find_element_by_xpath("//a[contains(text(), '视频')]").click()


# ========link text <a href="">========
# browser.find_element_by_link_text("贴吧").click()
# partial link text
# browser.find_element_by_partial_link_text("贴").click()


# 点击百度一下按钮
# browser.find_element_by_id("su").click()

# time.sleep(2)
# browser.get(nextUrl)
# time.sleep(2)
# browser.back()
# time.sleep(2)
# browser.forward()

# =====test local file=====
browser.get(localFilePath)

inputs = browser.find_elements_by_tag_name("input")

# 选中所有checkbox
# for inputItem in inputs:
#     if inputItem.get_attribute("type") == "checkbox":
#         inputItem.click()

checkboxs = browser.find_elements_by_css_selector("input[type=checkbox]")
for checkboxItem in checkboxs:
    checkboxItem.click()

# 不勾选最后个
checkboxs.pop().click()

# =====我是分割线=====

# 等网页加载完成 再等3秒
time.sleep(3)
browser.quit()

