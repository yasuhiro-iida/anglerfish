class LogoutController
  constructor: (@$scope, @$location, @authService) ->

  logout: ->
    @authService.logout((err, data) =>
      if err
        console.error(err)
        return

      @authService.clearAccessToken()
      @$location.path('/login')
    )

angular
  .module('todoApp')
  .controller('LogoutController',
    ['$scope', '$location', 'authService', LogoutController])


