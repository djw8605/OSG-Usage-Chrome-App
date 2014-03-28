

graphControllerModule = angular.module 'osgUsageApp.controller.graph', ['osgUsageApp.graphService']

graphControllerModule.controller 'GraphContoller',

    class GraphController
        constructor: (@$scope, @$http, @$log, @graphService, @$q, @$rootScope) ->
            
            @queryParams = {}
            
            @$log.info "Graph scope: #{@$scope.graphId}"
            
            # Define a promise to be fufilled when we have the profile information
            @profile_defer = @$q.defer()
            
            # Grab the profile from the rootScope scope (probably a bad idea)
            @profile = @$rootScope.profile
            @$scope.profile = @profile
            
            # wait for both the graph information and the profile information
            # The profile contains system wide query parameters
            @graphService.getGraph(@$scope.graphId).then (@graphData) =>
                
                # Add the profile's query parameters
                @setParams(@profile.queryParams)
                
                # Add the graph's query params
                if ( @$scope.graphData.queryParams? )
                    @setParams(@$scope.graphData.queryParams)
                
                # Get the url @$scope.graphUrl 
                @graphService.getUrl(@graphData.baseUrl, @queryParams).then (graphUrl) =>
                    @$scope.graphUrl = graphUrl
                    @$log.info("Got URL #{@$scope.graphUrl}")
                    
                # Set the scope variables for the View
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
            
            