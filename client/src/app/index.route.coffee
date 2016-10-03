angular.module 'productSelector'
  .config ($stateProvider, $urlRouterProvider) ->
    'ngInject'
    $stateProvider
      .state 'home',
        url: '/'
        templateUrl: 'app/main/main.html'
        controller: 'MainController'
        controllerAs: 'main'
      .state 'admin',
        url: '/admin/:key'
        templateUrl: 'app/admin/index.html'
        controller: 'AdminController'
        controllerAs: 'main'

    $urlRouterProvider.otherwise '/'
