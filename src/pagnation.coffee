Promise = require 'bluebird'

friendly = (total, display, current) ->
  left = 1
  right = total
  pages = []
  if total >= display + 1
    half = Math.ceil display / 2
    if current > half and current < total - (half - 1)
      left = current - half
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
      @display = 0
      @selection = @population = @condition = @sorting = {}

    display: (display) ->
      @display = display
      return @

    find: (condition) ->
      @condition = condition
      return @

    select: (selection) ->
      @selection = selection
      return @

    populate: (population) ->
      @population = population
      return @

    sort: (sorting) ->
      @sorting = sorting
      return @

    page: (index) ->
      @index = index
      return @

    size: (count) ->
      @count = count
      return @

    exec: ->
      skip = (@index - 1) * @count

      promiseCount = @__model__
        .where @condition
        .count()
        .exec()

      promiseRecords = @model
        .find @condition
        .select @selection
        .sort @sorting
        .skip skip
        .limit @count
        .populate @population
        .exec()

      Promise
        .all [promiseCount, promiseRecords]
        .bind @
        .then ([total, records]) ->
            final =
              total: total
              records: records
              pages: Math.ceil total / @count
            unless @display is 0 then final.friendly = friendly final.pages, @display, @index
            return final
