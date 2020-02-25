# 注解控制器

Easyswoole的http包自1.5版本开始，不再自带注解控制器。如果原先已经用于生产的用户，请指定依赖
```
"easyswoole/http": "^1.4"
```

## 安装
```
composer require easyswoole/http-annotation
```
## 旧版升级
使用`easyswoole/http 1.4`版本的用户,可通过安装组件进行升级   
只需要修改控制器继承改为`EasySwoole\HttpAnnotation\AnnotationController` 即可.

## 示例代码
```php
<?php


namespace App\HttpController;


use EasySwoole\Component\Context\ContextManager;
use EasySwoole\HttpAnnotation\AnnotationController;
use EasySwoole\HttpAnnotation\AnnotationTag\CircuitBreaker;
use EasySwoole\HttpAnnotation\AnnotationTag\Context;
use EasySwoole\HttpAnnotation\AnnotationTag\Di;
use EasySwoole\HttpAnnotation\AnnotationTag\Param;
use EasySwoole\HttpAnnotation\Exception\Annotation\ParamValidateError;
use EasySwoole\Validate\Validate;

class Index extends AnnotationController
{
    /**
     * @Di(key="IOC")
     */
    protected $ioc;

    /**
     * @Context(key="context")
     */
    protected $context;

    /**
     * @Param(name="account",from={GET,POST},notEmpty="不能为空")
     * @Param(name="session",notEmpty="不能为空")
     */
    function index()
    {
        $this->writeJson(200,null,'hello '.$this->request()->getRequestParam('account'));
    }

    /**
     * @Param(name="account",from={GET,POST},notEmpty="不能为空")
     * @Param(name="session",from={COOKIE},notEmpty="不能为空")
     */
    function index2($account,$session)
    {
        $this->writeJson(200,null,'hello '.$account);
    }

    function ioc()
    {
        $this->writeJson(200,null,"ioc ".$this->ioc);
    }

    function context()
    {
        $this->writeJson(200,null,"context ".$this->context);
    }

    /**
     * @CircuitBreaker(timeout="1.5",failAction="circuitBreakerFail")
     * @Param(name="timeout",required="",between={1,5})
     */
    public function circuitBreaker($timeout)
    {
        \co::sleep($timeout);
        $this->writeJson(200,null,'success call');
    }

    public function circuitBreakerFail()
    {
        $this->writeJson(200,null,'this is fail call');
    }

    protected function onRequest(?string $action): ?bool
    {
        ContextManager::getInstance()->set('context',time());
        return  true;
    }



    protected function onException(\Throwable $throwable): void
    {
        if($throwable instanceof ParamValidateError){
            /** @var Validate $validate */
            $validate = $throwable->getValidate();
            $errorMsg = $validate->getError()->getErrorRuleMsg();
            $errorCol = $validate->getError()->getField();
            $this->writeJson(400,null,"字段{$errorCol}{$errorMsg}");
        }else{
            $this->writeJson(500,null,$throwable->getMessage());
        }
    }
}
```

> 为了方便测试IOC注解，请在全局初始化事件中写入以下代码方便测试。

```php
use use EasySwoole\Component\Di;

Di::getInstance()->set('IOC',time());
```