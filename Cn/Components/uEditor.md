# u-editor
百度编辑器,composer eayswoole版本.  
## 安装
```bash
composer require easyswoole/u-editor
```

## 使用方法
新增一个控制器,继承`EasySwoole\UEditor\UEditorController`.
```php
<?php
namespace App\HttpController;
use EasySwoole\Http\AbstractInterface\Controller;
use EasySwoole\UEditor\UEditorController;

class UEditor extends UEditorController
{

}
```
> 该控制器请求地址为:/UEditor  

修改百度编辑器`ueditor.config.js` =>`window.UEDITOR_CONFIG`=>`serverUrl=URL + "/UEditor"`
如图![](/Images/uEditorJsConfig.png)

即可直接使用.  

## 补充说明
百度编辑器前端初始化后,会通过`ueditor.config.js`获取配置,通过获取到的服务器路径,请求格式为:  
服务器路径+"?action=操作方法".例如:
`http://127.0.0.1:9501//UEditor?action=config&&noCache=1587973402520`   
前端请求之后,将通过`UEditorController`的index方法进行识别action,转发到不同的请求逻辑上,实现百度编辑器的后端接口.  

## 自定义使用方法.
在`EasySwoole\UEditor\UEditorController`控制器中,有着默认的实现方法,如果你需要修改配置,可通过重写控制器方法进行修改.
### 保存路径
默认保存路径为`EASYSWOOLE_ROOT . '/Static'`.可通过属性继承`$rootPath`修改属性修改. 
### 权限控制实现
本组件默认控制器实现继承为`EasySwoole\Http\AbstractInterface\Controller`,如果你有需要登录用户上传等权限验证的需求,可以直接复制`EasySwoole\UEditor\UEditorController`里面的代码,重写继承,重写控制器方法
