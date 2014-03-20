define ['../js/angular', 'graph'], () ->
    
    graphModule = angular.module 'osgUsageApp.graphService', []
    
    graphModule.service 'graphService',
        class GraphService
            constructor: (@$http, @$log) ->
                
                # First, read in the graph configuration (which is json)
                @readGraphsData()
                
                
            readGraphsData: ->
                @$http.get('../data/graphs.json').success (data) =>
                    @graphsData = data
                    
            
            getGraph(graphName): ->
                if @graphsData[graphName]?
                    null
                else
                    # Create a new class instance
                    new Graph @graphsData[graphName] @$http
                    