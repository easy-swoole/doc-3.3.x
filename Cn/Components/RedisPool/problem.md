# 常见问题
## 如何在initialize使用
```
<?php

namespace EasySwoole\EasySwoole;

use EasySwoole\EasySwoole\Swoole\EventRegister;
use EasySwoole\EasySwoole\AbstractInterface\Event;
use EasySwoole\Http\Message\Status;
use EasySwoole\Http\Request;
use EasySwoole\Http\Response;
use EasySwoole\EasySwoole\Config as GlobalConfig;
use EasySwoole\Redis\Config\RedisConfig;
use EasySwoole\RedisPool\Redis;
use Swoole\Coroutine\Scheduler;
use Swoole\Timer as SwooleTimer;

class EasySwooleEvent implements Event
{

    public static function initialize()
    {
        // TODO: Implement initialize() method.
        date_default_timezone_set('Asia/Shanghai');
        //注册redis
        $config = new RedisConfig(GlobalConfig::getInstance()->getConf('REDIS'));
        Redis::getInstance()->register('waf',$config);
        $scheduler = new Scheduler();
        $scheduler->add(function ()use($config) {
            Redis::invoke('waf',function ($client){
                $client->fuck();
                $client->set('a','h');
            });
            Redis::defer('waf');
            Redis::getInstance()->get('waf')->reset();
        });
        $scheduler->start();
        SwooleTimer::clearAll();
    }


    public static function mainServerCreate(EventRegister $register)
    {
      
    }

    public static function onRequest(Request $request, Response $response): bool
    {
       
    }

    public static function afterRequest(Request $request, Response $response): void
    {
        // TODO: Implement afterAction() method.
    }
}
```