angular
  .module('todoApp', ['lbServices'])
  .config((LoopBackResourceProvider) ->
    LoopBackResourceProvider.setUrlBase 'http://localhost:3000/api'
  )
