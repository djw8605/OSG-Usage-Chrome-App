
graphModule = angular.module 'osgUsageApp.graphService', []

graphModule.service 'graphService',
    class GraphService
        constructor: (@$http, @$log, @$q) ->
            
            # First, read in the graph configuration (which is json)
            @readGraphsData()
            
        
        readGraphsData: ->
            @$log.info "Getting the graphs.json"
            @http_promise = @$http.get('../data/graphs.json').success (data) =>
                @$log.info "Received graphs.json: #{data}"
                @graphsData = data
                
                
                
        
        getGraph: (graphName) ->
            @$log.info "Inside getGraph, getting #{graphName}"
            deferred_reading = @$q.defer()
            @http_promise.then () =>
                @$log.info "Inside http_promise.then for #{graphName}"
                if (graphName of @graphsData) 
                    @$log.info "Resolving graphs data for #{graphName}"
                    deferred_reading.resolve(@graphsData[graphName])
                else
                    @$log.info "rejecting graphs data"
                    deferred_reading.reject("#{graphName} not in Recieved Graph Data")
                
            deferred_reading.promise