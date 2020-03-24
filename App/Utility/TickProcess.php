<?php


namespace App\Utility;


use EasySwoole\Component\Process\AbstractProcess;
use EasySwoole\DocSystem\DocLib\DocSearchParser;
use EasySwoole\EasySwoole\Config;
use EasySwoole\EasySwoole\Trigger;
use Swoole\Coroutine;

class TickProcess extends AbstractProcess
{

    protected function run($arg)
    {
        go(function (){
            while (1){
                $list = Config::getInstance()->getConf("DOC.ALLOW_LANGUAGE");
                try{
                    foreach ($list as $dir => $value){
                        $json = DocSearchParser::parserDoc2JsonUrlMap(EASYSWOOLE_ROOT,"{$dir}");
                        file_put_contents(EASYSWOOLE_ROOT."/Static/keyword{$dir}.json",json_encode($json,JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES));
                    }
                }catch (\Throwable $throwable){
                    Trigger::getInstance()->throwable($throwable);
                }
                //本项目是git克隆下来的，因此自动同步
                $exec = "cd ".EASYSWOOLE_ROOT."; git pull";
                exec($exec);
                Coroutine::sleep(30);
            }
        });
    }
}
