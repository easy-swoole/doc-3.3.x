# orWhere

快速完成条件语句构建

下面两种方法等价

```php
$builder->where('is_vip', 1)->where('id', 1, '=', 'OR')->get('getTable');
```

```php
$builder->where('is_vip', 1)->orWhere('id', 1)->get('getTable');
```

## 传参说明

方法原型

```php
function orWhere($whereProp, $whereValue = 'DBNULL', $operator = '=')
```

- $whereProp string 支持索引数组、kv数组、或直接传递字符串
- $whereValue string 条件值
- $operator string 操作符
