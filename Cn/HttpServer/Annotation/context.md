#context
上下文注解可通过属性绑定上下文参数,直接进行类属性调用上下文参数.
例如:
在`onRequest`事件中(可以在控制器的onRequest,也可以在EasySwooleEvent的onRequest)注入一个上下文:
```php
    public static function onRequest(Request $request, Response $response): bool
    {
        ContextManager::getInstance()->set('key',time());//使用时间作为key参数的数据
        // TODO: Implement onRequest() method.
        return true;
    }

```
在控制器中注解绑定:
```php

class Index extends AnnotationController
{
    /**
     * @Context(key="key")
     */
    protected $key;
}
```

直接调用:
```php
function context()
{
    $this->writeJson(200,null,"key {$this->key}");
}
```