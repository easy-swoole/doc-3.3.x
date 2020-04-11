## Bridge
在 `3.3.5版本` 后,EasySwoole新增了`Bridge`模块,`Bridge`模块在`mainServerCreate`事件后启动,将创建一个自定义进程``,监听`socket`用于处理外部数据交互. 

### onStart
Bridge进程启动时,提供了onStart事件注册:
```php
public static function mainServerCreate(EventRegister $register)
{
    Bridge::getInstance()->setOnStart(function () {
        echo "进程id:" . getmypid();
    });
    // TODO: Implement mainServerCreate() method.
}
```
::: warning
此事件只能在`mainServerCreate`事件中注册.  
:::

### bridge数据交互
当你的`easyswoole`服务已经启动后,当你需要获取`easyswoole`内部的运行数据时,例如`自定义进程/task 信息`,`连接池信息`,已经创建过的`swoole Table ` 在外部是无法直接获取到的,我们可以通过bridge 进行`unixSock`数据交互,发送相应的命令并且实现交互接口,即可实现在外部获取`easyswole`内部运行数据.   
例如,easyswole Config配置,默认为swoole Table,我们可以实现通过外部命令,动态获取easyswoole服务的配置,以及动态配置:  

#### 实现config交互类
```php
<?php
/**
 * Created by PhpStorm.
 * User: Tioncico
 * Date: 2020/4/11 0011
 * Time: 10:35
 */

namespace App\Bridge;

use EasySwoole\EasySwoole\Bridge\BridgeCommand;
use EasySwoole\EasySwoole\Bridge\Package;
use EasySwoole\EasySwoole\Config as GlobalConfig;
use EasySwoole\EasySwoole\Core;

class Config
{
    /**
     * 注册命令回调,注意不能和BridgeCommand 默认的命令一致,否则会覆盖系统原有的回调
     * initCommand
     * @param BridgeCommand $command
     * @author Tioncico
     * Time: 10:36
     */
    static function initCommand(BridgeCommand $command)
    {
        $command->set(401, [Config::class, 'info']);
        $command->set(402, [Config::class, 'set']);
    }

    /**
     * 获取config配置信息
     * info
     * @param Package $package
     * @param Package $response
     * @return bool
     * @author Tioncico
     * Time: 10:39
     */
    static function info(Package $package,Package $response)
    {
        $data = $package->getArgs();
        if (empty($data['key'])){
            $configArray =GlobalConfig::getInstance()->toArray();
            $configArray['mode'] = Core::getInstance()->isDev() ? 'develop' : 'produce';
        }else{
            $configArray = GlobalConfig::getInstance()->getConf($data['key']);
            $configArray = [$data['key']=>$configArray];
        }
        $response->setArgs($configArray);
        return true;
    }

    /**
     * 设置config配置信息
     * set
     * @param Package $package
     * @param Package $response
     * @return bool
     * @author Tioncico
     * Time: 10:39
     */
    static function set(Package $package,Package $response){
        $data = $package->getArgs();
        if (empty($data['key'])){
            $response->setArgs( "config key can not be null");
            return false;
        }
        $key = $data['key'];
        $value = $data['value']??null;
        GlobalConfig::getInstance()->setConf($key,$value);
        $response->setArgs([$key=>$value]);
        return true;
    }
}
```
#### 注册交互类到Bridge中:
```php
public static function mainServerCreate(EventRegister $register)
{
    \App\Bridge\Config::initCommand(Bridge::getInstance()->onCommand());
    // TODO: Implement mainServerCreate() method.
}
```
::: warning
只能在`mainServerCreate`事件中注册.  
:::

#### 外部脚本交互
启动easyswoole之后,运行以下代码,即可在easyswoole服务中动态添加`a=>2`的配置项,并可通过`401`命令获取到当前配置

```php
<?php
/**
 * Created by PhpStorm.
 * User: Tioncico
 * Date: 2020/4/11 0011
 * Time: 10:53
 */

include "./vendor/autoload.php";
//初始化easyswoole框架服务
\EasySwoole\EasySwoole\Core::getInstance()->initialize();

//开启一个协程调度器
$run = new \Swoole\Coroutine\Scheduler();
$run->add(function (){
    $package = new \EasySwoole\EasySwoole\Bridge\Package();
    $package->setCommand(402);
    $package->setArgs(['key' => 'a','value'=>2]);
    $package = \EasySwoole\EasySwoole\Bridge\Bridge::getInstance()->send($package);
    var_dump($package);
    $package = new \EasySwoole\EasySwoole\Bridge\Package();
    $package->setCommand(401);
    $package->setArgs(['key' => 'a']);
    $package = \EasySwoole\EasySwoole\Bridge\Bridge::getInstance()->send($package);
    var_dump($package);
});
//执行协程调度器
$run->start();
```

::: warning 
此脚本可以放到自定义命令中,实现通过自定义命令和`easyswoole服务`交互,具体代码可查看源码: https://github.com/easy-swoole/easyswoole/blob/3.x/src/Command/DefaultCommand/Config.php
:::


