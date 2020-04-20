---
title: easyswoole orm配置数据库连接
meta:
  - name: description
    content: easyswoole orm配置数据库连接
  - name: keywords
    content:  easyswoole orm配置数据库连接
---

# 配置信息注册

ORM 的连接配置信息（数据库连接信息）需要注册到`连接管理器`中。

## 数据库连接管理器

ORM的连接管理由```EasySwoole\ORM\DbManager```类完成，它是一个单例类。

```php
use EasySwoole\ORM\DbManager;

DbManager::getInstance();
```


## 注册数据库连接配置

你**可以**在框架 `initialize` 主服务创建事件中注册连接

```php
use EasySwoole\ORM\DbManager;
use EasySwoole\ORM\Db\Connection;
use EasySwoole\ORM\Db\Config;


public static function initialize()
{
    $config = new Config();
    $config->setDatabase('easyswoole_orm');
    $config->setUser('root');
    $config->setPassword('');
    $config->setHost('127.0.0.1');

    DbManager::getInstance()->addConnection(new Connection($config));
}
```


## 数据库连接自带连接池说明

在默认实现中，ORM自带了一个`基于连接池`实现的连接类

`EasySwoole\ORM\Db\Connection` 实现了连接池的使用

```php
use EasySwoole\ORM\DbManager;
use EasySwoole\ORM\Db\Connection;
use EasySwoole\ORM\Db\Config;


public static function initialize()
{
    $config = new Config();
    $config->setDatabase('easyswoole_orm');
    $config->setUser('root');
    $config->setPassword('');
    $config->setHost('127.0.0.1');
    //连接池配置
    $config->setGetObjectTimeout(3.0); //设置获取连接池对象超时时间
    $config->setIntervalCheckTime(30*1000); //设置检测连接存活执行回收和创建的周期
    $config->setMaxIdleTime(15); //连接池对象最大闲置时间(秒)
    $config->setMaxObjectNum(20); //设置最大连接池存在连接对象数量
    $config->setMinObjectNum(5); //设置最小连接池存在连接对象数量
    $config->setAutoPing(5); //设置自动ping客户端链接的间隔

    DbManager::getInstance()->addConnection(new Connection($config));
}
```

::: tip
详细的连接池属性介绍[点击查看](../Pool/config.md)
:::

## 连接预热
为了避免链接空档期突如其来的高并发，我们可以做数据库链接预热，也就是worker启动的是时候，提前准备好链接。
```php
<?php
namespace EasySwoole\EasySwoole;


use EasySwoole\EasySwoole\Swoole\EventRegister;
use EasySwoole\EasySwoole\AbstractInterface\Event;
use EasySwoole\Http\Request;
use EasySwoole\Http\Response;
use EasySwoole\ORM\DbManager;
use EasySwoole\ORM\Db\Connection;
use EasySwoole\ORM\Db\Config;
use EasySwoole\EasySwoole\Config as GlobalConfig;

class EasySwooleEvent implements Event
{

    public static function initialize()
    {
        // TODO: Implement initialize() method.
        date_default_timezone_set('Asia/Shanghai');
        $config = new Config(GlobalConfig::getInstance()->getConf("MYSQL"));
        DbManager::getInstance()->addConnection(new Connection($config));
    }

    public static function mainServerCreate(EventRegister $register)
    {
        $register->add($register::onWorkerStart,function (){
            //链接预热
            DbManager::getInstance()->getConnection()->getClientPool()->keepMin();
        });
    }

    public static function onRequest(Request $request, Response $response): bool
    {
        // TODO: Implement onRequest() method.
        return true;
    }

    public static function afterRequest(Request $request, Response $response): void
    {
        // TODO: Implement afterAction() method.
    }
}
```


## 断线问题
### 为什么会断线？
在连接池模式下，一个连接创建后，并不会因为因为请求结束而断开，就好比php-fpm下的pconnect特性一样。而一个连接
建立后，可能会因为太久没有使用(执行sql),而被mysql服务端主动断了连接，或者是因为链路问题，切断了连接。而被切断的时候。我们并不知道这件事。因此就导致了我们用了
一个断线的连接去执行sql，从而出现断线错误或者是异常。

### 如何解决
与java全家桶的原理一致，我们需要做的事情就是：
- 定时检查连接是否可用
- 定时检查连接的最后一次使用状态

因此我们在EasySwoole的orm中，我们的```IntervalCheckTime```配置项目指定的就是多久做一次周期检查，
```MaxIdleTime```指的是如果一个连接超过这个时间没有使用，则会被回收。```AutoPing```指的是多久执行一个```select 1```用来触发这个连接，使得被mysql服务端标记为活跃而不会被回收。
如果经常出现断线，可以适当缩短时间。

### 百分百不会断线了?
理论上，做了上面的步骤，出现使用断线连接的概率是非常低的，但是、并不是真的就百分百稳了，比如极端情况，mysql服务重启，或者是链路断线了。
因此，我们一定要做以下类似事情：
```
try{
    $client = $pool->getClient()
    $cilient->query(xxxxxx);
}catch(\Throable $t){}

```
也就是，任何orm的使用，一定要try。至于为何，请参考java为何强制对任何数据库io作try.