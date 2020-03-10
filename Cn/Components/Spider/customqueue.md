---
title: Spider
meta:
  - name: description
    content: EasySwoole-Spider 可以方便用户快速搭建分布式多协程爬虫。
  - name: keywords
    content: swoole|swoole 拓展|swoole 框架|easyswoole|spider|爬虫
---

## 自定义队列

实现EasySwoole\Spider\Hole\QueueInterface接口，以组件默认的fast-cache queue为例

### 实现QueueInterface

```php
<?php
namespace EasySwoole\Spider\Queue;

use EasySwoole\FastCache\Cache;
use EasySwoole\Spider\Hole\QueueInterface;

class FastCacheQueue implements QueueInterface
{

    public function push($key, $value)
    {
        // TODO: Implement push() method.
        Cache::getInstance()->enQueue($key,$value);
    }

    public function pop($key)
    {
        // TODO: Implement pop() method.
        return Cache::getInstance()->deQueue($key);
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
            ->setStartUrl('xxx') // 爬虫开始地址
            ->setProduct(new ProductTest()) // 设置生产端
            ->setConsume(new ConsumeTest()) // 设置消费端

            // ----------注意
            ->setQueue(new FastCacheQueue()) // 设置自定义队列

            ->setProductCoroutineNum(3) // 生产端协程数
            ->setConsumeCoroutineNum(1); // 消费端协程数
        Spider::getInstance()
            ->setConfig($config)
            ->attachProcess(ServerManager::getInstance()->getSwooleServer());
    }
```