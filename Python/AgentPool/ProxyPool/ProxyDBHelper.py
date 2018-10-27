from redis import StrictRedis

from random import choice
import re

# from ProxyPool.Configure import *
from ProxyPool.Configure import REDIS_HOST, REDIS_PORT, REDIS_PASSWORD, REDIS_KEY
from ProxyPool.Configure import MAX_SCORE, MIN_SCORE, INITIAL_SCORE

from ProxyPool.ProxyPoolError import PoolEmptyError

# 存储模块
class RedisClient(object):
    def __init__(self, host=REDIS_HOST, port=REDIS_PORT, password=REDIS_PASSWORD):
        self.db = StrictRedis(host=host, port=port, password=password, decode_responses=True)

    def add(self, proxy, score=INITIAL_SCORE):
        '''
        添加代理
        :param proxy:proxy地址
        :param score:
        :return:
        '''
        if not re.match('\d+\.\d+\.\d+\.\d+\:\d+', proxy):
            print('代理地址不符合规范')
            return

        if not self.db.zscore(REDIS_KEY, proxy):
            return self.db.zadd(REDIS_KEY, score, proxy)

    def random(self):
        result = self.db.zrangebyscore(REDIS_KEY, MAX_SCORE, MAX_SCORE)
        if len(result):
            return choice(result)
        else:
            # 从大到小排序
            result = self.db.zrevrange(REDIS_KEY, MIN_SCORE, MAX_SCORE)
            if len(result):
                return choice(result)
            else:
                raise PoolEmptyError

    def decrease(self, proxy):
        score = self.db.zscore(REDIS_KEY, proxy)
        if score and score > MIN_SCORE:
            print('代理:', proxy, 'score:', score, '-1')
            return self.db.zincrby(REDIS_KEY, proxy, -1)
        else:
            print('代理:', proxy, 'score:', score, 'remove')
            return self.db.zrem(REDIS_KEY, proxy)

    def exists(self, proxy):
        return not self.db.zscore(REDIS_KEY, proxy) == None

    def update_score_to_max(self, proxy):
        # return: 设置结果
        return self.db.zadd(REDIS_KEY, MAX_SCORE, proxy)

    def count(self):
        return self.db.zcard(REDIS_KEY)

    def total_list(self):
        return self.db.zrangebyscore(REDIS_KEY, MIN_SCORE, MAX_SCORE)

    def range_list(self, from_value, to_value):
        return self.db.zrevrange(REDIS_KEY, from_value, to_value - 1)