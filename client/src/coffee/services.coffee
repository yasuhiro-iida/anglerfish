todos = ($rootScope, $filter, $log, ToDo) ->
  where = $filter('filter')
  done = { done: true }
  remaining = { done: false }

  errorHandler = (err) ->
    $log.error(err)

  list = ToDo
    .find({}, ->
      return
    , errorHandler)

  $rootScope.$watch(
    ->
      list
    , (value) ->
      $rootScope.$broadcast('change:list', value)
    , true
  )

  getDone = ->
    where(list, done)

  add = (title) ->
    ToDo
      .create({ title: title, done: false })
      .$promise
      .then((response) ->
        list.push(response)
      )
      .catch(errorHandler)

  update = (todo) ->
    todo
      .$save()
      .then(->
        return
      )
      .catch(errorHandler)

  remove = (currentTodo) ->
    ToDo
      .deleteById({ id: currentTodo.id })
      .$promise
      .then(->
        list = where(list, (todo) ->
          currentTodo != todo
        )
      )
      .catch(errorHandler)

  removeDone = ->
    doneList = where(list, done)
    for doneTodo in doneList
      do (doneTodo) ->
        ToDo
          .deleteById({ id: doneTodo.id })
          .$promise
          .then(->
            list = where(list, (todo) ->
              todo.id != doneTodo.id
            )
          )
          .catch(errorHandler)

  changeState = (state) ->
    for todo in list
      do (state) ->
        todo.done = state
        todo
          .$save()
          .$promise
          .catch(errorHandler)

  filter:
    done: done
    remaining: remaining
  getDone: getDone
  add: add
  update: update
  remove: remove
  removeDone: removeDone
  changeState: changeState

authService = ($rootScope, $localStorage, User) ->
  signup = (email, password, callback) ->
    credentials = {
      email: email
      password: password
    }

    User.create(credentials, (data) ->
      callback(null, data)
    , (err) ->
      callback(err)
    )

  login = (email, password, callback) ->
    credentials = {
      email: email
      password: password
    }

    ###
      ここではLoopBackのAngularSDKを利用している。
      UserサービスにはRESTクライアントとしての機能が備わっており、
      その中の一つにloginメソッドがある。
      login()はemail/passwordのcredentialsと、コールバック関数を引数にとる。
      ログインに成功した場合、dataにはアクセストークンを含むオブジェクトが格納される。
      失敗した場合、errにはエラーオブジェクトが格納される。
    ###
    User.login(credentials, (data) ->
      callback(null, data)
    , (err) ->
      callback(err)
    )

  logout = (callback) ->
    User.logout((data) ->
      callback(null, data)
    , (err) ->
      callback(err)
    )

  storeAccessToken = (accessToken, userId) ->
    currentUser = {
      userId: userId
      accessToken: accessToken
    }

    $localStorage.currentUser = currentUser
    $rootScope.currentUser = currentUser

  clearAccessToken = ->
    delete $localStorage.currentUser
    $rootScope.currentUser = null

  signup: signup
  login: login
  logout: logout
  storeAccessToken: storeAccessToken
  clearAccessToken: clearAccessToken

angular
  .module('todoApp')
  .factory('todos', ['$rootScope', '$filter', '$log', 'ToDo', todos])
  .factory('authService', ['$rootScope', '$localStorage', 'User', authService])
