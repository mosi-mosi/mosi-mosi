angular.module 'mosimosi'
  .controller "FriendsCtrl", ($scope, bulletFactory, $firebaseObject, $firebaseArray, $q) ->
    ref = new Firebase("https://mosi-mosi.firebaseio.com/users")

    $scope.users = $firebaseArray(ref)
    $scope.users.$loaded((user)->
      console.log $scope.users
    )