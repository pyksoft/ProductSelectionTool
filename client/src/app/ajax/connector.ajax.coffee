angular.module 'productSelector'
  .factory 'QuestionConnector', ($resource) ->
    return $resource '/api/questions/:quest_id', {quest_id: '@id'},
      update:
        method: 'PUT'