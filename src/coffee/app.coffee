angular.module('App', [])

  .controller('MainController', ['$scope', '$filter', ($scope, $filter) ->
    $scope.todos = []
    $scope.newTitle = ''
    $scope.addTodo = ->
      $scope.todos.push { title: $scope.newTitle, done: false }
      $scope.newTitle = ''

    $scope.filter =
      done:
        done: true
      remaining:
        done: false

    $scope.currentFilter = null

    $scope.changeFilter = (filter) ->
      $scope.currentFilter = filter

    where = $filter 'filter'
    $scope.$watch 'todos', (todos) ->
      length = todos.length

      $scope.allCount = length
      $scope.doneCount = where(todos, $scope.filter.done).length
      $scope.remainingCount = length - $scope.doneCount
    , true

    originalTitle = null
    $scope.editing = null

    $scope.editTodo = (todo) ->
      originalTitle = todo.title
      $scope.editing = todo

    $scope.doneEdit = (todoForm) ->
      $scope.editing.title = originalTitle if todoForm.$invalid
      $scope.editing = originalTitle = null
  ])

  .directive('mySelect', ->
    link = (scope, element, attrs) ->
      scope.$watch attrs.mySelect, (value) ->
        element[0].select() if value

    { link: link }
  )
