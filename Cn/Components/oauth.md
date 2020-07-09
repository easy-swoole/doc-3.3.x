# OAuth

基于`easyswoole/http-client`对第三方登录授权的SDK。集成了一些常见的第三方登录。

## 安装

```
composer require easyswoole/o-auth
```

## 方法

下列方法是公共的：
- `getAuthUrl()` 获取授权地址
- `getAccessToken($storeState = null, $state = null, $code = null)` 获取AccessToken（只返回access_token）
- `getAccessTokenResult()` 执行`getAccessToken`方法后，此方法获取原结果
- `getUserInfo(string $accessToken)` 获取用户信息
- `validateAccessToken(string $accessToken)` 验证token是否有效
- `refreshToken(string $refreshToken = null)` 刷新token 返回`bool`
- `getRefreshTokenResult()` 执行`refreshToken`方法后，此方法获取原结果


## 示例代码

### 微信

```php
class WeiXin extends \EasySwoole\Http\AbstractInterface\Controller
{
    public function index()
    {
        $config = new \EasySwoole\OAuth\WeiXin\Config();
        $config->setAppId('appid');
        $config->setState('easyswoole');
        $config->setRedirectUri('redirect_uri');

        $oauth = new \EasySwoole\OAuth\WeiXin\OAuth($config);
        $url = $oauth->getAuthUrl();

        return $this->response()->redirect($url);
    }

    public function callback()
    {
        $params = $this->request()->getQueryParams();

        $config = new \EasySwoole\OAuth\WeiXin\Config();
        $config->setAppId('appid');
        $config->setSecret('secret');
        $config->setOpenIdMode(\EasySwoole\OAuth\WeiXin\Config::OPEN_ID); // 可设置UNION_ID 默认为OPEN_ID

        $oauth = new \EasySwoole\OAuth\WeiXin\OAuth($config);
        $accessToken = $oauth->getAccessToken('easyswoole', $params['state'], $params['code']);
        $refreshToken = $oauth->getAccessTokenResult()['refresh_token'];

        $userInfo = $oauth->getUserInfo($accessToken);
        var_dump($userInfo);

        if (!$oauth->validateAccessToken($accessToken)) echo 'access_token 验证失败！' . PHP_EOL;


        if (!$oauth->refreshToken($refreshToken)) echo 'access_token 续期失败！' . PHP_EOL;

    }
}
```

### QQ

```php
class QQ extends \EasySwoole\Http\AbstractInterface\Controller
{
    public function index()
    {
        $config = new \EasySwoole\OAuth\QQ\Config();
        $config->setAppId('appid');
        $config->setState('easyswoole');
        $config->setRedirectUri('redirect_uri');

        $oauth = new \EasySwoole\OAuth\QQ\OAuth($config);
        $url = $oauth->getAuthUrl();

        return $this->response()->redirect($url);
    }

    public function callback()
    {
        $params = $this->request()->getQueryParams();

        $config = new \EasySwoole\OAuth\QQ\Config();
        $config->setAppId('appid');
        $config->setAppKey('appkey');
        $config->setRedirectUri('redirect_uri');
        $config->setOpenIdMode(\EasySwoole\OAuth\QQ\Config::OPEN_ID); // 可设置UNION_ID 默认为OPEN_ID

        $oauth = new \EasySwoole\OAuth\QQ\OAuth($config);
        $accessToken = $oauth->getAccessToken('easyswoole', $params['state'], $params['code']);
        $refreshToken = $oauth->getAccessTokenResult()['refresh_token'];

        $userInfo = $oauth->getUserInfo($accessToken);
        var_dump($userInfo);

        if (!$oauth->validateAccessToken($accessToken)) echo 'access_token 验证失败！' . PHP_EOL;


        if (!$oauth->refreshToken($refreshToken)) echo 'access_token 续期失败！' . PHP_EOL;

    }
}
```

### 微博

```php
class Weibo extends \EasySwoole\Http\AbstractInterface\Controller
{
    public function index()
    {
        $config = new \EasySwoole\OAuth\Weibo\Config();
        $config->setClientId('clientid');
        $config->setState('easyswoole');
        $config->setRedirectUri('redirect_uri');

        $oauth = new \EasySwoole\OAuth\Weibo\OAuth($config);
        $url = $oauth->getAuthUrl();

        return $this->response()->redirect($url);
    }

    public function callback()
    {
        $params = $this->request()->getQueryParams();

        $config = new \EasySwoole\OAuth\Weibo\Config();
        $config->setClientId('clientid');
        $config->setClientSecret('secret');
        $config->setRedirectUri('redirect_uri');

        $oauth = new \EasySwoole\OAuth\Weibo\OAuth($config);
        $accessToken = $oauth->getAccessToken('easyswoole', $params['state'], $params['code']);

        $userInfo = $oauth->getUserInfo($accessToken);
        var_dump($userInfo);

        if (!$oauth->validateAccessToken($accessToken)) echo 'access_token 验证失败！' . PHP_EOL;
    }
}
```

