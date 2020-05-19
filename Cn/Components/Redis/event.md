## 回调事件
在`redis`组件中,自定义了2个回调事件,用于代码跟踪调试,可在config中设置:
```php
<?php
$redisConfig = new RedisConfig([
    'host' => REDIS_HOST,
    'port' => REDIS_PORT,
    'auth' => REDIS_AUTH,
]);
// 命令执行之前将调用
$redisConfig->onBeforeEvent(function ($commandName,$commandData){
    var_dump ($commandName,$commandData);
});
//命令获取到结果后将调用
$redisConfig->onAfterEvent(function ($commandName,$commandData,$result){
    var_dump ($commandName,$commandData,$result);
});
```

::: warning
回调事件支持事务,pipe.   
在pipe模式中,只有最后excePipe时才会调用回调事件.
:::
