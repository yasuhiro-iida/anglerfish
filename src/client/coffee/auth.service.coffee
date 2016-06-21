authService = ($rootScope, Account) ->
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
  }

angular
  .module('todoApp')
  .factory('authService', ['$rootScope', 'Account', authService])
