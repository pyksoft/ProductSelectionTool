angular.module 'productSelector'
  .controller 'AdminInputController', (QuestionStore, LxDialogService, LxNotificationService) ->
    'ngInject'
    vm = this
    vm.expanded_quest_id = null
    vm.modals =
      quest_new:
        title: ''

    vm.expandQuest = (quest) ->
      if quest.id == vm.expanded_quest_id
        vm.expanded_quest_id = null
      else
        vm.expanded_quest_id = quest.id
      return

    vm.openDialog = (id) ->
      LxDialogService.open(id);
      return

    QuestionStore.init () ->
      vm.arr_quests = QuestionStore.arr_quests
      return

    return