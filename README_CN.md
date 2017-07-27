# ﻿![mongoose-sex-page](static/logo.gif)

# mongoose-sex-page [![Build Status](https://travis-ci.org/dtboy1995/mongoose-sex-page.svg?branch=master)](https://travis-ci.org/dtboy1995/mongoose-sex-page)
一个mongoose分页小工具

## Translations
[中文](README_CN.md)

# 什么情况下使用
- 使用mongoose做分页查询

# 安装
> npm install --save mongoose-sex-page

# 用法
```javascript
// ...
var Foo = mongoose.model('Foo', FooSchema)
var Pagnation = require('mongoose-sex-page')
/*
  Promise形式
*/
Pagnation(Foo)
  .find()
  .select('age')
  .page(1) // 当前页数
  .size(10) // 每页几条
  .display(6) // 要显示的页码总数
  .sort({age: -1})
  .populate('foo')
  .exec()
  .then(function (result) {
    // result.page 当前页数
    // result.pages 总页数
    // result.total 总记录数
    // result.records 当前页的记录
    // result.size 每页几条
    // result.display 应该显示的页码数组 比如总页数有1000页的时候 我们只显示10页的情况下页码的下标
  })
  .catch(function (err) {
    console.log(err)
  })
/*
  回调函数形式
*/
Pagnation(Foo)
  .find()
  .select('age')
  .page(1)
  .size(10)
  .display(6)
  .sort({age: -1})
  .populate('foo')
  .exec(function (err, result) {

  })
```
# api
- page(number)  设置当前页
- size(number)  设置每页的数量
- display(number)  设置要显示在前端的页码数
- find select sort populate  这几个方法的使用和mongoose相应的方法一样
- exec(fn)
  - 如果fn是一个函数 那么 function(err, result) 会被调用
  - 如果不传fn 那么直接返回一个Promise对象

# 测试
> npm test
