todoService = ($rootScope, $filter, $log, Account, authService) ->
  where = $filter('filter')
  done = { done: true }
  remaining = { done: false }

  errorHandler = (err) ->
    $log.error(err)

  return {
    filter: {
      done: done
      remaining: remaining
    }

    getTodoList: (callback) ->
      Account
        .todos({id: Account.getCurrentId()})
        .$promise

    add: (title) ->
      Account
        .todos
        .create({id: Account.getCurrentId()}, {title: title, done: false, registeredAt: new Date()})
        .$promise

    getDone: (todoList) ->
      where(todoList, done)

    update: (todo) ->
      Account
        .todos
        .updateById({id: Account.getCurrentId(), fk: todo.id}, todo)
        .$promise

    remove: (todo) ->
      Account
        .todos
        .destroyById({id: Account.getCurrentId()}, {fk: todo.id})
        .$promise
  }

angular
  .module('todoApp')
  .factory('todoService', ['$rootScope', '$filter', '$log', 'Account', 'authService', todoService])
