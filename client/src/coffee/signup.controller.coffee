class SignupController
  constructor: (@$scope, @$location, @authService) ->
    @email = ''
    @password = ''

  signup: ->
    @authService.signup(@email, @password, (err, data) =>
      if err
        console.error(err)
        return

      @$location.path('/login')
    )

angular
  .module('todoApp')
  .controller('SignupController',
    ['$scope', '$location', 'authService', SignupController])

