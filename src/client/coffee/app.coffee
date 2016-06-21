config = (apiUrl, $routeProvider, LoopBackResourceProvider) ->
  LoopBackResourceProvider.setUrlBase(apiUrl)
  LoopBackResourceProvider.setAuthHeader('X-Access-Token')

  $routeProvider
    .when('/', {
      templateUrl: 'partials/todo.html'
      controller: 'MainController'
      controllerAs: 'vm'
    })
    .when('/signup', {
      templateUrl: 'partials/signup.html'
      controller: 'SignupController'
      controllerAs: 'vm'
    })
    .when('/login', {
      templateUrl: 'partials/login.html'
      controller: 'LoginController'
      controllerAs: 'vm'
    })
    .otherwise({
      redirectTo: '/'
    })

run = ($rootScope, $location, Account, LoopBackAuth) ->
  loginCheck = ->
    restrected = ['/signup', '/login'].indexOf($location.path()) == -1
    if restrected && !Account.isAuthenticated()
      return $location.path('/login')
    if !restrected && Account.isAuthenticated()
      return $location.path('/')

  Account
    .getCurrent()
    .$promise
    .then(->
      $rootScope.loggedIn = true
    )
    .catch(->
      LoopBackAuth.clearUser()
      LoopBackAuth.clearStorage()
    )
    .finally(->
      $rootScope.$on('$locationChangeStart', loginCheck)
      loginCheck()
    )

angular
  .module('todoApp', ['todoApp.config', 'lbServices', 'ngRoute'])
  .config(['apiUrl', '$routeProvider', 'LoopBackResourceProvider', config])
  .run(['$rootScope', '$location', 'Account', 'LoopBackAuth', run])
