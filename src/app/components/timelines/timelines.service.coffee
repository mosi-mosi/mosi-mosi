angular.module "mosimosi"
  .factory "Timelines", ($interval, Things) ->

    Things.onUpdate = (thing) ->
      Timelines.timelines[0].updateThing thing.parameters()

    # each timeline
    class Timeline
      constructor: (@userId, @focusTime) ->
        @things = []
        @currentThing = null

      addThing: (newThing) ->
        return if @things.some (thing) -> thing.id == newThing.id

        # sort the list of things
        for thing, index in @things
          if thing.start.getTime() > newThing.start.getTime()
            @things.splice index, 0, newThing
            return

        # append if the start time of new thing is more than all existing things
        @things.push newThing

        @adjustThings()

      removeThing: (thingId) -> @things.splice @findThing(thingId), 1

      updateThing: (update) ->
        for thing in @things
          if update.id == thing.id
            thing.title = update.title || thing.title
            thing.done = update.done || thing.done
            thing.start = update.start || thing.start
            thing.end = update.end || thing.end
            @adjustThings()

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
        i = 0
        ii = @things.length - 1
        while (i < ii)
          target = @things[i]
          next = @things[i + 1]

          delta = target.end.getTime() - next.start.getTime()

          if delta > 0
            next.start.setTime(next.start.getTime() + delta)
            next.end.setTime(next.end.getTime() + delta)

          ++i

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
