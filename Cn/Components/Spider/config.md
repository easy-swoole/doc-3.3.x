---
title: Spider
meta:
  - name: description
    content: EasySwoole-Spider 可以方便用户快速搭建分布式多协程爬虫。
  - name: keywords
    content: swoole|swoole 拓展|swoole 框架|easyswoole|spider|爬虫
---

## Config

设置生产端
```php
    public function setProduct(ProductInterface $product): Config
```

设置消费端
```php
    public function setConsume(ConsumeInterface $consume): Config
```

设置队列类型,Config::QUEUE_TYPE_FAST_CACHE、Config::QUEUE_TYPE_REDIS
```php
    public function setQueueType($queueType): Config
```

设置自定义队列,当组件中的队列方式不能满足您的需求时，可以自己实现队列
```php
    public function setQueue($queue): Config
```

设置生产端协程数
```php
    public function setProductCoroutineNum($productCoroutineNum): Config
```

设置消费端协程数
```php
    public function setConsumeCoroutineNum($consumeCoroutineNum): Config
```

设置生产队列key,默认Easyswoole-product
```php
    public function setProductQueueKey($productQueueKey): Config
```

设置消费队列key,默认Easyswoole-consume
```php
    public function setConsumeQueueKey($consumeQueueKey): Config
```

分布式时指定某台机器为开始机
```php
    public function setMainHost($mainHost): Config
```
