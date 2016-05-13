todos = ($scope, $filter, ToDo) ->
  list = ToDo.find()
  where = $filter('filter')
  done = done: true
  remaining = done: false

  $scope.$watch(
    ->
      list
    , (value) ->
      $scope.$broadcast('change:list', value)
    , true
  )

  getDone = ->
    where(list, done)

  add = (title) ->
    list.push(ToDo.create({ title: title, done: false }))

  update = (todo) ->
    todo.$save()

  remove = (currentTodo) ->
    ToDo.deleteById(id: currentTodo.id)
      .$promise
      .then(->
        list = where(list, (todo) ->
          currentTodo != todo
        )
      )

  removeDone = ->
    doneList = where(list, done)
    for doneTodo in doneList
      do (doneTodo) ->
        ToDo.deleteById(id: doneTodo.id)
          .$promise
          .then(->
            list = where(list, (todo) ->
              todo.id != doneTodo.id
            )
          )

  changeState = (state) ->
    for todo in list
      do (state) ->
        todo.done = state
        todo.$save()

  filter:
    done: done
    remaining: remaining
  getDone: getDone
  add: add
  update: update
  remove: remove
  removeDone: removeDone
  changeState: changeState

angular
  .module('todoApp')
  .factory('todos', ['$rootScope', '$filter', 'ToDo', todos])
