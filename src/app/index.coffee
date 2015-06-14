angular.module 'mosimosi', ['ngAnimate', 'ngCookies', 'ngTouch', 'ngSanitize', 'ngResource', 'ui.router', 'firebase', 'ui.keypress', 'braintree-angular']
  .config ($stateProvider, $urlRouterProvider) ->
    $stateProvider
      .state "home",
        url: "/",
        templateUrl: "app/main/main.html",
        controller: "MainCtrl"
      .state "bullets",
        url: "/bullets",
        templateUrl: "app/components/bullets/base.html",
        controller: "BulletsCtrl"
      .state "auth",
        url: "/auth",
        templateUrl: "app/components/auth/login.html",
        controller: "AuthCtrl"
      .state "login",
        url: "/login",
        templateUrl: "app/components/login/login.html",
        controller: "LoginCtrl"
      .state "information",
        url: "/information",
        templateUrl: "app/components/information/information.html",
        controller: "InformationCtrl"
      .state "architecture",
        url: "/architecture",
        templateUrl: "app/components/architecture/architecture.html",
        controller: "ArchitectureCtrl"

      .state "payment",
        url: "/payment",
        templateUrl: "app/payment/payment.html",
        controller: "PaymentCtrl"

    $urlRouterProvider.otherwise '/'
