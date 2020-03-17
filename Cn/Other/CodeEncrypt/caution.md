---
title: easyswoole php源码加密原理
meta:
  - name: description
    content: easyswoole php源码加密原理
  - name: keywords
    content: php源码加密|swoole源码加密|easyswoole源码加密
---

# 注意！！！！！
## 首先世界上没有绝对的安全，只有破解代价与利益是否等价
别说啥PHP不安全，其他语言安全。例子：
- windows牛逼不，被破解了
- photoshop牛逼不，被破解了
- 等等等

## 未处理项目
### 加解密空实现
```
//空实现
static unsigned char* encrypt_str(unsigned char *raw,int raw_size, int *decode_size)
{
    unsigned char *res;
    res = malloc(sizeof(unsigned char)*raw_size);
    *decode_size = raw_size;
    memcpy(res,raw,raw_size);
    return res;
}
//空实现
static unsigned char* decrypt_str(unsigned char *raw,int raw_size, int *decode_size)
{
    unsigned char *res;
    res = malloc(sizeof(unsigned char)*raw_size);
    *decode_size = raw_size;
    memcpy(res,raw,raw_size);
    return res;
}

```

目前的例子中，加解密完全为空实现。数据仅仅是做了base64。这边用户可以修改这部分代码，比如改为AES,或者是openssl等方式，然后就可以编译成自己的加密啦，而且不被人知道。

### 文件校验
目前加密的文件数据，仅有代码数据。为了安全用户可以加上自己的校验数据。例如以下结构体
```
struct {
    char *ip
    char *mac
    char *phpCode
    int expire
}
```
从而实现，机器的ip、mac地址、还有过期时间限制

## 未完善
###  mixed_opcode
```
static void mixed_opcode(zend_op_array* opline) {
  if (NULL != opline) {
    for (size_t i = 0; i < opline->last; i++) {
      zend_op* orig_opline = &(opline->opcodes[i]);
      if (orig_opline->opcode == ZEND_IS_EQUAL) {
        orig_opline->opcode = ZEND_IS_IDENTICAL;
        zend_vm_set_opcode_handler(orig_opline);
      } else if (orig_opline->opcode == ZEND_IS_NOT_EQUAL) {
        orig_opline->opcode = ZEND_IS_NOT_IDENTICAL;
        zend_vm_set_opcode_handler(orig_opline);
      }
    }
  }
}
```

目前，对zend_op_array的混淆，仅仅做了简单处理。这一步是为了防止有人从op code逆向出代码(编译原理AST语法树相关知识)。

### zend_execute等hook
讲道理，用户可以修改编译自己的php,从而从关键位置拿到数据，也就是拿内存数据。为此，
一些关键函数，例如zend_execute等，一定要加入例如Easyswoole Compiler实例代码中```compile_string```函数的hook校验

# 结束语
讲真，写这个文章来讲解原理，也不是为了拆台，zend的加密器都能被破解，你写的再牛逼，无非就是利益够不够的问题。这是为了帮助大家，更了解深入PHP源码的加密。不论什么语言，真想破解，一定是有办法的。因此，最好的方式那就是```核心API放自己的服务器，以SASS方式提供服务```。
当然，加密也并不是意义全无、至少、、、心里都会权衡一下，看你是要自己开发划算、还是破解我的划算。