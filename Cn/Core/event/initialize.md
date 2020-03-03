---
title: initialize
meta:
  - name: description
    content: 框架初始化事件
  - name: keywords
    content: swoole|swoole 拓展|swoole 框架|EasySwoole|swoole|initialize
---
# 框架初始化事件

## 函数原型

```php
public static function initialize(): void
{
}
```

## 已完成工作

在执行框架初始化事件时，EasySwoole已经完成的工作有：

- 全局常量EASYSWOOLE_ROOT的定义
- 系统默认Log/Temp目录的定义


## 可处理内容

在该事件中，可以进行一些系统常量的更改和全局配置，例如：

- 修改并创建系统默认Log/Temp目录。
- 引入用户自定义配置
- 注册 数据库,redis 连接池
- trace链追踪器注册

## 启动前调用协程API
```php
use Swoole\Coroutine\Scheduler;
$scheduler = new Scheduler();
$scheduler->add(function() {
    /*  调用协程API */
});
$scheduler->start();
//清除全部定时器
\Swoole\Timer::clearAll();
```

## 调用ORM
```
namespace EasySwoole\EasySwoole;

use EasySwoole\EasySwoole\Swoole\EventRegister;
use EasySwoole\EasySwoole\AbstractInterface\Event;
use EasySwoole\Http\Message\Status;
use EasySwoole\Http\Request;
use EasySwoole\Http\Response;
use EasySwoole\Mysqli\QueryBuilder;
use EasySwoole\ORM\Db\Config;
use EasySwoole\EasySwoole\Config as GlobalConfig;
use EasySwoole\ORM\Db\Connection;
use EasySwoole\ORM\DbManager;
use Swoole\Coroutine\Scheduler;

class EasySwooleEvent implements Event
{

    public static function initialize()
    {
        // TODO: Implement initialize() method.
        date_default_timezone_set('Asia/Shanghai');
        $config = new Config(GlobalConfig::getInstance()->getConf('MYSQL'));
        DbManager::getInstance()->addConnection(new Connection($config));
        //创建一个协程调度器
        $scheduler = new Scheduler();
        $scheduler->add(function () {
            $builder = new QueryBuilder();
            $builder->raw('select version()');
            DbManager::getInstance()->query($builder, true);
            //这边重置ORM连接池的pool,避免链接被克隆岛子进程，造成链接跨进程公用。
            DbManager::getInstance()->getConnection()->getClientPool()->reset();
        });
        //执行调度器内注册的全部回调
        $scheduler->start();
        //清理调度器内可能注册的定时器，不要影响到swoole server 的event loop
        \Swoole\Timer::clearAll();
    }


    public static function mainServerCreate(EventRegister $register)
    {

    }

    public static function onRequest(Request $request, Response $response): bool
    {
        return true;
    }

    public static function afterRequest(Request $request, Response $response): void
    {
        // TODO: Implement afterAction() method.
    }
}
```