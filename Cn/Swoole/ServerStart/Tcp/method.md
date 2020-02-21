## server方法列表
对象命名空间: `Swoole\Server`

### __construct
方法原型:__construct($host, $port = null, $mode = null, $sockType = null)  
#### 参数介绍
- $host 指定监听的ip地址  
::: warning
ipv4中,`127.0.0.1`表示监听本机地址,`0.0.0.0`表示监听所有地址.  
ipv6中,`::1`表示监听本机地址,`::` 表示监听所有地址
:::
- $port 指定监听的端口
::: warning
如果$sockType 值为 UnixSocket Stream/Dgram,可忽略该参数  
端口小于1024需要root权限才可创建
$port 为0将随机分配一个端口,在new server的时候并不建议使用,你将会不知道它监听的是哪个端口
:::
- $mode 指定运行模式,默认为`SWOOLE_PROCESS`多进程模式
::: warning
建议使用SWOOLE_PROCESS模式(多进程分配模式)
还可以选择SWOOLE_BASE模式(多进程抢占模式)
:::

- $sockType 指定socket类型,例如:SWOOLE_SOCK_TCP
::: warning
可选参数:  
SWOOLE_TCP/SWOOLE_SOCK_TCP tcp ipv4 socket
SWOOLE_TCP6/SWOOLE_SOCK_TCP6 tcp ipv6 socket
SWOOLE_UDP/SWOOLE_SOCK_UDP udp ipv4 socket
SWOOLE_UDP6/SWOOLE_SOCK_UDP6 udp ipv6 socket
SWOOLE_UNIX_DGRAM unix socket dgram
SWOOLE_UNIX_STREAM unix socket stream
:::

::: warning
配置 $sockType|SWOOLE_SSL 可开启ssl加密,实现https访问,但是需要配置`ssl_key_file`和`ssl_cert_file`
:::


#### 示例
```php
<?php
//创建Server对象,监听 127.0.0.1:9501端口
$server = new Swoole\Server("127.0.0.1", 0,SWOOLE_PROCESS,SWOOLE_SOCK_TCP);

//监听连接进入事件
$server->on('Connect', function ($server, $fd) {
    echo "客户端 {$fd} 连接成功\n";
});

//监听数据接收事件
$server->on('Receive', function ($server, $fd, $from_id, $data) {
    echo "客户端 {$fd} 发来消息:{$data} \n";

    /**
     * @var $server \Swoole\Server
     */
    $server->send($fd, "服务器响应: ".$data);
});

//监听连接关闭事件
$server->on('Close', function ($server, $fd) {
    echo "客户端 {$fd} 关闭\n";
});
echo "服务器启动成功\n";
//启动服务器
$server->start(); 
```

### listen
新增一个监听端口,swoole服务允许监听多个端口用于不同的服务,例如,你可以监听9501成为http服务,可以新增9502作为websocket服务,再新增一个9503作为tcp服务.      
方法原型:listen($host, $port, $sockType)  
#### 参数介绍
- $host,同上
- $port,同上
- $sockType,同上

#### 示例
```php
<?php

//创建Server对象,监听 127.0.0.1:9501端口
$server = new Swoole\Server("127.0.0.1", 9501,SWOOLE_PROCESS,SWOOLE_SOCK_TCP);

/**
 * @var $port1  \Swoole\Server\Port
 * @var $port2  \Swoole\Server\Port
 * @var $port3  \Swoole\Server\Port
 */
$port1 = $server->listen("0.0.0.0", 9502, SWOOLE_SOCK_TCP); // 添加 TCP
$port2 = $server->listen("127.0.0.1", 9503, SWOOLE_SOCK_TCP); // 添加 Web Socket
$port3 = $server->listen("0.0.0.0", 9504, SWOOLE_SOCK_UDP); // UDP
//给port1监听的端口单独配置参数
$port1->set([
    'open_length_check' => true,
    'package_length_type' => 'N',
]);
//给port2监听的端口单独配置回调参数
$port2->on('Connect',function ($server,$fd){
    echo "9503 客户端 {$fd} 连接成功\n";
});

//给port3 监听的端口单独配置Packet回调函数
$port3->on('Packet',function ($server,$data,$address){
    echo "udp接收响应数据,地址:{$address},数据:{$data}";
});

//监听连接进入事件
$server->on('Connect', function ($server, $fd) {
    echo "客户端 {$fd} 连接成功\n";
});

//监听数据接收事件
$server->on('Receive', function ($server, $fd, $from_id, $data) {
    echo "客户端 {$fd} 发来消息:{$data} \n";

    /**
     * @var $server \Swoole\Server
     */
    $server->send($fd, "服务器响应: ".$data);
});

//监听连接关闭事件
$server->on('Close', function ($server, $fd) {
    echo "客户端 {$fd} 关闭\n";
});
echo "服务器启动成功\n";
//启动服务器
$server->start(); 
```

### addlistener
listen 的别名方法

### on
注册 server的回调函数
方法原型:on($eventName, callable $callback)  
#### 参数介绍
- $eventName 回调函数名称,忽略大小写
- $callback 回调函数,参数根据回调函数的不同而不同
::: warning
具体的回调函数名称和传参,可查看[事件](/Cn/Swoole/ServerStart/Tcp/events.md) 
::: 

