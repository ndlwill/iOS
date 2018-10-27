from urllib.error import URLError
from urllib.request import ProxyHandler, build_opener

import socket
import socks
from urllib import request

import requests

from selenium import webdriver

# urllib
'''
proxy = '114.113.126.86:80'
# proxy = 'username:password@114.113.126.86:80' # 在代理前面加入代理认证的用户名密码即可
proxy_handler = ProxyHandler({
    'http': 'http://' + proxy
})
opener = build_opener(proxy_handler)

try:
    response = opener.open('http://httpbin.org/get')
    print(response.read().decode('utf-8'))
except URLError as e:
    print('reason:', e.reason)
'''

# 代理是 SOCKS5 类型
'''
socks.set_default_proxy(socks.SOCKS5, '127.0.0.1', 9742)
socket.socket = socks.socksocket

try:
    response = request.urlopen('http://httpbin.org/get')
    print(response.read().decode('utf-8'))
except URLError as e:
    print('reason:', e.reason)
'''

# requests
'''
proxies = {
    'http': 'http://' + proxy,
    'https': 'https://' + proxy
}

# socks5  pip install 'requests[socks]'
# proxies = {
#     'http': 'socks5://' + proxy,
#     'https': 'socks5://' + proxy
# }

try:
    res = requests.get('http://httpbin.org/get', proxies=proxies)
    print(res.text)
except requests.exceptions.ConnectionError as e:
    print(e.args)
'''

'''
socks.set_default_proxy(socks.SOCKS5, '127.0.0.1', 9742)
socket.socket = socks.socksocket

try:
    response = requests.get('http://httpbin.org/get')
    print(response.text)
except requests.exceptions.ConnectionError as e:
    print('Error:', e.args)
'''

# selenium
'''
proxy = '114.113.126.86:80'
chrome_options = webdriver.ChromeOptions()
chrome_options.add_argument('--proxy-server=http://' + proxy)
browser = webdriver.Chrome(chrome_options=chrome_options)
browser.get('http://httpbin.org/get')
'''

# PhantomJS
'''
service_args = [
    '--proxy=127.0.0.1:9743',
    '--proxy-type=http',
    # '--proxy-auth=username:password' # 认证
]
browser = webdriver.PhantomJS(service_args=service_args)
browser.get('http://httpbin.org/get')
print(browser.page_source)
'''