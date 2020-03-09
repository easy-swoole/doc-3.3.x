## websocket方法
`websocket server`继承于`http Server`,大致方法和`http server`一致(同时,`http server`又继承于`server`),可查看[http方法](/Cn/Swoole/ServerStart/Http/method.md)    
以下方法为`websocket server`专属,或者在`websocket server`环境下有不同解释
### push
向 `websocket` 客户端推送数据,最大不得超过 `2M`.
方法原型:push(int $fd, string $data/Swoole\WebSocket\Frame $frame, int $opcode = 1, bool $finish = true): bool;  
参数介绍:  
- $fd  客户端标识id
- $data/$frame  需要发送的数据/也可传入Swoole\WebSocket\Frame对象,当传入对象时,后面的参数直接无效.
- $opcode  发送的数据内容格式`WEBSOCKET_OPCODE_TEXT(文本)/WEBSOCKET_OPCODE_BINARY(二进制)`
- $finish  是否发送完成,默认true

### exist
判断 `webSocket` 客户端是否存在.  
方法原型:exist(int $fd): bool;
参数介绍:
- $fd 客户端标识id
::: warning
连接存在并已完成 `WebSocket` 握手时将返回 `true`,否则为`false`.
:::
### pack
打包`websocket`消息,打包之后,可直接通过`send`发送此消息.  
方法原型:pack(string $data, int $opCode = 1, bool $finish = true, bool $mask = false): string;  
参数介绍:  
- $data 消息内容
- $opCode 指定发送数据内容的格式`WEBSOCKET_OPCODE_TEXT(文本)/WEBSOCKET_OPCODE_BINARY(二进制)`
- $finish 帧是否完成
- $mask 是否设置掩码
::: warning
websocket的消息,是非粘包性的,原因是websocket每一条消息,都有消息帧代表发送完成,

:::
### unpack
方法原型:
参数介绍:
::: warning
:::
### disconnect
方法原型:
参数介绍:
::: warning
:::
### isEstablished
方法原型:
参数介绍:
::: warning
:::