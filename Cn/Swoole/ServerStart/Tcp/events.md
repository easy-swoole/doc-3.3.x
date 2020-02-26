## 回调事件   
回调事件是swoole开启异步服务后,通过注册回调事件的函数,来进行处理相应的逻辑.  
### onStart
调用原型:onStart(Swoole\Server $server)  
事件说明:服务开启后的回调,在 `Master` 进程的主线程中被调用.(SWOOLE_BASE模式不存在该回调)  
参数说明:  
- $server Swoole\Server 对象  

事件调用前执行的操作:  
- `manager` 进程创建完成
- `worker` 子进程创建完成
- 监听所有设置监听的`TCP/UDP/unixSocket` 端口,但还未开始 `Accept` 连接和请求
- 监听了定时器  

事件调用后执行的操作:  
- 这个时候客户端已经可以连接服务了,`Reactor`线程开始接收事件.

::: warning
在此回调中,不能调用 `server` 相关函数等操作,因为服务还未就绪.  
因为`onWorkerStart` 和 `onStart` 回调事件是在不同进程中并行执行的,所以不存在先后顺序.   
`worker进程`和`onStart`是同时调用的,所以`onStart`的创建的全局变量,不能在`worker进程`使用
:::
### onShutdown
调用原型:onShutdown(Swoole\Server $server)  
事件说明:`server`正常终止时将调用该回调  
参数说明:  
- $server Swoole\Server 对象  

事件调用前执行的操作:   
- 关闭了所有 `Reactor` 线程,`HeartbeatCheck(心跳检测)` 线程,`UdpRecv(udp接收)` 线程
- 关闭了所有 `Worker 进程`, `Task 进程`,`自定义进程`
- 关闭了所有 `TCP/UDP/UnixSocket`监听端口
- 关闭了主 `Reactor` 线程
事件调用后执行的操作:  
没了,程序已经结束了  
::: warning
`onShutdown`无法调用协程或者异步.    
:::
  
### onWorkerStart
调用原型:onWorkerStart(Swoole\Server  $server, int $workerId)
事件说明:当`worker进程/task worker进程`启动时,将调用该回调    
参数说明:  
- $server  Swoole\Server对象
- $workerId 进程启动的id标识(从0开始).  

事件调用前执行的操作:  
无,start的时候,进程就创建好了
事件调用后执行的操作:   
等待`Reactor`线程接收数据,交给进程处理.
::: warning
可以通过 `$server->taskworker` 属性来判断此进程是 `Worker进程`还是 `Task 进程`   
该事件会根据`worker_num+task_worker_num` 触发多次,但$workerId不一样  


:::
### onWorkerStop
调用原型:onWorkerStop()  
事件说明:  
参数说明:  


事件调用前执行的操作:  
事件调用后执行的操作:  

::: warning

:::
### onWorkerExit
调用原型:onWorkerExit()  
事件说明:  
参数说明:  


事件调用前执行的操作:  
事件调用后执行的操作:  

::: warning

:::
### onConnect
调用原型:onConnect()  
事件说明:  
参数说明:  


事件调用前执行的操作:  
事件调用后执行的操作:  

::: warning

:::
### onReceive
调用原型:onReceive()  
事件说明:  
参数说明:  


事件调用前执行的操作:  
事件调用后执行的操作:  

::: warning

:::
### onPacket
调用原型:onPacket()  
事件说明:  
参数说明:  


事件调用前执行的操作:  
事件调用后执行的操作:  

::: warning

:::
### onClose
调用原型:onClose()  
事件说明:  
参数说明:  


事件调用前执行的操作:  
事件调用后执行的操作:  

::: warning

:::
### onTask
调用原型:onTask()  
事件说明:  
参数说明:  


事件调用前执行的操作:  
事件调用后执行的操作:  

::: warning

:::
### onFinish
调用原型:onFinish()  
事件说明:  
参数说明:  


事件调用前执行的操作:  
事件调用后执行的操作:  

::: warning

:::
### onPipeMessage
调用原型:onPipeMessage()  
事件说明:  
参数说明:  


事件调用前执行的操作:  
事件调用后执行的操作:  

::: warning

:::
### onWorkerError
调用原型:onWorkerError()  
事件说明:  
参数说明:  


事件调用前执行的操作:  
事件调用后执行的操作:  

::: warning

:::
### onManagerStart
调用原型:onManagerStart()  
事件说明:  
参数说明:  


事件调用前执行的操作:  
事件调用后执行的操作:  

::: warning

:::
### onManagerStop
调用原型:onManagerStop()  
事件说明:  
参数说明:  


事件调用前执行的操作:  
事件调用后执行的操作:  

::: warning

:::
### 事件执行顺序
调用原型:事件执行顺序()  
事件说明:  
参数说明:  


事件调用前执行的操作:  
事件调用后执行的操作:  

::: warning

:::