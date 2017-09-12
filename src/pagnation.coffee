Promise = require 'bluebird'

# get display pages
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
    # inject model
    constructor: (@model) ->
    # wrap find
    find: (@condition) -> @
    # wrap select
    select: (@selection) -> @
    # wrap populate
    populate: (population...) ->
      unless @populations? then @populations = []
      @populations.push population
      return @
    # wrap sort
    sort: (@sorting) -> @
    # define page
    page: (@index) -> @
    # define size
    size: (@count) -> @
    # define display
    display: (@friend) -> @
    # define extend
    extend: (name, params...) ->
      unless @extends? then @extends = []
      @extends.push
        name: name
        params: params
      return @
    # execute
    exec: (fn)->
      # default index count friend
      unless @index? then @index = 1
      unless @count? then @count = 20
      unless @friend? then @friend = 0
      # compute skip
      skip = (@index - 1) * @count
      # default condition
      @condition ?= {}
      # prepare count-Promise
      promiseCount = @model
        .where @condition
        .count()
        .exec()
      # prepare records-Promise
      promiseRecords = @model
        .find @condition
        .skip skip
        .limit @count
      # inject extends
      if @extends?
        for extend in @extends
          if @model[extend.name]? then promiseRecords = promiseRecords[extend.name] extend.params...
      # inject select
      if @selection? then promiseRecords = promiseRecords.select @selection
      # inject sort
      if @sorting? then promiseRecords = promiseRecords.sort @sorting
      # inject populations
      if @populations?
        for population in @populations
          promiseRecords = promiseRecords.populate population...
      # execute
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
            # compute display pages
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
