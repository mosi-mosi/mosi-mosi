angular.module "mosimosi"
  .factory "Things", ->
    maxThingId = 0

    class Thing
      constructor: (@title) ->
        @done = false
        @id = ++maxThingId

      parameters: () ->
        title: @title
        done: @done

    Things =
      things: []

      add: () ->
        @things.push new Thing("")

      update: (update) ->
        for thing in @things
          if thing.id == update.id
            thing.title = update.title
            thing.done = update.done
            onUpdate thing

      findThing: (thingId) ->
        for thing in @things
          return thing if thing.id == thingId
        return null

      onUpdate: angular.noop

    return Things
