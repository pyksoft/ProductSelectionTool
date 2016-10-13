angular.module 'productSelector'
  .config ($stateProvider, $urlRouterProvider) ->
    'ngInject'
    $stateProvider
      .state 'result',
        url: '/product/:product_id',
        templateUrl: 'app/main/result/index.html',
        controller: 'ResultMatchController',
        controllerAs: 'vm'
      .state 'deadend',
        url: '/no-match',
        templateUrl: 'app/main/deadend/index.html',
        controller: 'DeadEndController'
      .state 'admin',
        url: '/admin/:key'
        templateUrl: 'app/admin/index.html'
        controller: 'AdminController'
        controllerAs: 'main'
      .state 'conclude',
        url: '/thank-you'
        templateUrl: 'app/main/thanks/index.html'
        controller: 'ThankController'
        controllerAs: 'vm'
      .state 'home',
        url: '/:quest_id'
        templateUrl: 'app/main/main.html'
        controller: 'MainController'
        controllerAs: 'main'

    $urlRouterProvider.otherwise '/'
