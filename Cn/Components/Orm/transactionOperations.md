# 事务操作
目前有两种方式开启事务
## DbManager操作事务
| 参数类型        |  参数说明                                                     |
| --------------- | ------------------------------------------------------------ |
| string或array | 值为connectionName，代表当前协程下连接名相符的mysql链接执行事务 |
返回说明：bool  开启成功则返回true，开启失败则返回false
```php
//开启事务
DbManager::getInstance()->startTransaction($connectionNames = 'default');
//提交事务
DbManager::getInstance()->commit($connectName = null);
//回滚事务
DbManager::getInstance()->rollback($connectName = null);
```
代码示例
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
::: warning
注意在事务操作的时候，`connectName`必须是同一个连接
:::

## Client客户端操作事务
`>=1.4.6`版本开始，可以支持在client客户端内使用事务。
### invoke
`invoke(callable $call,string $connectionName = 'default',float $timeout = null)`方法操作事务。

| 参数类型        |  参数说明                                                     |
| --------------- | ------------------------------------------------------------ |
| callable | 回调函数 |
| string | 值为connectionName，代表当前协程下连接名相符的mysql链接执行事务|
| float | 超时时间

返回说明：返回`callable`回调函数返回的参数
```php
DbManager::getInstance()->invoke(function (EasySwoole\ORM\Db\ClientInterface $client){
    //开启事务
    $client->startTransaction();
    //提交事务
    $client->commit();
    //回滚事务
    $client->rollback();
},$connectionName = 'default');
```
代码示例
```php
$user = DbManager::getInstance()->invoke(function ($client){
     //在版本
    //开启事务 版本必须>=>=1.4.6
    $client->startTransaction();
    try {
        $testUserModel = Users::invoke($client);
        $testUserModel->state = 1;
        $testUserModel->name = 'Siam';
        $testUserModel->age = 18;
        $testUserModel->addTime = date('Y-m-d H:i:s');
        $testUserModel->save();
        //提交
        $client->commit();
    }catch (\Throwable $t){
        //回滚事务
        $client->rollback();
        var_dump($t->getMessage());
    }
});
```
### defer
`defer(float $timeout = null)`方法操作事务。

| 参数类型        |  参数说明                                                     |
| --------------- | ------------------------------------------------------------ |
| float | 超时时间

返回说明：返回client客户端类

```php
//开启事务
Users::defer()->startTransaction();
//提交事务
Users::defer()->commit();
//回滚事务
Users::defer()->rollback();
```
代码示例
```php
$userModel = new Users();
//开启事务
$userModel::defer()->startTransaction();
try {
    $userModel->username = "victor";
    $userModel->save();
    //提交事务
    $userModel::defer()->commit();
}catch (\Throwable $t){
    //回滚事务
    $userModel::defer()->rollback();
}
```