###
# 関数形式での書き方
LoginController = ($scope, $location, authService) ->
  init = =>
    @email = ''
    @password = ''
    @login = login

  login = =>
    authService.login(@email, @password, (err) ->
      if !err
        $location.path('/')
      else
        console.log(err)
    )

  init()
  return
###

# クラス（コンストラクタ関数）形式での書き方
class LoginController
  constructor: (@$scope, @$location, @authService) ->
    @email = ''
    @password = ''

  login: ->
    @authService.login(@email, @password, (err, data) =>
      if err
        console.error(err)
        return

      @authService.storeAccessToken(data.id, data.userId)
      @$location.path('/')
    )

angular
  .module('todoApp')
  .controller('LoginController',
    ['$scope', '$location', 'authService', LoginController])
