---
title: Spider
meta:
  - name: description
    content: EasySwoole-Spider 可以方便用户快速搭建分布式多协程爬虫。
  - name: keywords
    content: swoole|swoole 拓展|swoole 框架|easyswoole|spider|爬虫
---

## Consume

### 回调方法

在product执行完后会投递productJob到消费队列
````php
public function consume(ProductJob $productJob):ProductResult
{
    // TODO: Implement product() method.
}
````

## ConsumeJob

设置数据
````php
    public function setData($data) : ConsumeJob
````
