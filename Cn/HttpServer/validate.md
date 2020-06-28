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

#### alpha

#### alphaNum

#### alphaDash

#### between

#### bool

#### decimal

#### dateBefore

#### dateAfter

#### equal

#### different

#### equalWithColumn

#### differentWithColumn

#### float

#### inArray

#### integer

#### isIp

#### notEmpty

#### numeric

#### notInArray

#### length

#### lengthMax

#### lengthMin

#### betweenLen

#### max

#### min

#### money

#### regex

#### required

#### timestamp

#### timestampBeforeDate

#### timestampAfterDate

#### timestampBefore

#### timestampAfter

#### url

#### allDigital

#### allowFile
