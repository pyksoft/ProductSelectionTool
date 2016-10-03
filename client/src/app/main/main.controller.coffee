angular.module 'productSelector'
  .controller 'MainController', ($timeout, toastr) ->
    'ngInject'
    vm = this

    this.title = "Product Selection Tool"
    return