angular.module 'productSelector'
  .controller 'AdminInputController', (QuestionStore, ResultStore, LxDialogService, LxNotificationService) ->
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
      root_confirm:
        subject: null
        confirm: (id) -> rootQuest(id, @subject.id)
      lead:
        subject: null
        belongs_to: null
        quest: null
        result: null
        next: null
        choice_quests: []
        choice_results: []
        confirm: (id) -> setLead(id, @subject.id, @next, @quest, @result, @belongs_to)

    vm.expandQuest = (quest) ->
      if quest.id == vm.expanded_quest_id
        vm.expanded_quest_id = null
      else
        vm.expanded_quest_id = quest.id
      return

    vm.openDialog = (id, param1 = null, param2 = null, param3 = null, additional = null) ->
      if id == 'dialog-new-quest'
        vm.modals.quest_new.title = ''
      if id == 'dialog-delete-confirm'
        vm.modals.delete_confirm.item_type = param1
        vm.modals.delete_confirm.subject = param2
        vm.modals.delete_confirm.item_id = param3
        vm.modals.delete_confirm.additional = additional
      if id == 'dialog-new-choice'
        vm.modals.choice_new.quest_id = param1.id
        vm.modals.choice_new.title = ''
      if id == 'dialog-title-change'
        vm.modals.edit.subject = param1
        vm.modals.edit.title = param2.title
        vm.modals.edit.item_id = param2.id
        if param3
          vm.modals.edit.additional = param3.id
      if id == 'dialog-root-confirm'
        vm.modals.root_confirm.subject = param1
      if id == 'dialog-select-lead'
        vm.modals.lead.subject = param1
        vm.modals.lead.choice_quests = []
        vm.modals.lead.choice_results = []
        vm.modals.lead.belongs_to = param2
        vm.modals.lead.quest = null
        vm.modals.lead.result = null
        vm.modals.lead.next = param1.next

        for quest, i in vm.arr_quests
          flat_quest = JSON.parse(JSON.stringify(quest))
          if quest.id != param2
            vm.modals.lead.choice_quests.push flat_quest
          if param1.lead == quest.id
            vm.modals.lead.quest = flat_quest
      
        for result, i in ResultStore.arr_results
          flat_result = JSON.parse(JSON.stringify(result))
          vm.modals.lead.choice_results.push flat_result
          if param1.result == result.id
            vm.modals.lead.result = flat_result

      LxDialogService.open(id)
      return

    QuestionStore.init () ->
      vm.arr_quests = QuestionStore.arr_quests
      return

    ResultStore.init () ->
      return

    addQuest = (id) ->
      QuestionStore.add vm.modals.quest_new.title, () ->
        vm.arr_quests = QuestionStore.arr_quests
        LxDialogService.close id
        return
      return
    
    setLead = (modal_id, choice_id, lead_type, quest, result, belongs_to) ->
      lead_id = null

      if lead_type == 'quest'
        if quest == undefined || quest == null
          return
        lead_id = quest.id

      if lead_type == 'result'
        if result == undefined || result == null
          return
        lead_id = result.id

      QuestionStore.set_lead choice_id, lead_type, lead_id, belongs_to, () ->
        vm.arr_quests = QuestionStore.arr_quests
        LxDialogService.close modal_id
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

    rootQuest = (modal_id, quest_id) ->
      QuestionStore.set_root quest_id, () ->
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