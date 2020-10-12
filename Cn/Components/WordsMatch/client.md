---
title: easyswoole 内容检测
meta:
  - name: description
    content: easyswoole 内容检测
  - name: keywords
    content: swoole|easyswoole|内容检测|敏感词|检测
---

## 支持的方法

#### setWordBanks

指定词库
````php
public function setWordBanks(array $wordBanks)
````

#### detect

检测内容，不指定词库则检测所有词库
````php
public function detect(string $content, float $timeout = 3.0) : array
````

#### append

添加词，第一个参数：词，第二个参数：词的其它信息，必须指定词库
````php
public function append(string $word, array $otherInfo=[], float $timeout = 3.0)
````

#### remove

移除词，必须指定词库

````php
public function remove(string $word, float $timeout = 3.0)
````
