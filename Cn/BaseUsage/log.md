---
title: easyswoole日志处理
meta:
  - name: description
    content: easyswoole日志处理
  - name: keywords
    content: easyswoole日志处理|easyswoole logger
---


# logger使用
```php
use use EasySwoole\EasySwoole\Logger;
Logger::getInstance()->log('log level info',Logger::LOG_LEVEL_INFO,'DEBUG');//记录info级别日志//例子后面2个参数默认值
Logger::getInstance()->log('log level notice',Logger::LOG_LEVEL_NOTICE,'DEBUG2');//记录notice级别日志//例子后面2个参数默认值
Logger::getInstance()->console('console',Logger::LOG_LEVEL_INFO,'DEBUG');//记录info级别日志并输出到控制台
Logger::getInstance()->info('log level info');//记录info级别日志并输出到控制台
Logger::getInstance()->notice('log level notice');//记录notice级别日志并输出到控制台
Logger::getInstance()->waring('log level waring');//记录waring级别日志并输出到控制台
Logger::getInstance()->error('log level error');//记录error级别日志并输出到控制台
Logger::getInstance()->onLog()->set('myHook',function ($msg,$logLevel,$category){
    //增加日志写入之后的回调函数
});
```

::: warning 
 注意，在非框架中使用，例如是单元测试脚本，请执行 EasySwoole\EasySwoole\Core::getInstance()->initialize(); 用于初始化日志 
:::

::: warning 
在3.3.7版本后,initialize事件调用改为:`EasySwoole\EasySwoole\Core::getInstance()->initialize()->globalInitialize();`
:::

将输出/记录以下内容:
````
[2019-06-01 21:10:25][DEBUG][INFO] : [1]
[2019-06-01 21:10:25][DEBUG][INFO] : [2]
[2019-06-01 21:10:25][DEBUG][INFO] : [3]
[2019-06-01 21:10:25][DEBUG][NOTICE] : [4]
[2019-06-01 21:10:25][DEBUG][WARNING] : [5]
[2019-06-01 21:10:25][DEBUG][ERROR] : [6]
[2019-06-01 21:23:27][DEBUG][INFO] : [log level info]
[2019-06-01 21:23:27][DEBUG2][NOTICE] : [log level notice]
[2019-06-01 21:23:27][DEBUG][INFO] : [console]
[2019-06-01 21:23:27][DEBUG][INFO] : [log level info]
[2019-06-01 21:23:27][DEBUG][NOTICE] : [log level notice]
[2019-06-01 21:23:27][DEBUG][WARNING] : [log level waring]
[2019-06-01 21:23:27][DEBUG][ERROR] : [log level error]
````

::: warning 
 在新版logger处理方案中，新增了 `LOG_LEVEL_INFO = 1`，`LOG_LEVEL_NOTICE = 2`，`LOG_LEVEL_WARNING = 3`，`LOG_LEVEL_ERROR = 4`，4个日志等级，有助于更好的区分日志
:::

# 自定义处理器
easyswoole支持自定义处理器,只需要实现`EasySwoole\Log\LoggerInterface` 接口即可:
```php
<?php
/**
 * Created by PhpStorm.
 * User: tioncico
 * Date: 20-4-20
 * Time: 下午8:57
 */

namespace App\Log;


use EasySwoole\Log\LoggerInterface;

class LogHandel implements LoggerInterface
{

    private $logDir;

    function __construct(string $logDir = null)
    {
        if(empty($logDir)){
            $logDir = getcwd();
        }
        $this->logDir = $logDir;
    }

    function log(?string $msg,int $logLevel = self::LOG_LEVEL_INFO,string $category = 'debug'):string
    {
        $date = date('Y-m-d H:i:s');
        $levelStr = $this->levelMap($logLevel);
        $filePath = $this->logDir."/log_{$category}.log";
        $str = "自定义日志:[{$date}][{$category}][{$levelStr}] : [{$msg}]\n";
        file_put_contents($filePath,"{$str}",FILE_APPEND|LOCK_EX);
        return $str;
    }

    function console(?string $msg,int $logLevel = self::LOG_LEVEL_INFO,string $category = 'console')
    {
        $date = date('Y-m-d H:i:s');
        $levelStr = $this->levelMap($logLevel);
        $temp = "自定义日志:[{$date}][{$category}][{$levelStr}]:[{$msg}]\n";
        fwrite(STDOUT,$temp);
    }

    private function levelMap(int $level)
    {
        switch ($level)
        {
            case self::LOG_LEVEL_INFO:
                return 'info';
            case self::LOG_LEVEL_NOTICE:
                return 'notice';
            case self::LOG_LEVEL_WARNING:
                return 'warning';
            case self::LOG_LEVEL_ERROR:
                return 'error';
            default:
                return 'unknown';
        }
    }
}
```
在 `bootstrap.php` bootstrap事件中注入自定义logger处理器:

```php
\EasySwoole\EasySwoole\Logger::getInstance(new \App\Log\LogHandel());
```
> 具体可以看Easyswoole\Easyswoole\Core.php文件的实现

##日志中心

比如，会有想把数据往日志中心推送，或者是最TCP日志推送，那么，可以新增onLog回调，然后把日志信息，推送到日志中心。
