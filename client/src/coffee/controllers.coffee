angular.module('todoController', [])

.controller('RegisterController', ['$scope', 'todos', ($scope, todos) ->
  $scope.newTitle = ''

  $scope.addTodo = ->
    todos.add $scope.newTitle
    $scope.newTitle = ''
])

.controller('ToolbarController', ['$scope', 'todos', ($scope, todos) ->
  $scope.filter = todos.filter

  $scope.$on 'change:list', (evt, list) ->
    length = list.length
    doneCount = todos.getDone().length

    $scope.allCount = length
    $scope.doneCount = doneCount
    $scope.remainingCount = length - doneCount

  $scope.checkAll = ->
    todos.changeState !!$scope.remainingCount

  $scope.changeFilter = (filter) ->
    $scope.$emit 'change:filter', filter

  $scope.removeDoneTodo = ->
    todos.removeDone()
])

.controller('TodoListController', ['$scope', 'todos', ($scope, todos) ->
  $scope.$on 'change:list', (evt, list) ->
    $scope.todoList = list

  originalTitle = null
  $scope.editing = null

  $scope.editTodo = (todo) ->
    originalTitle = todo.title
    $scope.editing = todo

  $scope.doneEdit = (todoForm) ->
    $scope.editing.title = originalTitle if todoForm.$invalid
    $scope.editing = originalTitle = null

  $scope.removeTodo = (todo) ->
    todos.remove(todo)
])

.controller('MainController', ['$scope', ($scope) ->
  $scope.currentFilter = null

  $scope.$on 'change:filter', (evt, filter) ->
    $scope.currentFilter = filter
])

.directive('mySelect', ->
  link = (scope, element, attrs) ->
    scope.$watch attrs.mySelect, (value) ->
      element[0].select() if value

  { link: link }
)
