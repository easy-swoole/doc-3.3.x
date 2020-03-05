# 内容配置

## set

设置协议版本
```php
public function setMimeVersion($mimeVersion): void
```

设置contentType
```php
public function setContentType($contentType): void
```

设置字符
```php
public function setCharset($charset): void
```

设置编码
```php
public function setContentTransferEncoding($contentTransferEncoding): void
````

设置主题
```php
public function setSubject($subject): void
```

设置邮件内容
```php
public function setBody($body): void
````

添加附件
```php
public function addAttachment($attachment)
```

## get

获取协议版本
```php
public function getMimeVersion()
```

获取contenttype
```php
public function getContentType()
```

获取字符
```php
public function getCharset()
```

获取编码
```php
public function getContentTransferEncoding()
```

获取主题
```php
public function getSubject()
```

获取邮件内容
```php
public function getBody()
```

获取附件
```php
public function getAttachments()
```
