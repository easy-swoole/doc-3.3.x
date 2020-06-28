---
title: easyswoole参数验证器
meta:
  - name: description
    content: easyswoole参数验证器
  - name: keywords
    content: easyswoole参数验证器
---


## Validate

EasySwoole 提供了自带基础的验证类，默认在控制器中带有一个validate方法，如果希望用其他的方法或者是工具去做检验，可以在子类控制器中重写该方法，从而实现用其他工具进行校验

::: warning 
 验证器类: EasySwoole\Validate\Validate
:::

> 注意,easyswoole/http包自1.7版本起步不再自带validate包，需要按照此方法或者是兼容老项目的用户，可以自己引入，并在基类控制器添加如下方法：

```php
protected function validate(Validate $validate)
{
    return $validate->validate($this->request()->getRequestParam());
}
```

### 基础使用

```php
<?php
use EasySwoole\Validate\Validate;

$data = [
    'name' => 'blank',
    'age'  => 25
];

$valitor = new Validate();
$valitor->addColumn('name', '名字不为空')->required('名字不为空')->lengthMin(10,'最小长度不小于10位');
$bool = $valitor->validate($data);
var_dump($bool?"true":$valitor->getError()->__toString());

/* 结果：
 string(26) "最小长度不小于10位"
*/
```
### 控制器中封装使用
```php
namespace App\HttpController;
use EasySwoole\Http\Message\Status;
use EasySwoole\Validate\Validate;
use EasySwoole\Http\AbstractInterface\Controller;

class BaseController extends Controller
{

    protected function onRequest(?string $action): ?bool
    {
        $ret =  parent::onRequest($action);
        if($ret === false){
            return false;
        }
        $v = $this->validateRule($action);
        if($v){
            $ret = $this->validate($v);
            if($ret == false){
                $this->writeJson(Status::CODE_BAD_REQUEST,null,"{$v->getError()->getField()}@{$v->getError()->getFieldAlias()}:{$v->getError()->getErrorRuleMsg()}");
                return false;
            }
        }   
        return true;
    }

    protected function validateRule(?string $action):?Validate
    {

    }
}

```


::: warning 
 我们定义了一个带有validateRule方法的基础控制器。
:::

```php
namespace App\HttpController;


use App\HttpController\Api\BaseController;
use EasySwoole\Validate\Validate;

class Common extends BaseController
{
   
    function sms()
    {
        $phone = $this->request()->getRequestParam('phone');
      
    }

    protected function validateRule(?string $action): ?Validate
    {
        $v = new Validate();
        switch ($action){
            case 'sms':{
                $v->addColumn('phone','手机号')->required('不能为空')->length(11,'长度错误');
                $v->addColumn('verifyCode','验证码')->required('不能为空')->length(4,'长度错误');
                break;
            }
        }
        return $v;
    }
}
```


::: warning 
 在需要验证的控制器方法中，我们给对应的action添加对应的校验规则，即可实现自动校验，这样控制器方法即可安心实现逻辑。
:::

### 方法列表

获取Error：

```php
function getError():?EasySwoole\Validate\Error
```

给字段添加规则：

1.1.9版本到目前

- string `name`         字段key
- string `alias`        别名
- string `reset`        重置规则

```php
public function addColumn(string $name, ?string $alias = null,bool $reset = false):EasySwoole\Validate\Rule
```

1.1.0版本到1.1.8版本

- string `name`         字段key
- string `alias`        别名

```php
public function addColumn(string $name, ?string $alias = null):EasySwoole\Validate\Rule
```

1.0.1版本

- string `name`         字段key
- string `errorMsg`     错误信息
- string `alias`        别名

```php
public function addColumn(string $name,?string $errorMsg = null,?string $alias = null):EasySwoole\Validate\Rule
```

1.0.0版本

- string `name`         字段key
- string `alias`        别名
- string `errorMsg`     错误信息

```php
public function addColumn(string $name,?string $alias = null,?string $errorMsg = null):EasySwoole\Validate\Rule
```

返回一个Rule对象可以添加自定义规则。

数据验证：

- array `data` 数据

```php
function validate(array $data)
```

### 验证规则

