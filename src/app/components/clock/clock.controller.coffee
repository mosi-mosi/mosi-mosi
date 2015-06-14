angular.module 'mosimosi'
  .controller 'ClockCtrl', ($scope) ->

    displayTime = () ->
      date = new Date()
      $scope.year = date.getFullYear()
      $scope.mon = date.getMonth()
      $scope.date = ('0' + date.getDate()).slice(-2)
      $scope.hour = date.getHours()
      $scope.min = ('0' + date.getMinutes()).slice(-2)
      $scope.sec = ('0' + date.getSeconds()).slice(-2)
      dayList = ['SUN','MON','TUE','WED','THU','FRI','SAT']
      $scope.day = dayList[date.getDay()]

      $scope.secHand = date.getSeconds() * 6
      $scope.minHand = date.getMinutes() * 6 + $scope.secHand / 60
      $scope.hourHand = date.getHours() * 30 + $scope.minHand * 0.1

    displayTime()
    setInterval ->
        $scope.$apply(displayTime)
    , 100
