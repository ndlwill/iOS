# coding = utf-8

from selenium import webdriver
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support.select import Select
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.action_chains import ActionChains

import time, os

browser = webdriver.Chrome()

browser.maximize_window() # 将浏览器最大化显示
# browser.set_window_size(1920, 1080)



time.sleep(1)

url = "http://www.baidu.com"
nextUrl = "http://news.baidu.com"
youdaoURL = "http://www.youdao.com"
localFilePath = "file:///" + os.path.abspath("findElements.html")
levelLocationFilePath = "file:///" + os.path.abspath("level_location.html")
framePath = "file:///" + os.path.abspath("frame.html")
jsPath = "file:///" + os.path.abspath("js.html")
uploadFilePath = "file:///" + os.path.abspath("upload_file.html")
dropDownMenuPath = "file:///" + os.path.abspath("dropDownMenu.html")

# =====test baidu=====
browser.implicitly_wait(10)
print("===now access to %s" % (url))
browser.get(url)
print(browser.title)
inputText = "python"

# for http://www.baidu.com
#########百度输入框的定位方式##########
# browser.find_element_by_id("kw").clear() # 清除输入框的内容 比如百度输入框里默认有个“请输入关键字”的信息
# browser.find_element_by_id("kw").send_keys("selenium") # id
# browser.find_element_by_name("wd").send_keys("python") # name
# browser.find_element_by_tag_name("input").send_keys("python") # tag_name
# browser.find_element_by_class_name("s_ipt").send_keys(inputText) # class_name
# =====css selector=====
'''
# css 调试技巧
# 启动Chrome浏览器，打开“开发者工具”，切换到console标签，通过 document.querySelector() 方法使用CSS语法定位元素
"#KW"->id="kw"
".s_ipt"->class="s_ipt"或者"input.s_ipt"-><input class="s_ipt">
"[name='wd']"->name="wd"
'''
# <XXX id="kw" >
# browser.find_element_by_css_selector("#kw").send_keys(inputText) # css_selector
# <a class="mnav">
# browser.find_element_by_css_selector("a.mnav").click()

# XML Path Language (XPath) XPath是一种在XML文档中定位元素的语言 因为HTML可以看做XML的一种实现
# browser.find_element_by_xpath("//input[@id='kw']").send_keys(inputText) # xpath 属性
browser.find_element_by_xpath("//input").send_keys("google") # 位置
time.sleep(2)
# browser.find_element_by_xpath("//input").send_keys(Keys.COMMAND, 'a') # ?
time.sleep(2)
browser.find_element_by_xpath("//input").send_keys("我们")
time.sleep(2)
# browser.find_element_by_xpath("//input").send_keys(Keys.RETURN) # Keys: TAB,RETURN

# 视频
# browser.find_element_by_xpath("//a[@href='http://v.baidu.com']").click()
# browser.find_element_by_xpath("//a[contains(text(), '视频')]").click()

# 设置 有些元素并不是不存在，而是不可见display: block, display: none
'''
browser.find_element_by_link_text("设置").click()
sel = browser.find_element_by_name("NR")
sel.find_element_by_xpath("//option[@value='50']").click()

time.sleep(2)

browser.find_element_by_xpath("//input[@value='保存设置']").click()

time.sleep(3)

browser.switch_to.alert.accept()
'''

# =====百度登录-注册=====
'''
homeHandle = browser.current_window_handle

browser.find_element_by_link_text('登录').click()
browser.find_element_by_link_text("立即注册").click()

allHanddle = browser.window_handles
print(allHanddle)

for handle in allHanddle:
    if handle != homeHandle:
        browser.switch_to.window(handle)
        browser.find_element_by_name("userName").send_keys('username')
'''

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

# =====定位一组元素=====
'''
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
'''

# =====WebElemant=====
'''
WebElement :
text  获取该元素的文本
submit  提交表单 # 把“百度一下”的操作从click 换成submit
get_attribute  获得属性值
'''

# baiduInput = browser.find_element_by_id("kw")
# print('tag_name = %s, text = %s, selected = %d, enabled = %s' %
#       (baiduInput.tag_name, baiduInput.text, baiduInput.is_selected(), baiduInput.is_enabled()))

# =====frame.html中嵌套inner.html=====
'''
browser.get(framePath)

browser.implicitly_wait(30)
browser.switch_to.frame("f1")
browser.switch_to.frame("f2")

# 操作f2上面的元素
browser.find_element_by_id("kw").send_keys("selenium")
browser.find_element_by_id("su").click()
'''

# =====调用js=====
'''
# 操作百度input
js = "var input = document.getElementById(\"kw\");" \
     "input.style.border = \"2px solid red\";"
browser.execute_script(js)
'''

# 操作滚动条 滚动到底部
'''
scrollJS = "var scroll = document.documentElement.scrollTop = 10000"
time.sleep(2)
browser.execute_script(scrollJS)
'''

# 一种是在页面上直接执行JS,另一种是在某个已经定位的元素上执行JS

# =====上传文件=====
'''
browser.get(uploadFilePath)
browser.find_element_by_name("file").send_keys("/Users/dzcx/Desktop/OA.txt")
'''

# =====下拉框=====
'''
browser.get(dropDownMenuPath)

select = browser.find_element_by_id("ShippingMethod")
select.find_element_by_xpath("//option[@value='10.69']").click()
# 或者
# select.find_element_by_xpath("//option[@value=\"10.69\"]").click()
'''

# =====cookie=====
'''
browser.get(youdaoURL)

# 获得cookie信息
# cookie = browser.get_cookies()
# print(cookie)

# 向cookie添加会话信息
browser.add_cookie({'name':'name-cc', 'value':'value-cc'})
for cookie in browser.get_cookies():
    print("name = %s, value = %s" % (cookie["name"], cookie["value"]))

browser.delete_all_cookies()
'''


'''
账号，密码，保存密码，登录
第一次注释掉勾选保存密码的操作，第二次通过勾选保存密码获得cookie信息 ；来看两次运行结果的cookie的何不同：
u'expiry': None
u'expiry': 1379502502
'''

# =====鼠标事件=====

# ?
# onElement = browser.find_element_by_xpath("/html/body/div/div[2]/table/tbody/tr/td[2]")
# ActionChains(browser).context_click(onElement).perform() # 右击
# ActionChains(browser).double_click(onElement).perform() # 双击

# element = browser.find_element_by_name("source")
# target =  browser.find_element_by_name("target")
# ActionChains(browser).drag_and_drop(element, target).perform() # 拖放操作

# =====我是分割线=====

# 等网页加载完成 再等3秒
print("我是分割线")
time.sleep(3)
browser.quit()

