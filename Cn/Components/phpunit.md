---
title: easyswoole利用phpunit进行单元测试
meta:
  - name: description
    content: easyswoole利用phpunit进行单元测试
  - name: keywords
    content: easyswoole单元测试|swoole单元测试
---

# Phpunit

Easyswoole/Phpunit 是对 Phpunit 的协程定制化封装，主要为解决自动协程化入口的问题。并屏蔽了Swoole ExitException

## 安装 
```
composer require easyswoole/phpunit
```
## 使用
执行
```
./vendor/bin/co-phpunit tests
```


::: warning 
 tests为你写的测试文件的目录，可以自定义
:::

## 预处理
```php
/*
 * 允许自动的执行一些初始化操作，只初始化一次
 */
if(file_exists(getcwd().'/phpunit.php')){
    require_once getcwd().'/phpunit.php';
}
```

easyswoole/phpunit 支持在项目目录下定义一个phpunit.php，用户可以在该文件下进行统一的测试前预处理，其他测试与phpunit一致

## ORM数据测试

### 链接注册

我们在Easyswoole全局的initialize事件中注册链接。
```php
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
        // TODO: Implement mainServerCreate() method.
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

> 更多信息请看ORM章节

### 环境预处理
在项目目录下，创建phpunit.php 文件
```php
<?php
use EasySwoole\EasySwoole\Core;
Core::getInstance()->initialize()->globalInitialize();
```

### 编写测试用例
```php
<?php
namespace Test;
use EasySwoole\Mysqli\QueryBuilder;
use PHPUnit\Framework\TestCase;
use EasySwoole\ORM\DbManager;

class DbTest extends TestCase
{
    function testCon()
    {
        $builder = new QueryBuilder();
        $builder->raw('select version()');
        $ret = DbManager::getInstance()->query($builder,true)->getResult();
        $this->assertArrayHasKey('version()',$ret[0]);
    }
}
```

> 请注册composer.json下Test命名空间与tests目录的映射关系

### 执行测试用例
```bash
./vendor/bin/co-phpunit tests
```

这样既可编写ORM测试