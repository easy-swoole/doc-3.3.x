<?php

\EasySwoole\EasySwoole\Command\CommandContainer::getInstance()->set(new \EasySwoole\DocSystem\DocLib\DocCommand(getcwd()));