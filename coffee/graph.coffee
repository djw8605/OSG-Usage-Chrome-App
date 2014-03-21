

graphControllerModule = angular.module 'osgUsageApp.controller.graph', []

graphControllerModule.controller 'GraphContoller',

    class GraphController
        constructor: (@$scope, @$http, @$log) ->
            @graphData = @$scope.graph
            @$log.info "Current Graph: #{ @graphData.name }"
            
        init: (@graphData) ->
            
            
        setParams: (values) ->
            @queryParams[key] = value for key, value of values
            
        
        onMouseOver: (event) ->
            
        getName: () ->
            @graphData.name