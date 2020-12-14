---
title: easyswoole docker镜像
meta:
  - name: description
    content: easyswoole docker镜像
  - name: keywords
    content: swoole dockerfile|easyswoole docker镜像|swoole docker镜像
---



# Docker

- [GitHub](https://github.com/easy-swoole/easyswoole)  喜欢记得点个 ***star***
- [GitHub for Doc](https://github.com/easy-swoole/doc-3.3.x)  文档贡献

## 镜像拉取
```
docker pull easyswoole/easyswoole3
```
>  docker hub上的环境为php7.2 + swoole4.4.17+easyswoole 3.3.x

## 启动

```
docker run -ti -p 9501:9501 easyswoole/easyswoole3
```
默认工作目录为: ***/easyswoole*** ，以上命令启动的时候，自动进入工作目录，执行php easyswoole start ，浏览器访问 ***http://127.0.0.1:9501/***
即可看到easyswoole欢迎页。

## Docker下开发

可以单独映射一个宿主机目录到Docker容器当中，然后根据easyswoole按照[安装文档](../QuickStart/install.md) 在
自定义映射的Docker容器目录中重新安装easyswoole。安装好后即可在宿主机中开发，docker中同步测试运行。

> 注意，在部分环境下，例如win10的docker环境中，不可把虚拟机共享目录作为EasySwoole的Temp目录，否则会因为权限不足无法创建socket，产生报错：listen xxxxxx.sock fail，
> 为此可以手动在dev.php配置文件里把Temp目录改为其他路径即可,如：'/Tmp'
 
## Docker File
您也可以使用Dockerfile进行自动构建。
```
FROM centos:8

#version defined
ENV SWOOLE_VERSION 4.4.17
ENV EASYSWOOLE_VERSION 3.x-dev

#install libs
RUN yum install -y curl zip unzip  wget openssl-devel gcc-c++ make autoconf git
#install php
RUN yum install -y php-devel php-openssl php-mbstring php-json php-simplexml
# composer
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/bin/composer && chmod +x /usr/bin/composer
# use aliyun composer
RUN composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/

# swoole ext
RUN wget https://github.com/swoole/swoole-src/archive/v${SWOOLE_VERSION}.tar.gz -O swoole.tar.gz \
    && mkdir -p swoole \
    && tar -xf swoole.tar.gz -C swoole --strip-components=1 \
    && rm swoole.tar.gz \
    && ( \
    cd swoole \
    && phpize \
    && ./configure --enable-openssl \
    && make \
    && make install \
    ) \
    && sed -i "2i extension=swoole.so" /etc/php.ini \
    && rm -r swoole

# Dir
WORKDIR /easyswoole
# install easyswoole
RUN cd /easyswoole \
    && composer require easyswoole/easyswoole=${EASYSWOOLE_VERSION} \
    && php vendor/bin/easyswoole install

EXPOSE 9501
```
