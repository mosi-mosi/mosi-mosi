angular.module 'mosimosi'
  .controller 'ClockCtrl', ($scope) ->

    displayTime = () ->
      date = new Date()
      $scope.year = date.getFullYear()
      $scope.mon = date.getMonth()
      $scope.day = ('0' + date.getDate()).slice(-2)
      $scope.hour = date.getHours()
      $scope.min = ('0' + date.getMinutes()).slice(-2)
      $scope.sec = ('0' + date.getSeconds()).slice(-2)

    displayTime()
    setInterval ->
        $scope.$apply(displayTime)
    , 100
