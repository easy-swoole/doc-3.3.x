---
title: Spider
meta:
  - name: description
    content: EasySwoole-Spider 可以方便用户快速搭建分布式多协程爬虫。
  - name: keywords
    content: swoole|swoole 拓展|swoole 框架|easyswoole|spider|爬虫
---

## Product

### 注意事项

- init方法中必须先生成firstProductJob

- product方法返回必须返回ProductResult对象


### 回调方法

爬虫启动前执行的回调，目的是为了生成第一个生产任务(ProductJob)
````php
public function init()
{
    // TODO: Implement init() method.
}
````

当init生成完第一个productJob会传到product方法中，这时候根据productJob提供的url和其它信息爬取数据，并生成新的productJob和customJob设置到ProductResult对象中返回。
````php
public function product(ProductJob $productJob):ProductResult
{
    // TODO: Implement product() method.
}
````

### ProductJob

设置下一个需要抓取的url
````php
    public function setUrl($url) : ProductJob
````

设置其它信息

````php
    public function setOtherInfo($otherInfo) : ProductJob
````

### ProductResult

执行完product方法，需返回ProductResult对象

设置下一个ProductJob
````php
    public function setProductJob(ProductJob $productJob): ProductResult
````

设置ConsumeJob
````php
    public function setConsumeJob(ConsumeJob $consumJob): ProductResult
````