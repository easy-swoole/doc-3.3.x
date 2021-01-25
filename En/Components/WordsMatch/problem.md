---
title: easyswoole Content detection
meta:
  - name: description
    content: easyswoole Content detection
  - name: keywords
    content: swoole|easyswoole|Content detection|Sensitive words|detect
---

### What to do after the service stops?

> When the 1. X version service stops, it will drop all the running words to the file, and 2. X will remove this feature
  We are more inclined to let users handle these words themselves. For example: for example, all your words exist in dB. When you add or remove words online, you can update DB accordingly,
  Then regularly refresh the thesaurus file.

### How to change "dirty words" into *?

> In the detection result, there will be hit words in the specific position of the article, and then you can make corresponding replacement according to the length of the words, or you can simply replace the hit words directly according to this idea
  Can achieve more fun things.

### QQ will according to chat content under the expression of rain, this is how to do?

> Detect chat content, hit corresponding keywords, pull corresponding expressions and throw them on your screen.

<img src="/Images/WordsMatch/qq.jpg" alt="图片替换文本" width="300" height="500" align="bottom" />

### Support multi word bank

###### Service
````php
public static function mainServerCreate(EventRegister $register)
{
    // TODO: Implement mainServerCreate() method.
    $config = [
    	// Key value pair, key is thesaurus alias
        'wordBank' => [
            'test1' => EASYSWOOLE_ROOT.'/WM/test1.txt',
            'test2' => EASYSWOOLE_ROOT.'/WM/test2.txt'
        ],
        'processNum' => 3, // process number
        'maxMem' => 1024, // Maximum memory consumption per process(M)
        'separator' => ',', // Separators for words and other information
    ];
    WordsMatchServer::getInstance()
        ->setConfig($config)
        ->attachToServer(ServerManager::getInstance()->getSwooleServer());
}
````

###### Client

````php
WordsMatchClient::getInstance()
        ->setWordBankName('test2') // Specify word bank alias
        ->detect('content');
````

