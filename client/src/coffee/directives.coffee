angular.module('todoDirective', [])

.directive('mySelect', ->
  link = (scope, element, attrs) ->
    scope.$watch attrs.mySelect, (value) ->
      element[0].select() if value

  { link: link }
)
