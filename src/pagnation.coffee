Promise = require 'bluebird'

friendly = (total, display, current) ->
  left = 1
  right = total
  pages = []
  if total >= display + 1
    half = Math.ceil display / 2
    if current > half and current < total - (half - 1)
      if display % 2 is 0
        left = current - half
      else
        left = current - half + 1
      right = current + half - 1
    else
      if current <= half
        left = 1
        right = display
      else
        right = total
        left = total - (display - 1)
  while left <= right
    pages.push left
    left++
  return pages

class Pagnation

    constructor: (model) ->
      @model = @__model__ = model
      @index = 1
      @count = 20
      @friend = 0
      @extends = @condition = @selection = @population = @sorting = null

    find: (@condition) -> @
    select: (@selection) -> @
    populate: (@population) -> @
    sort: (@sorting) -> @
    page: (@index) -> @
    size: (@count) -> @
    display: (@friend) -> @
    extend: (name, params) ->
      unless @extends? then @extends = []
      @extends.push
        name: name
        params: params
      return @

    exec: (fn)->

      skip = (@index - 1) * @count
      @condition ?= {}

      promiseCount = @__model__
        .where @condition
        .count()
        .exec()

      promiseRecords = @model
        .find @condition
        .skip skip
        .limit @count

      if @extends?
        for extend in @extends
          if @model[extend.name]?
            promiseRecords = promiseRecords[extend.name](extend.params)

      if @selection? then promiseRecords = promiseRecords.select @selection
      if @sorting? then promiseRecords = promiseRecords.sort @sorting
      if @population then promiseRecords = promiseRecords.populate @population

      Promise
        .all [ promiseCount, promiseRecords.exec() ]
        .bind @
        .then ([total, records]) ->
            final =
              page: @index
              size: @count
              total: total
              records: records
              pages: Math.ceil total / @count
            unless @friend is 0 then final.display = friendly final.pages, @friend, @index
            if fn? and typeof fn is 'function'
              fn null, final
            else
              final
        .catch (err) ->
          if fn? and typeof fn is 'function'
            fn err, null
          else
            throw err


module.exports = Pagnation
