angular.module "mosimosi"
  .controller "TimelinesCtrl", ($scope, Things, Timelines) ->
    DAY = 1000 * 60 * 60 * 24
    STEP_TIME = 1000 * 60 * 15 # 15 minutes

    Timelines.initTimelines 0, new Date(2015, 5, 14)

    $scope.timelines = Timelines.timelines
    $scope.origThings = Things.things

    $scope.detectThingStyle = (thing) ->
      start = Timelines.startingTime
      end = start + DAY
      top = calcTimeRetio thing.start.getTime(), start, end

      top: top + "%"
      height: (calcTimeRetio(thing.end.getTime(), start, end) - top) + "%"

    $scope.detectCurrentTimeStyle = () ->
      start = Timelines.startingTime
      end = start + DAY

      top: calcTimeRetio(Timelines.currentTime, start, end) + "%"

    $scope.detectThingBackHeight = (thing) ->
      calcTimeRetio(Timelines.currentTime, thing.start.getTime(), thing.end.getTime()) + "%"


    calcTimeRetio = (time, start, end) -> (time - start) / (end - start) * 100

    $scope.detectThingClass = (thing) ->
      start = thing.start.getTime()
      end = thing.end.getTime()

      return if end < Timelines.currentTime || thing.done
        "done"
      else if start < Timelines.currentTime
        "current"

    $scope.isCurrentThing = (thing) ->
      thing.start.getTime() < Timelines.currentTime && Timelines.currentTime <= thing.end.getTime()

    $scope.resizeStart = (thing) ->
      console.log thing

    $scope.resizeEnd = (thing, info) ->
      delta = info.y * STEP_TIME
      if info.direction == "top"
        thing.start.setTime(thing.start.getTime() - delta)
      else if info.direction == "bottom"
        thing.end.setTime(thing.end.getTime() + delta)
      Timelines.timelines[0].updateThing thing

    $scope.dragStart = (thing) ->
      console.log thing

    $scope.dragEnd = (thing, info) ->
      delta = info.x * STEP_TIME
      thing.start.setTime(thing.start.getTime() + delta)
      thing.end.setTime(thing.end.getTime() + delta)
      Timelines.timelines[0].updateThing thing

    $scope.onClickAddThing = () ->
      Things.add()

    $scope.onClickMoveThing = (thing) ->
      clone = thing.parameters()
      clone.start = new Date(Timelines.startingTime)
      clone.end = new Date(Timelines.startingTime + STEP_TIME * 4) # 1 hour
      Timelines.timelines[0].addThing clone

    $scope.onChangeThing = (thing) ->
      Things.update thing
