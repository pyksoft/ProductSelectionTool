angular.module 'productSelector'
  .service 'QuestionStore', (QuestionConnector) ->
    srv = this
    @arr_quests = []
    @synched = false

    @pushQuest = (obj_quest) ->
      @arr_quests.push obj_quest
      return

    @init = (callback) ->
      if @synched
        callback()
        return

      QuestionConnector.query {}, (result) ->
        angular.forEach result, (quest) ->
          srv.pushQuest JSON.parse(JSON.stringify(quest))
          return
        srv.synched = true
        callback()
      return

    return