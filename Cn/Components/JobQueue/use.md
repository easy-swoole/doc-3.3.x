---
title: Spider
meta:
  - name: description
    content: JobQueue任务队列。
  - name: keywords
    content: swoole|swoole 拓展|swoole 框架|easyswoole|JobQueue|任务队列
---

## JobQueue

可以方便用户快速搭建多协程分布式任务处理队列

#### 安装
````php
composer require easyswoole/job-queue
````

#### 自定义队列
以Spider组件中的FastCache为例
````php
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

````

#### 单独使用
````php
$queue = new \EasySwoole\JobQueue\JobQueue(new FastCacheQueue());

$http = new swoole_http_server("127.0.0.1", 9501);
$queue->attachServer($http);

$http->on("request", function ($request, $response) {
    $response->header("Content-Type", "text/plain");
    $response->end("Hello World\n");
});

$http->start();
````

#### 框架中使用

需自己实现通信队列

````php
public static function mainServerCreate(EventRegister $register)
    $jobQueue = new JobQueue(new FastCacheQueue());
    $jobQueue->setMaxCurrency(设置最大同时可执行任务数);
    $jobQueue->attachServer(ServerManager::getInstance()->getSwooleServer());
}
````

#### 创建一个任务(Job)

````php
<?php
namespace EasySwoole\Spider\Hole;

use EasySwoole\JobQueue\AbstractJob;

class JobTest extends AbstractJob
{

    public function exec(): bool
    {
        // TODO: Implement exec() method.
        
        return true;
    }

    function onException(\Throwable $throwable): bool
    {
        // TODO: Implement onException() method.

        return true;
    }

}

````

#### 投递任务

````php
$queue = new FastCacheQueue();

$queue->push(new JobTest());
````