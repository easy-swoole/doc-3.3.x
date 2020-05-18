---
title: easyswoole swoole-自定义进程
meta:
  - name: description
    content: easyswoole swoole-自定义进程
  - name: keywords
    content: easyswoole swoole-自定义进程|easyswoole swoole-进程池|easyswoole|swoole|process/pool
---

# Process

Swoole所提供的进程管理模块，替代php的`pcntl`

:::warning
此模块比较底层，操作系统进程管理的封装，需要使用者有 `linux` 系统多进程编程经验
:::

`PHP` 自带 `pcntl`，有很多不足，如：
- 没有提供进程间通信功能
- 不支持重定向标准输入输出
- 只提供`fork`这样的原始接口，使用起来容易出错

`Process` 使我们在多进程编程方面更加轻松

`Process` 提供的特性：
- 方便实现进程间通讯
- 支持重定向标准输入输出，在子进程 `echo` 不会打印屏幕，直接写入管道，读键盘输入可以重定向为管道读取数据
- 提供了 `exec` 接口，创建的进程可以执行其它程序，与原 `PHP` 父进程之间进行方便的通信
- 在协程环境中无法使用此模块，具体实现参考[协程进程管理](/Cn/Swoole/Coroutine/procOpen.md)