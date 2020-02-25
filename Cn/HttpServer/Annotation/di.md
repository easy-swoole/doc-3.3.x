# Di
通过Di注解,可以直接在控制器属性中绑定Di注入的参数,例如:

在`initialize`事件中注入参数:
```php
    public static function initialize()
    {
        date_default_timezone_set('Asia/Shanghai');

        Di::getInstance()->set('IOC', time());
        Di::getInstance()->set('test', '仙士可');
        Di::getInstance()->set('testObj', new \StdClass());

    }
```

控制器属性中增加Di注解:
```php

class Index extends AnnotationController
{
    /**
     * @DI(key="IOC")
     */
    protected $ioc;
    /**
     * @DI(key="test")
     */
    protected $name;
    /**
     * @DI(key="testObj")
     */
    protected $testObj;
}
```
::: warning 
控制器必须严格按照`安装`章节,继承`AnnotationController`
:::

只需要正常$this->xxx即可访问ioc内容:
```php
    function ioc()
    {
        $this->writeJson(200,null,"ioc:{$this->ioc} name:{$this->name} testObj:{$this->testObj}");
    }
```


