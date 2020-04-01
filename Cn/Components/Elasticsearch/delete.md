# 删除

##根据id删除

```php
$config = new \EasySwoole\ElasticSearch\Config([
    'host'          => '127.0.0.1',
    'port'          => 9200
]);

$elasticsearch = new \EasySwoole\ElasticSearch\ElasticSearch($config);

go(function()use($elasticsearch){
    $bean = new \EasySwoole\ElasticSearch\RequestBean\Delete();
    $time = time();
    $bean->setIndex('my-index-' . $time);
    $bean->setId('my-id-' . $time);
    $response = $this->getElasticSearch()->client()->delete($bean)->getBody();
    $response = json_decode($response,true);
    var_dump($response);
})
```


##根据query删除

```php
$config = new \EasySwoole\ElasticSearch\Config([
    'host'          => '127.0.0.1',
    'port'          => 9200
]);

$elasticsearch = new \EasySwoole\ElasticSearch\ElasticSearch($config);

go(function()use($elasticsearch){
    $bean = new \EasySwoole\ElasticSearch\RequestBean\DeleteByQuery();
    $time = time();
    $bean->setIndex('my-index-' . $time);
    $bean->setBody([
        'query' => [
            'match'=>['name'=>'测试删除']
        ]
    ]);
    $response = $this->getElasticSearch()->client()->deleteByQuery($bean)->getBody();
    $response = json_decode($response,true);
    var_dump($response);
})
```