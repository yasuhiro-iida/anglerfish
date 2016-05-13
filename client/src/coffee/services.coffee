angular.module 'todoApp'

.factory 'todos', ['$rootScope', '$filter', 'ToDo', ($scope, $filter, ToDo) ->
  list = ToDo.find()

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
    list.push ToDo.create { title: title, done: false }
  update: (todo) ->
    todo.$save()
  remove: (currentTodo) ->
    ToDo.deleteById id: currentTodo.id
      .$promise
      .then ->
        list = where list, (todo) ->
          currentTodo != todo
  removeDone: ->
    doneList = where list, done
    for doneTodo in doneList
      do (doneTodo) ->
        ToDo.deleteById id: doneTodo.id
          .$promise
          .then ->
            list = where list, (todo) ->
              todo.id != doneTodo.id
  changeState: (state) ->
    for todo in list
      do (state) ->
        todo.done = state
        todo.$save()
]
