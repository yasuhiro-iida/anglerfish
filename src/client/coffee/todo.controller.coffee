class RegisterController
  constructor: (@$scope, @todoService) ->
    @newTitle = ''

  addTodo: ->
    @todoService
      .add(@newTitle)
      .then((data) =>
        @$scope.$parent.vm.todoList.push(data)
      )
    @newTitle = ''

class ToolbarController
  constructor: (@$scope, @$filter, @todoService) ->
    @filter = @todoService.filter

    @$scope.$watch('vm.todoList', (todoList) =>
      length = todoList.length
      doneCount = @todoService.getDone(todoList).length

      @allCount = length
      @doneCount = doneCount
      @remainingCount = length - doneCount
    , true
    )

  checkAll: ->
    for todo in @$scope.$parent.vm.todoList
      todo.done = !!@remainingCount
      @todoService.update(todo)

  changeFilter: (filter) ->
    @$scope.$emit('change:filter', filter)

  removeDoneTodo: ->
    where = @$filter('filter')
    todoList = @$scope.$parent.vm.todoList
    doneList = where(todoList, @filter.done)

    for todo in doneList
      do (todo) =>
        @todoService
          .remove(todo)
          .then(->
            todoList.splice(todoList.indexOf(todo), 1)
          )
          .catch((err) ->
            console.log(err) if err
          )

class TodoListController
  constructor: (@$scope, @todoService) ->
    @originalTitle = ''
    @editing = {}

    @$scope.$on('change:list', (evt, list) =>
      @$scope.$parent.todoList = list
    )

  editTodo: (todo) ->
    @originalTitle = todo.title
    @editing = todo

  doneEdit: (todoForm) ->
    if todoForm.$invalid
      @editing.title = @originalTitle
    else
      @todoService.update(@editing)

    @originalTitle = ''
    @editing = {}

  removeTodo: (todo) ->
    todoList = @$scope.$parent.vm.todoList
    @todoService
      .remove(todo)
      .then(->
        todoList.splice(todoList.indexOf(todo), 1)
      )
      .catch((err) ->
        console.log(err) if err
      )

  check: (todo) ->
    @todoService.update(todo)

class MainController
  constructor: (@$scope, @todoService) ->
    @currentFilter = @todoService.filter.remaining
    @todoList = []

    @todoService.getTodoList()
      .then((data) =>
        @todoList = data
      )
      .catch((err) ->
        console.log(err) if err
      )

    @$scope.$on('change:filter', (evt, filter) =>
      @currentFilter = filter
    )

angular
  .module('todoApp')
  .controller('RegisterController', ['$scope', 'todoService', RegisterController])
  .controller('ToolbarController', ['$scope', '$filter', 'todoService', ToolbarController])
  .controller('TodoListController', ['$scope', 'todoService', TodoListController])
  .controller('MainController', ['$scope', 'todoService', MainController])
