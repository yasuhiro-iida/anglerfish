angular.module('App', [])
  .controller('MainController', ['$scope', ($scope) ->
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
  ])

