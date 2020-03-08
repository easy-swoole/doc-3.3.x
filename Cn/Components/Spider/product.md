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

- product方法返回必须返回ProductResult对象，因为ProductResult包含此次任务新产生的一批任务配置和一个消费任务数据


### 回调方法


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
