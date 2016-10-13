angular.module 'productSelector'
  .factory 'QuestionConnector', ($resource) ->
    return $resource '/api/questions/:quest_id', {quest_id: '@id'},
      update:
        method: 'PUT'
  .factory 'ChoiceConnector', ($resource) ->
    return $resource '/api/choices/:choice_id', {choice_id: '@id'},
      update:
        method: 'PUT'
  .factory 'ResultConnector', ($resource) ->
    return $resource '/api/results/:result_id', {result_id: '@id'},
      update:
        method: 'PUT'
  .factory 'RequestConnector', ($resource) ->
    return {
      recommend: $resource '/api/requests/recommend'
      inquire: $resource '/api/requests/inquire'
    }