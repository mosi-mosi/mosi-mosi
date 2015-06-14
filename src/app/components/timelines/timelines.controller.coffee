angular.module "mosimosi"
  .controller "TimelinesCtrl", ($scope, Timelines) ->
    DAY = 1000 * 60 * 60 * 24

    Timelines.initTimelines 0, new Date(2015, 5, 14)

    $scope.timelines = Timelines.timelines

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
      console.log thing
      console.log info

    $scope.dragStart = (thing) ->
      console.log thing

    $scope.dragEnd = (thing, info) ->
      console.log thing
      console.log info
