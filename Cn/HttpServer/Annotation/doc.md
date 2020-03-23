---
title: easyswoole注解文档生成
meta:
  - name: description
    content: easyswoole注解文档生成
  - name: keywords
    content:  easyswoole注解文档生成|swoole注解文档生成
---
# 注解文档
对于任意的注解控制器的任意方法，只需要加上@Api注解，即可被文档扫描器自动识别。
## 例子
我们先创建两个实例控制器
### Shares控制器
```
<?php


namespace App\HttpController\Api\Common;


use EasySwoole\HttpAnnotation\AnnotationTag\DocTag\Api;
use EasySwoole\HttpAnnotation\AnnotationTag\Param;
use App\Model\Shares\Shares as SharesModel;

class Shares extends CommonBase
{
    /**
     * @Api(name="list",group="shares",description="获取分信息列表",path="/api/common/shares/list.html")
     * @Param(name="page",integer="",min="1",defaultValue="1")
     */
    public function list($page)
    {
        $model = SharesModel::create();
        $list = $model->page($page)->all();
        $this->writeJson(200,[
            'total'=>$model->lastQueryResult()->getTotalCount(),
            'list'=>$list
        ]);
    }
}
```

### Auth控制器
直接上代码，注意，看完代码记得看后面的提示

```
<?php


namespace App\HttpController\Api\User;


use App\Model\User;
use EasySwoole\HttpAnnotation\AnnotationTag\DocTag\Api;
use EasySwoole\HttpAnnotation\AnnotationTag\DocTag\ApiFail;
use EasySwoole\HttpAnnotation\AnnotationTag\DocTag\ApiRequestExample;
use EasySwoole\HttpAnnotation\AnnotationTag\DocTag\ApiSuccess;
use EasySwoole\HttpAnnotation\AnnotationTag\DocTag\ResponseParam;
use EasySwoole\HttpAnnotation\AnnotationTag\Param;
use EasySwoole\Utility\Random;

class Auth extends UserBase
{

    protected function onRequest(?string $action): ?bool
    {
        if(in_array($action,['login','register'])){
            return  true;
        }else{
            return  parent::onRequest($action);
        }
    }

    /**
     * @Api(name="login",group="auth",path="/api/user/login",description="用户登录接口",method={GET,POST})
     * @Param(name="account",required="")
     * @Param(name="password",required="")
     * @ApiRequestExample(curl http://127.0.0.1:9501/api/user/auth/login.html?account=test&password=123456)
     * @ApiSuccess(
     {
        "code": 200,
        "result": {
        "userId": 1,
        "userName": "测试用户",
        "account": "test",
        "userSession": "3WDETkim5dl9X1j4",
        "password": "123456",
        "balance": 0,
        "isVerify": 0
        },
        "msg": "登录成功"
     })
     * @ResponseParam(name="code",description="状态码")
     * @ResponseParam(name="result",description="api请求结果")
     * @ResponseParam(name="msg",description="api提示信息")
     * @ApiFail({"code":400,"result":null,"msg":"登录失败"})
     */
    function login()
    {
        $ret = User::create()->get($this->request()->getRequestParam());
        /** @var User $ret */
        if($ret){
            $ret->userSession = Random::character(16);
            $ret->update();
            $this->response()->setCookie('userSession',$ret->userSession,time()+86400*7);
            $this->writeJson(200,$ret->toArray(),'登录成功');
        }else{
            $this->writeJson(400,null,'登录失败');
        }
    }

    /**
     * @Api(name="register",group="auth",path="/api/user/register",description="用户注册接口",method={GET,POST})
     * @Param(name="account",required="")
     * @Param(name="password",required="")
     * @Param(name="rePassword",equalWithColumn="password")
     * @ApiRequestExample(curl http://127.0.0.1:9501/api/user/auth/register.html?account=test2&password=123456&&rePassword=123456)
     * @ApiFail({"code":400,"result":null,"msg":"注册失败"})
     */
    function register()
    {
        try{
            $ret = User::create($this->request()->getRequestParam())->save();
            $this->writeJson(200,$ret,'注册成功');
        }catch (\Throwable $throwable){
            $this->writeJson(400,null,"注册失败");
        }
    }

    function logout()
    {
        $this->user->userSession = null;
        $this->user->update();
        $this->writeJson(200,null,'退出成功');
    }
}
```

然后我们再项目根目录执行生成命令：
```
php vendor/bin/easy-doc 
```
即可在文档目录下看到```easy_doc.html```文件。执行：
```
php -S 127.0.0.1:8080
```
浏览器访问```http://127.0.0.1:8080/easy_doc.html```即可看到文档。效果如下：

![](/Images/Passage/annotationDoc.png)

## 解析单个控制器文档
```
namespace App\HttpController;


use App\Model\User;
use EasySwoole\HttpAnnotation\AnnotationTag\Doc\Render;
use EasySwoole\Utility\Random;

class Index extends BaseController
{
    function index()
    {
        $html = Render::renderToHtml($this->getMethodAnnotation());
        $this->response()->withAddedHeader('Content-type',"text/html;charset=utf-8");
        $this->response()->write($html);
    }

    /**
     * @Api(name="login",group="auth",path="/api/user/login",description="用户登录接口",method={GET,POST})
     * @Param(name="account",required="")
     * @Param(name="password",required="")
     * @ApiRequestExample(curl http://127.0.0.1:9501/api/user/auth/login.html?account=test&password=123456)
     * @ApiSuccess(
    {
    "code": 200,
    "result": {
    "userId": 1,
    "userName": "测试用户",
    "account": "test",
    "userSession": "3WDETkim5dl9X1j4",
    "password": "123456",
    "balance": 0,
    "isVerify": 0
    },
    "msg": "登录成功"
    })
     * @ResponseParam(name="code",description="状态码")
     * @ResponseParam(name="result",description="api请求结果")
     * @ResponseParam(name="msg",description="api提示信息")
     * @ApiFail({"code":400,"result":null,"msg":"登录失败"})
     */
    function login()
    {
        $ret = User::create()->get($this->request()->getRequestParam());
        /** @var User $ret */
        if($ret){
            $ret->userSession = Random::character(16);
            $ret->update();
            $this->response()->setCookie('userSession',$ret->userSession,time()+86400*7);
            $this->writeJson(200,$ret->toArray(),'登录成功');
        }else{
            $this->writeJson(400,null,'登录失败');
        }
    }

    /**
     * @Api(name="register",group="auth",path="/api/user/register",description="用户注册接口",method={GET,POST})
     * @Param(name="account",required="")
     * @Param(name="password",required="")
     * @Param(name="rePassword",equalWithColumn="password")
     * @ApiRequestExample(curl http://127.0.0.1:9501/api/user/auth/register.html?account=test2&password=123456&&rePassword=123456)
     * @ApiFail({"code":400,"result":null,"msg":"注册失败"})
     */
    function register()
    {
        try{
            $ret = User::create($this->request()->getRequestParam())->save();
            $this->writeJson(200,$ret,'注册成功');
        }catch (\Throwable $throwable){
            $this->writeJson(400,null,"注册失败");
        }
    }

}
```

> 本控制器仅有index方法可用，实际使用中，开发阶段可用在onRequest处，当get请求的时候显示对应的文档，post请求去做对应的action