### 支付宝

```php
class AliPay extends \EasySwoole\Http\AbstractInterface\Controller
{
    public function index()
    {
        $config = new \EasySwoole\OAuth\AliPay\Config();
        $config->setState('easyswoole');
        $config->setAppId('appid');
        $config->setRedirectUri('redirect_uri');

        // 进行测试开发的时候 把OAuth的源码文件里面的 API_DOMAIN 和 AUTH_DOMAIN 进行修改
        $oauth = new \EasySwoole\OAuth\AliPay\OAuth($config);
        $url = $oauth->getAuthUrl();
        return $this->response()->redirect($url);
    }

    public function callback()
    {
        $params = $this->request()->getQueryParams();

        $config = new \EasySwoole\OAuth\AliPay\Config();
        $config->setAppId('appid');
//        $config->setAppPrivateKey('私钥');
        $config->setAppPrivateKeyFile('私钥文件'); // 私钥文件(非远程) 此方法与上个方法二选一

        $oauth = new \EasySwoole\OAuth\AliPay\OAuth($config);
        $accessToken = $oauth->getAccessToken('easyswoole', $params['state'], $params['auth_code']);
        $refreshToken = $oauth->getAccessTokenResult()['alipay_system_oauth_token_response']['refresh_token'];

        $userInfo = $oauth->getUserInfo($accessToken);
        var_dump($userInfo);

        if (!$oauth->validateAccessToken($accessToken)) echo 'access_token 验证失败！' . PHP_EOL;
        var_dump($oauth->getAccessTokenResult());

        if (!$oauth->refreshToken($refreshToken)) echo 'access_token 续期失败！' . PHP_EOL;
        var_dump($oauth->getRefreshTokenResult());
    }
}
```

### Github

```php
class Github extends \EasySwoole\Http\AbstractInterface\Controller
{
    public function index()
    {
        $config = new \EasySwoole\OAuth\Github\Config();
        $config->setClientId('clientid');
        $config->setRedirectUri('redirect_uri');
        $config->setState('easyswoole');
        $oauth = new \EasySwoole\OAuth\Github\OAuth($config);
        $this->response()->redirect($oauth->getAuthUrl());
    }

    public function callback()
    {
        $params = $this->request()->getQueryParams();
        $config = new \EasySwoole\OAuth\Github\Config();
        $config->setClientId('clientid');
        $config->setClientSecret('secret');
        $config->setRedirectUri('redirect_uri');

        $oauth = new \EasySwoole\OAuth\Github\OAuth($config);
        $accessToken = $oauth->getAccessToken('easyswoole', $params['state'], $params['code']);
        $userInfo = $oauth->getUserInfo($accessToken);
        var_dump($userInfo);

        if (!$oauth->validateAccessToken($accessToken)) echo 'access_token 验证失败！' . PHP_EOL;
    }
}
```

### Gitee

```php
class Gitee extends \EasySwoole\Http\AbstractInterface\Controller
{
    public function index()
    {
        $config = new \EasySwoole\OAuth\Gitee\Config();
        $config->setState('easyswoole');
        $config->setClientId('clientid');
        $config->setRedirectUri('redirect_uri');
        $oauth = new \EasySwoole\OAuth\Gitee\OAuth($config);
        $this->response()->redirect($oauth->getAuthUrl());
    }

    public function callback()
    {
        $params = $this->request()->getQueryParams();

        $config = new \EasySwoole\OAuth\Gitee\Config();
        $config->setClientId('client_id');
        $config->setClientSecret('secret');
        $config->setRedirectUri('redirect_uri');

        $oauth = new \EasySwoole\OAuth\Gitee\OAuth($config);
        $accessToken = $oauth->getAccessToken('easyswoole', $params['state'], $params['code']);
        $userInfo = $oauth->getUserInfo($accessToken);
        var_dump($userInfo);

        if (!$oauth->validateAccessToken($accessToken)) echo 'access_token 验证失败！' . PHP_EOL;
        var_dump($oauth->getAccessTokenResult());
    }
}
```
