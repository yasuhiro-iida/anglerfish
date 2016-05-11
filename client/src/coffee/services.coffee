angular.module('todoService', [])

.factory('todos', ['$rootScope', '$filter', ($scope, $filter) ->
  list = []

  $scope.$watch ->
    list
  , (value) ->
    $scope.$broadcast 'change:list', value
  , true

  where = $filter 'filter'
  done = { done: true }
  remaining = { done: false }

  filter:
    done: done
    remaining: remaining
  getDone: ->
    where list, done
  add: (title) ->
    list.push { title: title, done: false }
  remove: (currentTodo) ->
    list = where list, (todo) ->
      currentTodo != todo
  removeDone: ->
    list = where list, remaining
  changeState: (state) ->
    angular.forEach list, (todo) ->
      todo.done = state
])
