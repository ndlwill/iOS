# coding = utf-8

from selenium import webdriver
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
from selenium.common.exceptions import TimeoutException

from urllib.parse import quote

from pyquery import PyQuery as pq

from config import *

import pymongo

# chrome_options = webdriver.ChromeOptions()
# chrome_options.add_argument('--headless') # 也就是无界面模式
# browser = webdriver.Chrome(chrome_options=chrome_options)

browser = webdriver.Chrome()
# browser = webdriver.Firefox()
# browser = webdriver.PhantomJS(service_args=SERVICE_ARGS) # 是一个无界面浏览器,可以禁用 PhantomJS 的图片加载同时开启缓存，可以发现页面爬取速度进一步提升
wait = WebDriverWait(browser, 10)

client = pymongo.MongoClient(MONGO_URL)
db = client[MONGO_DB]

def get_index_page_data(index):
    print('正在爬取第', index, '页')

    try:
        url = 'https://s.taobao.com/search?q=' + quote(KEYWORD)
        browser.get(url)

        if index > 1:
            textField = wait.until(EC.presence_of_element_located((By.CSS_SELECTOR, '#mainsrp-pager div.form > input')))
            submit = wait.until(EC.element_to_be_clickable((By.CSS_SELECTOR, '#mainsrp-pager div.form > span.btn.J_Submit')))
            textField.clear()
            textField.send_keys(index)
            submit.click()

        wait.until(EC.text_to_be_present_in_element((By.CSS_SELECTOR, '#mainsrp-pager li.item.active > span'), str(index)))
        wait.until(EC.presence_of_element_located((By.CSS_SELECTOR, '.m-itemlist .items .item'))) # 每个商品的信息块
        get_product_info()
    except TimeoutException:
        get_index_page_data(index)

def get_product_info():
    html = browser.page_source

    doc = pq(html)
    items = doc('.m-itemlist .items .item').items()

    for item in items:
        product = {
            'image': item.find('.pic .img').attr('data-src'),
            'price': item.find('.price').text(),
            'deal': item.find('.deal-cnt').text(),
            'title': item.find('.title').text(),
            'shop': item.find('.shop').text(),
            'location': item.find('.location').text()
        }
        print(product)
        save_to_mongo(product)

def save_to_mongo(product):
    try:
        if db[MONGO_COLLECTION].insert(product):
            print('存储到MongoDB成功')
    except Exception:
        print('存储到MongoDB失败')


def main():
    for i in range(1, MAX_PAGE + 1):
        get_index_page_data(i)
    browser.close()

if __name__ == '__main__':
    main()



