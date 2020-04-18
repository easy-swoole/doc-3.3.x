<?php


namespace App\HttpController;


use EasySwoole\DocSystem\DocLib\Config;
use EasySwoole\DocSystem\HttpController\DocIndexController;


class Index extends DocIndexController
{
    protected function config(): Config
    {
        $config = new Config();
        $config->setRoot(EASYSWOOLE_ROOT);
        $config->setAllowLanguages(\EasySwoole\EasySwoole\Config::getInstance()->getConf('DOC.ALLOW_LANGUAGE'));
        $config->setDefaultLanguage(\EasySwoole\EasySwoole\Config::getInstance()->getConf('DOC.DEFAULT_LANGUAGE'));
        $config->setTempDir(EASYSWOOLE_TEMP_DIR);
        return $config;
    }
}
