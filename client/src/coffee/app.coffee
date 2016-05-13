angular.module('todoApp', [
  'lbServices',
  'todoService',
  'todoController',
  'todoDirective'
])

.config (LoopBackResourceProvider) ->
  LoopBackResourceProvider.setUrlBase 'http://localhost:3000/api'
