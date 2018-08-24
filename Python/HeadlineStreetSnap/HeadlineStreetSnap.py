import requests
import os
from urllib.parse import urlencode
from hashlib import md5
from multiprocessing.pool import Pool

def get_page_data(offset):
    params = {
        'offset': offset,
        'format': 'json',
        'keyword': '街拍',
        'autoload': 'true',
        'count': '20',
        'cur_tab': '1',
        'from': 'search_tab'
    }

    url = 'http://www.toutiao.com/search_content/?' + urlencode(params)

    try:
        response = requests.get(url)
        if response.status_code == 200:
            print(type(response.json())) # class->dict
            return response.json()
    except requests.ConnectionError:
        return None

def get_images(jsonDict):
    cellArray = jsonDict.get('data')
    if cellArray:
        for cell in cellArray:
            title = cell.get('title')
            if title:
                images = cell.get('image_list')
                for image in images:
                    yield {
                        'imageURL': image.get('url'),
                        'title': title
                    }

def save_image(item):
    if not os.path.exists(item.get('title')):
        os.mkdir(item.get('title'))

    try:
        response = requests.get('http:' + item.get('imageURL'))

        if response.status_code == 200:
            file_path = '{0}/{1}.{2}'.format(item.get('title'), md5(response.content).hexdigest(), 'jpg')
            if not os.path.exists(file_path):
                with open(file_path, 'wb') as f:
                    f.write(response.content)
            else:
                print('Already Downloaded', file_path)
    except requests.ConnectionError:
        print('Failed to Save Image')

def main(offset):
    jsonDict = get_page_data(offset)
    for item in get_images(jsonDict):
        print(item)
        save_image(item)

# 下载5个offset
GROUP_START = 0
GROUP_END = 1

if __name__ == '__main__':
    pool = Pool()
    groups = ([x * 20 for x in range(GROUP_START, GROUP_END + 1)])
    pool.map(main, groups)
    pool.close()
    pool.join()

