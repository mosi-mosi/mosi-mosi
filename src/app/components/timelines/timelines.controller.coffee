angular.module "mosimosi"
  .controller "TimelinesCtrl", ($scope, Timelines) ->
    DAY = 1000 * 60 * 60 * 24

    Timelines.initTimelines 0, new Date("2015-06-13T00:00")

    $scope.timelines = Timelines.timelines

    $scope.detectThingStyle = (thing) ->
      top = detectPosFromTime thing.start.getTime()

      top: top + "%"
      height: (detectPosFromTime(thing.end.getTime()) - top) + "%"

    detectPosFromTime = (time) ->
      start = Timelines.startingTime
      end = start + DAY
      return (time - start) / (end - start) * 100
