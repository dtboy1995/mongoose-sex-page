# ﻿![mongoose-sex-page](static/logo.gif)

# mongoose-sex-page [![Build Status](https://travis-ci.org/dtboy1995/mongoose-sex-page.svg?branch=master)](https://travis-ci.org/dtboy1995/mongoose-sex-page)
一个mongoose分页小工具

## Translations
[English](README.md)

# 什么情况下使用
- 使用mongoose做分页查询

# 安装
> npm install --save mongoose-sex-page

# 用法
```javascript
// ...
var User = mongoose.model('User', UserSchema);
var Pagnation = require('mongoose-sex-page');
/*
  Promise形式
*/
server.get('/users',function (req, res, next) {
  var page, size;
    page = req.query.page;
    size = req.query.size;
  Pagnation(User)
    .find()
    .select('age')
    .page(page)
    .size(size)
    .display(8)
    .sort({age: -1})
    .populate('mother', 'age')
    .populate('father', 'name')
    .exec()
    .then(function (result) {
      res.send(result);
    });
});
/*
  回调函数形式
*/
server.get('/users',function (req, res, next) {
  var page, size;
    page = req.query.page;
    size = req.query.size;
  Pagnation(User)
    .find()
    .select('age')
    .page(page)
    .size(size)
    .display(8)
    .sort({age: -1})
    .populate('mother', 'age')
    .populate('father', 'name')
    .exec(function (err, result) {
      res.send(result);
    });
});
/*
  extend 方法
  如果你使用了mongoose的插件那么Model会有一些其他的方法
  比如在用了mongoose-deep-populate后，Model.deepPopulate这个方法就有了
*/
var deepPopulate = require('mongoose-deep-populate')(mongoose);
UserSchema.plugin(deepPopulate);
var User = mongoose.model('User', UserSchema);
Pagnation(Foo)
  .find()
  .page(1)
  .size(10)
  .extend('deepPopulate', ['some_field'], { populate: { select: 'some_field'}})
  .exec()
  .then(function (result) {

  });
```

# 返回值
- [page] 当前页
- [pages] 总页数
- [total] 总数据数
- [records] 当前页的数据
- [size] 每页多少条
- [display] 显示的页码

**例子**
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
- find select sort populate  这几个方法的使用和mongoose相应的方法一样
- exec(fn)
  - 如果fn是一个函数 那么 function(err, result) 会被调用
  - 如果不传fn 那么直接返回一个Promise对象
- extend(name, params...)
  - name Model的某个方法名
  - params 要传给该方法的参数,可以传入多个参数

# 测试
> npm test
