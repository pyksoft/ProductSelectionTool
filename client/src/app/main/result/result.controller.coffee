angular.module 'productSelector'
  .controller 'ResultMatchController', ($state, ResultStore, RequestConnector, $window, $stateParams) ->
    'ngInject'
    vm = this
    vm.loading = true
    vm.submitting = false
    vm.submitted = false

    vm.info =
      product: ''
      email_me:
        additional: false
        price: false
        sample: false
      email: ''

    vm.product = null
    vm.disable_submit = false

    vm.setResult = (result_id) ->
      if result_id == null
        $window.location.href = "#/no-match"
        return
      vm.product = ResultStore.getResult result_id
      if vm.product == null
        $window.location.href = "#/no-match"
        return
      vm.info.product = vm.product.title
      return

    vm.visitPage = () ->
      $window.open('http://'+vm.product.url, '_blank')
      return

    vm.submit = () ->
      vm.submitting = true
      vm.disable_submit = true
      new RequestConnector.inquire(info: vm.info).$save () ->
        console.log "Successfully sent an email"
        vm.submitting = false
        vm.disable_submit = false
        vm.submitted = true
        return
      return

    ResultStore.init () ->
      vm.loading = false
      if $stateParams['product_id'] == ''
        $window.location.href = "#/no-match"
        return
      vm.setResult $stateParams['product_id']
      return

    return