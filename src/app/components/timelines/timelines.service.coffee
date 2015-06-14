angular.module "mosimosi"
  .factory "Timelines", ($interval) ->

    # each timeline
    class Timeline
      constructor: (@userId, @focusTime) ->
        @things = []
        @currentThing = null

      addThing: (newThing) ->
        # sort the list of things
        for thing, index in @things
          if thing.start.getTime() > newThing.start.getTime()
            @things.splice index, 0, newThing
            return

        # append if the start time of new thing is more than all existing things
        @things.push newThing

      removeThing: (thingId) -> @things.splice @findThing(thingId), 1

      updateThing: (update) ->
        for thing, index in @things
          if update.id == thing.id
            @things.splice index, 1, update

      findThing: (thingId) ->
        for thing in @things
          return thing if thing.id = thingId
        return null

      updateTime: (time) ->
        prevThing = @currentThing
        @currentThing = null

        for thing in @things
          if thing.start.getTime() < time && time <= thing.end.getTime()
            @currentThing = thing

        return if prevThing == null || prevThing == @currentThing

        # it indicates throgh out the previous thing

        # extend the end time if the user could not have done current thing
        if !prevThing.done
          prevThing.end = new Date(time)
          @currentThing = prevThing

        @adjustThings()

      # prevent things to overlap each other
      adjustThings: () ->
        for i in [0..@things.length - 2]
          target = @things[i]
          next = @things[i + 1]

          delta = target.end.getTime() - next.start.getTime()

          if delta > 0
            next.start.setTime(next.start.getTime() + delta)
            next.end.setTime(next.end.getTime() + delta)



    # the model managing all timelines
    Timelines =
      timelines: []
      startingTime: null
      currentTime: Date.now()

      initTimelines: (users, start) ->
        # FIXME: this is a dummy user
        tl = new Timeline(0, @currentTime)

        @startingTime = start.getTime()
        @timelines.push tl

      updateCurrentTime: () ->
        @currentTime = Date.now()
        @timelines.forEach (timeline) =>
          timeline.updateTime @currentTime

    # update the currentTime every minute
    $interval Timelines.updateCurrentTime.bind(Timelines), 60000

    return Timelines
