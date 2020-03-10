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

例如在控制器的onException中,我们可以记录错误异常,然后输出其他内容,不让系统终端运行,不让用户发觉真实错误.
````php
use EasySwoole\EasySwoole\Trigger;
//记录错误异常日志,等级为Exception
Trigger::getInstance()->throwable($throwable);
//记录错误信息,等级为FatalError
Trigger::getInstance()->error($throwable->getMessage().'666');

Trigger::getInstance()->onError()->set('myHook',function (){
    //当发生error时新增回调函数
});
Trigger::getInstance()->onException()->set('myHook',function (){
    
});
````

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