# ﻿![mongoose-sex-page](static/logo.gif)

# mongoose-sex-page [![Build Status](https://travis-ci.org/dtboy1995/mongoose-sex-page.svg?branch=master)](https://travis-ci.org/dtboy1995/mongoose-sex-page)
A widget for mongoose paging

## Translations
[中文](README_CN.md)

# useful if you
- mongoose paging query

# install
> npm install --save mongoose-sex-page

# usage
```javascript
// ...
var User = mongoose.model('User', UserSchema);
var Pagnation = require('mongoose-sex-page');
/*
  Promise
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
  callback
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
  extend()
  if you use the mongoose plugin, Model will have some other methods
  for example, after using mongoose-deep-populate, the Model.deepPopulate method exists
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
/*
  global config
  options
    size # per page size
    display # page numbers
    light # is simple page
    size_name # inject() default size_name
    page_name # inject() default page_name
*/
Pagnation(/*not pass params*/)
  .config({
    size: 10, // default 20
    display: 5, // default 0
    size_name: 'pageSize', // default 'size'
    page_name: 'pageIndex', // default 'page'
    light: true // default false
  })
/*
  simple()
*/
Pagnation(User)
  .page(1)
  .size(10)
  .simple(true)
  .exec()
  .then(function (results) {
    // results is a result arrays without other info
  })
/*
  inject()
*/
// if req.query is { page: 3, size: 8}
Pagnation(User)
  .inject(req.query)
  .exec()
  .then(function (result) {
    // like page(3).size(8)
  })
```

# result
- page current page
- pages page count
- total total records number
- [records] current page records
- size quantity per page
- display the page number to display

**sample**
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

# api
- page(number)  current page
- size(number)  quantity per page
- display(number)  the page number to display
- find select sort populate  same as mongoose
- simple(boolean) light pagnation
- inject(object) page().size() shorthand
- exec(fn)
  - if fn is function then function(err, result) called
  - if fn is null then return a Promise
- extend(name, params...)
  - name a method name for Model
  - params Arguments to pass to this method, you can pass more than one parameter

# test
> npm test
