# socket客户端

## 介绍
`Swoole\Coroutine\Socket`可以实现更细粒度的`io`操作。   
可用`Co\Socket`短命名来简化类名。  
`Swoole\Coroutine\Socket`提供的`io`操作是同步编程风格，底层自动使用协程调度器来实现异步`io`。

## 属性

### fd
socket对应的文件描述符。

### errCode
返回的错误码

## 方法

### __controller
作用：构建`Co\Socket`对象。     
方法原型：__construct(int $domain, int $type, int $protocol);
参数说明：
- $domain 协议域（`AF_INET`、`AF_UNIX`、`AF_INET6`）   
- $type 类型（`SOCK_STREAM`,`SOCK_RAW`,`SOCK_DGRAM`）   
- $protocol 协议（`IPPROTO_TCP`、`IPPROTO_UDP`、`IPPROTO_STCP`、`IPPROTO_TIPC`，`0`）   

### setOption
作用：设置配置     
方法原型：setOption(int $level, int $optName, mixed $optVal): bool;  
参数说明：
- $level 指定协议级别
- $optName 套接字选项，参考[socket_get_option()](https://www.php.net/manual/zh/function.socket-get-option.php)
- $optVal 选项的值 根据 `level` 和 `optname` 决定


### getOption
作用：获取配置。    
方法原型：getOption(int $level, int $optName): mixed;    
参数说明：
- $level 指定协议级别
- $optName 套接字选项，参考[socket_get_option()](https://www.php.net/manual/zh/function.socket-get-option.php)


### setProtocol
作用：让`socket`有协议处理能力
方法原型：setProtocol(array $settings): bool;
参数说明：
- $settings [配置选项](/Cn/Swoole/ServerStart/Tcp/serverSetting.html)

### bind

### listen

### accept

### connect

### checkLiveness

### send

### sendAll

### peek

### recv

### recvAll

### recvPacket

### sendto

### recvfrom

### getsockname

### getpeername

### close

### 简单示例代码
```php

```