<?php
namespace EasySwoole\EasySwoole;


use App\Utility\TickProcess;
use EasySwoole\EasySwoole\Swoole\EventRegister;
use EasySwoole\EasySwoole\AbstractInterface\Event;
use EasySwoole\Http\Request;
use EasySwoole\Http\Response;

class EasySwooleEvent implements Event
{

    public static function initialize()
    {
        // TODO: Implement initialize() method.
        date_default_timezone_set('Asia/Shanghai');
    }

    public static function mainServerCreate(EventRegister $register)
    {
        $process = new TickProcess('TickProcess');
        ServerManager::getInstance()->getSwooleServer()->addProcess($process->getProcess());
    }

    public static function onRequest(Request $request, Response $response): bool
    {
        $path = EASYSWOOLE_ROOT.'/Static'.$request->getUri()->getPath();
        if(is_file($path)){
            //兼容swoole低版本对未知文件的静态处理bug
            $response->sendFile($path);
            return false;
        }
        return true;
    }

    public static function afterRequest(Request $request, Response $response): void
    {
        // TODO: Implement afterAction() method.
    }
}