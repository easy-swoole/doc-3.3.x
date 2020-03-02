---
title: Spider
meta:
  - name: description
    content: EasySwoole-Spider 可以方便用户快速搭建分布式多协程爬虫。
  - name: keywords
    content: swoole|swoole 拓展|swoole 框架|easyswoole|spider|爬虫
---

## 自定义队列

实现use EasySwoole\JobQueue\JobQueueInterface;接口，以组件默认的fast-cache queue为例

```php
<?php
/**
 * @CreateTime:   2020/2/22 下午2:55
 * @Author:       huizhang  <tuzisir@163.com>
 * @Copyright:    copyright(2020) Easyswoole all rights reserved
 * @Description:  爬虫组件默认fastcache为通信队列
 */
namespace EasySwoole\Spider\Queue;

use EasySwoole\Component\Singleton;
use EasySwoole\FastCache\Cache;
use EasySwoole\JobQueue\JobAbstract;
use EasySwoole\JobQueue\JobQueueInterface;

class FastCacheQueue implements JobQueueInterface
{

    use Singleton;

    function pop($key): ?JobAbstract
    {
        // TODO: Implement pop() method.
        $job =  Cache::getInstance()->deQueue($key);
        if (empty($job)) {
            return null;
        }
        $job = unserialize($job);
        if (empty($job)) {
            return null;
        }
        return $job;
    }

    function push($key, JobAbstract $job): bool
    {
        // TODO: Implement push() method.
        $res = Cache::getInstance()->enQueue($key, serialize($job));
        if (empty($res)) {
            return false;
        }
        return true;
    }

}

```

### mainServerCreate

使用setQueue方法注册自定义队列

```php
 public static function mainServerCreate(EventRegister $register)
{
    // TODO: Implement mainServerCreate() method.
    $config = Config::getInstance()
        ->setProduct(new ProductTest()) // 设置生产端
        ->setConsume(new ConsumeTest()) // 设置消费端
        // ----------注意
        ->setQueue(new FastCacheQueue()) // 设置自定义队列
    Spider::getInstance()
        ->setConfig($config)
        ->attachProcess(ServerManager::getInstance()->getSwooleServer());
}
```