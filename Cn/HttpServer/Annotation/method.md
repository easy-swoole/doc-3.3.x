#Method
请求方法注解可规定该方法只运行某种/多种请求方法  
例如限制方法只能GET,POST请求:
```php
/**
 * @Method(allow={POST,GET})
 */
function index()
{
    $this->writeJson(200,null,'hello');
}
```