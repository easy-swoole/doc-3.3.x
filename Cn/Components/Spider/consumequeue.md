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
namespace EasySwoole\Spider\Queue;

use EasySwoole\Component\Singleton;
use EasySwoole\FastCache\Cache;
use EasySwoole\JobQueue\AbstractJob;
use EasySwoole\JobQueue\JobAbstract;
use EasySwoole\JobQueue\QueueDriverInterface;

class FastCacheQueue implements QueueDriverInterface
{

    use Singleton;

    private const FASTCACHE_JOB_QUEUE_KEY='FASTCACHE_JOB_QUEUE_KEY';

    function pop(float $timeout = 3):?AbstractJob
    {
        // TODO: Implement pop() method.
        $job =  Cache::getInstance()->deQueue(self::FASTCACHE_JOB_QUEUE_KEY);
        if (empty($job)) {
            return null;
        }
        $job = unserialize($job);
        if (empty($job)) {
            return null;
        }
        return $job;
    }

    function push(AbstractJob $job):bool
    {
        // TODO: Implement push() method.
        $res = Cache::getInstance()->enQueue(self::FASTCACHE_JOB_QUEUE_KEY, serialize($job));
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