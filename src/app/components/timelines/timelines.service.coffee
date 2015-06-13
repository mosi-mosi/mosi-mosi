angular.module "mosimosi"
  .factory "Timelines", ($interval) ->

    # each timeline
    class Timeline
      constructor: (@userId) ->
        @things = []

      addThing: (thing) -> @things.push thing

      removeThing: (thingId) -> @things.splice @findThing(thingId), 1

      findThing: (thingId) ->
        for thing in @things
          return thing if thing.id = thingId
        return null

    # the model managing all timelines
    Timelines =
      timelines: []
      startingTime: null
      currentTime: Date.now()

      initTimelines: (users, start) ->
        # FIXME: this is a mock
        tl = new Timeline(0)
        tl.addThing
          title: "test thing 1"
          start: new Date(2015, 5, 14, 0, 0)
          end: new Date(2015, 5, 14, 2, 30)
        tl.addThing
          title: "test thing 2"
          start: new Date(2015, 5, 14, 6, 0)
          end: new Date(2015, 5, 14, 9, 30)
        tl.addThing
          title: "test thing 3"
          start: new Date(2015, 5, 14, 11, 0)
          end: new Date(2015, 5, 14, 13, 45)


        @startingTime = start.getTime()
        @timelines.push tl

    # update the currentTime every minute
    $interval () ->
      Timelines.currentTime += 60000
    , 100

    return Timelines
