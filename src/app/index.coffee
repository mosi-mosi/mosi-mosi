angular.module 'mosimosi', ['ngAnimate', 'ngCookies', 'ngTouch', 'ngSanitize', 'ngResource', 'ui.router', 'firebase']
  .config ($stateProvider, $urlRouterProvider) ->
    $stateProvider
      .state "home",
        url: "/",
        templateUrl: "app/main/main.html",
        controller: "MainCtrl"
      .state "bullets",
        url: "/bullets",
        templateUrl: "app/components/bullets/bullets.html",
        controller: "BulletsCtrl"

    $urlRouterProvider.otherwise '/'

