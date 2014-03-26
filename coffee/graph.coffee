

graphControllerModule = angular.module 'osgUsageApp.controller.graph', ['osgUsageApp.graphService']

graphControllerModule.controller 'GraphContoller',

    class GraphController
        constructor: (@$scope, @$http, @$log, @graphService) ->
            @$scope.name = @$scope.graph
            @$log.info "Current Graph: #{ @graphData }"
            @$log.info "Graph scope: #{@$scope.graph}"
            @graphService.getGraph(@$scope.name).then (@graphData) =>
                # Get the url @$scope.graphUrl 
                @graphService.getUrl(@graphData.baseUrl, @queryParams).then (graphUrl) =>
                    @$scope.graphUrl = graphUrl
                    
                @$log.info("Got URL #{@$scope.graphUrl}")
                @$scope.name = @graphData.name
                @$scope.description = @graphData.description
            , (reason) =>
                @$log.info("Refused to load URL because #{reason}")
            
        init: (@profile) ->
            @$log.info "Got graph data: #{@graphData}"
            
            
        setParams: (values) ->
            @queryParams[key] = value for key, value of values
            
        
        onMouseOver: () ->
            
            