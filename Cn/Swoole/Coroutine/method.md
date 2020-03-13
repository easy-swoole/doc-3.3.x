## 协程方法
`\Swoole\Coroutine`类方法列表.   
::: warning
在开启短别名时,`\Swoole\Coroutine`可简写为`\co`;  
:::
### set()
协程设置,可配置一些协程下的参数.   
方法原型:\Swoole\Coroutine::set(array $options);
参数说明:  
- $options 配置的参数数组
::: warning
可配置的参数列表:  
- max_coroutine	 单进程最大协程创建数,超过限制将无法新建新的协程
- stack_size	 设置单个协程栈的内存大小,默认`2M` 
- log_level	     协程日志等级
- trace_flags	 日志跟踪标签
- socket_connect_timeout	协程连接建立超时时间
- socket_timeout	协程连接收发数据超时时间
- socket_read_timeout	协程连接读取超时时间
- socket_write_timeout	协程连接写入超时时间
- dns_cache_expire	dns缓存失效时间,默认60秒
- dns_cache_capacity	dns缓存容量,默认1000
- hook_flags	一键协程化的hook值
- enable_preemptive_scheduler	 是否打开抢占式协程调度(开启后会自动切换协程)
- dns_server	设置dns服务器 默认8.8.8.8

:::
### create()  
创建一个新的协程,并立即执行协程内的函数.     
方法原型:   
- \Swoole\Coroutine::create(callable $function, ...$args) : int|false;  
- go(callable $function, ...$args) : int|false;  //短别名函数写法
参数说明:  
- $function  可执行的回调函数,例如闭包,类方法.  
- ...$args   传入回调函数的参数,可多个.  
::: warning 
创建失败将返回false,成功则返回协程id,通过此id,可以对这个协程做出相应的操作.   
协程函数如同函数一样,里面的变量需要占用内存,在协程退出后回收.   
:::
### defer()  
注册一个回调函数,当协程执行完毕之前将调用此回调,并且就算协程发生了异常,也会调用此函数.   
方法原型:   
- \Swoole\Coroutine::defer(callable $function);  
- defer(callable $function); //短别名函数写法
参数说明:  
- $function 需要调用的回调函数.  
```php
<?php
go(function () {
    $a = 1;
    echo "协程开始\n";
    defer(function () use ($a) {
        echo $a;//可以调用协程内的变量
        echo "defer结束\n";
    });
    echo "协程结束\n";
});

//输出
//协程开始
//协程结束
//1defer结束
```
### exists()  
判断指定协程是否存在.  
方法原型:\Swoole\Coroutine::exists(int $cid = 0): bool
参数说明:  
- $cid 协程id,在创建协程时会返回该id   
```php
<?php
$cid = go(function () {
    echo "协程开始\n";
    \co::sleep(0.1);
    echo "协程结束\n";
});

var_dump(co::exists($cid));
```
### getCid()  
获取当前协程内的id,在同一个进程中唯一.  
方法原型:  
- \Swoole\Coroutine::getCid(): int
- \Swoole\Coroutine::getUid(): int  //别名
参数说明:
::: warning
:::
### getPcid()  
获取创建指定子协程的上级协程id.    
方法原型:\Swoole\Coroutine::getPcid([$cid]): int  
参数说明:  
- $cid  协程id,如果不填,这默认当前协程.  
::: warning
- 如果没有父协程,将返回-1.  
- 如果不填cid,当前又不是协程环境,则返回false.
- 父子协程并没有什么实质上的关系,协程内参数都是互相隔离的,只是一个id标识而已.    

:::
### getContext()  
获取协程的上下文数据.    
方法原型:\Swoole\Coroutine::getContext([$cid]): Swoole\Coroutine\Context  
参数说明:  
- $cid 协程id,默认为当前协程.  
::: warning
由于协程环境下是串行的,不能直接使用全局变量,但为了在协程内共享一些全局变量,swoole提供了`getContext()`用于存储当前协程的上下文数据.    
```php
<?php
$server = new Swoole\Http\Server("0.0.0.0", 9501);

//当浏览器发送http请求时,将会到这里回调
$server->on('Request', function (\Swoole\Http\Request $request, \Swoole\Http\Response $response) {
    //将get数据存入上下文
    $context = co::getContext();
    $context['get'] = $request->get;//将get变量存储到context中
    test();
    $response->end('test');
});
$server->start();

//这个方法将模拟获取get数据进行处理
function test(){
    $cid = co::getCid();
    $data = co::getContext($cid);//直接获取到context数据
    var_dump($data['get']);
}
```

:::
### yield() 
挂起当前的协程     
方法原型:\Swoole\Coroutine::yield();     

::: warning
调用此方法后,该协程将会挂起,去执行其他的协程,但是必须需要在其他地方调用`resume`方法恢复,否则该协程将会一直挂起,造成协程内存泄漏.      
此方法必须和`resume`成对使用.  
:::
### resume()
当协程因为`yield`方法挂起时,可通过此方法恢复.  
方法原型:\Swoole\Coroutine::resume(int $cid);    
参数说明:  
- $cid 协程id
::: warning
当调用`yield`挂起协程时,在后面的操作中必须存在调用`resume`恢复协程的方法,否则会造成协程内存泄漏.  
```php



```

:::
### list()
方法原型:
参数说明:
::: warning
:::
### stats()
方法原型:
参数说明:
::: warning
:::
### getBackTrace()
方法原型:
参数说明:
::: warning
:::