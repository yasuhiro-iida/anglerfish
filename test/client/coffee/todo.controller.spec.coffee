describe('ToDoコントローラのテスト', ->

  $scope = $controller = $rootScope = $httpBackend = $q = todoService = mainCtrl = undefined

  beforeEach(module('todoApp'))

  beforeEach(inject((_$controller_, _$rootScope_, _$httpBackend_, _$q_, _todoService_) ->
    $controller = _$controller_
    $rootScope = _$rootScope_
    $httpBackend = _$httpBackend_
    $q = _$q_
    todoService = _todoService_
  ))

  beforeEach(->
    defered = $q.defer()
    promise = defered.promise
    defered.resolve([])
    spyOn(todoService, 'getTodoList').and.returnValue(promise)

    $scope = $rootScope.$new()
    $controller('MainController as vm', {$scope: $scope})
  )

  it('RegisterController', ->
    childScope = $scope.$new()
    ctrl = $controller('RegisterController as registCtrl', {$scope: childScope})
    expect(ctrl.newTitle).toBe('')

    newTitle = 'new'
    addedTodo = {title: newTitle}
    defered = $q.defer()
    promise = defered.promise
    defered.resolve(addedTodo)
    spyOn(todoService, 'add').and.returnValue(promise)

    ctrl.newTitle = newTitle
    ctrl.addTodo()

    expect(todoService.add).toHaveBeenCalledWith(newTitle)
    expect(ctrl.newTitle).toBe('')

    $rootScope.$digest()
    expect($scope.vm.todoList[0]).toBe(addedTodo)
  )

  describe('TodoListController', ->
    ctrl = undefined

    beforeEach(->
      childScope = $scope.$new()
      ctrl = $controller('TodoListController as listCtrl', {$scope: childScope})
    )

    it('doneEditでフォームが不正な場合', ->
      ctrl.originalTitle = 'original'
      ctrl.editing = {
        title: 'invalid'
        done: false
      }
      dummyForm = {$invalid: true}

      ctrl.doneEdit(dummyForm)
      expect(ctrl.originalTitle).toBe('')
      expect(ctrl.editing).toEqual({})
    )

    it('doneEditでToDoが編集された場合', ->
      todo = {
        title: 'foo'
        done: false
      }
      ctrl.editing = todo
      dummyForm = {
        $invalid: false
        $setPristine: ->
      }
      spyOn(todoService, 'update')
      spyOn(dummyForm, '$setPristine')

      ctrl.doneEdit(dummyForm)
      expect(todoService.update).toHaveBeenCalledWith({title: 'foo', done: false})
      expect(dummyForm.$setPristine).toHaveBeenCalled()
      expect(ctrl.originalTitle).toBe('')
      expect(ctrl.editing).toEqual({})
    )
  )

)
