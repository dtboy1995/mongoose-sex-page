# ﻿![mongoose-sex-page](art/logo.gif)

# mongoose-sex-page [![Build Status](https://travis-ci.org/dtboy1995/mongoose-sex-page.svg?branch=master)](https://travis-ci.org/dtboy1995/mongoose-sex-page)
一个api友好的mongoose分页工具

# 安装
> npm install --save mongoose-sex-page

# 用法
```javascript
// ...
// ...
const Foo = mongoose.model('Foo', FooSchema)
const P  = require('mongoose-sex-page')

P(Foo)
  .page(1)
  .size(20)
  .exec() // 返回 Promise
  .then(function (result) {
    // ...
  })
```

# 返回值
- `page` 当前页
- `pages` 总页数
- `total` 总数据数
- `[records]` 当前页的数据
- `size` 每页多少条
- `display` 显示的页码

``` json
{
  "page": 1,
  "size": 5,
  "total": 100,
  "records": [{
    "name": "Test1",
    "age": 1
  }, {
    "name": "Test2",
    "age": 2
  }, {
    "name": "Test3",
    "age": 3
  }, {
    "name": "Test4",
    "age": 4
  }, {
    "name": "Test5",
    "age": 5
  }],
  "pages": 20,
  "display": [1, 2, 3, 4, 5, 6]
}
```

# 接口
- page(number)  设置当前页
- size(number)  设置每页的数量
- display(number)  设置要显示在前端的页码数
- infinite(boolean) 是否返回所有数据
- find select sort populate  这几个方法的使用和mongoose相应的方法一样
- simple(boolean) 轻分页
- inject(object) page().size()函数的缩写
- exec(fn)
  - 如果fn是一个函数 那么 function(err, result) 会被调用
  - 如果不传fn 那么直接返回一个Promise对象
- extend(name, params...)
  - name Model的某个方法名
  - params 要传给该方法的参数,可以传入多个参数

# 最佳实践
```javascript
// 如果你的客户端的query参数是pageSize=20&pageIndex=1这样子，并且该业务每页数量固定为20，size如果配置了query中可以不传pageSize
// 仅配置一次
P().config({
  page_name: 'pageIndex',
  size_name: 'pageSize',
  size: 20
})
// 之后调用分页如下
P(User)
  .inject(req.query)
  .exec()
  .then(function (result) {

  })
// 其他api的使用，请参考test.js
```

# translations
[English](README.md)

# 测试
> npm test
