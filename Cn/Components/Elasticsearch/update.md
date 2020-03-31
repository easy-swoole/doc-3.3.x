# 修改

##根据id修改

```php
$config = new \EasySwoole\ElasticSearch\Config([
    'host'          => '127.0.0.1',
    'port'          => 9200
]);

$elasticsearch = new \EasySwoole\ElasticSearch\ElasticSearch($config);

go(function()use($elasticsearch){
    $bean = new \EasySwoole\ElasticSearch\RequestBean\Update();
    $bean->setIndex('my-index');
    $bean->setType('my-type');
    $bean->setId('my-id');
    $bean->setBody([
        'doc' => [
            'test-field' => 'abd'
        ]
    ]);
    $response = $this->getElasticSearch()->client()->update($bean)->getBody();
    $response = json_decode($response,true);
    var_dump($response);
})
```

##根据query修改

```php
$config = new \EasySwoole\ElasticSearch\Config([
    'host'          => '127.0.0.1',
    'port'          => 9200
]);

$elasticsearch = new \EasySwoole\ElasticSearch\ElasticSearch($config);

go(function()use($elasticsearch){
    $bean = new \EasySwoole\ElasticSearch\RequestBean\UpdateByQuery();
    $bean->setIndex('my-index');
    $bean->setType('my-type');
    $bean->setBody([
        'query' => [
            'match' => ['test-field' => 'abd']
        ],
        'script' => [
            'source' => 'ctx._source["test-field"]="testing"'
        ]
    ]);
    $response = $this->getElasticSearch()->client()->updateByQuery($bean)->getBody();
    $response = json_decode($response,true);
    var_dump($response);
})
```

##Reindex

```php
$config = new \EasySwoole\ElasticSearch\Config([
    'host'          => '127.0.0.1',
    'port'          => 9200
]);

$elasticsearch = new \EasySwoole\ElasticSearch\ElasticSearch($config);

go(function()use($elasticsearch){
    $bean = new \EasySwoole\ElasticSearch\RequestBean\Reindex();
    $bean->setBody([
        'source' => [
            'index' => 'my-index'
        ],
        'dest' => [
            'index' => 'my-index-new'
        ]
    ]);
    $response = $this->getElasticSearch()->client()->reindex($bean)->getBody();
    $response = json_decode($response,true);
    var_dump($response);
})
```