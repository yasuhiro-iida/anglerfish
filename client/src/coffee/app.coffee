config = ($routeProvider, LoopBackResourceProvider) ->
  LoopBackResourceProvider.setUrlBase('http://localhost:3000/api')
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

run = ($rootScope, $location, $localStorage) ->
  $rootScope.currentUser = $localStorage.currentUser || null

  $rootScope.$on('$locationChangeStart', (event, newUrl, oldUrl) ->
    restrected = ['/signup', '/login'].indexOf($location.path()) == -1
    if restrected && !$rootScope.currentUser
      return $location.path('/login')
    if !restrected && $rootScope.currentUser
      $location.path('/')
  )

angular
  .module('todoApp', ['lbServices', 'ngRoute', 'ngStorage'])
  .config(['$routeProvider', 'LoopBackResourceProvider', config])
  .run(['$rootScope', '$location', '$localStorage', run])
