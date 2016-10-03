angular.module 'productSelector'
  .controller 'AdminInputController', (QuestionStore, LxDialogService, LxNotificationService) ->
    'ngInject'
    vm = this
    vm.expanded_quest_id = null
    vm.modals =
      quest_new:
        title: ''
        confirm: (id) -> addQuest(id)
      delete_confirm:
        subject: ''
        item_type: ''
        item_id: ''
        confirm: (id) -> deleteItem(id, @item_type, @item_id)

    vm.expandQuest = (quest) ->
      if quest.id == vm.expanded_quest_id
        vm.expanded_quest_id = null
      else
        vm.expanded_quest_id = quest.id
      return

    vm.openDialog = (id, param1 = null, param2 = null, param3 = null) ->
      if id == 'dialog-delete-confirm'
        vm.modals.delete_confirm.item_type = param1
        vm.modals.delete_confirm.subject = param2
        vm.modals.delete_confirm.item_id = param3

      LxDialogService.open(id)
      return

    QuestionStore.init () ->
      vm.arr_quests = QuestionStore.arr_quests
      return

    addQuest = (id) ->
      QuestionStore.add vm.modals.quest_new.title, () ->
        vm.arr_quests = QuestionStore.arr_quests
        LxDialogService.close id
        return
      return
    
    deleteItem = (modal_id, type, obj_id) ->
      if type == 'quest'
        QuestionStore.delete obj_id, () ->
          vm.arr_quests = QuestionStore.arr_quests
          LxDialogService.close modal_id
          return
      return

    return