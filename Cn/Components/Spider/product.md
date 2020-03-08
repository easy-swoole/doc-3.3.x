
## Product

### 注意事项

- init方法中必须先返回第一个productJob配置

- product方法返回必须返回ProductResult对象，因为ProductResult包含此次任务新产生的一批任务配置和一个消费任务数据


### 回调方法

爬虫启动前执行的回调，目的是为了生成第一个生产任务
````php
public function init() : array
{
    // TODO: Implement init() method.
    
    // 必返回的内容
    return [
        'url' => '爬虫开始地址',
        'otherInfo' => '其它信息'
    ];
}
````

当init生成完第一个productJob会传到product方法中，会根据返回的url和其它信息生成第一个任务

````php
public function product():ProductResult
{
    // TODO: Implement product() method.
    
    // productConfig存的就是当前任务的配置信息[
             'url' => '',
             'otherInfo' => '其它信息'
         ]
      
    $this->productConfig;
    
    $data = '爬出来的数据';
    
    // 下一批任务配置
    $productJobConfigs = [
        [
            'url' => '',
            'otherInfo' => '其它信息'
        ],
        [
            'url' => '',
            'otherInfo' => '其它信息'
        ],
    ];
    
    $result = new ProductResult();
    $result->setProductJobConfigs($productJobConfigs)->setConsumeData($data);
    return $result;
}
````
