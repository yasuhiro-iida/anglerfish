class SignupController
  constructor: (@$scope, @$location, @authService) ->
    @email = ''
    @password = ''

  signup: ->
    @authService.signup(@email, @password, (err, data) =>
      if err
        console.error(err)
        return @$location.path('/signup')

      @$location.path('/login')
    )

class LoginController
  constructor: (@$scope, @$rootScope, @$location, @authService) ->
    @email = ''
    @password = ''

  login: ->
    @authService.login(@email, @password, (err, data) =>
      if err
        console.error(err)
        return @$location.path('/login')

      @$rootScope.loggedIn = true
      @$location.path('/')
    )

class LogoutController
  constructor: (@$scope, @$rootScope, @$location, @authService) ->

  logout: ->
    @authService.logout((err, data) =>
      if err
        console.error(err)
        return

      delete @$rootScope.loggedIn
      @$location.path('/login')
    )

angular
  .module('todoApp')
  .controller('SignupController', ['$scope', '$location', 'authService', SignupController])
  .controller('LoginController', ['$scope', '$rootScope', '$location', 'authService', LoginController])
  .controller('LogoutController', ['$scope', '$rootScope', '$location', 'authService', LogoutController])
