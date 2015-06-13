angular.module 'mosimosi', ['ngAnimate', 'ngCookies', 'ngTouch', 'ngSanitize', 'ngResource', 'ui.router', 'braintree-angular']
  .config ($stateProvider, $urlRouterProvider) ->
    $stateProvider
      .state "home",
        url: "/",
        templateUrl: "app/main/main.html",
        controller: "MainCtrl"

      .state "payment",
        url: "/payment",
        templateUrl: "app/payment/payment.html",
        controller: "PaymentCtrl"

    $urlRouterProvider.otherwise '/'

