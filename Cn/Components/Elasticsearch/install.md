---
title: easyswoole协程elasticsearch组件
meta:
  - name: description
    content: Elasticsearch client，对官方客户端的协程化移植
  - name: keywords
    content:  swoole协程elasticsearch
---

# Elasticsearch

## 安装

```php
composer require easyswoole/elasticsearch
```

## Client用法

```php
$config = new \EasySwoole\ElasticSearch\Config([
    'host'          => '127.0.0.1',
    'port'          => 9200
]);

$elasticsearch = new \EasySwoole\ElasticSearch\ElasticSearch($config);

go(function()use($elasticsearch){
    $bean = new \EasySwoole\ElasticSearch\RequestBean\Search();
    $bean->setIndex('my_index');
    $bean->setType('my_type');
    $bean->setBody(['query' => ['matchAll' => []]]);
    $response = $elasticsearch->client()->search($bean)->getBody();
    var_dump(json_decode($response, true));
})
```

## x-pack验证

当elasticsearch开启x-pack登录验证时，只需在config中再传入用户名密码即可

```php
$config = new \EasySwoole\ElasticSearch\Config([
    'host'          => '127.0.0.1',
    'port'          => 9200,
    'username'      => 'elastic',
    'password'      => '123456'
]);

$elasticsearch = new \EasySwoole\ElasticSearch\ElasticSearch($config);
```

## 修改http为https

```php
$config = new \EasySwoole\ElasticSearch\Config([
    'host'          => '127.0.0.1',
    'port'          => 9200,
    'username'      => 'elastic',
    'password'      => '123456',
    'scheme'        => 'https'
]);

$elasticsearch = new \EasySwoole\ElasticSearch\ElasticSearch($config);
```