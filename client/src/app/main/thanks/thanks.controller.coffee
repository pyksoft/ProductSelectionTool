angular.module 'productSelector'
  .controller 'ThankController', ($state, $window, LxNotificationService) ->
    'ngInject'
    vm = this
    vm.restart = () ->
      $state.go('home')
      return

    vm.outsider = () ->
      $window.open('http://www.accuris-usa.com/', '_blank')
      return
    
    return