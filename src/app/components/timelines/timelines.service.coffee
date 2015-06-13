angular.module "mosimosi"
  .factory "Timelines", ->

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
          start: new Date("2015-06-13T01:15")
          end: new Date("2015-06-13T02:30")
        tl.addThing
          title: "test thing 2"
          start: new Date("2015-06-13T06:00")
          end: new Date("2015-06-13T09:30")
        tl.addThing
          title: "test thing 3"
          start: new Date("2015-06-13T13:15")
          end: new Date("2015-06-13T16:30")


        @startingTime = start.getTime()
        @timelines.push tl

    # update the currentTime every minute
    setInterval (() -> Timelines.currentTime = Date.now()), 60000

    return Timelines
