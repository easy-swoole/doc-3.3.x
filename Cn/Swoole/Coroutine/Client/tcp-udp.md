## tcp/udp协程客户端
命名空间:`\Swoole\Coroutine\Client`,`\Co\Client`.  
`\Swoole\Coroutine\Client` 提供了`tcp/udp/unixSocket`协议的客户端封装.    
```php
<?php
go(function(){
    $client = new Swoole\Coroutine\Client(SWOOLE_SOCK_TCP);
    if (!$client->connect('127.0.0.1', 9501, 0.5))
    {
        echo "连接失败: {$client->errCode}\n";
    }
    $client->send("easyswoole\n");
    while(1){
        echo $client->recv();
    }
    $client->close();
});
```
::: warning

:::