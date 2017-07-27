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
var Foo = mongoose.model('Foo', FooSchema)
var Pagnation = require('mongoose-sex-page')
/*
  Promise
*/
Pagnation(Foo)
  .find()
  .select('age')
  .page(1) // current page
  .size(10) // quantity per page
  .display(6) // the page number to display
  .sort({age: -1})
  .populate('foo')
  .exec()
  .then(function (result) {
    // result.page current page
    // result.pages page count
    // result.total total record number
    // result.records current page records
    // result.size quantity per page
    // result.display the page number to display
  })
  .catch(function (err) {
    console.log(err)
  })
/*
  callback
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
- page(number)  current page
- size(number)  quantity per page
- display(number)  the page number to display
- find select sort populate  same as mongoose
- exec(fn)
  - if fn is function then function(err, result) called
  - if fn is null then return a Promise

# test
> npm test
