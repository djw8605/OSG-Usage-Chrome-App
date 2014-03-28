

graphControllerModule = angular.module 'osgUsageApp.controller.graph', ['osgUsageApp.graphService']

graphControllerModule.controller 'GraphContoller',

    class GraphController
        constructor: (@$scope, @$http, @$log, @graphService, @$q) ->
            
            @$scope.name = @$scope.graph
            @$log.info "Current Graph: #{ @graphData }"
            @$log.info "Graph scope: #{@$scope.graph}"
            
            # Define a promise to be fufilled when we have the profile information
            @profile_defer = @$q.defer()
            
            # wait for both the graph information and the profile information
            # The profile contains system wide query parameters
            @$q.all([ @graphService.getGraph(@$scope.name), @profile_defer.promise ]).then(@graphData, @profile) =>
                
                # Add the profile's query parameters
                @setParams(@profile.queryParams)
                
                # Add the graph's query params
                if ( @scope.graph.queryParams? )
                    @setParams(@scope.graph.queryParams)
                
                # Get the url @$scope.graphUrl 
                @graphService.getUrl(@graphData.baseUrl, @queryParams).then (graphUrl) =>
                    @$scope.graphUrl = graphUrl
                    
                @$log.info("Got URL #{@$scope.graphUrl}")
                @$scope.name = @graphData.name
                @$scope.description = @graphData.description
            , (reason) =>
                @$log.info("Refused to load URL because #{reason}")
            
        init: (@profile) ->
            @$log.info "Got graph data: #{@profile}"
            @profile_defer.resolve(@profile)
            
            
        setParams: (values) ->
            @queryParams[key] = value for key, value of values
            
        
        onMouseOver: () ->
            
            