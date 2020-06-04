---
title: easyswoole基础命令
meta:
  - name: description
    content: easyswoole基础命令
  - name: keywords
    content: easyswoole基础命令|easyswoole|swoole
---

## 基础命令 
easyswoole 自带了一系列的命令,如下:
- install       安装easySwoole
- start         启动easySwoole
- stop          停止easySwoole(守护模式下使用)
- reload        热重启easySwoole(守护模式下使用)
- restart       重启easySwoole(守护模式下使用)
- help          查看命令的帮助信息
- phpunit       启动协程单元测试
- config        easyswoole配置管理
- process       easyswoole 自定义进程/task进程管理
- status        easyswole 服务运行状态
- task          easyswoole task进程状态
- crontab       easyswoole crontab管理

### install   
`easyswoole` 安装命令,该命令会自动创建`App/HttpController/Index.php`文件,并会自动执行`composer dump-autoload `(如果禁用了exec函数则会执行失败,需要手动执行)
### start        
启动`easyswoole`服务
```bash
php easyswoole start d  守护进程启动
php easyswoole start d produce  生产环境,守护进程启动,生产环境将引入produce.php配置文件, 
```
### stop          
停止`easyswoole`服务  
此命令将获取/Temp/pid.pid文件的pid,用于关闭`easyswole进程`,当文件过期/被删除/已失效时,无法通过此命令停止服务.  
```bash
php easyswoole stop #停止`easyswoole`服务(正在运行的任务会等待运行结束再停止)
php easyswoole stop force  #强制停止`easyswoole`服务(直接杀死进程)
php easyswoole stop produce 停止生产环境`easyswoole`服务  
```

### reload        
热重启`easyswoole`服务.  
::: warning
 注意，守护模式下才需要reload，不然control+c或者是终端断开就退出进程了，此处为热重启，可以用于更新worker start后才加载的文件（业务逻辑），主进程（如配置文件）不会被重启。 http 自定义路由配置不会被更新,需要restart;
:::
### restart 
强制重启`easyswoole`服务.     
该命令为`php easyswoole stop force`+ `php easyswoole start d `组合  
### help       
帮助命令.  
```bash
php easyswoole help stop  查看stop命令帮助
```   
### phpunit       
启动`easyswoole`的单元测试,将带上协程环境:
```bash
php easyswoole phpunit ./Tests
```
### config        
动态管理config命令.   
```bash
php easyswoole config show [key]  查看配置项信息,key支持.分隔符
php easyswoole config set key value 动态设置一个配置,key支持.分隔符
```
### process    
查看/管理 自定义进程(包括task进程)   
```bash
php easyswoole process kill PID [-p] [-d]  -p代表通过进程id杀死进程并重启  
php easyswoole process kill PID [-f] [-p] [-d] -f代表强制杀死进程并重启
php easyswoole process kill GroupName [-f] [-d]  不带-p,代表杀死一个进程组并重启
php easyswoole process killAll [-d] 杀死全部进程并重启
php easyswoole process killAll -f [-d] 强制杀死全部进程并重启
php easyswoole process show 显示当前进程列表
php easyswoole process show -d -d代表个性化显示内存信息
```
### status        
查看服务运行状态 
```bash
[root@localhost easyswoole-git]# php easyswoole status
start_time                    2020-04-04 11:08:39
connection_num                0
accept_count                  0
close_count                   0
worker_num                    8
idle_worker_num               8
tasking_num                   0
request_count                 0
worker_request_count          0
worker_dispatch_count         0
coroutine_num                 2
```
### task          
查看task进程状态  
```bash
[root@localhost easyswoole-git]# php easyswoole task status
#┌─────────┬─────────┬──────┬───────┬─────────────┐
#│ running │ success │ fail │  pid  │ workerIndex │
#├─────────┼─────────┼──────┼───────┼─────────────┤
#│ 0       │ 4       │ 0    │ 28241 │ 0           │
#│ 0       │ 3       │ 0    │ 28242 │ 1           │
#│ 0       │ 3       │ 0    │ 28243 │ 2           │
#│ 0       │ 2       │ 0    │ 28244 │ 3           │
#└─────────┴─────────┴──────┴───────┴─────────────┘

```
### crontab       
```bash
php easyswoole crontab show  查看当前定时任务列表
php easyswoole crontab stop taskName 暂停一个定时任务
php easyswoole crontab resume taskName  继续运行一个定时任务
php easyswoole crontab run taskName  立即执行一次定时任务


```
