todoService = ($rootScope, $filter, $log, Account, authService) ->
  currentUser = $rootScope.currentUser
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
        .todos({id: currentUser.userId})
        .$promise

    add: (title) ->
      Account
        .todos
        .create({id: currentUser.userId}, {title: title, done: false})
        .$promise

    getDone: (todoList) ->
      where(todoList, done)

    update: (todo) ->
      Account
        .todos
        .updateById({id: currentUser.userId, fk: todo.id}, todo)
        .$promise

    remove: (todo) ->
      Account
        .todos
        .destroyById({id: currentUser.userId}, {fk: todo.id})
        .$promise
  }

angular
  .module('todoApp')
  .factory('todoService', ['$rootScope', '$filter', '$log', 'Account', 'authService', todoService])
