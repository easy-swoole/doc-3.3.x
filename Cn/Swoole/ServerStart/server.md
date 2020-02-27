## 异步服务器(Server)
通过`Swoole\Server`对象,可快速,方便的创建一个网络服务器,支持 `TCP/UDP/unixSocket` 3 种 `socket` 类型,支持 `IPv4/IPv6`,`SSL/TLS 单向双向证书的隧道加密`,由于是异步服务器,创建好之后,需要配置异步回调事件.  

::: warning
只有`server`风格是异步的,在回调函数里,默认开启了`enable_coroutine`,在回调中,为同步写法. 
:::

## Server进程组解析
### swoole Server运行流程图
[!Server运行流程图](/Images/Swoole/Server/serverFlow.jpg)

### swoole Server 进程/线程关系图
[!Server 进程/线程关系图](/Images/Swoole/Server/serverProcess.jpg)


