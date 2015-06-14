angular.module 'mosimosi', ['ngAnimate', 'ngCookies', 'ngTouch', 'ngSanitize', 'ngResource', 'ui.router', 'firebase', 'ui.keypress']
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

    $urlRouterProvider.otherwise '/'
