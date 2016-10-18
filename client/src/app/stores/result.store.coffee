angular.module 'productSelector'
  .service 'ResultStore', (ResultConnector, ItemConnector, ChoiceConnector) ->
    srv = this
    @arr_results = []
    @synched = false

    @pushResult = (obj_result) ->
      @arr_results.push obj_result
      return

    @getResult = (result_id) ->
      for result, i in @arr_results
        if result.id == result_id
          return result
      return null

    @removeResult = (result_id) ->
      for result, i in @arr_results
        if result.id == result_id
          @arr_results.splice i, 1
          break

    @init = (callback) ->
      if @synched
        callback()
        return

      ResultConnector.query {}, (res) ->
        angular.forEach res, (result) ->
          srv.pushResult JSON.parse(JSON.stringify(result))
          return
        srv.synched = true
        callback()
      return

    @add = (title, url, callback) ->
      new ResultConnector(result: {title: title, url: url}).$save (result) ->
        srv.pushResult result
        callback()
        return
      return

    @add_item = (result_id, item, callback) ->
      new ItemConnector(item: item, result_id: result_id).$save (item) ->
        result = srv.getResult result_id
        result.items.push item
        callback()
        return
      return
    
    @update = (id, title, url, callback) ->
      new ResultConnector(result: {title: title, url: url}).$update {result_id: id}, () ->
        result = srv.getResult id
        result.title = title
        result.url = url
        callback()
        return
      return

    @delete = (id, callback) ->
      ResultConnector.remove {result_id: id}, () ->
        srv.removeResult id
        callback()
        return
      return

    @delete_item = (result_id, id, callback) ->
      ItemConnector.remove {item_id: id}, () ->
        result = srv.getResult result_id
        for item, i in result.items
          if item.id == id
            result.items.splice i, 1
            break
        callback()
      return

    @update_item = (result_id, item, callback) ->
      new ItemConnector(item: item).$update {item_id: item.id}, () ->
        result = srv.getResult result_id
        for _item, i in result.items
          if _item.id == item.id
            result.items[i].item_no = item.item_no
            result.items[i].description = item.description
            result.items[i].reactions = item.reactions
            break
        callback()
        return
      return
    return