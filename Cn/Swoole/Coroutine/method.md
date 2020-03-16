## 协程方法
`\Swoole\Coroutine`类方法列表.  
### set()
协程设置,可配置一些协程下的参数.   
方法原型:set(array $options);
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
方法原型:
参数说明:
::: warning
:::
### defer()
方法原型:
参数说明:
::: warning
:::
### exists()
方法原型:
参数说明:
::: warning
:::
### getCid()
方法原型:
参数说明:
::: warning
:::
### getPcid()
方法原型:
参数说明:
::: warning
:::
### getContext()
方法原型:
参数说明:
::: warning
:::
### yield()
方法原型:
参数说明:
::: warning
:::
### resume()
方法原型:
参数说明:
::: warning
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