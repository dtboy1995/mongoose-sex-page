# ﻿![mongoose-sex-page](art/logo.gif)

# mongoose-sex-page [![Build Status](https://img.shields.io/travis/dtboy1995/mongoose-sex-page/master.svg)](https://travis-ci.org/dtboy1995/mongoose-sex-page)

:sunrise: a api friendly mongoose pagination tool

# install
> npm install --save mongoose-sex-page

# usage

```javascript
const Foo = mongoose.model('Foo', FooSchema)
const P  = require('mongoose-sex-page')
```

### simple

```javascript
P(Foo)
  .page(1)
  .size(20)
  .exec() // Promise
  .then(function (result) {

  })
```

### complex

```javascript
P(Foo)
  .find({foo: foo})
  .page(1)
  .size(20)
  .display(8)
  .simple(true)
  .exec() // Promise
  .then(function (result) {

  })
```

# config

```javascript
P().config({
  page_name: 'pageIndex',
  size_name: 'pageSize',
  size: 20,
  display: 10,
  light: true // just return records
})
```

# result
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
  .find({foo: foo})
  .inject(req.query)
  .exec()
  .then(function (result) {

  })
// for the use of other api, please refer to test.js
```

# test
> npm test
