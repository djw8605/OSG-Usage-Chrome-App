

graphControllerModule = angular.module 'osgUsageApp.controller.graph', ['osgUsageApp.graphService', 'osgUsageApp.controller.editparams', 'ui.bootstrap']

graphControllerModule.controller 'GraphContoller',

    class GraphController
        constructor: (@$scope, @$http, @$log, @graphService, @$q, @$rootScope, @$modal) ->
            
            @queryParams = @$scope.graphData.queryParams
            @$scope.openGraphEdit = @openGraphEdit
            @$scope.refreshGraph = @refreshGraph
            
            
            @$log.info "Graph scope: #{@$scope.graphId}"
            
            # Define a promise to be fufilled when we have the profile information
            @profile_defer = @$q.defer()
            
            # Grab the profile from the rootScope scope (probably a bad idea).
            @profile = @$rootScope.profile
            @$scope.profile = @profile
            
            # wait for both the graph information and the profile information
            # The profile contains system wide query parameters
            @graphService.getGraph(@$scope.graphId).then (@graphData) =>
                
                # Add the profile's query parameters
                @setParams(@profile.queryParams)
                
                # Add the graph's query params
                #if ( @$scope.graphData.queryParams? )
                #    @setParams(@$scope.graphData.queryParams)
                
                # Get the url @$scope.graphUrl 
                @refreshGraph()
                    
                # Set the scope variables for the View
                @$scope.name = @graphData.name
                @$scope.description = @graphData.description
                @$scope.$watch('graphData', @refreshGraph, true)
            , (reason) =>
                @$log.info("Refused to load URL because #{reason}")
            
        init: (@profile) ->
            @$log.info "Got graph data: #{@profile}"
            @profile_defer.resolve(@profile)
            
        refreshGraph: (newValue, oldValue) =>
            if (newValue?)
                @$log.info(newValue)
                @$log.info(oldValue)
            
            opts = {
              lines: 13, # The number of lines to draw
              length: 20, # The length of each line
              width: 10, # The line thickness
              radius: 30, # The radius of the inner circle
              corners: 1, # Corner roundness (0..1)
              rotate: 0, # The rotation offset
              direction: 1, # 1: clockwise, -1: counterclockwise
              color: '#000', # #rgb or #rrggbb or array of colors
              speed: 1, # Rounds per second
              trail: 60, # Afterglow percentage
              shadow: false, # Whether to render a shadow
              hwaccel: false, # Whether to use hardware acceleration
              className: 'spinner', # The CSS class to assign to the spinner
              zIndex: 2e9, # The z-index (defaults to 2000000000)
              top: '50%', # Top position relative to parent in px
              left: '50%' # Left position relative to parent in px
            };
            
            target = $("#spinner-#{@$scope.graphId}").spin(opts)
            $(".#{@$scope.graphId} .graph-image").addClass("loading")
            
            
            @graphService.getUrl(@graphData.baseUrl, @$scope.graphData.queryParams).then (graphUrl) =>
                @$scope.graphUrl = graphUrl
                @$log.info("Got URL #{@$scope.graphUrl}")
                target.spin(false)
                $(".#{@$scope.graphId} .graph-image").removeClass("loading")
            
        setParams: (values) ->
            @$scope.graphData.queryParams[key] = value for key, value of values
            
        
        onMouseOver: () ->
            
        openGraphEdit: () =>
            @$log.info "Open edit graph"
            modalInstance = @$modal.open({
                templateUrl: 'html/edit_params.html',
                controller: 'EditParamsCtrl',
                resolve: {
                    queryParams: () =>
                        @$scope.graphData.queryParams
                }
            });
            modalInstance.result.then (params) =>
                @$log.info("Graph edit closed...")
                @$log.info(params)
                @setParams(params)
                # Changes to queryParams will be caught by the watch statement
                # @refreshGraph()
        
            