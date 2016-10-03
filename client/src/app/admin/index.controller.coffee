angular.module 'productSelector'
  .controller 'AdminController', ($stateParams, $window, obviouskey) ->
    'ngInject'
    vm = this

    if ($stateParams['key'] != obviouskey)
      $window.location.href = '/'

    clickEvent: () ->
      console.log 'Button clicked...'