#### activeUrl
验证url是否可以通讯
```php
$validate = new \EasySwoole\Validate\Validate();
$data = [
    'url' => 'https://www.easyswoole.com/'
];
$validate->addColumn('url')->activeUrl();
$bool = $validate->validate($data);
```
#### alpha
给定的参数是否是字母 即[a-zA-Z]
```php
$validate = new \EasySwoole\Validate\Validate();
$data = [
    'param' => 'easyswoole'
];
$validate->addColumn('param')->alpha();
$bool = $validate->validate($data);
```
#### alphaNum
给定的参数是否是字母和数字组成 即[a-zA-Z0-9]
```php
$validate = new \EasySwoole\Validate\Validate();
$data = [
    'param' => 'easyswoole2020'
];
$validate->addColumn('param')->alphaNum();
$bool = $validate->validate($data);
```
#### alphaDash
给定的参数是否是字母和数字下划线破折号组成 即[a-zA-Z0-9\-\_]
```php
$validate = new \EasySwoole\Validate\Validate();
$data = [
    'param' => 'easyswoole_2020'
];
$validate->addColumn('param')->alphaDash();
$bool = $validate->validate($data);
```
#### between
给定的参数是否在 $min $max 之间
```php
$validate = new \EasySwoole\Validate\Validate();
$data = [
    'param' => '2020'
];
$validate->addColumn('param')->between(2016,2020);
$bool = $validate->validate($data);
```
#### bool
给定的参数是否为布尔值
```php
$validate = new \EasySwoole\Validate\Validate();
$data = [
    'param' => 1
];
$validate->addColumn('param')->bool();
$bool = $validate->validate($data);
```
#### decimal
给定的参数是否合格的小数
```php
$validate = new \EasySwoole\Validate\Validate();
$data = [
    'param' => 1.1
];
$validate->addColumn('param')->decimal();
$bool = $validate->validate($data);
```
#### dateBefore
给定参数是否在某日期之前
```php
$validate = new \EasySwoole\Validate\Validate();
$data = [
    'param' => '2020-06-28'
];
$validate->addColumn('param')->dateBefore();
$bool = $validate->validate($data);
```
#### dateAfter
给定参数是否在某日期之后
```php
$validate = new \EasySwoole\Validate\Validate();
$data = [
    'param' => '2020-06-29'
];
$validate->addColumn('param')->dateAfter();
$bool = $validate->validate($data);
```
#### equal
验证值是否相等
```php
$validate = new \EasySwoole\Validate\Validate();
$data = [
    'param' => 2020
];
$validate->addColumn('param')->equal(2020);
$bool = $validate->validate($data);
```
#### different
验证值是否不相等
```php
$validate = new \EasySwoole\Validate\Validate();
$data = [
    'param' => 2020
];
$validate->addColumn('param')->different(2021);
$bool = $validate->validate($data);
```
#### equalWithColumn
验证值是否相等
```php
$validate = new \EasySwoole\Validate\Validate();
$data = [
    'param' => 2020,
    'test'  => 2020
];
$validate->addColumn('param')->equalWithColumn('test');
$bool = $validate->validate($data);
```
#### differentWithColumn
验证值是否不相等
```php
$validate = new \EasySwoole\Validate\Validate();
$data = [
    'param' => 2020,
    'test'  => 2021
];
$validate->addColumn('param')->differentWithColumn('test');
$bool = $validate->validate($data);
```
#### float
验证值是否一个浮点数
```php
$validate = new \EasySwoole\Validate\Validate();
$data = [
    'param' => 2020.1
];
$validate->addColumn('param')->float();
$bool = $validate->validate($data);
```
#### inArray
值是否在数组中
```php
$validate = new \EasySwoole\Validate\Validate();
$data = [
    'param' => 2020
];
$validate->addColumn('param')->inArray([2020,2021]);
$bool = $validate->validate($data);
```
#### integer
是否一个整数值
```php
$validate = new \EasySwoole\Validate\Validate();
$data = [
    'param' => 2020
];
$validate->addColumn('param')->integer();
$bool = $validate->validate($data);
```
#### isIp
是否一个有效的IP
```php
$validate = new \EasySwoole\Validate\Validate();
$data = [
    'ip' => '127.0.0.1'
];
$validate->addColumn('ip')->isIp();
$bool = $validate->validate($data);
```
#### notEmpty
是否不为空
```php
$validate = new \EasySwoole\Validate\Validate();
$data = [
    'param' => ''
];
$validate->addColumn('param')->notEmpty();
$bool = $validate->validate($data);
```
#### numeric
是否一个数字值
```php
$validate = new \EasySwoole\Validate\Validate();
$data = [
    'param' => 2020
];
$validate->addColumn('param')->numeric();
$bool = $validate->validate($data);
```
#### notInArray
值是否不在数组中
```php
$validate = new \EasySwoole\Validate\Validate();
$data = [
    'param' => 2022
];
$validate->addColumn('param')->inArray([2020,2021]);
$bool = $validate->validate($data);
```
#### length
验证数组或字符串或者文件的大小
```php
$validate = new \EasySwoole\Validate\Validate();
$data = [
    'string' => 2022,
    'array'  => [0,1,2],
    'file'   => $this->request()->getUploadedFile('file')
];
$validate->addColumn('string')->length(4);
$validate->addColumn('array')->length(3);
$validate->addColumn('file')->length(4); // 此处length为文件的size
$bool = $validate->validate($data);
```
#### lengthMax
验证数组或字符串的长度或文件的大小是否超出
```php
$validate = new \EasySwoole\Validate\Validate();
$data = [
    'string' => 2022,
    'array'  => [0,1,2],
    'file'   => $this->request()->getUploadedFile('file')
];
$validate->addColumn('string')->lengthMax(4);
$validate->addColumn('array')->lengthMax(3);
$validate->addColumn('file')->lengthMax(4); // 此处length为文件的size
$bool = $validate->validate($data);
```
#### lengthMin
验证数组或字符串的长度或文件的大小是否达到
```php
$validate = new \EasySwoole\Validate\Validate();
$data = [
    'string' => 2022,
    'array'  => [0,1,2],
    'file'   => $this->request()->getUploadedFile('file')
];
$validate->addColumn('string')->lengthMin(4);
$validate->addColumn('array')->lengthMin(3);
$validate->addColumn('file')->lengthMin(4); // 此处length为文件的size
$bool = $validate->validate($data);
```
#### betweenLen
验证数组或字符串的长度或文件的大小是否在一个区间里面
```php
$validate = new \EasySwoole\Validate\Validate();
$data = [
    'string' => 2022,
    'array'  => [0,1,2],
    'file'   => $this->request()->getUploadedFile('file')
];
$validate->addColumn('string')->betweenLen(1,4);
$validate->addColumn('array')->betweenLen(1,4);
$validate->addColumn('file')->betweenLen(1,4); // 此处length为文件的size
$bool = $validate->validate($data);
```
#### max
验证值不大于(相等视为通过)
```php
$validate = new \EasySwoole\Validate\Validate();
$data = [
    'param' => 2022
];
$validate->addColumn('param')->max(2022);
$bool = $validate->validate($data);
```
#### min
验证值不小于(相等视为通过)
```php
$validate = new \EasySwoole\Validate\Validate();
$data = [
    'param' => 2022
];
$validate->addColumn('param')->min(2022);
$bool = $validate->validate($data);
```
#### money
给定值是否一个合法的金额
```php
$validate = new \EasySwoole\Validate\Validate();
$data = [
    'param' => 2022.22
];
$validate->addColumn('param')->money();
$bool = $validate->validate($data);
```
#### regex
正则表达式验证
```php
$validate = new \EasySwoole\Validate\Validate();
$data = [
    'param' => 'easyswoole'
];
$validate->addColumn('param')->regex('/^[a-zA-Z]+$/');
$bool = $validate->validate($data);
```
#### required
必须存在值
```php
$validate = new \EasySwoole\Validate\Validate();
$data = [
];
$validate->addColumn('param')->required();
$bool = $validate->validate($data);
```
#### timestamp
值是一个合法的时间戳
```php
$validate = new \EasySwoole\Validate\Validate();
$data = [
    'param' => 1593315393
];
$validate->addColumn('param')->timestamp();
$bool = $validate->validate($data);
```
#### timestampBeforeDate
时间戳在某指定日期之前
```php
$validate = new \EasySwoole\Validate\Validate();
$data = [
    'param' => 1593315393
];
$validate->addColumn('param')->timestampBeforeDate('2020-06-29');
$bool = $validate->validate($data);
```
#### timestampAfterDate
时间戳在某指定日期之后
```php
$validate = new \EasySwoole\Validate\Validate();
$data = [
    'param' => 1593315393
];
$validate->addColumn('param')->timestampAfterDate('2020-06-27');
$bool = $validate->validate($data);
```
#### timestampBefore
时间戳是否在某时间戳之前
```php
$validate = new \EasySwoole\Validate\Validate();
$data = [
    'param' => 1593315393
];
$validate->addColumn('param')->timestampBefore(1593315394);
$bool = $validate->validate($data);
```
#### timestampAfter
时间戳是否在某时间戳之后
```php
$validate = new \EasySwoole\Validate\Validate();
$data = [
    'param' => 1593315393
];
$validate->addColumn('param')->timestampAfter(1593315392);
$bool = $validate->validate($data);
```
#### url
值是一个合法的链接
```php
$validate = new \EasySwoole\Validate\Validate();
$data = [
    'url' => 'https://www.easyswoole.com/'
];
$validate->addColumn('param')->url();
$bool = $validate->validate($data);
```
#### allDigital
验证字符串是否由数字构成
```php
$validate = new \EasySwoole\Validate\Validate();
$data = [
    'param' => 2022
];
$validate->addColumn('param')->allDigital();
$bool = $validate->validate($data);
```
#### allowFile
判断文件扩展名是否在规定内
```php
$validate = new \EasySwoole\Validate\Validate();
$data = [
    'file' => $this->request()->getUploadedFile('file')
];
$validate->addColumn('param')->allowFile(['png','jpg']);
$bool = $validate->validate($data);
```
#### allowFileType
判断文件类型是否在规定内
```php
$validate = new \EasySwoole\Validate\Validate();
$data = [
    'file' => $this->request()->getUploadedFile('file')
];
$validate->addColumn('param')->allowFileType(['image/png','image/jpeg']);
$bool = $validate->validate($data);
```