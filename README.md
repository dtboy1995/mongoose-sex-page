# ﻿![mongoose-sex-page](static/logo.gif)

# mongoose-sex-page 

[![Build Status](https://img.shields.io/travis/dtboy1995/mongoose-sex-page/master.svg?style=flat-square)](https://travis-ci.org/dtboy1995/mongoose-sex-page)
a api friendly mongoose pagination tool

# install
> npm install --save mongoose-sex-page

# usage
```javascript
// ...
const Foo = mongoose.model('Foo', FooSchema)
const P  = require('mongoose-sex-page')

P(Foo)
  .page(1)
  .size(20)
  .exec() // return Promise
  .then(function (result) {
    // ...
  })
```

# result
- `page` current page
- `pages` page count
- `total` total records number
- `[records]` current page records
- `size` quantity per page
- `display` the page number to display

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
- infinite(boolean) is non paging
- find select sort populate  same as mongoose methods
- simple(boolean) light pagnation
- inject(object) page().size() shorthand
- exec(fn)
  - if fn is function then function(err, result) called
  - if fn is null then return a Promise
- extend(name, params...)
  - name a method name for Model
  - params Arguments to pass to this method, you can pass more than one parameter

# best practice
```javascript
// if your client's query parameter is pageSize=20&pageIndex=1 like this, and the number of pages per business is fixed to 20
// configure only once
P().config({
  page_name: 'pageIndex',
  size_name: 'pageSize',
  size: 20
})
// sample
P(User)
  .inject(req.query)
  .exec()
  .then(function (result) {

  })
// for the use of other api, please refer to test.js
```

# translations
[中文](README_CN.md)

# test
> npm test
