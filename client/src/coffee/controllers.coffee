RegisterController = ($scope, todos) ->
  $scope.newTitle = ''

  $scope.addTodo = ->
    todos.add($scope.newTitle)
    $scope.newTitle = ''

ToolbarController = ($scope, todos) ->
  $scope.filter = todos.filter

  $scope.$on('change:list', (evt, list) ->
    length = list.length
    doneCount = todos.getDone().length

    $scope.allCount = length
    $scope.doneCount = doneCount
    $scope.remainingCount = length - doneCount
  )

  $scope.checkAll = ->
    todos.changeState !!$scope.remainingCount

  $scope.changeFilter = (filter) ->
    $scope.$emit('change:filter', filter)

  $scope.removeDoneTodo = ->
    todos.removeDone()

TodoListController = ($scope, todos) ->
  $scope.$on('change:list', (evt, list) ->
    $scope.todoList = list
  )

  originalTitle = ''
  $scope.editing = {}

  $scope.editTodo = (todo) ->
    originalTitle = todo.title
    $scope.editing = todo

  $scope.doneEdit = (todoForm) ->
    if todoForm.$invalid
      $scope.editing.title = originalTitle
    else
      todos.update($scope.editing)

    originalTitle = ''
    $scope.editing = {}

  $scope.removeTodo = (todo) ->
    todos.remove(todo)

  $scope.check = (todo) ->
    todos.update(todo)

MainController = ($scope) ->
  $scope.currentFilter = ''

  $scope.$on 'change:filter', (evt, filter) ->
    $scope.currentFilter = filter

angular
  .module('todoApp')
  .controller('RegisterController', ['$scope', 'todos', RegisterController])
  .controller('ToolbarController', ['$scope', 'todos', ToolbarController])
  .controller('TodoListController', ['$scope', 'todos', TodoListController])
  .controller('MainController', ['$scope', MainController])
