# where

快速完成条件语句构建。where方法的参数支持字符串和数组。

## 普通查询+

```php
$builder->where('col1', 2)->get('getTable');
```

## 字符串语句

可以使用字符串语句构建比较复杂的条件

```php
// 生成大概语句：where status = 1 AND (id > 10 or id < 2)
$builder->where('status', 1)->where(' (id > 10 or id <2) ')->get('getTable');
```
##  null 条件
```php

$builder = new \EasySwoole\Mysqli\QueryBuilder();
$builder->where('status', null,'is')->get('getTable');
$builder->where('status is null')->get('getTable');
$builder->where('status', null,'is not')->get('getTable');
```

## 特殊操作符

```php
$builder->where('id', [1,2,3], 'IN')->get('getTable');
```

```php
$builder->where('age', 12, '>')->get('getTable');
```

## 连接条件

### orWhere

```php
$builder->where('is_vip', 1)->where('id', [1,2], '=', 'OR')->get('getTable');
```

```php
$builder->where('is_vip', 1)->orWhere('id', [1,2])->get('getTable');
```

## 传参说明

方法原型

```php
function where($whereProp, $whereValue = 'DBNULL', $operator = '=', $cond = 'AND')
```

- $whereProp string 支持索引数组、kv数组、或直接传递字符串
- $whereValue string 条件值
- $operator string 操作符
- $cond string 连接条件
