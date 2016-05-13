mySelect = ->
  link = (scope, element, attrs) ->
    scope.$watch(attrs.mySelect, (value) ->
      element[0].select() if value
    )

  { link: link }

angular
  .module('todoApp')
  .directive('mySelect', mySelect)
