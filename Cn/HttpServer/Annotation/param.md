#Param
Param参数注解,可过滤客户端提交的参数,例如:  

```php
/**
 * @Param(name="account",from={GET,POST},notEmpty="不能为空")
 * @Param(name="session",notEmpty="不能为空")
 */
function index()
{
    $this->writeJson(200,null,'hello '.$this->request()->getRequestParam('account'));
}
```

同时可以通过@Param注解的参数顺序,直接给控制器传输参数:
```php

/**
 * @Method(allow={POST,GET})
 * @Param(name="account",from={GET,POST},notEmpty="不能为空")
 * @Param(name="session",from={COOKIE},notEmpty="不能为空")
 */
function index2($account,$session)
{
    $this->writeJson(200,null,'hello '.$account);
}
```

## Param方法列表
Param方法基本和 Validate 组件的验证方法一致,详细方法如下:
可查看[Validate验证器](../validate.md) 查看详细参数传递

- activeUrl
- alpha
- alphaNum
- alphaDash
- between
- bool
- decimal
- dateBefore
- dateAfter
- equal
- different
- equalWithColumn
- differentWithColumn
- float
- func
- inArray
- integer
- isIp
- notEmpty
- numeric
- notInArray
- length
- lengthMax
- lengthMin
- betweenLen
- money
- max
- min
- regex
- allDigital
- required
- timestamp
- timestampBeforeDate
- timestampAfterDate
- timestampBefore
- timestampAfter
- url
- optional

::: warning
除去验证器验证方法,还有着额外的from方法,它将规定表单某个数据从何获取,例如:from={GET,POST,COOKIE},表示从get,post,cookie中获取
:::