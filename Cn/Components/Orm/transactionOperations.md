# 事务操作

事务操作的传参说明，分为以下两种传参情况

| 参数类型        |  参数说明                                                     |
| --------------- | ------------------------------------------------------------ |
| string或array | 值为connectionName，代表当前协程下连接名相符的mysql链接执行事务 |
| ClientInterface | 在invoke闭包中直接传入client，代表直接操作指定客户端 |


返回说明：bool  开启成功则返回true，开启失败则返回false


## 开启事务

```php
DbManager::getInstance()->startTransaction($connectionNames = 'default');
```

## 提交事务

```php
DbManager::getInstance()->commit($connectName = null);
```

## 回滚事务

```php
DbManager::getInstance()->rollback();
```


## 事务用例

```php 
$user = UserModel::create()->get(4);

$user->age = 4;
// 开启事务
$strat = DbManager::getInstance()->startTransaction();

// 更新操作
$res = $user->update();

// 直接回滚 测试
$rollback = DbManager::getInstance()->rollback();

// 返回false 因为连接已经回滚。事务关闭。
$commit = DbManager::getInstance()->commit();
var_dump($commit);
```

