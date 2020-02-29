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

以百度搜索为例，根据搜索关键词爬出每次检索结果前三页的特定数据
`纯属教学目的，如有冒犯贵公司还请及时通知，会及时调整`

#### Product

```php
<?php
namespace App\Spider;

use EasySwoole\HttpClient\HttpClient;
use EasySwoole\Spider\ConsumeJob;
use EasySwoole\Spider\Hole\ProductAbstract;
use EasySwoole\Spider\ProductResult;
use EasySwoole\Spider\ProductJob;
use QL\QueryList;

class ProductTest extends ProductAbstract
{

    private const SEARCH_WORDS = 'SEARCH_WORDS';

    public function init()
    {
        // TODO: Implement init() method.
        $words = [
            'php',
            'java',
            'go'
        ];
        foreach ($words as $word) {
            $this->config->getQueue()->push(self::SEARCH_WORDS, $word);
        }

        $wd = $this->config->getQueue()->pop(self::SEARCH_WORDS);

        $productJob = new ProductJob();
        $productJob->setUrl("https://www.baidu.com/s?wd={$wd}&pn=0");
        $productJob->setOtherInfo(['page'=>0, 'word'=>$wd]);
        $this->firstProductJob = $productJob;
    }

    public function product(ProductJob $productJob):ProductResult
    {
        // TODO: Implement product() method.
        // 请求地址数据
        $httpClient = new HttpClient($productJob->getUrl());
        $httpClient->setHeader('User-Agent', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.116 Safari/537.36');
        $body = $httpClient->get()->getBody();

        // 先将每个搜索结果的a标签内容拿到
        $rules = [
            'search_result' => ['.c-container .t', 'text', 'a']
        ];
        $searchResult = QueryList::rules($rules)->html($body)->query()->getData();

        $data = [];
        foreach ($searchResult as $result) {
            $item = [
                'href' => QueryList::html($result['search_result'])->find('a')->attr('href'),
                'text' => QueryList::html($result['search_result'])->find('a')->text()
            ];
            $data[] = $item;
        }

        $productJobOtherInfo = $productJob->getOtherInfo();

        // 下一个任务
        $nextProductJob = new ProductJob();
        if ($productJobOtherInfo['page'] === 3) {
            $word = $this->config->getQueue()->pop(self::SEARCH_WORDS);
            $pn = 0;
            $nextOtherInfo = [
                'page' => 0,
                'word' => $word
            ];
        } else {
            $word = $productJobOtherInfo['word'];
            $pn = $productJobOtherInfo['page']*10;
            $nextOtherInfo = [
                'page' => ++$productJobOtherInfo['page'],
                'word' => $word
            ];
        }

        $nextProductJob->setUrl("https://www.baidu.com/s?wd={$word}&pn={$pn}");
        $nextProductJob->setOtherInfo($nextOtherInfo);

        // 消费任务
        $consumeJob = new ConsumeJob();
        $consumeJob->setData($data);

        $result = new ProductResult();
        $result->setProductJob($nextProductJob)->setConsumeJob($consumeJob);
        return $result;
    }

}
```

### Consume

实现ConsumeInterface接口

```php
namespace App\Spider;

use EasySwoole\Spider\ConsumeJob;
use EasySwoole\Spider\Hole\ConsumeAbstract;

class ConsumeTest extends ConsumeAbstract
{

    public function consume(ConsumeJob $consumeJob)
    {
        // TODO: Implement consume() method.
        $data = $consumeJob->getData();

        $items = '';
        foreach ($data as $item) {
            $items .= implode("\t", $item)."\n";
        }

        file_put_contents('baidu.txt', $items);
    }
}
```

### 注册爬虫组件

```php
public static function mainServerCreate(EventRegister $register)
{
    $config = Config::getInstance()
        ->setProduct(new ProductTest())
        ->setConsume(new ConsumeTest())
        ->setProductCoroutineNum(1)
        ->setConsumeCoroutineNum(1);
    Spider::getInstance()
        ->setConfig($config)
        ->attachProcess(ServerManager::getInstance()->getSwooleServer());
}
```