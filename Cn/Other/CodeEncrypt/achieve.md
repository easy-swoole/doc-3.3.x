---
title: easyswoole php源码加密原理
meta:
  - name: description
    content: easyswoole php源码加密原理
  - name: keywords
    content: php源码加密|swoole源码加密|easyswoole源码加密
---

# 实现原理
- 在拓展层实现代码加密，生成新代码
- 在拓展层解密代码
    - hook校验
    - opcode混淆
- 在拓展层执行解密后代码

# 知识储备
首先，对于一个php文件的执行，我们需要知道其大概的步骤：
- 基础环境初始化
- 调用zend_compile_file解析文件生成opcode
- 调用zend_execute执行生成的opcode

## 相关函数
```
static zend_op_array *(*zend_compile_string)(zval *source_string, char *filename TSRMLS_DC);
```
```
static zend_op_array *(*zend_compile_string)(zval *source_string, char *filename TSRMLS_DC);
```
```
static zend_op_array *(*zend_compile_string)(zval *source_string, char *filename TSRMLS_DC);
```

```
static void zend_execute(zend_op_array *op_array,zval *return_value);
```

## 替换PHP默认方法

```
PHP_MINIT_FUNCTION(decrypt_code)
{
    //init exception class
    INIT_CLASS_ENTRY(easy_compiler_exception_ce, "EasySwoole\\EasyCompilerException", NULL);
    easy_compiler_exception_class_entry_ptr = zend_register_internal_class_ex(&easy_compiler_exception_ce, zend_exception_get_default(TSRMLS_C));
    // zend hook
    zend_compile_file = decrypt_compile_file;
    orig_compile_string = zend_compile_string;
    zend_compile_string = decrypt_compile_string;
    return SUCCESS;
}

PHP_MSHUTDOWN_FUNCTION(myShut)
{
    zend_compile_string = orig_compile_string;
    return SUCCESS;
}
```

我们在php加载拓展的时候，替换了php默认的 ```zend_compile_file```和```orig_compile_string```。当然，在Easyswoole中实现的执行代码的方式，
不会被这两个函数hook，这个两个可以用来破解纯php层的混淆加密。相关安全问题在注意事项章节讲解。

## 定义加密方法
```
PHP_FUNCTION(easy_compiler_encrypt) {
    unsigned char *encrypt_string;
    unsigned char *raw_string;
    size_t raw_string_len;
    if (zend_parse_parameters(ZEND_NUM_ARGS() TSRMLS_CC, "s", &raw_string, &raw_string_len) == FAILURE) {
        RETURN_NULL();
    }
    //先加密，得到加密后长度
    size_t encrypt_len;
    encrypt_string = encrypt_str(raw_string,raw_string_len,&encrypt_len);
    //根据加密后长度做base64
    zend_string *zend_encode_string;
    zend_string *base64;
    zend_encode_string = zend_string_init(encrypt_string,encrypt_len,0);
    base64 = php_base64_encode((const unsigned char*)ZSTR_VAL(zend_encode_string),ZSTR_LEN(zend_encode_string));
    char *res = ZSTR_VAL(base64);
    zend_string_release(base64);
    zend_string_release(zend_encode_string);
    base64 = NULL;
    zend_encode_string = NULL;
    raw_string = NULL;
    efree(zend_encode_string);
    efree(base64);
    efree(raw_string);
    free(encrypt_string);
    RETURN_STRING(res);
};
```

## 定义解密方法
```
PHP_FUNCTION(easy_compiler_decrypt) {
    unsigned char *base64;
    unsigned char *decrypt_string;
    //base64参数长度
    size_t base64_len;
    if (zend_parse_parameters(ZEND_NUM_ARGS() TSRMLS_CC, "s", &base64, &base64_len) == FAILURE) {
        RETURN_NULL();
    }
    //提前执行一次eval空字符串,用来判定compile_file和compile_string是否被hook替换，禁止从内存拿数据
    zend_try {
        zend_eval_string("", NULL, (char *)"" TSRMLS_CC);
    } zend_catch {

    } zend_end_try();

    if(easy_compiler_globals.is_hook_compile_file == false){
         throw_exception("hook compile_file is forbid");
    }

    if(easy_compiler_globals.is_hook_compile_string == false){
        throw_exception("hook compile_string is forbid");
    }
    //base64 decode
    zend_string *base64_decode;
    base64_decode = php_base64_decode(base64,base64_len);
    efree(base64);
    //得到原始长度和原始字符串
    base64_len = ZSTR_LEN(base64_decode);
    int decrypt_len = NULL;
    decrypt_string = decrypt_str((const char*)ZSTR_VAL(base64_decode),base64_len,&decrypt_len);
    zend_string_release(base64_decode);
    base64_decode = NULL;
    efree(base64_decode);
    zend_string *eval_string;
    zval z_str;
    eval_string = zend_string_init(decrypt_string,decrypt_len,0);
    ZVAL_STR(&z_str,eval_string);
    zend_op_array *new_op_array;
    char *filename = zend_get_executed_filename(TSRMLS_C);
    new_op_array =  compile_string(&z_str, filename TSRMLS_C);
    if(new_op_array){
        mixed_opcode(new_op_array);
        zend_try {
            // exec new op code
            zend_execute(new_op_array,return_value);
            //zend_eval_stringl(decrypt_string,strlen(decrypt_string), return_value, (char *)"" TSRMLS_CC);
        } zend_catch {

        } zend_end_try();
        destroy_op_array(new_op_array);
        efree(new_op_array);
    }
    zval_ptr_dtor(&z_str);
    free(decrypt_string);
    decrypt_string = NULL;
    efree(filename);
    filename = NULL;
};
```
> 就是在这一步解析加密后的代码，并执行对应的opcode

## 更多细节源码

[EasySwoole Compiler](https://github.com/easy-swoole/compiler/blob/master/src/compiler.c)