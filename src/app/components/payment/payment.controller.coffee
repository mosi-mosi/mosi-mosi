angular.module "mosimosi"
  .constant('clientTokenPath', 'https://am9-api.herokuapp.com/client-token')
  .controller "PaymentCtrl", ($scope, $braintree) ->
