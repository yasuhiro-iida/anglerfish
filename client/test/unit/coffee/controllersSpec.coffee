describe 'todoControllerモジュールのテスト', ->

  $scope = $controller = $rootScope = $httpBackend = todos = undefined

  beforeEach module 'todoApp'

  beforeEach inject (_$controller_, _$rootScope_, _$httpBackend_, _todos_) ->
    $controller = _$controller_
    $rootScope = _$rootScope_
    $scope = $rootScope.$new()
    $httpBackend = _$httpBackend_
    todos = _todos_

  expectTodoAdd = (title, id) ->
    todo = { title: title, done: false }
    $httpBackend.expectPOST 'http://localhost:3000/api/ToDos', todo
      .respond angular.extend id: id, todo

  expectTodoGet = (response) ->
    response = response || [
        { id: 1, title: 'foo', done: false }
        { id: 2, title: 'bar', done: true }
        { id: 3, title: 'baz', done: false }
      ]

    $httpBackend.expectGET 'http://localhost:3000/api/ToDos'
      .respond response

  it 'RegisterController', ->
    $controller 'RegisterController', $scope: $scope

    expect($scope.newTitle).toBe ''

    spyOn todos, 'add'

    $scope.newTitle = 'new'
    $scope.addTodo()

    expect(todos.add).toHaveBeenCalledWith('new')
    expect($scope.newTitle).toBe ''

  describe 'ToolbarController', ->

    beforeEach ->
      $controller 'ToolbarController', $scope: $scope

    afterEach ->
      # $httpBackend.verifyNoOutstandingExpectation()
      # $httpBackend.verifyNoOutstandingRequest()

    it '$scope.filterとtodos.filterが同じオブジェクト', ->
      expect($scope.filter).toEqual todos.filter

    it '全部/未了/完了タスク数が適切である', ->
      expectTodoGet()
      $httpBackend.flush()
      expect($scope.allCount).toBe 3
      expect($scope.doneCount).toBe 1
      expect($scope.remainingCount).toBe 2

      expectTodoAdd 'qux', 4
      todos.add 'qux'
      $httpBackend.flush()
      expect($scope.allCount).toBe 4
      expect($scope.doneCount).toBe 1
      expect($scope.remainingCount).toBe 3

    it 'checkAll 未了タスクなし', ->
      spyOn todos, 'changeState'
      expectTodoGet [ id: 1, title: 'foo', done: true ]
      $httpBackend.flush()
      $scope.checkAll()

      expect(todos.changeState).toHaveBeenCalledWith false

    it 'checkAll 未了タスクあり', ->
      spyOn todos, 'changeState'
      expectTodoGet()
      $httpBackend.flush()
      $scope.checkAll()

      expect(todos.changeState).toHaveBeenCalledWith true

    it 'changeFilterは change:filter イベントを発火する', ->
      spyOn $scope, '$emit'

      $scope.changeFilter 'foo'
      expect($scope.$emit).toHaveBeenCalledWith 'change:filter', 'foo'

    it 'removeDoneTodo', ->
      spyOn todos, 'removeDone'
      $scope.removeDoneTodo()

      expect(todos.removeDone).toHaveBeenCalled()

  describe 'TodoListController', ->

    fooTodo = undefined

    beforeEach ->
      $controller 'TodoListController', $scope: $scope

      fooTodo = {
        title: 'foo'
        done: false
      }

    it 'editTodo', ->
      $scope.editTodo fooTodo

      expect($scope.editing).toBe fooTodo

    it 'doneEdit 正しいフォーム', ->
      $scope.editTodo fooTodo
      expect($scope.editing).toBe fooTodo

      spyOn todos, 'update'

      validForm = $invalid: false
      $scope.doneEdit validForm
      expect(todos.update).toHaveBeenCalledWith(fooTodo)

    it 'doneEdit 不正なフォーム', ->
      $scope.editTodo fooTodo

      expect($scope.editing).toBe fooTodo

      fooTodo.title = 'changed'
      invalidForm = $invalid: true

      $scope.doneEdit invalidForm

      expect(fooTodo.title).toBe 'foo'

    it 'removeTodo', ->
      spyOn todos, 'remove'
      $scope.removeTodo fooTodo

      expect(todos.remove).toHaveBeenCalledWith fooTodo

  it 'MainController', ->
    $controller 'MainController', $scope: $scope

    dummyFilter = {}
    $scope.$emit 'change:filter', dummyFilter

    expect($scope.currentFilter).toEqual dummyFilter
