<?php


namespace App\HttpController;


use EasySwoole\DocSystem\DocLib\Config;
use EasySwoole\DocSystem\DocLib\Render;
use EasySwoole\DocSystem\HttpController\DocIndexController;

class Index extends DocIndexController
{
    protected function render(): Render
    {
        $config = new Config();
        $config->setDocRoot(EASYSWOOLE_ROOT."/".$this->getLanguage());
        $config->setAllowLanguages(\EasySwoole\EasySwoole\Config::getInstance()->getConf('DOC.ALLOW_LANGUAGE'));
        $config->setTempDir(EASYSWOOLE_TEMP_DIR);
        $config->setLanguage($this->getLanguage());
        return new Render($config);
    }

    protected function getLanguage(): string
    {
        $lang = $this->request()->getCookieParams('language');
        $allow = \EasySwoole\EasySwoole\Config::getInstance()->getConf('DOC.ALLOW_LANGUAGE');
        if(isset($allow[$lang])){
            return $lang;
        }
        return \EasySwoole\EasySwoole\Config::getInstance()->getConf('DOC.DEFAULT_LANGUAGE');
    }

}