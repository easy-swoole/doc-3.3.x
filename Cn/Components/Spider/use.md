---
title: Spider
meta:
  - name: description
    content: EasySwoole-Spider 可以方便用户快速搭建分布式多协程爬虫。
  - name: keywords
    content: swoole|swoole 拓展|swoole 框架|easyswoole|spider|爬虫
---

## Spider

Spider组件可以方便用户快速搭建分布式多协程爬虫，用户只需关心product和consume，product对dom的解析推荐使用[Querylist](http://www.querylist.cc/)

## 安装
```
composer require easyswoole/spider
```

组件默认使用fast-cache为通信队列
```
composer require easyswoole/fast-cache
```

如果使用redis-pool连接池为通信方式
```
composer require easyswoole/redis-pool
```

## 快速使用

#### Product

实现ProductInterface接口

```php
namespace App\Spider;

use EasySwoole\HttpClient\HttpClient;
use EasySwoole\Spider\Hole\ProductInterface;
use EasySwoole\Spider\Spider;
use EasySwoole\Spider\Config\ProductResult;

class ProductTest implements ProductInterface
{

    public function product($url):ProductResult
    {
        // TODO: Implement product() method.
        // 通过http协程客户端拿到地址内容
        $httpClient = new HttpClient($url);
        $body = $httpClient->get()->getBody();
        // 可以借助第三方dom解析，如Querylist
        $nextUrl = 'xxx';
        $data = 'xxx';
        $result = new ProductResult();
        return $result->setNexturl($nextUrl)->setConsumeData($data);
    }
}
```

### Consume

实现ConsumeInterface接口

```php
namespace App\Spider;

use EasySwoole\Spider\Hole\ConsumeInterface;

class ConsumeTest implements ConsumeInterface
{

    public function consume($data)
    {
        // TODO: Implement consume() method.
        $urls = '';
        foreach ($data as $item) {
            if (!empty($item)) {
                $urls .= $item."\n";
            }
        }
        file_put_contents('xx.txt', $urls);
    }
}
```

### 注册爬虫组件

```php
public static function mainServerCreate(EventRegister $register)
{
    // TODO: Implement mainServerCreate() method.
    $config = Config::getInstance()
            ->setStartUrl('xxxx') // 爬虫开始地址
            ->setProduct(new ProductTest()) // 设置生产端
            ->setConsume(new ConsumeTest()) // 设置消费端
            ->setProductCoroutineNum(1) // 生产端协程数
            ->setConsumeCoroutineNum(1); // 消费端协程数

    Spider::getInstance()
        ->setConfig($config)
        ->attachProcess(ServerManager::getInstance()->getSwooleServer());
}
```