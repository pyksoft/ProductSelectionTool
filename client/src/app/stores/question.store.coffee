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

    @getRootQuest = () ->
      for quest, i in @arr_quests
        if quest.is_root
          return quest
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

    @set_root = (quest_id, callback) ->
      new QuestionConnector(question: {is_root: true}).$update {quest_id: quest_id}, () ->
        for quest, i in srv.arr_quests
          if quest.id == quest_id
            quest.is_root = true
          else
            quest.is_root = false
        callback()
        return
      return

    @set_lead = (choice_id, lead_type, lead_id, belongs_to_id, callback) ->
      hash_updates = {lead_id: null, result_id: null}
      if lead_type == 'quest'
        hash_updates['lead_id'] = lead_id
      if lead_type == 'result'
        hash_updates['result_id'] = lead_id

      new ChoiceConnector(choice: hash_updates).$update {choice_id: choice_id}, () ->
        belonging_quest = srv.getQuest belongs_to_id
        for choice, i in belonging_quest.choices
          if choice.id == choice_id
            if lead_type == 'quest'
              belonging_quest.choices[i].lead = lead_id
            if lead_type == 'result'
              belonging_quest.choices[i].result = lead_id
            belonging_quest.choices[i].next = lead_type
            break
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