var mongoose = require('mongoose')
var Pagnation = require('../index')
var Promise = require('bluebird')
mongoose.Promise = Promise
var assert = require('assert')

var PopulationSchema = new mongoose.Schema({
  name: String
})

var Population = mongoose.model('Population', PopulationSchema)

var TestSchema = new mongoose.Schema({
  name: String,
  age: Number,
  population: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Population'
  }
})

var Test = mongoose.model('Test', TestSchema)

var populations = []
for (var i = 0; i < 10; i++) {
  populations.push({
    name: 'population'+i
  })
}

var tests = []
for (var j = 0; j<100; j++){
  tests.push({
    name: 'test'+j,
    age: j
  })
}


mongoose.connect('mongodb://localhost:27017/pagnation',{ useMongoClient: true}).then(function (db) {
  return Population
    .create(populations)
    .then(function (docs) {
        tests[0].population = docs[0].id
        return Test.create(tests)
    })
    .then(function (docs) {
      console.log('data loaded.');
      console.log('----------------------');
      return Pagnation(Test)
        .find()
        .select('age')
        .page(1)
        .size(10)
        .display(6)
        .sort({age: -1})
        .populate()
        .exec()
    })
    .then(function (result) {
      assert.equal(result.page, 1)
      assert.equal(result.pages, 10)
      assert.equal(result.total, 100)
      assert.equal(result.records.length, 10)
      assert.equal(result.size, 10)
      console.log('Promise test passed!')
    })
    .then(function () {
      // test callback
      return Pagnation(Test)
        .find()
        .select('age')
        .page(1)
        .size(10)
        .display(6)
        .sort({age: -1})
        .populate()
        .exec(function (err, result) {
          if (err) {
            throw err
          }
          assert.equal(result.page, 1)
          assert.equal(result.pages, 10)
          assert.equal(result.total, 100)
          assert.equal(result.records.length, 10)
          assert.equal(result.size, 10)
          console.log('callback test passed!')
        })
    })
    .catch(function (err) {
      console.error('test not passed due to:' + err.stack);
    })
    .finally(function () {
      console.log('----------------------');
      return Test.remove().then(function () {
        console.log('clear tests');
        return Population.remove()
      }).then(function () {
        console.log('clear populations');
      })
    })

}).catch(function (err) {
  console.log('disconneted.');
})
