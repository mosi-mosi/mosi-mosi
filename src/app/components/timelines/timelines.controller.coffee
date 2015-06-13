angular.module "mosimosi"
  .controller "TimelinesCtrl", ($scope, Timelines) ->
    DAY = 1000 * 60 * 60 * 24

    Timelines.initTimelines 0, new Date(2015, 5, 14)

    $scope.timelines = Timelines.timelines

    $scope.detectThingStyle = (thing) ->
      top = detectPosFromTime thing.start.getTime()

      top: top + "%"
      height: (detectPosFromTime(thing.end.getTime()) - top) + "%"

    $scope.detectCurrentTimeStyle = () ->
      top: detectPosFromTime(Timelines.currentTime) + "%"

    detectPosFromTime = (time) ->
      start = Timelines.startingTime
      end = start + DAY
      return (time - start) / (end - start) * 100

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
