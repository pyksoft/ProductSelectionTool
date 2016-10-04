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
        additional: ''
        confirm: (id) -> deleteItem(id, @item_type, @item_id, @additional)
      choice_new:
        title: ''
        quest_id: ''
        confirm: (id) -> addChoice(id, @quest_id)
      edit:
        title: ''
        subject: ''
        item_id: ''
        additional: ''
        confirm: (id) -> changeItem(id, @subject, @item_id, @additional)

    vm.expandQuest = (quest) ->
      if quest.id == vm.expanded_quest_id
        vm.expanded_quest_id = null
      else
        vm.expanded_quest_id = quest.id
      return

    vm.openDialog = (id, param1 = null, param2 = null, param3 = null, additional = null) ->
      if id == 'dialog-delete-confirm'
        vm.modals.delete_confirm.item_type = param1
        vm.modals.delete_confirm.subject = param2
        vm.modals.delete_confirm.item_id = param3
        vm.modals.delete_confirm.additional = additional
      if id == 'dialog-new-choice'
        vm.modals.choice_new.quest_id = param1.id
      if id == 'dialog-title-change'
        vm.modals.edit.subject = param1
        vm.modals.edit.title = param2.title
        vm.modals.edit.item_id = param2.id
        if param3
          vm.modals.edit.additional = param3.id

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
    
    deleteItem = (modal_id, type, obj_id, additional) ->
      if type == 'quest'
        QuestionStore.delete obj_id, () ->
          vm.arr_quests = QuestionStore.arr_quests
          LxDialogService.close modal_id
          return
      if type == 'choice'
        QuestionStore.delete_choice additional.id, obj_id, () ->
          vm.arr_quests = QuestionStore.arr_quests
          LxDialogService.close modal_id
          return

      return

    changeItem = (modal_id, type, item_id, additional) ->
      if type == 'Question'
        QuestionStore.update item_id, vm.modals.edit.title, () ->
          vm.arr_quests = QuestionStore.arr_quests
          LxDialogService.close modal_id
          return
      if type == 'Choice'
        QuestionStore.update_choice additional, item_id, vm.modals.edit.title, () ->
          vm.arr_quests = QuestionStore.arr_quests
          LxDialogService.close modal_id
          return
      return

    addChoice = (modal_id, quest_id) ->
      QuestionStore.add_choice quest_id, vm.modals.choice_new.title, () ->
        vm.arr_quests = QuestionStore.arr_quests
        LxDialogService.close modal_id
        return
      return

    return