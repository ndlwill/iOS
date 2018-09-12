# 代理66、 Proxy360、 Goubanjia 三个免费代理网站

import re, json
from pyquery import PyQuery as pq
from .RequestUtils import get_page_data

# 获取模块
class CrawlerMetaclass(type):
    def __new__(cls, cls_name, bases, attrs):
        count = 0
        attrs['__CrawlFuncs__'] = []
        for k, v in attrs.items():
            if 'crawl_' in k:
                attrs['__CrawlFuncs__'].append(k)
                count += 1
        attrs['__CrawlFuncCount__'] = count
        return type.__new__(cls, cls_name, bases, attrs)


class Crawler(object, metaclass=CrawlerMetaclass):
    def get_proxies(self, callback):
        proxies = []
        for proxy in eval("self.{}()".format(callback)):
            proxies.append(proxy)
        return proxies

    def crawl_daili66(self, page_index=4):
        '''
        抓起代理66网站的代理
        :param page_index: 页码
        :return: 代理地址
        '''
        format_url = 'http://www.66ip.cn/{}.html'
        urls = [format_url.format(page) for page in range(1, page_index + 1)]

        for url in urls:
            html = get_page_data(url)
            if html:
                doc = pq(html)
                trs = doc('.containerbox table tr:gt(0)').items() # 第0个后面的所有tr
                for tr in trs:
                    ip = tr.find('td:nth-child(1)').text() # 第一个td
                    port = tr.find('td:nth-child(2)').text()
                    yield ':'.join([ip, port])

    '''
    def crawl_proxy360(self):
        url = 'http://www.proxy360.cn/Region/China'
        html = get_page_data(url)
        if html:
            doc = pq(html)
            lines = doc('div[name="list_proxy_ip"]').items()
            for line in lines:
                ip = line.find('.tbBottomLine:nth-child(1)').text()
                port = line.find('.tbBottomLine:nth-child(2)').text()
                yield ':'.join([ip, port])
    '''


    '''
    def crawl_goubanjia(self):
        url = 'http://www.goubanjia.com/free/gngn/index.shtml'
        html = get_page_data(url)
        if html:
            doc = pq(html)
            tds = doc('td.ip').items()
            for td in tds:
                td.find('p').remove()
                yield td.text().replace(' ', '')
    '''

    def crawl_ip3366(self):
        for page in range(1, 4):
            url = 'http://www.ip3366.net/free/?stype=1&page={}'.format(page)
            html = get_page_data(url)
            ip_address = re.compile('<tr>\s*<td>(.*?)</td>\s*<td>(.*?)</td>')
            # \s * 匹配空格，起到换行作用
            re_ip_address = ip_address.findall(html)
            for address, port in re_ip_address:
                result = address + ':' + port
                yield result.replace(' ', '')

    def crawl_kuaidaili(self):
        for i in range(1, 4):
            url = 'http://www.kuaidaili.com/free/inha/{}/'.format(i)
            html = get_page_data(url)
            if html:
                ip_address = re.compile('<td data-title="IP">(.*?)</td>')
                re_ip_address = ip_address.findall(html)
                port = re.compile('<td data-title="PORT">(.*?)</td>')
                re_port = port.findall(html)
                for address, port in zip(re_ip_address, re_port):
                    address_port = address + ':' + port
                    yield address_port.replace(' ', '')

    def crawl_xicidaili(self):
        for i in range(1, 3):
            url = 'http://www.xicidaili.com/nn/{}'.format(i)
            headers = {
                'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8',
                'Cookie': '_free_proxy_session=BAh7B0kiD3Nlc3Npb25faWQGOgZFVEkiJWRjYzc5MmM1MTBiMDMzYTUzNTZjNzA4NjBhNWRjZjliBjsAVEkiEF9jc3JmX3Rva2VuBjsARkkiMUp6S2tXT3g5a0FCT01ndzlmWWZqRVJNek1WanRuUDBCbTJUN21GMTBKd3M9BjsARg%3D%3D--2a69429cb2115c6a0cc9a86e0ebe2800c0d471b3',
                'Host': 'www.xicidaili.com',
                'Referer': 'http://www.xicidaili.com/nn/3',
                'Upgrade-Insecure-Requests': '1',
            }
            html = get_page_data(url, options=headers)
            if html:
                find_trs = re.compile('<tr class.*?>(.*?)</tr>', re.S)
                trs = find_trs.findall(html)
                for tr in trs:
                    find_ip = re.compile('<td>(\d+\.\d+\.\d+\.\d+)</td>')
                    re_ip_address = find_ip.findall(tr)
                    find_port = re.compile('<td>(\d+)</td>')
                    re_port = find_port.findall(tr)
                    for address, port in zip(re_ip_address, re_port):
                        address_port = address + ':' + port
                        yield address_port.replace(' ', '')