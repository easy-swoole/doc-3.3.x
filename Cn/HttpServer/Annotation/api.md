# Api
通过@Api标签可以实现对一个api的定义。在文档中即可实现对应的信息显示。例如：
```
    /**
     * @Api(path="/api/pay/qrCode/info/index.html",group="qrCode",name="info",description="获取二维码商户信息")
     * @Param(name="shopId",required="")
     */
    public function info($shopId)
    {
        $info = Shop::create()->where('shopId',$shopId)->get();
        if($info && $info['status'] == 0){
            $this->writeJson(200,$info,'店铺信息获取成功');
        }else{
            $this->writeJson(400,['errorCode'=>1],'店铺不存在');
        }
    }
```
## 路径注入路由
自easyswoole/http-annotation 1.2版本起，提供了一个工具类，可以把注解的Api路径写入FastRouter路由。代码如下：
```
<?php


namespace App\HttpController;


use EasySwoole\Http\AbstractInterface\AbstractRouter;
use EasySwoole\HttpAnnotation\DocGenerator\Utility;
use FastRoute\RouteCollector;

class Router extends AbstractRouter
{

    function initialize(RouteCollector $routeCollector)
    {
        Utility::mappingRouter($routeCollector,EASYSWOOLE_ROOT.'/App/HttpController');
    }
}
```