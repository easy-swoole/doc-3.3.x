## 参数注入到上下文
在 `>=1.1.1` 版本后,新增额参数注入到上下文的注解`InjectParamsContext`;  
通过此注解,可以将`Param`注解中的参数,全部注入到`InjectParamsContext`注解中指定的key中,过滤其他get,post参数.   

```php
/**
 * index
 * @InjectParamsContext(key="data")
 * @Param(name="userAccount",required="")
 * @Param(name="userPassword",optional="")
 * @Param(name="userSex",from={COOKIE})
 * @author apple
 * Time: 10:07
 */
public function index()
{
    $data = ContextManager::getInstance()->get('data');
    //这里获取的参数,一定是在Param中先声明好的,不会出现用户其他传输的参数.
    $model = new UserModel($data);
    $model->save();
    $this->response()->write('hello easyswoole.');
}
```

::: warning
`InjectParamsContext`  用处在于,当需要在数据库变更数据时,直接通过注解过滤掉一些数据库敏感字段,不需要通过重新声明$data方式赋值方式过滤掉敏感字段.  
例如,`UserModel`存在`money字段`,当我们需要更新user其他数据时,必须通过重新声明data来进行更新:
```php
$data = [
   'userName' => $param['userName'], 
   'userSex' => $param['userSex'], 
   'userAvatar' => $param['userAvatar'], 
//           'money' => $param['moeny'], //不能更新money.
];
$model = new UserModel();
$model->where(['userId'=>1])->update($data);
```
通过`InjectParamsContext`,可以无需声明$data,直接通过Param注解参数过滤掉不能更新的字段,通过`InjectParamsContext`获取一个完整的$data,即可直接更新.
:::
