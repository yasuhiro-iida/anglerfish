angular.module('App', [])

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
