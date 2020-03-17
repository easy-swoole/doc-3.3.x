---
title: easyswoole php源码加密原理
meta:
  - name: description
    content: easyswoole php源码加密原理
  - name: keywords
    content: php源码加密|swoole源码加密|easyswoole源码加密
---
# 使用
## 安装拓展
- 克隆仓库 https://github.com/easy-swoole/compiler
- phpize
- ./configure
- make install
- php.ini加入```extension=easy_compiler.so```

> 注意swoole4.x的library hook也用到了此技术，请在swoole.so后引入easy_compiler.so。另外，swooole加密器也可能用到了该方式，因此可能会有冲突

## composer助手脚本
```
composer require easyswoole/compiler=dev-master
```
对任意文件加密
```
 php vendor/bin/easy_compiler App/HttpController/Index.php 
```

> 会自动替换文件，并生成App/HttpController/Index.php.bak


## 效果如下
![](/Images/Other/CodeEncrypt/encrypt.png)