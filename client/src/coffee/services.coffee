todos = ($scope, $filter, $log, ToDo) ->
  where = $filter('filter')
  done = { done: true }
  remaining = { done: false }

  errorHandler = (err) ->
    $log.error(err)

  list = ToDo
    .find({}, ->
      return
    , errorHandler)

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
    ToDo
      .create({ title: title, done: false })
      .$promise
      .then((response) ->
        list.push(response)
      )
      .catch(errorHandler)

  update = (todo) ->
    todo
      .$save()
      .then(->
        return
      )
      .catch(errorHandler)

  remove = (currentTodo) ->
    ToDo
      .deleteById({ id: currentTodo.id })
      .$promise
      .then(->
        list = where(list, (todo) ->
          currentTodo != todo
        )
      )
      .catch(errorHandler)

  removeDone = ->
    doneList = where(list, done)
    for doneTodo in doneList
      do (doneTodo) ->
        ToDo
          .deleteById({ id: doneTodo.id })
          .$promise
          .then(->
            list = where(list, (todo) ->
              todo.id != doneTodo.id
            )
          )
          .catch(errorHandler)

  changeState = (state) ->
    for todo in list
      do (state) ->
        todo.done = state
        todo
          .$save()
          .$promise
          .catch(errorHandler)

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
  .factory('todos', ['$rootScope', '$filter', '$log', 'ToDo', todos])
