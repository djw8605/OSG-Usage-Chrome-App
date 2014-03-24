

graphControllerModule = angular.module 'osgUsageApp.controller.graph', ['osgUsageApp.graphService']

graphControllerModule.controller 'GraphContoller',

    class GraphController
        constructor: (@$scope, @$http, @$log, @graphService) ->
            @$scope.name = @$scope.graph
            @$log.info "Current Graph: #{ @graphData }"
            @$log.info "Graph scope: #{@$scope.graph}"
            @graphService.getGraph(@$scope.name).then (@graphData) =>
                @$scope.graphUrl = @graphData.baseUrl
                @$log.info("Got URL #{@$scope.graphUrl}")
            , (reason) =>
                @$log.info("Refused to load URL because #{reason}")
            
        init: (@graphData) ->
            @$log.info "Got graph data: #{@graphData}"
            
            
        setParams: (values) ->
            @queryParams[key] = value for key, value of values
            
        
        onMouseOver: () ->
            
            