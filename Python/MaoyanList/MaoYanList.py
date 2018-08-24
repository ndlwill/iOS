import requests
import re
import time
import json
from requests.exceptions import RequestException

# python3教程
# http://www.runoob.com/python3/python3-tutorial.html

def get_first_page(url):
    try:
        headers = {
            'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36'
        }
        response = requests.get(url, headers=headers)
        if response.status_code == 200:
            return response.text
        return None
    except RequestException:
        return None

def parse_html(html):
    # 排名，image_url，片名，主演，上映时间，评分，
    pattern = re.compile(
        '<dd>.*?board-index.*?>(.*?)</i>.*?data-src="(.*?)".*?name.*?a.*?>(.*?)</a>.*?star.*?>(.*?)</p>.*?releasetime.*?>(.*?)</p>.*?integer.*?>(.*?)</i>.*?fraction.*?>(.*?)</i>.*?</dd>',
        re.S)

    items = re.findall(pattern, html)

    for item in items:
        # strip() 用于移除字符串头尾指定的字符（默认为空格或换行符）或字符序列
        # 使用方括号来截取字符串
        yield {
            'index': item[0],
            'image': item[1],
            'title': item[2].strip(),
            'actor': item[3].strip()[3:],
            'time': item[4].strip()[5:],
            'score': item[5] + item[6]
        }

def write_dict_to_file(content):
    with open("data.txt", "a", encoding="utf-8") as f:
        #  dumps() 字典的序列化(dict->json obj) ensure_ascii 参数为 False，这样可以保证输出的结果是中文形式而不是 Unicode 编码
        f.write(json.dumps(content, ensure_ascii=False) + '\n') # 每条数据是个json



def main(offset):
    print(__name__)

    url = 'http://maoyan.com/board/4?offset=' + str(offset)
    html = get_first_page(url)
    for item in parse_html(html):
        print(item)
        write_dict_to_file(item)

# 让你写的脚本模块既可以导入到别的模块中用，另外该模块自己也可执行
# 从另外一个.py文件通过import导入该文件的时候，这时__name__的值就是我们这个py文件的名字而不是__main__
if __name__ == '__main__':
    for i in range(10):
        main(offset=i * 10)
        time.sleep(1)

