angular.module 'productSelector'
  .controller 'AdminResultController', (ResultStore, LxDialogService, LxNotificationService) ->
    'ngInject'
    vm = this

    vm.modals =
      result_new:
        title: ''
        url: ''
        confirm: (id) -> addResult(id, @title, @url)
      delete_confirm:
        subject: ''
        confirm: (id) -> deleteResult(id, @subject)
      edit:
        subject: ''
        title: ''
        url: ''
        result_id: ''
        confirm: (id) -> changeResult(id, @result_id, @title, @url)

    vm.openDialog = (id, param1 = null) ->
      if id == 'dialog-new-result'
        vm.modals.result_new.title = vm.modals.result_new.url = ''
      if id == 'dialog-delete-confirm'
        vm.modals.delete_confirm.subject = param1
      if id == 'dialog-edit'
        vm.modals.edit.subject = param1.title
        vm.modals.edit.title = param1.title
        vm.modals.edit.url = param1.url
        vm.modals.edit.result_id = param1.id

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

    return