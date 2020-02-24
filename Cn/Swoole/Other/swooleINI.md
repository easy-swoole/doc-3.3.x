---
title: swoole ini配置
meta:
  - name: description
    content: swoole ini配置
  - name: keywords
    content: swoole|swoole 拓展|swoole 框架|EasySwoole|swoole|swoole ini配置
---

### ini配置

- 参数：swoole.enable_coroutine 				默认值：On 	说明： 开关内置协程
- 参数：swoole.display_errors   				默认值：On	说明： 开启或者关闭swoole的错误信息
- 参数：swoole.use_shortname 				默认值：On	说明： 是否启用短命名
- 参数：swoole.enable_preemptive_scheduler 	默认值：On 	说明： 防止协程死循环占用CPU，导致其他协程无法调度
- 参数：swoole.enable_library 				默认值：On	说明： 开启或者关闭扩展内置的library