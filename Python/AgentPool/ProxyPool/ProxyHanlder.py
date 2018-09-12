from ProxyPool.ProxyDBHelper import RedisClient
from ProxyPool.Crawler import Crawler
from ProxyPool.Configure import *

import sys

class ProxyHandler():
    def __init__(self):
        self.redis = RedisClient()
        self.crawler = Crawler()

    def is_over_threshold(self):
        if self.redis.count() >= POOL_UPPER_LIMIT:
            return True
        else:
            return False

    def process(self):
        if not self.is_over_threshold():
            for callbackIndex in range(self.crawler.__CrawlFuncCount__):
                callbackName = self.crawler.__CrawlFuncs__[callbackIndex]

                proxies = self.crawler.get_proxies(callbackName)
                sys.stdout.flush()
                for proxy in proxies:
                    self.redis.add(proxy)
