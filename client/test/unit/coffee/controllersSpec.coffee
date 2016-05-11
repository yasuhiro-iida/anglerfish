describe 'todoControllerモジュールのテスト', ->

  $scope = $controller = $rootScope = todos = undefined

  beforeEach module 'todoApp'

  beforeEach inject (_$controller_, _$rootScope_, _todos_) ->
    $controller = _$controller_
    $rootScope = _$rootScope_
    $scope = $rootScope.$new()
    todos = _todos_

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

    it '$scope.filterとtodos.filterが同じオブジェクト', ->
      expect($scope.filter).toEqual todos.filter

    it '全部/未了/完了タスク数が適切である', ->
      $rootScope.$digest()

      expect($scope.allCount).toBe 0
      expect($scope.doneCount).toBe 0
      expect($scope.remainingCount).toBe 0

      todos.add 'foo'
      todos.add 'bar'
      todos.add 'baz'
      $rootScope.$digest()

      expect($scope.allCount).toBe 3
      expect($scope.doneCount).toBe 0
      expect($scope.remainingCount).toBe 3

    it 'checkAll 未了タスクなし', ->
      spyOn todos, 'changeState'
      $rootScope.$digest()
      $scope.checkAll()

      expect(todos.changeState).toHaveBeenCalledWith false

    it 'checkAll 未了タスクあり', ->
      spyOn todos, 'changeState'
      todos.add 'foo'
      $rootScope.$digest()
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

      fooTodo.title = 'changed'
      validForm = $invalid: false

      $scope.doneEdit validForm

      expect(fooTodo.title).toBe 'changed'

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
