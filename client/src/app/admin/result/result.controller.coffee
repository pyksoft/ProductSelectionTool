angular.module 'productSelector'
  .controller 'AdminResultController', (ResultStore, LxDialogService, LxNotificationService) ->
    'ngInject'
    vm = this
    vm.expanded_result_id = null

    vm.modals =
      result_new:
        title: ''
        url: ''
        confirm: (id) -> addResult(id, @title, @url)
      item_edit:
        item: ''
        result_id: ''
        confirm: (dialog_id) -> editItem(dialog_id, @result_id, @item)
      item_new:
        item_no: ''
        description: ''
        reactions: ''
        result_id: ''
        confirm: (dialog_id) -> addItem(dialog_id, @result_id, {item_no: @item_no, description: @description, reactions: @reactions})
      delete_confirm:
        subject: ''
        confirm: (id) -> deleteResult(id, @subject)
      delete_item:
        item: ''
        result_id: ''
        confirm: (dialog_id) -> deleteItem(dialog_id, @item, @result_id)
      edit:
        subject: ''
        title: ''
        url: ''
        result_id: ''
        confirm: (id) -> changeResult(id, @result_id, @title, @url)

    vm.expandResult = (result) ->
      if result.id == vm.expanded_result_id
        vm.expanded_result_id = null
      else
        vm.expanded_result_id = result.id

      return

    vm.openDialog = (id, param1 = null, param2 = null) ->
      if id == 'dialog-new-result'
        vm.modals.result_new.title = vm.modals.result_new.url = ''
      if id == 'dialog-delete-confirm'
        vm.modals.delete_confirm.subject = param1
      if id == 'dialog-delete-item'
        vm.modals.delete_item.item = param1
        vm.modals.delete_item.result_id = param2
      if id == 'dialog-new-item'
        vm.modals.item_new.result_id = param1.id
        vm.modals.item_new.item_no = ''
        vm.modals.item_new.description = ''
        vm.modals.item_new.reactions = ''
      if id == 'dialog-edit'
        vm.modals.edit.subject = param1.title
        vm.modals.edit.title = param1.title
        vm.modals.edit.url = param1.url
        vm.modals.edit.result_id = param1.id
      if id == "dialog-edit-item"
        vm.modals.item_edit.item = {}
        angular.copy(param1, vm.modals.item_edit.item)
        vm.modals.item_edit.result_id = param2

      LxDialogService.open(id)
      return

    ResultStore.init () ->
      vm.arr_results = ResultStore.arr_results
      return

    addResult = (id, title, url) ->
      ResultStore.add title, url, () ->
        vm.arr_results = ResultStore.arr_results
        LxDialogService.close id
        return
      return

    changeResult = (modal_id, result_id, title, url) ->
      ResultStore.update result_id, title, url, () ->
        vm.arr_results = ResultStore.arr_results
        LxDialogService.close modal_id
        return
      return

    deleteResult = (modal_id, result) ->
      ResultStore.delete result.id, () ->
        vm.arr_results = ResultStore.arr_results
        LxDialogService.close modal_id
        return

    addItem = (modal_id, result_id, item) ->
      ResultStore.add_item result_id, item, () ->
        vm.arr_results = ResultStore.arr_results
        LxDialogService.close modal_id
        return
      return

    deleteItem = (modal_id, item, result_id) ->
      ResultStore.delete_item result_id, item.id, () ->
        vm.arr_results = ResultStore.arr_results
        LxDialogService.close modal_id
        return
      return

    editItem = (modal_id, result_id, item) ->
      ResultStore.update_item result_id, item, () ->
        vm.arr_results = ResultStore.arr_results
        LxDialogService.close modal_id
        return
      return

    return