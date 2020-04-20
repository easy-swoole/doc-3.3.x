---
title: easyswoole追踪器
meta:
  - name: description
    content: easyswoole追踪器
  - name: keywords
    content: easyswoole追踪器|easyswoole trigger
---
# Trigger

`\EasySwoole\EasySwoole\Trigger`触发器,用于主动触发错误或者异常而不中断程序继续执行。  
触发器是用来主动触发错误或者异常而不中断程序继续执行。  
命名空间:`\EasySwoole\EasySwoole\Trigger`.  
例如在控制器的`onException`中调用异常处理
````php
protected function onException(\Throwable $throwable): void
{
    //拦截错误进日志,使控制器继续运行
    EasySwoole\EasySwoole\Trigger::getInstance()->throwable($throwable);
    $this->writeJson(Status::CODE_INTERNAL_SERVER_ERROR, null, $throwable->getMessage());
}
````
使用error方法直接记录输出错误
````php
//记录输出错误
EasySwoole\EasySwoole\Trigger::getInstance()->error('test error');
````

## Trigger默认处理类
在EasySwoole底层中,已经注册了默认的触发器处理类,以及一系列的错误处理逻辑:  
Trigger默认处理类
````php
<?php
/**
 * Created by PhpStorm.
 * User: yf
 * Date: 2018/8/14
 * Time: 下午6:17
 */

namespace EasySwoole\EasySwoole;


use EasySwoole\Component\Event;
use EasySwoole\Component\Singleton;
use EasySwoole\Trigger\Location;
use EasySwoole\Trigger\TriggerInterface;

class Trigger implements TriggerInterface
{
    use Singleton;

    private $trigger;

    private $onError;
    private $onException;

    function __construct(TriggerInterface $trigger)
    {
        $this->trigger = $trigger;
        $this->onError = new Event();
        $this->onException = new Event();
    }

    public function error($msg,int $errorCode = E_USER_ERROR,Location $location = null)
    {
        // TODO: Implement error() method.
        if($location == null){
            $location = $this->getLocation();
        }
        $this->trigger->error($msg,$errorCode,$location);
        $all = $this->onError->all();
        foreach ($all as $call){
            call_user_func($call,$msg,$errorCode,$location);
        }
    }

    public function throwable(\Throwable $throwable)
    {
        // TODO: Implement throwable() method.
        $this->trigger->throwable($throwable);
        $all = $this->onException->all();
        foreach ($all as $call){
            call_user_func($call,$throwable);
        }
    }

    public function onError():Event
    {
        return $this->onError;
    }

    public function onException():Event
    {
        return $this->onException;
    }

    private function getLocation():Location
    {
        $location = new Location();
        $debugTrace = debug_backtrace();
        array_shift($debugTrace);
        $caller = array_shift($debugTrace);
        $location->setLine($caller['line']);
        $location->setFile($caller['file']);
        return $location;
    }
}
````
## 自定义处理类
我们需要通过实现`EasySwoole\Trigger\TriggerInterface`接口进行实现处理类:
````php
<?php
/**
 * Created by PhpStorm.
 * User: tioncico
 * Date: 20-4-20
 * Time: 下午9:28
 */

namespace App\Exception;


use EasySwoole\EasySwoole\Logger;
use EasySwoole\Trigger\Location;
use EasySwoole\Trigger\TriggerInterface;

class TriggerHandel implements TriggerInterface
{
    public function error($msg, int $errorCode = E_USER_ERROR, Location $location = null)
    {
        Logger::getInstance()->console('这是自定义输出的错误:'.$msg);
        // TODO: Implement error() method.
    }

    public function throwable(\Throwable $throwable)
    {
        Logger::getInstance()->console('这是自定义输出的异常:'.$throwable->getMessage());
        // TODO: Implement throwable() method.
    }
}
````

在 `bootstrap.php` bootstrap事件中注入自定义logger处理器:

```php
\EasySwoole\EasySwoole\Trigger::getInstance(new \App\Exception\TriggerHandel());
```



# 线上实时预警
在一些重要的线上服务，我们希望出现错误的时候，可以实时预警并处理。我们以短信或者邮件通知为例子。

## 预警处理类
```
<?php


namespace App\Utility;


use App\Model\EventNotifyModel;
use App\Model\EventNotifyPhoneModel;
use App\Utility\Sms\Sms;
use EasySwoole\Component\Singleton;
use EasySwoole\EasySwoole\Trigger;
use Swoole\Table;

class EventNotify
{
    use Singleton;

    private $evenTable;

    function __construct()
    {
        $this->evenTable = new Table(2048);
        $this->evenTable->column('expire',Table::TYPE_INT,8);
        $this->evenTable->column('count',Table::TYPE_INT,8);
        $this->evenTable->create();
    }

    function notifyException(\Throwable $throwable)
    {
        $class = get_class($throwable);
        //根目录下的异常，以msg为key
        if($class == 'Exception'){
            $key = substr(md5($throwable->getMessage()),8,16);
        }else{
            $key = substr(md5($class),8,16);
        }
        $this->onNotify($key,$throwable->getMessage());
    }

    function notify(string $msg)
    {
        $key = md5($msg);
        $this->onNotify($key,$msg);
    }

    private function onNotify(string $key,string $msg)
    {
        $info = $this->evenTable->get($key);
        //同一种消息在十分钟内不再记录
        $this->evenTable->set($key,[
            "expire"=>time() + 10 * 60
        ]);
        if(!empty($info)){
            return;
        }
        try{
            EventNotifyPhoneModel::create()->chunk(function (EventNotifyPhoneModel $model)use($msg){
                Sms::send($model->phone,$msg);
            });
            EventNotifyModel::create([
                'msg'=>$msg,
                'time'=>time()
            ])->save();
        }catch (\Throwable $throwable){
            //避免死循环
            Trigger::getInstance()->error($throwable->getMessage());
        }
    }
}
```
注意，此处为不完全代码。以下三个class需要自己实现
```
use App\Model\EventNotifyModel;
use App\Model\EventNotifyPhoneModel;
use App\Utility\Sms\Sms;
```
目的在于:
- 记录通知的手机号码
- 下发短信
- 异常信息记录


## 回调接管注册

在easyswoole全局的``mainServerCreate``事件中进行注册
```
<?php

class EasySwooleEvent implements Event
{
    public static function mainServerCreate(EventRegister $register)
    {
        //提前实例化异常通知器并注册回调
        EventNotify::getInstance();
        Trigger::getInstance()->onException()->set('notify',function (\Throwable $throwable){
            EventNotify::getInstance()->notifyException($throwable);
        });

        Trigger::getInstance()->onError()->set('notify',function ($msg){
            EventNotify::getInstance()->notify($msg);
        });
    }
}
```

## 效果
后续，在任何业务逻辑当中有调用Trigger的地方，都会触发，效果如下：
![](/Images/trigger_sms.jpg)

> Easyswoole Http Request回调已经自动做了异常捕获，未处理的异常均会被Trigger捕获。