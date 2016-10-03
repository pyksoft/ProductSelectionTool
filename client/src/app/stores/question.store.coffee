angular.module 'productSelector'
  .service 'QuestionStore', (QuestionConnector) ->
    srv = this
    @arr_quests = []
    @synched = false

    @pushQuest = (obj_quest) ->
      @arr_quests.push obj_quest
      return

    @removeQuest = (quest_id) ->
      for quest, i in @arr_quests
        if quest.id == quest_id
          @arr_quests.splice i, 1
          break

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

    @add = (title, callback) ->
      new QuestionConnector(question: {title: title}).$save (quest) ->
        srv.pushQuest quest
        callback()
        return
      return

    @delete = (id, callback) ->
      QuestionConnector.remove {quest_id: id}, () ->
        srv.removeQuest id
        callback()
        return
      return

    return