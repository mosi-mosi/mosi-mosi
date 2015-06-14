angular.module "mosimosi"
  .constant('clientTokenPath', 'https://am9-api.herokuapp.com/client-token')
  .controller "PaymentCtrl", ($scope, $rootScope, $braintree) ->
    $rootScope.showPayment = false

    $scope.showModal = ()->
      $rootScope.showPayment = true

    $scope.closeModal = ()->
      $rootScope.showPayment = false
