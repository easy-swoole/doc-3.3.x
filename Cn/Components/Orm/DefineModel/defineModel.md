---
title: easyswoole ORM模型定义
meta:
  - name: description
    content: easyswoole ORM模型定义
---

# 基础定义

## 定义模型
定义一个模型基础的模型，必须继承```EasySwoole\ORM\AbstractModel```类
```php
namespace App\Models;

use EasySwoole\ORM\AbstractModel;

/**
 * 用户商品模型
 * Class UserShop
 */
class UserShop extends AbstractModel
{
    
}
```

## 数据表名称
必须在Model中定义 ```$tableName``` 属性，指定完整表名，否则将会产生错误Table name is require for model
```php
namespace App\Models;

use EasySwoole\ORM\AbstractModel;

/**
 * 用户商品模型
 * Class UserShop
 */
class UserShop extends AbstractModel
{
     /**
      * @var string 
      */
     protected $tableName = 'user_shop';
}
```
