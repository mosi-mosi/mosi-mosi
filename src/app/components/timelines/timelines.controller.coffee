angular.module "mosimosi"
  .controller "TimelinesCtrl", ($scope, Timelines) ->
    Timelines.initTimelines 0, new Date(2015, 5, 13, 0, 0, 0)

    $scope.timelines = Timelines.timelines

    $scope.detectPosFromTime = (time) ->
