angular.module 'productSelector'
  .service 'ResultStore', (ResultConnector, ChoiceConnector) ->
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

    return