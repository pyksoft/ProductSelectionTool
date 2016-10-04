angular.module 'productSelector'
  .service 'QuestionStore', (QuestionConnector, ChoiceConnector) ->
    srv = this
    @arr_quests = []
    @synched = false

    @pushQuest = (obj_quest) ->
      @arr_quests.push obj_quest
      return

    @getQuest = (quest_id) ->
      for quest, i in @arr_quests
        if quest.id == quest_id
          return quest
      return null

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

    @add_choice = (quest_id, title, callback) ->
      new ChoiceConnector(choice: {title: title}, question_id: quest_id).$save (choice) ->
        quest = srv.getQuest quest_id
        quest.choices.push choice
        callback()
        return
      return

    @delete = (id, callback) ->
      QuestionConnector.remove {quest_id: id}, () ->
        srv.removeQuest id
        callback()
        return
      return

    @delete_choice = (quest_id, id, callback) ->
      ChoiceConnector.remove {choice_id: id}, () ->
        quest = srv.getQuest quest_id
        for choice, i in quest.choices
          if choice.id == id
            quest.choices.splice i, 1
            break
        callback()
        return
      return
    
    @update = (quest_id, title, callback) ->
      new QuestionConnector(question: {title: title}).$update {quest_id: quest_id}, () ->
        quest = srv.getQuest quest_id
        quest.title = title
        callback()
        return
      return

    @update_choice = (quest_id, choice_id, title, callback) ->
      new ChoiceConnector(choice: {title: title}).$update {choice_id: choice_id}, () ->
        quest = srv.getQuest quest_id
        for choice, i in quest.choices
          if choice.id == choice_id
            quest.choices[i].title = title
            break
        callback()
        return
      return

    return