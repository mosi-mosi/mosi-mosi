angular.module "mosimosi"
  .controller "MainCtrl", ($scope, $rootScope) ->
    $scope.showModal = ()->
      $rootScope.showPayment = true
