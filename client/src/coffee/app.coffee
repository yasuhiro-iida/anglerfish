LoopBackResourceProvider = (LoopBackResourceProvider) ->
  LoopBackResourceProvider.setUrlBase('http://localhost:3000/api')

routeProvider = ($routeProvider) ->
  $routeProvider
    .when('/', {
      templateUrl: 'partials/todo.html'
      controller: 'MainController'
    })
    .when('/signup', {
      templateUrl: 'partials/signup.html'
    })
    .when('/login', {
      templateUrl: 'partials/login.html'
    })
    .otherwise({
      redirectTo: '/'
    })

angular
  .module('todoApp', ['lbServices', 'ngRoute'])
  .config(['LoopBackResourceProvider', LoopBackResourceProvider])
  .config(['$routeProvider', routeProvider])
