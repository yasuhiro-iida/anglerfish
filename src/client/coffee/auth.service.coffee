authService = ($rootScope, $localStorage, Account) ->
  return {
    signup: (email, password, callback) ->
      credentials = {
        email: email
        password: password
      }

      Account.create(credentials, (data) ->
        callback(null, data)
      , (err) ->
        callback(err)
      )

    login: (email, password, callback) ->
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
      Account.login(credentials, (data) ->
        callback(null, data)
      , (err) ->
        callback(err)
      )

    logout: (callback) ->
      Account.logout((data) ->
        callback(null, data)
      , (err) ->
        callback(err)
      )

    storeAccessToken: (accessToken, userId) ->
      currentUser = {
        userId: userId
        accessToken: accessToken
      }

      $localStorage.currentUser = currentUser
      $rootScope.currentUser = currentUser

    clearAccessToken: ->
      delete $localStorage.currentUser
      $rootScope.currentUser = null

    getCurrentAccount: (callback) ->
      Account.getCurrent((data) ->
        callback(null, data)
      , (err) ->
        callback(err)
      )
  }

angular
  .module('todoApp')
  .factory('authService', ['$rootScope', '$localStorage', 'Account', authService])