#### 示例
```php
<?php

//创建Server对象,监听 127.0.0.1:9501端口
$server = new Swoole\Server("127.0.0.1", 9501);

//监听连接进入事件,当客户端连接成功时,会分配一个fd(自增id),然后会调用这个回调函数
$server->on('Connect', function ($server, $fd) {
    echo "客户端 {$fd} 连接成功\n";
});

//监听数据接收事件,当客户端发送数据到服务器时,会调用这个回调函数
$server->on('Receive', function ($server, $fd, $from_id, $data) {
    echo "客户端 {$fd} 发来消息:{$data} \n";

    /**
     * @var $server \Swoole\Server
     */
    $server->send($fd, "服务器响应: ".$data);
});

//监听连接关闭事件,当客户端关闭连接时,会调用这个回调函数
$server->on('Close', function ($server, $fd) {
    echo "客户端 {$fd} 关闭\n";
});

echo "服务器启动成功\n";

//启动服务器
$server->start(); 
```

### getCallback
获取当前注册的回调函数闭包对象
方法原型:getCallback($eventName)  
#### 参数介绍
- $eventName 回调函数名
#### 示例
```php
<?php
//创建Server对象,监听 127.0.0.1:9501端口
$server = new Swoole\Server("127.0.0.1", 9501,SWOOLE_PROCESS,SWOOLE_SOCK_TCP);

//监听连接关闭事件
$server->on('Close', function ($server, $fd) {
    echo "客户端 {$fd} 关闭\n";
});
var_dump($server->getCallback('Close'));

//输出
//object(Closure)#5 (1) {
//  ["parameter"]=>
//  array(2) {
//    ["$server"]=>
//    string(10) "<required>"
//    ["$fd"]=>
//    string(10) "<required>"
//  }
//}
```

### set
方法原型:set(array $settings)  
#### 参数介绍
参数介绍
#### 示例
```php

```

### start
方法原型:start()  
#### 参数介绍
参数介绍
#### 示例
```php

```

### send
方法原型:send($fd, $send_data, $server_socket = null)  
#### 参数介绍
参数介绍
#### 示例
```php

```

### sendto
方法原型:sendto($ip, $port, $send_data, $server_socket = null)  
#### 参数介绍
参数介绍
#### 示例
```php

```

### sendwait
方法原型:sendwait($conn_fd, $send_data)  
#### 参数介绍
参数介绍
#### 示例
```php

```

### exists
方法原型:exists($fd)  
#### 参数介绍
参数介绍
#### 示例
```php

```

### exist
方法原型:exist($fd)  
#### 参数介绍
参数介绍
#### 示例
```php

```

### protect
方法原型:protect($fd, $is_protected = null)  
#### 参数介绍
参数介绍
#### 示例
```php

```

### sendfile
方法原型:sendfile($conn_fd, $filename, $offset = null, $length = null)  
#### 参数介绍
参数介绍
#### 示例
```php

```

### close
方法原型:close($fd, $reset = null)  
#### 参数介绍
参数介绍
#### 示例
```php

```

### confirm
方法原型:confirm($fd)  
#### 参数介绍
参数介绍
#### 示例
```php

```

### pause
方法原型:pause($fd)  
#### 参数介绍
参数介绍
#### 示例
```php

```

### resume
方法原型:resume($fd)  
#### 参数介绍
参数介绍
#### 示例
```php

```

### task
方法原型:task($data, $worker_id = null, ?callable $finish_callback = null)  
#### 参数介绍
参数介绍
#### 示例
```php

```

### taskwait
方法原型:taskwait($data, $timeout = null, $worker_id = null)  
#### 参数介绍
参数介绍
#### 示例
```php

```

### taskWaitMulti
方法原型:taskWaitMulti(array $tasks, $timeout = null)  
#### 参数介绍
参数介绍
#### 示例
```php

```

### taskCo
方法原型:taskCo(array $tasks, $timeout = null)  
#### 参数介绍
参数介绍
#### 示例
```php

```

### finish
方法原型:finish($data)  
#### 参数介绍
参数介绍
#### 示例
```php

```

### reload
方法原型:reload()  
#### 参数介绍
参数介绍
#### 示例
```php

```

### shutdown
方法原型:shutdown()  
#### 参数介绍
参数介绍
#### 示例
```php

```

### stop
方法原型:stop($worker_id = null)  
#### 参数介绍
参数介绍
#### 示例
```php

```

### getLastError
方法原型:getLastError()  
#### 参数介绍
参数介绍
#### 示例
```php

```

### heartbeat
方法原型:heartbeat($reactor_id)  
#### 参数介绍
参数介绍
#### 示例
```php

```

### getClientInfo
方法原型:getClientInfo($fd, $reactor_id = null)  
#### 参数介绍
参数介绍
#### 示例
```php

```

### getClientList
方法原型:getClientList($start_fd, $find_count = null)  
#### 参数介绍
参数介绍
#### 示例
```php

```

### connection_info
方法原型:connection_info($fd, $reactor_id = null)  
#### 参数介绍
参数介绍
#### 示例
```php

```

### connection_list
方法原型:connection_list($start_fd, $find_count = null)  
#### 参数介绍
参数介绍
#### 示例
```php

```

### sendMessage
方法原型:sendMessage($message, $dst_worker_id)  
#### 参数介绍
参数介绍
#### 示例
```php

```

### addProcess
方法原型:addProcess(\swoole_process $process)  
#### 参数介绍
参数介绍
#### 示例
```php

```

### stats
方法原型:stats()  
#### 参数介绍
参数介绍
#### 示例
```php

```

### getSocket
方法原型:getSocket($port = null)  
#### 参数介绍
参数介绍
#### 示例
```php

```

### bind
方法原型:bind($fd, $uid)  
#### 参数介绍
参数介绍
#### 示例
```php

```

