angular.module 'productSelector'
  .controller 'MainController', (QuestionStore, $state, $stateParams, $window, LxNotificationService) ->
    'ngInject'
    vm = this
    vm.loading = true
    vm.currentQuest = {}
    vm.selectedChoice = null

    initQuests = () ->
      console.log $stateParams['quest_id']
      if $stateParams['quest_id'] == ''
        vm.currentQuest = QuestionStore.getRootQuest()
      else
        vm.currentQuest = QuestionStore.getQuest $stateParams['quest_id']
        if vm.currentQuest == null
          $window.location.href = "#/"
        return

      vm.selectedChoice = null
      return

    QuestionStore.init () ->
      vm.loading = false
      initQuests()
      return

    vm.proceedQuest = () ->
      selected_choice = null
      console.log vm.selectedChoice
      console.log vm.currentQuest.choices
      for choice, i in vm.currentQuest.choices
        if choice.id == vm.selectedChoice
          selected_choice = choice
          break
      
      if selected_choice == null
        vm.gotoDeadEnd()
        return
      
      switch selected_choice.next
        when 'quest'
          vm.gotoQuest selected_choice.lead
        when 'result'
          vm.gotoResult selected_choice.result
        else
          vm.gotoDeadEnd()
      return

    vm.gotoQuest = (quest_id) ->
      console.log "Led to quest"
      $state.go('home', {quest_id: quest_id})
      return

    vm.gotoResult = (result_id) ->
      console.log "Led to result"
      $window.location.href = "#/product/"+result_id
      return

    vm.gotoDeadEnd = () ->
      console.log "Led to deadend"
      $window.location.href = "#/no-match"
      return

    return