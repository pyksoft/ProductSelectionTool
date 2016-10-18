angular.module 'productSelector'
  .controller 'DeadEndController', ($scope, $state, RequestConnector) ->
    'ngInject'
    $scope.loading = false
    $scope.disable_submit = false
    $scope.submitted = false

    $scope.info =
      description: ''
      email: ''

    $scope.submit = () ->
      $scope.loading = true
      $scope.disable_submit = true
      new RequestConnector.recommend(info: $scope.info).$save () ->
        console.log "Successfully sent an email"
        $scope.loading = false
        $scope.disable_submit = false
        $scope.submitted = true
        return
      return

    return