---
title: ORM结果转换数组
meta:
  - name: description
    content: Easyswoole ORM组件,
  - name: keywords
    content:  swoole|swoole 拓展|swoole 框架|EasySwoole mysql ORM|EasySwoole ORM|Swoole mysqli协程客户端|swoole ORM|查询|ORM结果转换数组
---

# 结果转换数组

查询后将对象转为数组

## 传参

toArray和toRawArray传参一致

| 参数名       |  参数说明                                                     |
| --------------- | ------------------------------------------------------------ |
| notNull | 是否过滤空，bool类型 默认`false`，当为true时，只返回非空字段 |
| strict | 严格模式，bool类型 默认`true`，当为true时，只返回当前模型对应数据表的字段，其他field别名等不返回。 |


## 示例

经过获取器
```php
$model = Model::create()->get(1);
$array = $model->toArray();

$model = Model::create()->all();
foreach($model as $one){
    var_dump($one->toArray());
}
```


不经过获取器
```php
$model = Model::create()->get(1);
$array = $model->toRawArray();

$model = Model::create()->all();
foreach($model as $one){
    var_dump($one->toRawArray());
}
```