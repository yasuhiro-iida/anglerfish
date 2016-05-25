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

)
